import uuid
from typing import Optional, Tuple, List
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import desc
from app.api.deps import get_db, get_current_user, verify_cse_access, require_roles
from app.models.user import User
from app.models.analysis_run import AnalysisRun
from app.models.cse import CSE
from app.models.assessment import Assessment
from app.models.dataset_version import DatasetVersion
from app.schemas.analysis_run import (
    AnalysisRunCreate,
    AnalysisRunResponse,
    AnalysisRunListResponse
)
from app.services.analytics_runner import AnalyticsRunnerService
from app.services.auth_service import AuthService
from app.utils.exceptions import EntityNotFoundException

router = APIRouter(prefix="/analysis-runs", tags=["Analysis Runs"])

@router.post(
    "/",
    response_model=AnalysisRunResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create and execute an Analysis Run"
)
def create_analysis_run(
    req: AnalysisRunCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Triggers an Analysis Run tied to an Assessment and Dataset Version.
    Records engine version and rules evaluated for complete provenance.
    Enforces server-side CSE isolation.
    """
    verify_cse_access(cse_id=req.cse_id, current_user=current_user, db=db)

    cse = db.query(CSE).filter(CSE.id == req.cse_id).first()
    if not cse:
        raise EntityNotFoundException("CSE", req.cse_id)

    if req.assessment_id:
        asmt = db.query(Assessment).filter(Assessment.id == req.assessment_id, Assessment.cse_id == req.cse_id).first()
        if not asmt:
            raise EntityNotFoundException("Assessment", req.assessment_id)

    if req.dataset_version_id:
        dv = db.query(DatasetVersion).filter(DatasetVersion.id == req.dataset_version_id, DatasetVersion.cse_id == req.cse_id).first()
        if not dv:
            raise EntityNotFoundException("DatasetVersion", req.dataset_version_id)

    # 1. Create AnalysisRun record
    run = AnalysisRun(
        id=uuid.uuid4(),
        cse_id=req.cse_id,
        assessment_id=req.assessment_id,
        dataset_version_id=req.dataset_version_id,
        obs_start=req.obs_start,
        obs_end=req.obs_end,
        engine_version="v2.0.0-phase5-canonical",
        rules_evaluated=["EG-01", "EG-02", "EG-03", "EG-04", "NS-01", "NS-02", "AN-01", "BM-01"],
        status="RUNNING",
        executed_by_user_id=current_user.id
    )
    db.add(run)

    # Update Assessment state to IN_ANALYSIS if attached
    if req.assessment_id:
        asmt = db.query(Assessment).filter(Assessment.id == req.assessment_id).first()
        if asmt and asmt.status in ("DRAFT", "DATASET_ATTACHED"):
            asmt.status = "IN_ANALYSIS"

    db.commit()
    db.refresh(run)

    # 2. Execute analytics engine
    try:
        res = AnalyticsRunnerService.run_analytics(
            db=db,
            cse_id=req.cse_id,
            obs_start=req.obs_start,
            obs_end=req.obs_end
        )
        run.findings_created = res.findings_created
        run.baselines_persisted = res.baselines_created
        run.status = "COMPLETED"

        # Update Assessment state to UNDER_REVIEW
        if req.assessment_id:
            asmt = db.query(Assessment).filter(Assessment.id == req.assessment_id).first()
            if asmt:
                asmt.status = "UNDER_REVIEW"

        db.commit()
        db.refresh(run)
    except Exception as e:
        db.rollback()
        run.status = "FAILED"
        run.error_message = str(e)
        db.add(run)
        db.commit()
        db.refresh(run)

    return run

@router.get(
    "/",
    response_model=AnalysisRunListResponse,
    summary="List Analysis Runs"
)
def list_analysis_runs(
    cse_id: Optional[uuid.UUID] = Query(None, description="Filter by CSE ID"),
    assessment_id: Optional[uuid.UUID] = Query(None, description="Filter by Assessment ID"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Lists analysis runs with execution provenance and pagination.
    Restricts non-admin users to explicitly authorized CSEs.
    """
    allowed_cse_ids = None
    if cse_id:
        verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    elif current_user.role != "ADMIN":
        allowed_cse_ids = AuthService.get_user_allowed_cses(db, current_user)

    query = db.query(AnalysisRun)
    if cse_id:
        query = query.filter(AnalysisRun.cse_id == cse_id)
    elif allowed_cse_ids is not None:
        query = query.filter(AnalysisRun.cse_id.in_(allowed_cse_ids))

    if assessment_id:
        query = query.filter(AnalysisRun.assessment_id == assessment_id)

    total = query.count()
    items = query.order_by(desc(AnalysisRun.started_at)).offset(skip).limit(limit).all()
    return AnalysisRunListResponse(total=total, items=items)

@router.get(
    "/{run_id}",
    response_model=AnalysisRunResponse,
    summary="Get Analysis Run details"
)
def get_analysis_run(
    run_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves details for a single analysis run execution trace.
    Enforces object-level server-side CSE data isolation.
    """
    run = db.query(AnalysisRun).filter(AnalysisRun.id == run_id).first()
    if not run:
        raise EntityNotFoundException("AnalysisRun", run_id)

    verify_cse_access(cse_id=run.cse_id, current_user=current_user, db=db)
    return run
