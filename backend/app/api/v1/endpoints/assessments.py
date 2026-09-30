import uuid
from typing import Optional
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user, verify_cse_access, require_roles
from app.models.user import User
from app.schemas.assessment import (
    AssessmentCreate,
    AssessmentUpdateStatus,
    AssessmentResponse,
    AssessmentListResponse
)
from app.services.assessment_service import assessment_service
from app.services.auth_service import AuthService

router = APIRouter(prefix="/assessments", tags=["Supervisory Assessments"])

@router.post(
    "/",
    response_model=AssessmentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new V2 Supervisory Assessment for a CSE"
)
def create_assessment(
    req: AssessmentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Creates a new Supervisory Assessment bound to a specific CSE and assessment window.
    Enforces server-side CSE isolation and RBAC role restrictions.
    """
    verify_cse_access(cse_id=req.cse_id, current_user=current_user, db=db)
    return assessment_service.create_assessment(
        db=db,
        req=req,
        user_id=current_user.id
    )

@router.get(
    "/",
    response_model=AssessmentListResponse,
    summary="List V2 Supervisory Assessments"
)
def list_assessments(
    cse_id: Optional[uuid.UUID] = Query(None, description="Filter assessments by CSE ID"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Lists supervisory assessments with pagination.
    Restricts non-admin users to explicitly authorized CSEs.
    """
    allowed_cse_ids = None
    if cse_id:
        verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    elif current_user.role != "ADMIN":
        allowed_cse_ids = AuthService.get_user_allowed_cses(db, current_user)

    total, items = assessment_service.list_assessments(
        db=db,
        cse_id=cse_id,
        allowed_cse_ids=allowed_cse_ids,
        skip=skip,
        limit=limit
    )
    return AssessmentListResponse(total=total, items=items)

@router.get(
    "/{assessment_id}",
    response_model=AssessmentResponse,
    summary="Get Supervisory Assessment details"
)
def get_assessment(
    assessment_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves details for a single supervisory assessment.
    Enforces object-level server-side CSE data isolation.
    """
    assessment = assessment_service.get_assessment(db, assessment_id)
    verify_cse_access(cse_id=assessment.cse_id, current_user=current_user, db=db)
    return assessment

@router.patch(
    "/{assessment_id}/status",
    response_model=AssessmentResponse,
    summary="Update Supervisory Assessment lifecycle status"
)
def update_assessment_status(
    assessment_id: uuid.UUID,
    payload: AssessmentUpdateStatus,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Updates assessment lifecycle state (DRAFT -> DATASET_ATTACHED -> IN_ANALYSIS -> UNDER_REVIEW -> COMPLETED).
    Enforces state transition validation and server-side CSE isolation.
    """
    assessment = assessment_service.get_assessment(db, assessment_id)
    verify_cse_access(cse_id=assessment.cse_id, current_user=current_user, db=db)
    return assessment_service.update_assessment_status(
        db=db,
        assessment_id=assessment_id,
        target_status=payload.status
    )
