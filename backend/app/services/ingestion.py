import uuid
import datetime
from typing import List, Dict, Any, Optional
from sqlalchemy.orm import Session
from sqlalchemy import select, func
from app.models.cse import CSE
from app.models.ingestion import IngestionBatch
from app.schemas.ingestion import DatasetType, IngestionBatchResponse
from app.services.ingestion_parsers import CSVIngestionParser, JSONIngestionParser, BaseIngestionParser
from app.services.ingestion_validators import validate_file_security, validate_and_normalize_records
from app.services.ingestion_persistence import persist_ingestion_records
from app.utils.exceptions import EntityNotFoundException, IngestionException, SATSAException
from app.config.settings import settings

class IngestionService:

    @staticmethod
    def process_file_ingestion(
        db: Session,
        cse_id: uuid.UUID,
        dataset_type: DatasetType,
        filename: str,
        content: bytes
    ) -> IngestionBatch:
        """
        Orchestrates file upload ingestion (CSV or JSON).
        Creates a traceable IngestionBatch provenance record and handles transactional persistence.
        """
        # 1. Verify target CSE exists
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        # 2. Security validation (size, filename, path traversal)
        safe_filename = validate_file_security(
            filename=filename,
            content_length=len(content),
            max_bytes=settings.MAX_INGESTION_FILE_SIZE_BYTES
        )

        # 3. Generate provenance batch reference
        timestamp_str = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%d%H%M%S")
        batch_ref = f"BATCH-{timestamp_str}-{uuid.uuid4().hex[:8].upper()}"

        ext = safe_filename.rsplit(".", 1)[-1].upper()
        source_type = "CSV" if ext == "CSV" else "JSON"

        batch = IngestionBatch(
            id=uuid.uuid4(),
            cse_id=cse_id,
            batch_reference=batch_ref,
            source_type=source_type,
            source_filename=safe_filename,
            total_records=0,
            valid_records=0,
            rejected_records=0,
            status="PROCESSING",
            error_summary=None
        )
        db.add(batch)
        db.commit()
        db.refresh(batch)

        try:
            # 4. Parse content
            parser: BaseIngestionParser
            if source_type == "CSV":
                parser = CSVIngestionParser()
            else:
                parser = JSONIngestionParser()

            raw_records = parser.parse(content)
            total_count = len(raw_records)

            # 5. Schema validation and normalization
            validated_items = validate_and_normalize_records(
                dataset_type=dataset_type,
                records=raw_records
            )

            # 6. Transactional Database Persistence
            inserted_count = persist_ingestion_records(
                db=db,
                batch=batch,
                dataset_type=dataset_type,
                items=validated_items
            )

            # Update batch success state
            batch.total_records = total_count
            batch.valid_records = inserted_count
            batch.rejected_records = 0
            batch.status = "COMPLETED"
            db.commit()
            db.refresh(batch)
            return batch

        except Exception as e:
            db.rollback()
            # Update provenance record with failed status and error details
            err_msg = e.message if isinstance(e, SATSAException) else str(e)
            batch.status = "FAILED"
            batch.error_summary = err_msg
            batch.rejected_records = batch.total_records if batch.total_records > 0 else 1
            db.add(batch)
            db.commit()
            db.refresh(batch)
            
            # Re-raise original or wrapped exception
            if isinstance(e, SATSAException):
                raise e
            else:
                raise IngestionException(
                    message=f"Ingestion processing failed: {str(e)}",
                    code="INGESTION_PROCESSING_FAILED",
                    status_code=500
                )

    @staticmethod
    def process_json_payload_ingestion(
        db: Session,
        cse_id: uuid.UUID,
        dataset_type: DatasetType,
        records: List[Dict[str, Any]],
        source_name: str = "api_payload.json"
    ) -> IngestionBatch:
        """
        Orchestrates direct JSON payload ingestion.
        """
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        timestamp_str = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%d%H%M%S")
        batch_ref = f"BATCH-JSON-{timestamp_str}-{uuid.uuid4().hex[:8].upper()}"

        batch = IngestionBatch(
            id=uuid.uuid4(),
            cse_id=cse_id,
            batch_reference=batch_ref,
            source_type="JSON",
            source_filename=source_name,
            total_records=len(records),
            valid_records=0,
            rejected_records=0,
            status="PROCESSING",
            error_summary=None
        )
        db.add(batch)
        db.commit()
        db.refresh(batch)

        try:
            if not records or len(records) == 0:
                raise IngestionException("JSON payload contains no records.", code="EMPTY_DATASET", status_code=400)

            validated_items = validate_and_normalize_records(
                dataset_type=dataset_type,
                records=records
            )

            inserted_count = persist_ingestion_records(
                db=db,
                batch=batch,
                dataset_type=dataset_type,
                items=validated_items
            )

            batch.total_records = len(records)
            batch.valid_records = inserted_count
            batch.rejected_records = 0
            batch.status = "COMPLETED"
            db.commit()
            db.refresh(batch)
            return batch

        except Exception as e:
            db.rollback()
            err_msg = e.message if isinstance(e, SATSAException) else str(e)
            batch.status = "FAILED"
            batch.error_summary = err_msg
            batch.rejected_records = len(records)
            db.add(batch)
            db.commit()
            db.refresh(batch)

            if isinstance(e, SATSAException):
                raise e
            else:
                raise IngestionException(
                    message=f"JSON ingestion failed: {str(e)}",
                    code="INGESTION_PROCESSING_FAILED",
                    status_code=500
                )

    @staticmethod
    def get_batch(db: Session, batch_id: uuid.UUID) -> IngestionBatch:
        batch = db.query(IngestionBatch).filter(IngestionBatch.id == batch_id).first()
        if not batch:
            raise EntityNotFoundException("IngestionBatch", batch_id)
        return batch

    @staticmethod
    def list_batches(
        db: Session,
        cse_id: Optional[uuid.UUID] = None,
        skip: int = 0,
        limit: int = 50
    ) -> Dict[str, Any]:
        query = db.query(IngestionBatch)
        if cse_id:
            query = query.filter(IngestionBatch.cse_id == cse_id)

        total = query.count()
        items = query.order_by(IngestionBatch.imported_at.desc()).offset(skip).limit(limit).all()

        return {"total": total, "items": items}
