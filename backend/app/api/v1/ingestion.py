import uuid
from typing import Optional
from fastapi import APIRouter, Depends, UploadFile, File, Form, Query, status
from sqlalchemy.orm import Session
from app.db.session import get_db
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
    file: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    """
    Ingests an operational dataset file (CSV or JSON), performs format detection,
    security checks, schema validation, provenance recording, and transactional database storage.
    """
    content = await file.read()
    filename = file.filename or "uploaded_file.csv"

    batch = IngestionService.process_file_ingestion(
        db=db,
        cse_id=cse_id,
        dataset_type=dataset_type,
        filename=filename,
        content=content
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
    db: Session = Depends(get_db)
):
    """
    Ingests a structured JSON payload directly into the target operational data domain.
    """
    batch = IngestionService.process_json_payload_ingestion(
        db=db,
        cse_id=payload.cse_id,
        dataset_type=payload.dataset_type,
        records=payload.records
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
    db: Session = Depends(get_db)
):
    """
    Retrieves provenance history for data ingestion batches.
    """
    return IngestionService.list_batches(db=db, cse_id=cse_id, skip=skip, limit=limit)


@router.get(
    "/batches/{batch_id}",
    response_model=IngestionBatchResponse,
    status_code=status.HTTP_200_OK,
    summary="Get ingestion batch details"
)
def get_ingestion_batch(
    batch_id: uuid.UUID,
    db: Session = Depends(get_db)
):
    """
    Retrieves detailed metadata, record statistics, and validation status for a single ingestion batch.
    """
    return IngestionService.get_batch(db=db, batch_id=batch_id)
