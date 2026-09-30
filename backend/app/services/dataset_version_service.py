import uuid
import hashlib
import json
from datetime import datetime, timezone
from typing import List, Optional, Tuple
from sqlalchemy.orm import Session
from sqlalchemy import desc
from app.models.dataset_version import DatasetVersion
from app.models.cse import CSE
from app.models.assessment import Assessment
from app.models.ingestion import IngestionBatch
from app.schemas.dataset_version import DatasetVersionCreate
from app.utils.exceptions import EntityNotFoundException, SATSAException

class DatasetVersionService:
    """Service handling Immutable Dataset Version operations and provenance."""

    @staticmethod
    def create_dataset_version(
        db: Session,
        req: DatasetVersionCreate,
        user_id: Optional[uuid.UUID] = None,
        records_payload: Optional[List[dict]] = None
    ) -> DatasetVersion:
        # 1. Verify target CSE
        cse = db.query(CSE).filter(CSE.id == req.cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", req.cse_id)

        # 2. Verify optional Assessment if provided
        if req.assessment_id:
            assessment = db.query(Assessment).filter(
                Assessment.id == req.assessment_id,
                Assessment.cse_id == req.cse_id
            ).first()
            if not assessment:
                raise EntityNotFoundException("Assessment", req.assessment_id)

        # 3. Verify optional Ingestion Batch if provided
        batch = None
        if req.batch_id:
            batch = db.query(IngestionBatch).filter(
                IngestionBatch.id == req.batch_id,
                IngestionBatch.cse_id == req.cse_id
            ).first()
            if not batch:
                raise EntityNotFoundException("IngestionBatch", req.batch_id)

        # 4. Compute SHA-256 content hash
        hash_input = {
            "cse_id": str(req.cse_id),
            "dataset_type": req.dataset_type,
            "filename": req.source_filename,
            "batch_id": str(req.batch_id) if req.batch_id else None,
            "records": records_payload or []
        }
        hash_bytes = json.dumps(hash_input, sort_keys=True).encode("utf-8")
        content_hash = hashlib.sha256(hash_bytes).hexdigest()

        # 5. Determine record count
        rec_count = len(records_payload) if records_payload else (batch.valid_records if batch else 0)

        # 6. Generate version tag
        now_str = datetime.now(timezone.utc).strftime("%Y%m%d")
        version_tag = req.version_tag or f"DSV-{now_str}-{uuid.uuid4().hex[:6].upper()}"

        dataset_ver = DatasetVersion(
            id=uuid.uuid4(),
            cse_id=req.cse_id,
            assessment_id=req.assessment_id,
            batch_id=req.batch_id,
            version_tag=version_tag,
            dataset_type=req.dataset_type.lower(),
            source_filename=req.source_filename,
            content_hash=content_hash,
            record_count=rec_count,
            is_immutable=True,
            created_by_user_id=user_id
        )
        db.add(dataset_ver)

        # Update Assessment lifecycle status if attached
        if req.assessment_id:
            asmt = db.query(Assessment).filter(Assessment.id == req.assessment_id).first()
            if asmt and asmt.status == "DRAFT":
                asmt.status = "DATASET_ATTACHED"

        db.commit()
        db.refresh(dataset_ver)
        return dataset_ver

    @staticmethod
    def get_dataset_version(db: Session, version_id: uuid.UUID) -> DatasetVersion:
        dv = db.query(DatasetVersion).filter(DatasetVersion.id == version_id).first()
        if not dv:
            raise EntityNotFoundException("DatasetVersion", version_id)
        return dv

    @staticmethod
    def list_dataset_versions(
        db: Session,
        cse_id: Optional[uuid.UUID] = None,
        assessment_id: Optional[uuid.UUID] = None,
        allowed_cse_ids: Optional[List[uuid.UUID]] = None,
        skip: int = 0,
        limit: int = 50
    ) -> Tuple[int, List[DatasetVersion]]:
        query = db.query(DatasetVersion)
        if cse_id:
            query = query.filter(DatasetVersion.cse_id == cse_id)
        elif allowed_cse_ids is not None:
            query = query.filter(DatasetVersion.cse_id.in_(allowed_cse_ids))

        if assessment_id:
            query = query.filter(DatasetVersion.assessment_id == assessment_id)

        total = query.count()
        items = query.order_by(desc(DatasetVersion.created_at)).offset(skip).limit(limit).all()
        return total, items

dataset_version_service = DatasetVersionService()
