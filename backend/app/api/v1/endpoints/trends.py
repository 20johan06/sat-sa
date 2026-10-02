import uuid
from datetime import datetime
from typing import Optional
from fastapi import APIRouter, Depends, Query, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, verify_cse_access
from app.models.user import User
from app.schemas.trends import CSETrendAnalysisResponse
from app.services.trend_service import trend_service

router = APIRouter(prefix="/supervisory/cse", tags=["Trends & Historical Analytics"])

@router.get(
    "/{cse_id}/trends",
    response_model=CSETrendAnalysisResponse,
    summary="Retrieve Trends and Historical Analytics for a CSE"
)
def get_cse_trends(
    cse_id: uuid.UUID,
    obs_start: Optional[datetime] = Query(None),
    obs_end: Optional[datetime] = Query(None),
    window_days: int = Query(30, ge=1, le=365),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves period-over-period historical trends and baseline comparisons for a Critical Sector Entity (CSE).
    Enforces server-side CSE data isolation via verify_cse_access.
    """
    verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    try:
        return trend_service.get_cse_trends(
            db=db,
            cse_id=cse_id,
            obs_start=obs_start,
            obs_end=obs_end,
            window_days=window_days
        )
    except ValueError as ve:
        raise HTTPException(status_code=422, detail=str(ve))
