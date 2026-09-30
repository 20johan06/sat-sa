import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional, Literal
from pydantic import BaseModel, Field, ConfigDict

DatasetType = Literal[
    "alerts",
    "cases",
    "investigations",
    "escalations",
    "monitoring_coverages"
]

class AlertIngestionItem(BaseModel):
    external_alert_id: str = Field(..., min_length=1, max_length=100)
    title: str = Field(..., min_length=1, max_length=255)
    category: str = Field(..., min_length=1, max_length=100)
    severity: str = Field(..., min_length=1, max_length=50)
    status: str = Field(..., min_length=1, max_length=50)
    detected_at: datetime
    disposition: Optional[str] = Field(None, max_length=100)
    target_asset_name: Optional[str] = Field(None, max_length=255)
    closed_at: Optional[datetime] = None
    asset_id: Optional[uuid.UUID] = None
    raw_metadata: Optional[Dict[str, Any]] = None

    model_config = ConfigDict(extra="allow")

class CaseIngestionItem(BaseModel):
    external_case_id: str = Field(..., min_length=1, max_length=100)
    title: str = Field(..., min_length=1, max_length=255)
    status: str = Field(..., min_length=1, max_length=50)
    priority: str = Field("MEDIUM", min_length=1, max_length=50)
    opened_at: datetime
    summary: Optional[str] = None
    closed_at: Optional[datetime] = None
    alert_id: Optional[uuid.UUID] = None

    model_config = ConfigDict(extra="ignore")

class InvestigationIngestionItem(BaseModel):
    case_id: uuid.UUID
    action_type: str = Field(..., min_length=1, max_length=100)
    started_at: datetime
    external_investigation_id: Optional[str] = Field(None, max_length=100)
    investigator_ref: Optional[str] = Field(None, max_length=100)
    notes: Optional[str] = None
    completed_at: Optional[datetime] = None
    evidence_count: int = Field(0, ge=0)

    model_config = ConfigDict(extra="ignore")

class EscalationIngestionItem(BaseModel):
    case_id: uuid.UUID
    escalation_level: str = Field(..., min_length=1, max_length=50)
    escalated_at: datetime
    alert_id: Optional[uuid.UUID] = None
    reason: Optional[str] = None
    status: str = Field("PENDING", min_length=1, max_length=50)

    model_config = ConfigDict(extra="ignore")

class CoverageIngestionItem(BaseModel):
    log_source_category: str = Field(..., min_length=1, max_length=100)
    is_expected: bool = True
    is_active: bool = True
    last_received_at: Optional[datetime] = None
    coverage_percentage: Optional[float] = Field(None, ge=0.0, le=100.0)
    period_start: Optional[datetime] = None
    period_end: Optional[datetime] = None

    model_config = ConfigDict(extra="ignore")

class RejectionDetail(BaseModel):
    record_index: int
    field: str
    value: Optional[str] = None
    reason: str
    code: str

class DataQualityReport(BaseModel):
    total_records: int = 0
    valid_records: int = 0
    rejected_records: int = 0
    duplicate_records_count: int = 0
    invalid_timestamps_count: int = 0
    impossible_timestamps_count: int = 0
    invalid_severity_count: int = 0
    missing_cse_count: int = 0
    broken_references_count: int = 0
    missing_fields_count: int = 0
    rejections: List[RejectionDetail] = []
    coverage_limitations: List[str] = []

class JSONIngestionPayload(BaseModel):
    cse_id: uuid.UUID
    dataset_type: DatasetType
    records: List[Dict[str, Any]]
    assessment_id: Optional[uuid.UUID] = None

class IngestionBatchResponse(BaseModel):
    id: uuid.UUID
    cse_id: uuid.UUID
    assessment_id: Optional[uuid.UUID] = None
    batch_reference: str
    source_type: str
    source_filename: str
    total_records: int
    valid_records: int
    rejected_records: int
    status: str
    error_summary: Optional[str] = None
    quality_report: Optional[Dict[str, Any]] = None
    imported_at: datetime

    model_config = ConfigDict(from_attributes=True)

class IngestionBatchListResponse(BaseModel):
    total: int
    items: List[IngestionBatchResponse]

