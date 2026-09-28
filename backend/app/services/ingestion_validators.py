import os
import re
from typing import List, Dict, Any, Type
from pydantic import BaseModel, ValidationError
from app.schemas.ingestion import (
    AlertIngestionItem,
    CaseIngestionItem,
    InvestigationIngestionItem,
    EscalationIngestionItem,
    CoverageIngestionItem,
    DatasetType
)
from app.utils.exceptions import IngestionException, FileTooLargeException

SUPPORTED_EXTENSIONS = {".csv", ".json"}

# Mapping dataset types to Pydantic validation schemas
SCHEMA_MAP: Dict[str, Type[BaseModel]] = {
    "alerts": AlertIngestionItem,
    "cases": CaseIngestionItem,
    "investigations": InvestigationIngestionItem,
    "escalations": EscalationIngestionItem,
    "monitoring_coverages": CoverageIngestionItem
}

def validate_file_security(filename: str, content_length: int, max_bytes: int) -> str:
    """
    Validates file size and filename security to defend against path traversal,
    null byte injection, oversized payloads, and unsupported file types.
    
    Returns the sanitized safe filename.
    """
    if content_length > max_bytes:
        raise FileTooLargeException(size_bytes=content_length, max_bytes=max_bytes)

    if not filename or len(filename.strip()) == 0:
        raise IngestionException("Filename cannot be empty.", code="INVALID_FILENAME", status_code=400)

    # Sanitize null bytes and control characters
    if "\x00" in filename or "\n" in filename or "\r" in filename:
        raise IngestionException("Malicious character detected in filename.", code="PATH_TRAVERSAL_ATTEMPT", status_code=400)

    # Defend against path traversal (e.g. "../../etc/passwd" or "C:\\Windows\\...")
    clean_filename = os.path.basename(filename.replace("\\", "/"))
    
    # Check for path traversal markers
    if ".." in filename or clean_filename != filename.strip():
        # Path traversal markers present in full input string
        # We enforce strict filename sanitization and check if suspicious traversal was attempted
        if ".." in filename or "/" in filename or "\\" in filename:
            # Report path traversal defense trigger
            pass  # Use sanitized basename

    # Ensure extension is allowed
    ext = os.path.splitext(clean_filename)[1].lower()
    if ext not in SUPPORTED_EXTENSIONS:
        raise IngestionException(
            f"Unsupported file format '{ext}'. Allowed formats: CSV, JSON.",
            code="UNSUPPORTED_FORMAT",
            status_code=400
        )

    return clean_filename

def validate_and_normalize_records(
    dataset_type: DatasetType,
    records: List[Dict[str, Any]]
) -> List[BaseModel]:
    """
    Validates raw dictionary records against the defined Pydantic dataset schema.
    
    Preserves exact evidence field values without modifying original operational text.
    """
    if dataset_type not in SCHEMA_MAP:
        raise IngestionException(
            f"Unsupported dataset type '{dataset_type}'. Supported dataset types: {list(SCHEMA_MAP.keys())}.",
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
        # If any validation errors occur, reject batch to maintain transactional integrity
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
