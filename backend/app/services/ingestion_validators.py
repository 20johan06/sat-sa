import os
import datetime
from datetime import timezone
import uuid
from typing import List, Dict, Any, Type, Tuple, Optional
from pydantic import BaseModel, ValidationError
from sqlalchemy.orm import Session
from sqlalchemy import select
from app.models.alert import Alert
from app.models.case import Case
from app.models.asset import Asset
from app.models.investigation import Investigation
from app.schemas.ingestion import (
    AlertIngestionItem,
    CaseIngestionItem,
    InvestigationIngestionItem,
    EscalationIngestionItem,
    CoverageIngestionItem,
    DatasetType,
    DataQualityReport,
    RejectionDetail
)
from app.utils.exceptions import IngestionException, FileTooLargeException

SUPPORTED_EXTENSIONS = {".csv", ".json"}
CANONICAL_SEVERITIES = {"CRITICAL", "HIGH", "MEDIUM", "LOW", "INFORMATIONAL"}

SCHEMA_MAP: Dict[str, Type[BaseModel]] = {
    "alerts": AlertIngestionItem,
    "cases": CaseIngestionItem,
    "investigations": InvestigationIngestionItem,
    "escalations": EscalationIngestionItem,
    "monitoring_coverages": CoverageIngestionItem
}


def validate_file_security(filename: str, content_length: int, max_bytes: int) -> str:
    if content_length > max_bytes:
        raise FileTooLargeException(size_bytes=content_length, max_bytes=max_bytes)

    if not filename or len(filename.strip()) == 0:
        raise IngestionException("Filename cannot be empty.", code="INVALID_FILENAME", status_code=400)

    if "\x00" in filename or "\n" in filename or "\r" in filename:
        raise IngestionException("Malicious character detected in filename.", code="PATH_TRAVERSAL_ATTEMPT", status_code=400)

    clean_filename = os.path.basename(filename.replace("\\", "/"))
    ext = os.path.splitext(clean_filename)[1].lower()
    if ext not in SUPPORTED_EXTENSIONS:
        raise IngestionException(
            f"Unsupported file format '{ext}'. Allowed formats: CSV, JSON.",
            code="UNSUPPORTED_FORMAT",
            status_code=400
        )

    return clean_filename


def perform_comprehensive_data_quality_validation(
    db: Session,
    cse_id: uuid.UUID,
    dataset_type: DatasetType,
    records: List[Dict[str, Any]]
) -> Tuple[List[BaseModel], DataQualityReport]:
    """
    Performs comprehensive Data Quality analysis across operational data dimensions:
    - Schema & missing required fields
    - Severity taxonomy normalization
    - Timestamp sanity and chronological logic
    - Duplicate external identifier detection (in-file & database)
    - Relationship & foreign key integrity
    
    Returns (valid_pydantic_items, data_quality_report)
    """
    if dataset_type not in SCHEMA_MAP:
        raise IngestionException(
            f"Unsupported dataset type '{dataset_type}'.",
            code="UNSUPPORTED_DATASET_TYPE",
            status_code=400
        )

    schema_cls = SCHEMA_MAP[dataset_type]
    report = DataQualityReport(
        total_records=len(records),
        valid_records=0,
        rejected_records=0
    )

    valid_items: List[BaseModel] = []
    seen_external_ids = set()
    now_utc = datetime.datetime.now(timezone.utc)

    for idx, raw_record in enumerate(records, start=1):
        if not isinstance(raw_record, dict):
            report.rejected_records += 1
            report.missing_fields_count += 1
            report.rejections.append(RejectionDetail(
                record_index=idx,
                field="record",
                value=str(raw_record),
                reason="Record is not a key-value object.",
                code="INVALID_RECORD_FORMAT"
            ))
            continue

        # 1. Pydantic Schema Validation
        try:
            item = schema_cls.model_validate(raw_record)
        except ValidationError as e:
            report.rejected_records += 1
            report.missing_fields_count += len(e.errors())
            err_msg = "; ".join(f"{'->'.join(str(l) for l in err['loc'])}: {err['msg']}" for err in e.errors())
            report.rejections.append(RejectionDetail(
                record_index=idx,
                field="schema",
                value=None,
                reason=err_msg,
                code="SCHEMA_VALIDATION_ERROR"
            ))
            continue

        is_record_valid = True

        # 2. Severity Validation
        if hasattr(item, "severity") and item.severity:
            norm_sev = str(item.severity).upper().strip()
            if norm_sev not in CANONICAL_SEVERITIES:
                report.invalid_severity_count += 1
                report.rejections.append(RejectionDetail(
                    record_index=idx,
                    field="severity",
                    value=str(item.severity),
                    reason=f"Invalid severity '{item.severity}'. Canonical values: {sorted(list(CANONICAL_SEVERITIES))}",
                    code="INVALID_SEVERITY"
                ))
                is_record_valid = False
            else:
                setattr(item, "severity", norm_sev)

        # 3. Timestamp Validation (Impossible / Chronological)
        # Check detected_at / opened_at / started_at
        start_ts: Optional[datetime.datetime] = getattr(item, "detected_at", None) or getattr(item, "opened_at", None) or getattr(item, "started_at", None)
        end_ts: Optional[datetime.datetime] = getattr(item, "closed_at", None) or getattr(item, "completed_at", None)

        if start_ts:
            if start_ts.year < 2000:
                report.impossible_timestamps_count += 1
                report.rejections.append(RejectionDetail(
                    record_index=idx,
                    field="timestamp",
                    value=start_ts.isoformat(),
                    reason="Timestamp is earlier than year 2000.",
                    code="IMPOSSIBLE_TIMESTAMP"
                ))
                is_record_valid = False
            elif start_ts > now_utc + datetime.timedelta(minutes=5):
                report.impossible_timestamps_count += 1
                report.rejections.append(RejectionDetail(
                    record_index=idx,
                    field="timestamp",
                    value=start_ts.isoformat(),
                    reason="Timestamp is in the future.",
                    code="FUTURE_TIMESTAMP"
                ))
                is_record_valid = False

        if start_ts and end_ts:
            if end_ts < start_ts:
                report.impossible_timestamps_count += 1
                report.rejections.append(RejectionDetail(
                    record_index=idx,
                    field="closed_at",
                    value=end_ts.isoformat(),
                    reason=f"End timestamp ({end_ts.isoformat()}) is earlier than start timestamp ({start_ts.isoformat()}).",
                    code="CHRONOLOGICAL_INCONSISTENCY"
                ))
                is_record_valid = False

        # 4. In-File Duplicate Detection
        ext_id = getattr(item, "external_alert_id", None) or getattr(item, "external_case_id", None) or getattr(item, "external_investigation_id", None)
        if ext_id:
            if ext_id in seen_external_ids:
                report.duplicate_records_count += 1
                report.rejections.append(RejectionDetail(
                    record_index=idx,
                    field="external_id",
                    value=ext_id,
                    reason=f"Duplicate identifier '{ext_id}' within current upload batch.",
                    code="DUPLICATE_IN_BATCH"
                ))
                is_record_valid = False
            else:
                seen_external_ids.add(ext_id)

        # 5. Database Duplicate & Foreign Key Relationship Validation
        if is_record_valid:
            if dataset_type == "alerts" and isinstance(item, AlertIngestionItem):
                # Check DB duplicate external_alert_id for this CSE
                existing = db.query(Alert).filter(Alert.cse_id == cse_id, Alert.external_alert_id == item.external_alert_id).first()
                if existing:
                    report.duplicate_records_count += 1
                    report.rejections.append(RejectionDetail(
                        record_index=idx,
                        field="external_alert_id",
                        value=item.external_alert_id,
                        reason=f"Alert with external_alert_id '{item.external_alert_id}' already exists in database for this CSE.",
                        code="DUPLICATE_IN_DATABASE"
                    ))
                    is_record_valid = False
                elif item.asset_id:
                    # Check asset exists
                    asset_exists = db.query(Asset).filter(Asset.id == item.asset_id).first()
                    if not asset_exists:
                        report.broken_references_count += 1
                        report.rejections.append(RejectionDetail(
                            record_index=idx,
                            field="asset_id",
                            value=str(item.asset_id),
                            reason=f"Target asset_id '{item.asset_id}' does not exist in database.",
                            code="BROKEN_REFERENCE"
                        ))
                        is_record_valid = False

            elif dataset_type == "cases" and isinstance(item, CaseIngestionItem):
                existing = db.query(Case).filter(Case.cse_id == cse_id, Case.external_case_id == item.external_case_id).first()
                if existing:
                    report.duplicate_records_count += 1
                    report.rejections.append(RejectionDetail(
                        record_index=idx,
                        field="external_case_id",
                        value=item.external_case_id,
                        reason=f"Case with external_case_id '{item.external_case_id}' already exists in database for this CSE.",
                        code="DUPLICATE_IN_DATABASE"
                    ))
                    is_record_valid = False
                elif item.alert_id:
                    alert_obj = db.query(Alert).filter(Alert.id == item.alert_id).first()
                    if not alert_obj or alert_obj.cse_id != cse_id:
                        report.broken_references_count += 1
                        report.rejections.append(RejectionDetail(
                            record_index=idx,
                            field="alert_id",
                            value=str(item.alert_id),
                            reason=f"Parent alert_id '{item.alert_id}' does not exist or belongs to another CSE.",
                            code="BROKEN_REFERENCE"
                        ))
                        is_record_valid = False

            elif dataset_type == "investigations" and isinstance(item, InvestigationIngestionItem):
                case_obj = db.query(Case).filter(Case.id == item.case_id).first()
                if not case_obj or case_obj.cse_id != cse_id:
                    report.broken_references_count += 1
                    report.rejections.append(RejectionDetail(
                        record_index=idx,
                        field="case_id",
                        value=str(item.case_id),
                        reason=f"Target case_id '{item.case_id}' does not exist or belongs to another CSE.",
                        code="BROKEN_REFERENCE"
                    ))
                    is_record_valid = False

            elif dataset_type == "escalations" and isinstance(item, EscalationIngestionItem):
                case_obj = db.query(Case).filter(Case.id == item.case_id).first()
                if not case_obj or case_obj.cse_id != cse_id:
                    report.broken_references_count += 1
                    report.rejections.append(RejectionDetail(
                        record_index=idx,
                        field="case_id",
                        value=str(item.case_id),
                        reason=f"Target case_id '{item.case_id}' does not exist or belongs to another CSE.",
                        code="BROKEN_REFERENCE"
                    ))
                    is_record_valid = False

        if is_record_valid:
            valid_items.append(item)
        else:
            report.rejected_records += 1

    report.valid_records = len(valid_items)
    report.coverage_limitations = [
        "In-flight duplicate checks are limited to current batch scope and active DB index.",
        "Foreign key reference validation enforces exact CSE boundary boundaries."
    ]

    return valid_items, report


def validate_and_normalize_records(
    dataset_type: DatasetType,
    records: List[Dict[str, Any]]
) -> List[BaseModel]:
    """Legacy wrapper for backward compatibility."""
    if dataset_type not in SCHEMA_MAP:
        raise IngestionException(
            f"Unsupported dataset type '{dataset_type}'.",
            code="UNSUPPORTED_DATASET_TYPE",
            status_code=400
        )

    schema_cls = SCHEMA_MAP[dataset_type]
    validated_items: List[BaseModel] = []
    errors: List[str] = []

    for idx, raw_record in enumerate(records, start=1):
        if not isinstance(raw_record, dict):
            errors.append(f"Record {idx}: Must be a valid key-value object.")
            continue

        try:
            item = schema_cls.model_validate(raw_record)
            validated_items.append(item)
        except ValidationError as e:
            for err in e.errors():
                loc = "->".join(str(l) for l in err["loc"])
                errors.append(f"Record {idx} field '{loc}': {err['msg']}")

    if errors:
        error_msg = f"Validation failed for {len(errors)} record(s):\n" + "\n".join(errors[:10])
        if len(errors) > 10:
            error_msg += f"\n... and {len(errors) - 10} more errors."
        raise IngestionException(
            message=error_msg,
            code="SCHEMA_VALIDATION_ERROR",
            status_code=422,
            details={"total_errors": len(errors), "sample_errors": errors[:10]}
        )

    return validated_items

