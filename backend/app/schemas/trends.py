import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, ConfigDict

from app.schemas.reporting import ObservationPeriodSchema

class TrendMetricItemSchema(BaseModel):
    metric_name: str
    rule_code: Optional[str] = None
    category: Optional[str] = None
    current_value: Optional[float] = None
    previous_value: Optional[float] = None
    historical_baseline: Optional[float] = None
    absolute_change: Optional[float] = None
    percentage_change: Optional[float] = None
    evidence_strength: str  # STRONG, MODERATE, LIMITED
    limitation: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class FindingStatusTrendItemSchema(BaseModel):
    status: str
    current_count: int
    previous_count: int
    absolute_change: int

    model_config = ConfigDict(from_attributes=True)

class CapabilityTrendSummaryItemSchema(BaseModel):
    capability: str
    direct_findings_current: int
    direct_findings_previous: int
    indirect_signals_current: int
    indirect_signals_previous: int

    model_config = ConfigDict(from_attributes=True)

class TimeSeriesDataPointSchema(BaseModel):
    timestamp: datetime
    value: float
    metadata_json: Optional[Dict[str, Any]] = None

    model_config = ConfigDict(from_attributes=True)

class CSETrendAnalysisResponse(BaseModel):
    cse_id: uuid.UUID
    cse_code: str
    cse_name: str
    sector: str
    criticality_tier: str
    current_period: ObservationPeriodSchema
    previous_period: Optional[ObservationPeriodSchema] = None
    metrics: List[TrendMetricItemSchema]
    finding_status_trends: List[FindingStatusTrendItemSchema]
    capability_trends: List[CapabilityTrendSummaryItemSchema]

    model_config = ConfigDict(from_attributes=True)
