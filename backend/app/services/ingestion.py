import uuid
import datetime
from typing import List, Dict, Any, Optional
from sqlalchemy.orm import Session
from sqlalchemy import select, func
from app.models.cse import CSE
from app.models.ingestion import IngestionBatch
from app.schemas.ingestion import DatasetType, IngestionBatchResponse
from app.services.ingestion_parsers import CSVIngestionParser, JSONIngestionParser, BaseIngestionParser
from app.services.ingestion_validators import validate_file_security, perform_comprehensive_data_quality_validation
from app.services.ingestion_persistence import persist_ingestion_records
from app.services.dataset_version_service import DatasetVersionService
from app.schemas.dataset_version import DatasetVersionCreate
from app.utils.exceptions import EntityNotFoundException, IngestionException, SATSAException
from app.config.settings import settings

class IngestionService:

    @staticmethod
    def process_file_ingestion(
        db: Session,
        cse_id: uuid.UUID,
        dataset_type: DatasetType,
        filename: str,
        content: bytes,
        assessment_id: Optional[uuid.UUID] = None,
        user_id: Optional[uuid.UUID] = None
    ) -> IngestionBatch:
        """
        Orchestrates file upload ingestion (CSV or JSON).
        Performs data quality analysis, records batch provenance, persists valid records,
        and generates an immutable DatasetVersion linked to Assessment.
        """
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        safe_filename = validate_file_security(
            filename=filename,
            content_length=len(content),
            max_bytes=settings.MAX_INGESTION_FILE_SIZE_BYTES
        )

        timestamp_str = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%d%H%M%S")
        batch_ref = f"BATCH-{timestamp_str}-{uuid.uuid4().hex[:8].upper()}"

        ext = safe_filename.rsplit(".", 1)[-1].upper()
        source_type = "CSV" if ext == "CSV" else "JSON"

        batch = IngestionBatch(
            id=uuid.uuid4(),
            cse_id=cse_id,
            assessment_id=assessment_id,
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
            parser: BaseIngestionParser
            if source_type == "CSV":
                parser = CSVIngestionParser()
            else:
                parser = JSONIngestionParser()

            raw_records = parser.parse(content)

            # Perform Data Quality Validation
            validated_items, quality_report = perform_comprehensive_data_quality_validation(
                db=db,
                cse_id=cse_id,
                dataset_type=dataset_type,
                records=raw_records
            )

            batch.total_records = quality_report.total_records
            batch.quality_report = quality_report.model_dump()

            if quality_report.rejected_records > 0:
                # Reject entire batch if any record fails validation to ensure zero corrupt data entry
                batch.status = "FAILED"
                batch.valid_records = 0
                batch.rejected_records = quality_report.rejected_records
                err_summary = f"Data quality validation rejected {quality_report.rejected_records} of {quality_report.total_records} record(s)."
                if quality_report.rejections:
                    err_summary += f" Sample error: {quality_report.rejections[0].reason}"
                batch.error_summary = err_summary
                db.commit()
                db.refresh(batch)
                raise IngestionException(
                    message=err_summary,
                    code="DATA_QUALITY_REJECTION",
                    status_code=422,
                    details=quality_report.model_dump()
                )

            # Persist Valid Records
            inserted_count = 0
            if validated_items:
                inserted_count = persist_ingestion_records(
                    db=db,
                    batch=batch,
                    dataset_type=dataset_type,
                    items=validated_items
                )

            batch.valid_records = inserted_count
            batch.rejected_records = 0
            batch.status = "COMPLETED"
            db.commit()

            # Create Linked Immutable DatasetVersion
            dv_req = DatasetVersionCreate(
                cse_id=cse_id,
                assessment_id=assessment_id,
                batch_id=batch.id,
                dataset_type=dataset_type,
                source_filename=safe_filename
            )
            raw_payloads = [item.model_dump(mode="json") for item in validated_items]
            DatasetVersionService.create_dataset_version(
                db=db,
                req=dv_req,
                user_id=user_id,
                records_payload=raw_payloads
            )

            db.refresh(batch)
            return batch

        except Exception as e:
            db.rollback()
            err_msg = e.message if isinstance(e, SATSAException) else str(e)
            batch.status = "FAILED"
            batch.error_summary = err_msg
            if batch.total_records == 0 and 'raw_records' in locals():
                batch.total_records = len(raw_records)
            db.add(batch)
            db.commit()
            db.refresh(batch)

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
        assessment_id: Optional[uuid.UUID] = None,
        user_id: Optional[uuid.UUID] = None,
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
            assessment_id=assessment_id,
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

            validated_items, quality_report = perform_comprehensive_data_quality_validation(
                db=db,
                cse_id=cse_id,
                dataset_type=dataset_type,
                records=records
            )

            batch.total_records = quality_report.total_records
            batch.quality_report = quality_report.model_dump()

            if quality_report.rejected_records > 0:
                batch.status = "FAILED"
                batch.valid_records = 0
                batch.rejected_records = quality_report.rejected_records
                err_summary = f"Data quality validation rejected {quality_report.rejected_records} of {quality_report.total_records} record(s)."
                if quality_report.rejections:
                    err_summary += f" Sample error: {quality_report.rejections[0].reason}"
                batch.error_summary = err_summary
                db.commit()
                db.refresh(batch)
                raise IngestionException(
                    message=err_summary,
                    code="DATA_QUALITY_REJECTION",
                    status_code=422,
                    details=quality_report.model_dump()
                )

            inserted_count = 0
            if validated_items:
                inserted_count = persist_ingestion_records(
                    db=db,
                    batch=batch,
                    dataset_type=dataset_type,
                    items=validated_items
                )

            batch.valid_records = inserted_count
            batch.rejected_records = 0
            batch.status = "COMPLETED"
            db.commit()

            dv_req = DatasetVersionCreate(
                cse_id=cse_id,
                assessment_id=assessment_id,
                batch_id=batch.id,
                dataset_type=dataset_type,
                source_filename=source_name
            )
            raw_payloads = [item.model_dump(mode="json") for item in validated_items]
            DatasetVersionService.create_dataset_version(
                db=db,
                req=dv_req,
                user_id=user_id,
                records_payload=raw_payloads
            )

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
        allowed_cse_ids: Optional[List[uuid.UUID]] = None,
        skip: int = 0,
        limit: int = 50
    ) -> Dict[str, Any]:
        query = db.query(IngestionBatch)
        if cse_id:
            query = query.filter(IngestionBatch.cse_id == cse_id)
        elif allowed_cse_ids is not None:
            query = query.filter(IngestionBatch.cse_id.in_(allowed_cse_ids))

        total = query.count()
        items = query.order_by(IngestionBatch.imported_at.desc()).offset(skip).limit(limit).all()

        return {"total": total, "items": items}
