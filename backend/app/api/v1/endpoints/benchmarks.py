import uuid
from datetime import datetime
from typing import Optional
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, verify_cse_access
from app.models.user import User
from app.schemas.reporting import PeerBenchmarkResponse
from app.services.reporting_service import reporting_service

router = APIRouter(prefix="/benchmarks", tags=["Peer Group Benchmarks"])

@router.get(
    "/{cse_id}",
    response_model=PeerBenchmarkResponse,
    summary="Retrieve persisted sector or population peer benchmarks for a CSE"
)
def get_benchmarks(
    cse_id: uuid.UUID,
    obs_start: Optional[datetime] = Query(None),
    obs_end: Optional[datetime] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Read-only retrieval of persisted sector baseline records or population fallback.
    Does NOT recalculate BM-01 or run analytics.
    Enforces server-side CSE data isolation.
    """
    verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    if obs_start and obs_end and obs_start >= obs_end:
        raise HTTPException(status_code=422, detail="obs_start must be strictly before obs_end")

    return reporting_service.get_benchmarks(
        db=db,
        cse_id=cse_id,
        obs_start=obs_start,
        obs_end=obs_end
    )
