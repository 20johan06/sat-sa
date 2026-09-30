import uuid
from typing import Optional
from fastapi import APIRouter, Depends, UploadFile, File, Form, Query, status
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user, verify_cse_access, require_roles
from app.models.user import User
from app.services.auth_service import AuthService
from app.schemas.ingestion import (
    DatasetType,
    JSONIngestionPayload,
    IngestionBatchResponse,
    IngestionBatchListResponse
)
from app.services.ingestion import IngestionService

router = APIRouter(prefix="/ingestion", tags=["Ingestion"])


@router.post(
    "/upload",
    response_model=IngestionBatchResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Upload and ingest operational data file (CSV or JSON)"
)
async def upload_ingestion_file(
    cse_id: uuid.UUID = Form(...),
    dataset_type: DatasetType = Form(...),
    assessment_id: Optional[uuid.UUID] = Form(None),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Ingests an operational dataset file (CSV or JSON), performs format detection,
    security checks, schema validation, data quality analysis, provenance recording,
    and transactional database storage. Generates linked DatasetVersion.
    Enforces server-side CSE data isolation and RBAC.
    """
    verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    content = await file.read()
    filename = file.filename or "uploaded_file.csv"

    batch = IngestionService.process_file_ingestion(
        db=db,
        cse_id=cse_id,
        dataset_type=dataset_type,
        filename=filename,
        content=content,
        assessment_id=assessment_id,
        user_id=current_user.id
    )
    return batch


@router.post(
    "/json",
    response_model=IngestionBatchResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Ingest structured JSON operational data payload"
)
def ingest_json_payload(
    payload: JSONIngestionPayload,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Ingests a structured JSON payload directly into the target operational data domain.
    Enforces server-side CSE data isolation and RBAC.
    """
    verify_cse_access(cse_id=payload.cse_id, current_user=current_user, db=db)
    batch = IngestionService.process_json_payload_ingestion(
        db=db,
        cse_id=payload.cse_id,
        dataset_type=payload.dataset_type,
        records=payload.records,
        assessment_id=payload.assessment_id,
        user_id=current_user.id
    )
    return batch


@router.get(
    "/batches",
    response_model=IngestionBatchListResponse,
    status_code=status.HTTP_200_OK,
    summary="List data ingestion batches"
)
def list_ingestion_batches(
    cse_id: Optional[uuid.UUID] = Query(None, description="Filter batches by target CSE ID"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves provenance history for data ingestion batches.
    Enforces server-side CSE data isolation.
    """
    allowed_cse_ids = None
    if cse_id:
        verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    elif current_user.role != "ADMIN":
        allowed_cse_ids = AuthService.get_user_allowed_cses(db, current_user)

    return IngestionService.list_batches(
        db=db,
        cse_id=cse_id,
        allowed_cse_ids=allowed_cse_ids,
        skip=skip,
        limit=limit
    )


@router.get(
    "/batches/{batch_id}",
    response_model=IngestionBatchResponse,
    status_code=status.HTTP_200_OK,
    summary="Get ingestion batch details"
)
def get_ingestion_batch(
    batch_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves detailed metadata, record statistics, and validation status for a single ingestion batch.
    Enforces object-level server-side CSE authorization.
    """
    batch = IngestionService.get_batch(db=db, batch_id=batch_id)
    verify_cse_access(cse_id=batch.cse_id, current_user=current_user, db=db)
    return batch
