import uuid
from datetime import datetime
from typing import Optional, List
from fastapi import APIRouter, Depends, Query, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, require_roles, verify_cse_access
from app.models.user import User
from app.models.finding import Finding
from app.services.auth_service import AuthService
from app.utils.exceptions import EntityNotFoundException
from app.schemas.reporting import (
    PaginatedFindingsResponse,
    FindingDetailSchema,
    FindingStatusUpdateSchema,
    FindingReviewHistoryResponse,
    ExaminerNoteCreate,
    EvidenceRequestCreate
)
from app.services.reporting_service import (
    reporting_service,
    VALID_CATEGORIES,
    DEPRECATED_CATEGORIES
)

router = APIRouter(prefix="/findings", tags=["Supervisory Findings"])

@router.get(
    "/",
    response_model=PaginatedFindingsResponse,
    summary="Query and filter persisted supervisory findings"
)
def list_findings(
    cse_id: Optional[uuid.UUID] = Query(None),
    category: Optional[str] = Query(None),
    severity: Optional[str] = Query(None),
    status_filter: Optional[str] = Query(None, alias="status"),
    rule_code: Optional[str] = Query(None),
    obs_start: Optional[datetime] = Query(None),
    obs_end: Optional[datetime] = Query(None),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Paginated query endpoint for filtering persisted supervisory findings.
    Enforces server-side CSE data isolation.
    """
    if obs_start and obs_end and obs_start >= obs_end:
        raise HTTPException(status_code=422, detail="obs_start must be strictly before obs_end")

    allowed_cse_ids = None
    if cse_id:
        verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    elif current_user.role != "ADMIN":
        allowed_cse_ids = AuthService.get_user_allowed_cses(db, current_user)

    if category:
        cat_upper = category.upper()
        if cat_upper in DEPRECATED_CATEGORIES:
            raise HTTPException(
                status_code=422,
                detail=f"Category '{category}' is deprecated. Use canonical categories: {sorted(VALID_CATEGORIES)}"
            )
        if cat_upper not in VALID_CATEGORIES:
            raise HTTPException(
                status_code=422,
                detail=f"Invalid category '{category}'. Must be one of {sorted(VALID_CATEGORIES)}"
            )

    try:
        return reporting_service.get_findings(
            db=db,
            cse_id=cse_id,
            allowed_cse_ids=allowed_cse_ids,
            category=category,
            severity=severity,
            status=status_filter,
            rule_code=rule_code,
            obs_start=obs_start,
            obs_end=obs_end,
            page=page,
            page_size=page_size
        )
    except ValueError as ve:
        raise HTTPException(status_code=422, detail=str(ve))

@router.get(
    "/{finding_id}",
    response_model=FindingDetailSchema,
    summary="Retrieve single finding detail with traceable evidence links and review history"
)
def get_finding(
    finding_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves full details for a single finding, including linked FindingEvidence records and review history.
    Enforces object-level server-side CSE authorization.
    """
    finding = db.query(Finding).filter(Finding.id == finding_id).first()
    if not finding:
        raise EntityNotFoundException("Finding", finding_id)

    verify_cse_access(cse_id=finding.cse_id, current_user=current_user, db=db)
    return reporting_service.get_finding_detail(db=db, finding_id=finding_id)

@router.get(
    "/{finding_id}/history",
    response_model=List[FindingReviewHistoryResponse],
    summary="Retrieve audit and supervisory review history for a finding"
)
def get_finding_history(
    finding_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves immutable supervisory review history for a finding.
    Accessible to ADMIN, SUPERVISOR, and VIEWER roles with valid CSE access.
    """
    finding = db.query(Finding).filter(Finding.id == finding_id).first()
    if not finding:
        raise EntityNotFoundException("Finding", finding_id)

    verify_cse_access(cse_id=finding.cse_id, current_user=current_user, db=db)
    return reporting_service.get_finding_review_history(db=db, finding_id=finding_id)

@router.post(
    "/{finding_id}/notes",
    response_model=FindingReviewHistoryResponse,
    status_code=201,
    summary="Add an examiner review note to a finding"
)
def add_examiner_note(
    finding_id: uuid.UUID,
    payload: ExaminerNoteCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Appends an immutable examiner review note to a finding.
    Restricted to ADMIN and SUPERVISOR roles with valid CSE access. Denies VIEWER with HTTP 403.
    """
    finding = db.query(Finding).filter(Finding.id == finding_id).first()
    if not finding:
        raise EntityNotFoundException("Finding", finding_id)

    verify_cse_access(cse_id=finding.cse_id, current_user=current_user, db=db)
    try:
        return reporting_service.add_examiner_note(
            db=db,
            finding_id=finding_id,
            acting_user=current_user,
            note_text=payload.note_text
        )
    except ValueError as ve:
        raise HTTPException(status_code=422, detail=str(ve))

@router.post(
    "/{finding_id}/request-evidence",
    response_model=FindingDetailSchema,
    summary="Request additional operational evidence for a finding"
)
def request_evidence(
    finding_id: uuid.UUID,
    payload: EvidenceRequestCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Transitions finding status to NEEDS_MORE_EVIDENCE and attaches structured evidence request requirements.
    Restricted to ADMIN and SUPERVISOR roles with valid CSE access. Denies VIEWER with HTTP 403.
    """
    finding = db.query(Finding).filter(Finding.id == finding_id).first()
    if not finding:
        raise EntityNotFoundException("Finding", finding_id)

    verify_cse_access(cse_id=finding.cse_id, current_user=current_user, db=db)
    try:
        evidence_req_dict = {
            "required_data_types": payload.required_data_types,
            "requested_time_window": payload.requested_time_window,
            "description": payload.description
        }
        return reporting_service.update_finding_status(
            db=db,
            finding_id=finding_id,
            new_status="NEEDS_MORE_EVIDENCE",
            notes=payload.note_text,
            acting_user=current_user,
            evidence_request_details=evidence_req_dict
        )
    except ValueError as ve:
        raise HTTPException(status_code=422, detail=str(ve))

@router.patch(
    "/{finding_id}/status",
    response_model=FindingDetailSchema,
    summary="Update supervisory finding review status with audit notes"
)
def update_finding_status(
    finding_id: uuid.UUID,
    payload: FindingStatusUpdateSchema,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Updates the supervisory review status of a finding (NEW, UNDER_REVIEW, CONFIRMED, NOT_SUBSTANTIATED, DISMISSED, NEEDS_MORE_EVIDENCE).
    Restricted to ADMIN and SUPERVISOR roles with valid CSE access. Denies VIEWER with HTTP 403.
    """
    finding = db.query(Finding).filter(Finding.id == finding_id).first()
    if not finding:
        raise EntityNotFoundException("Finding", finding_id)

    verify_cse_access(cse_id=finding.cse_id, current_user=current_user, db=db)
    try:
        return reporting_service.update_finding_status(
            db=db,
            finding_id=finding_id,
            new_status=payload.status,
            notes=payload.notes,
            acting_user=current_user
        )
    except ValueError as ve:
        raise HTTPException(status_code=422, detail=str(ve))

