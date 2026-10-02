import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, ConfigDict, model_validator, Field

class ObservationPeriodSchema(BaseModel):
    start: Optional[datetime] = None
    end: Optional[datetime] = None
    is_bounded: bool

class CSESummarySchema(BaseModel):
    cse_id: uuid.UUID
    code: str
    name: str
    sector: str
    criticality_tier: str
    telemetry_counts: Dict[str, Any]
    analytics_summary: Dict[str, Any]

class AnalyticsRunRequest(BaseModel):
    obs_start: Optional[datetime] = None
    obs_end: Optional[datetime] = None
    batch_id: Optional[uuid.UUID] = None

    @model_validator(mode="after")
    def validate_dates(self):
        if self.obs_start and self.obs_end and self.obs_start >= self.obs_end:
            raise ValueError("obs_start must be strictly before obs_end")
        return self

class AnalyticsRunResultSchema(BaseModel):
    cse_id: uuid.UUID
    observation_period: ObservationPeriodSchema
    rules_evaluated: List[str]
    findings_created: int
    findings_deduplicated: int
    baselines_persisted: int
    data_sufficiency_by_rule: Dict[str, str]
    executed_at: datetime

class SignalGroupSchema(BaseModel):
    display_name: str
    count: int
    max_severity: Optional[str] = None
    findings: List[Dict[str, Any]]

class SignalMatrixResponse(BaseModel):
    cse_id: uuid.UUID
    observation_period: ObservationPeriodSchema
    data_sufficiency_status: str  # "NO_FINDINGS" or "SUFFICIENT"
    signals: Dict[str, SignalGroupSchema]

class FindingEvidenceResponse(BaseModel):
    id: uuid.UUID
    finding_id: uuid.UUID
    evidence_type: str
    alert_id: Optional[uuid.UUID] = None
    case_id: Optional[uuid.UUID] = None
    investigation_id: Optional[uuid.UUID] = None
    escalation_id: Optional[uuid.UUID] = None
    coverage_id: Optional[uuid.UUID] = None
    notes: Optional[str] = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

class FindingReviewHistoryResponse(BaseModel):
    id: uuid.UUID
    finding_id: uuid.UUID
    user_id: Optional[uuid.UUID] = None
    username: Optional[str] = None
    user_role: Optional[str] = None
    cse_id: uuid.UUID
    action_type: str
    previous_status: Optional[str] = None
    new_status: Optional[str] = None
    note_text: Optional[str] = None
    evidence_request_details: Optional[Dict[str, Any]] = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

class ExaminerNoteCreate(BaseModel):
    note_text: str = Field(..., min_length=1, max_length=2000)

class EvidenceRequestCreate(BaseModel):
    note_text: str = Field(..., min_length=1, max_length=2000)
    required_data_types: List[str] = Field(..., min_length=1)
    requested_time_window: Optional[str] = None
    description: Optional[str] = None

class ExplainabilitySchema(BaseModel):
    what: str
    why: str
    how: str
    evidence: str
    baseline: str
    impact: str

class FindingStatusUpdateSchema(BaseModel):
    status: str
    notes: Optional[str] = Field(None, max_length=2000)

class FindingItemSchema(BaseModel):
    id: uuid.UUID
    finding_code: str
    cse_id: uuid.UUID
    batch_id: Optional[uuid.UUID] = None
    category: str  # EXECUTION_GAP, NEGATIVE_SPACE, ANOMALY, BENCHMARK
    severity: str
    title: str
    description: str
    rationale: str
    detection_method: str
    metrics_json: Optional[Dict[str, Any]] = None
    status: str
    evidence_count: int
    detected_at: datetime
    explainability: Optional[ExplainabilitySchema] = None

    model_config = ConfigDict(from_attributes=True)

class FindingDetailSchema(FindingItemSchema):
    evidence: List[FindingEvidenceResponse] = []
    review_history: List[FindingReviewHistoryResponse] = []


class PaginatedFindingsResponse(BaseModel):
    items: List[FindingItemSchema]
    pagination: Dict[str, Any]
    observation_period: ObservationPeriodSchema

class PeerBaselineItemSchema(BaseModel):
    id: uuid.UUID
    metric_name: str
    peer_group: str
    baseline_value: float
    min_value: Optional[float] = None
    max_value: Optional[float] = None
    sample_size: int
    std_dev: float
    period_start: datetime
    period_end: datetime

    model_config = ConfigDict(from_attributes=True)

class PeerBenchmarkResponse(BaseModel):
    cse_id: uuid.UUID
    sector: str
    peer_group_name: str
    peer_group_status: str  # SECTOR_PEER_GROUP, POPULATION_FALLBACK, NO_APPLICABLE_BASELINE
    n_sector_observations: int
    observation_period: ObservationPeriodSchema
    baselines: List[PeerBaselineItemSchema]

class ReportJSONResponse(BaseModel):
    report_metadata: Dict[str, Any]
    cse_profile: Dict[str, Any]
    telemetry_summary: Dict[str, Any]
    supervisory_signals_summary: Dict[str, Any]
    active_findings: List[Dict[str, Any]]
    peer_baselines: List[Dict[str, Any]]
