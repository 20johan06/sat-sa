import uuid
from datetime import datetime
from typing import Optional, Union
from fastapi import APIRouter, Depends, Query, HTTPException, Response
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.schemas.reporting import ReportJSONResponse
from app.services.reporting_service import reporting_service

router = APIRouter(prefix="/reports", tags=["Supervisory Reporting"])

@router.get(
    "/cse/{cse_id}",
    response_model=Union[ReportJSONResponse, str],
    summary="Generate executive supervisory report for a CSE"
)
def generate_cse_report(
    cse_id: uuid.UUID,
    format_param: str = Query("json", alias="format"),
    obs_start: Optional[datetime] = Query(None),
    obs_end: Optional[datetime] = Query(None),
    db: Session = Depends(get_db)
):
    """
    Generates a deterministic supervisory assessment report in JSON or Markdown format.
    Does NOT use AI/LLMs or invent risk statuses.
    """
    fmt = format_param.lower()
    if fmt not in ("json", "markdown"):
        raise HTTPException(
            status_code=422,
            detail=f"Invalid format '{format_param}'. Allowed format values are 'json' or 'markdown'."
        )

    if obs_start and obs_end and obs_start >= obs_end:
        raise HTTPException(status_code=422, detail="obs_start must be strictly before obs_end")

    res = reporting_service.get_report(
        db=db,
        cse_id=cse_id,
        format_type=fmt,
        obs_start=obs_start,
        obs_end=obs_end
    )

    if fmt == "markdown":
        return Response(content=res, media_type="text/markdown; charset=utf-8")

    return res
