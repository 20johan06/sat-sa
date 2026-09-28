import uuid
from typing import List
from sqlalchemy.orm import Session
from pydantic import BaseModel
from app.models.ingestion import IngestionBatch
from app.models.alert import Alert
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.escalation import Escalation
from app.models.coverage import MonitoringCoverage
from app.schemas.ingestion import (
    AlertIngestionItem,
    CaseIngestionItem,
    InvestigationIngestionItem,
    EscalationIngestionItem,
    CoverageIngestionItem,
    DatasetType
)

def persist_ingestion_records(
    db: Session,
    batch: IngestionBatch,
    dataset_type: DatasetType,
    items: List[BaseModel]
) -> int:
    """
    Persists validated operational records into PostgreSQL within the active transaction context.
    Links all persisted records directly to batch.id and batch.cse_id for full provenance traceability.
    """
    db_objects = []

    if dataset_type == "alerts":
        for item in items:
            assert isinstance(item, AlertIngestionItem)
            obj = Alert(
                id=uuid.uuid4(),
                cse_id=batch.cse_id,
                batch_id=batch.id,
                asset_id=item.asset_id,
                external_alert_id=item.external_alert_id,
                title=item.title,
                category=item.category,
                severity=item.severity,
                status=item.status,
                disposition=item.disposition,
                target_asset_name=item.target_asset_name,
                detected_at=item.detected_at,
                closed_at=item.closed_at,
                raw_metadata=item.raw_metadata
            )
            db_objects.append(obj)

    elif dataset_type == "cases":
        for item in items:
            assert isinstance(item, CaseIngestionItem)
            obj = Case(
                id=uuid.uuid4(),
                cse_id=batch.cse_id,
                batch_id=batch.id,
                alert_id=item.alert_id,
                external_case_id=item.external_case_id,
                title=item.title,
                status=item.status,
                priority=item.priority,
                summary=item.summary,
                opened_at=item.opened_at,
                closed_at=item.closed_at
            )
            db_objects.append(obj)

    elif dataset_type == "investigations":
        for item in items:
            assert isinstance(item, InvestigationIngestionItem)
            obj = Investigation(
                id=uuid.uuid4(),
                case_id=item.case_id,
                external_investigation_id=item.external_investigation_id,
                investigator_ref=item.investigator_ref,
                action_type=item.action_type,
                notes=item.notes,
                started_at=item.started_at,
                completed_at=item.completed_at,
                evidence_count=item.evidence_count
            )
            db_objects.append(obj)

    elif dataset_type == "escalations":
        for item in items:
            assert isinstance(item, EscalationIngestionItem)
            obj = Escalation(
                id=uuid.uuid4(),
                case_id=item.case_id,
                alert_id=item.alert_id,
                escalation_level=item.escalation_level,
                reason=item.reason,
                status=item.status,
                escalated_at=item.escalated_at
            )
            db_objects.append(obj)

    elif dataset_type == "monitoring_coverages":
        for item in items:
            assert isinstance(item, CoverageIngestionItem)
            obj = MonitoringCoverage(
                id=uuid.uuid4(),
                cse_id=batch.cse_id,
                log_source_category=item.log_source_category,
                is_expected=item.is_expected,
                is_active=item.is_active,
                last_received_at=item.last_received_at,
                coverage_percentage=item.coverage_percentage,
                period_start=item.period_start,
                period_end=item.period_end
            )
            db_objects.append(obj)

    db.add_all(db_objects)
    return len(db_objects)
