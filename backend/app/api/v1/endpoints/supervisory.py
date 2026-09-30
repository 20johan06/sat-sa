import uuid
from datetime import datetime
from typing import Optional
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, verify_cse_access
from app.models.user import User
from app.services.auth_service import AuthService
from app.schemas.supervisory import (
    SupervisoryAttentionQueueResponse,
    EntitySupervisoryOverviewResponse
)
from app.services.supervisory_service import supervisory_service

router = APIRouter(prefix="/supervisory", tags=["Supervisory Attention & Benchmarking"])

@router.get(
    "/attention-queue",
    response_model=SupervisoryAttentionQueueResponse,
    summary="Retrieve the Supervisory Attention Queue for NCIIPC examiners"
)
def get_attention_queue(
    sector: Optional[str] = Query(None),
    obs_start: Optional[datetime] = Query(None),
    obs_end: Optional[datetime] = Query(None),
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves the supervisory Attention Queue.
    Enforces RBAC and server-side CSE data isolation for non-ADMIN users.
    Order is deterministically driven by active findings count, critical/high records, and CSE identity.
    """
    if obs_start and obs_end and obs_start >= obs_end:
        raise HTTPException(status_code=422, detail="obs_start must be strictly before obs_end")

    allowed_cse_ids = None
    if current_user.role != "ADMIN":
        allowed_cse_ids = AuthService.get_user_allowed_cses(db, current_user)

    return supervisory_service.get_attention_queue(
        db=db,
        allowed_cse_ids=allowed_cse_ids,
        sector=sector,
        obs_start=obs_start,
        obs_end=obs_end,
        page=page,
        page_size=page_size
    )

@router.get(
    "/cse/{cse_id}/attention-overview",
    response_model=EntitySupervisoryOverviewResponse,
    summary="Retrieve concise entity-level supervisory overview answering 'WHY IS THIS CSE SHOWING SUPERVISORY ATTENTION?'"
)
def get_entity_supervisory_overview(
    cse_id: uuid.UUID,
    obs_start: Optional[datetime] = Query(None),
    obs_end: Optional[datetime] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves entity-level supervisory overview for a single CSE.
    Enforces object-level server-side CSE data isolation.
    """
    verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    if obs_start and obs_end and obs_start >= obs_end:
        raise HTTPException(status_code=422, detail="obs_start must be strictly before obs_end")

    return supervisory_service.get_entity_supervisory_overview(
        db=db,
        cse_id=cse_id,
        obs_start=obs_start,
        obs_end=obs_end
    )
