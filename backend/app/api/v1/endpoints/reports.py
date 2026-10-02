import uuid
from datetime import datetime
from typing import Optional, Union, Any
from fastapi import APIRouter, Depends, Query, HTTPException, Response
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from sqlalchemy import desc

from app.api.deps import get_db, get_current_user, require_roles, verify_cse_access
from app.models.user import User
from app.models.report import ReportRecord
from app.schemas.report_export import (
    ReportGenerateRequest,
    ReportItemSchema,
    PaginatedReportsResponse
)
from app.services.report_generator_service import report_generator_service
from app.utils.exceptions import EntityNotFoundException

router = APIRouter(prefix="/reports", tags=["Supervisory Reporting"])

@router.post(
    "/generate",
    response_model=Dict[str, Any] if hasattr(dict, "m") else Any,
    summary="Generate immutable supervisory report snapshot"
)
def generate_report(
    req: ReportGenerateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Generates a persistent, immutable supervisory report snapshot.
    Binds dataset/analysis provenance and stores frozen JSON snapshot.
    Enforces server-side CSE data isolation.
    """
    verify_cse_access(cse_id=req.cse_id, current_user=current_user, db=db)

    if req.obs_start and req.obs_end and req.obs_start >= req.obs_end:
        raise HTTPException(status_code=422, detail="obs_start must be strictly before obs_end")

    report_rec = report_generator_service.create_report_record(
        db=db,
        cse_id=req.cse_id,
        acting_user=current_user,
        obs_start=req.obs_start,
        obs_end=req.obs_end,
        assessment_id=req.assessment_id,
        dataset_version_id=req.dataset_version_id,
        analysis_run_id=req.analysis_run_id
    )

    return report_rec.summary_json

@router.get(
    "/cse/{cse_id}",
    response_model=PaginatedReportsResponse,
    summary="List generated supervisory reports for a CSE"
)
def list_cse_reports(
    cse_id: uuid.UUID,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Lists all historical immutable report records generated for a specific CSE."""
    verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)

    query = db.query(ReportRecord).filter(ReportRecord.cse_id == cse_id)
    total = query.count()
    total_pages = (total + page_size - 1) // page_size if page_size > 0 else 1
    offset = (page - 1) * page_size

    records = query.order_by(desc(ReportRecord.created_at)).offset(offset).limit(page_size).all()

    items = []
    for r in records:
        username = r.generated_by_user.username if r.generated_by_user else "SUPERVISOR"
        items.append(ReportItemSchema(
            id=r.id,
            report_code=r.report_code,
            cse_id=r.cse_id,
            assessment_id=r.assessment_id,
            dataset_version_id=r.dataset_version_id,
            analysis_run_id=r.analysis_run_id,
            obs_start=r.obs_start,
            obs_end=r.obs_end,
            generated_by_user_id=r.generated_by_user_id,
            generated_by_username=username,
            created_at=r.created_at
        ))

    return PaginatedReportsResponse(
        items=items,
        total=total,
        page=page,
        page_size=page_size,
        total_pages=total_pages
    )

@router.get(
    "/{report_id}",
    response_model=Any,
    summary="Get supervisory report JSON details"
)
def get_report_detail(
    report_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Retrieves full frozen report summary JSON by report ID."""
    report_rec = report_generator_service.get_report_by_id(db, report_id)
    verify_cse_access(cse_id=report_rec.cse_id, current_user=current_user, db=db)
    return report_rec.summary_json

@router.get(
    "/{report_id}/export/pdf",
    summary="Export supervisory report as PDF"
)
def export_report_pdf(
    report_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """Exports formal supervisory report as a local, offline PDF document."""
    report_rec = report_generator_service.get_report_by_id(db, report_id)
    verify_cse_access(cse_id=report_rec.cse_id, current_user=current_user, db=db)

    pdf_bytes = report_generator_service.export_pdf(report_rec.summary_json)
    filename = f"{report_rec.report_code}.pdf"

    return Response(
        content=pdf_bytes,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'}
    )

@router.get(
    "/{report_id}/export/csv",
    summary="Export evidence matrix as CSV"
)
def export_report_csv(
    report_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """Exports structured evidence matrix as a CSV file preserving zero-evidence findings."""
    report_rec = report_generator_service.get_report_by_id(db, report_id)
    verify_cse_access(cse_id=report_rec.cse_id, current_user=current_user, db=db)

    csv_str = report_generator_service.export_csv(report_rec.summary_json)
    filename = f"{report_rec.report_code}_evidence.csv"

    return Response(
        content=csv_str,
        media_type="text/csv; charset=utf-8",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'}
    )

@router.get(
    "/{report_id}/export/json",
    summary="Export machine-readable report JSON"
)
def export_report_json(
    report_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Downloads machine-readable report JSON attachment."""
    report_rec = report_generator_service.get_report_by_id(db, report_id)
    verify_cse_access(cse_id=report_rec.cse_id, current_user=current_user, db=db)

    import json
    json_bytes = json.dumps(report_rec.summary_json, indent=2).encode("utf-8")
    filename = f"{report_rec.report_code}.json"

    return Response(
        content=json_bytes,
        media_type="application/json; charset=utf-8",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'}
    )
