import uuid
from typing import Optional
from fastapi import APIRouter, Depends, Query, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, verify_cse_access
from app.models.user import User
from app.services.auth_service import AuthService
from app.schemas.manual_review import (
    PaginatedManualReviewResponse,
    ManualReviewRecommendationItem
)
from app.services.review_service import review_service

router = APIRouter(prefix="/manual-review", tags=["Manual Review Prioritization"])

@router.get(
    "/queue",
    response_model=PaginatedManualReviewResponse,
    summary="Query prioritized manual review recommendations queue"
)
def get_manual_review_queue(
    cse_id: Optional[uuid.UUID] = Query(None),
    record_type: Optional[str] = Query(None),
    category: Optional[str] = Query(None),
    status_filter: Optional[str] = Query(None, alias="status"),
    actionable_only: bool = Query(True),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Returns a Manual Review Queue surfacing operational records linked to supervisory findings in chronological order (detected_at DESC).
    Enforces server-side CSE data isolation.
    """
    allowed_cse_ids = None
    if cse_id:
        verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    elif current_user.role != "ADMIN":
        allowed_cse_ids = AuthService.get_user_allowed_cses(db, current_user)

    try:
        return review_service.get_manual_review_queue(
            db=db,
            cse_id=cse_id,
            allowed_cse_ids=allowed_cse_ids,
            record_type=record_type,
            category=category,
            status=status_filter,
            actionable_only=actionable_only,
            page=page,
            page_size=page_size
        )
    except ValueError as ve:
        raise HTTPException(status_code=422, detail=str(ve))

@router.get(
    "/recommendation/{evidence_id}",
    response_model=ManualReviewRecommendationItem,
    summary="Retrieve single manual review recommendation detail"
)
def get_manual_review_recommendation_detail(
    evidence_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves recommendation detail for a specific linked evidence record.
    Enforces server-side object-level CSE authorization.
    """
    rec = review_service.get_manual_review_recommendation_detail(db=db, evidence_id=evidence_id)
    verify_cse_access(cse_id=rec.cse_id, current_user=current_user, db=db)
    return rec
