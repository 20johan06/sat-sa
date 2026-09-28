import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, Field, ConfigDict

class AnalyticsRunRequest(BaseModel):
    cse_id: uuid.UUID
    observation_start: Optional[datetime] = None
    observation_end: Optional[datetime] = None

class SignalCounts(BaseModel):
    evidence_gaps: int = 0
    statistical_anomalies: int = 0
    benchmark_deviations: int = 0
    supervisory_signals: int = 0

class SeverityBreakdown(BaseModel):
    critical: int = 0
    high: int = 0
    medium: int = 0
    low: int = 0

class ObservationPeriodSchema(BaseModel):
    start: Optional[datetime] = None
    end: Optional[datetime] = None

class SupervisorySignalMatrix(BaseModel):
    cse_id: uuid.UUID
    observation_period: ObservationPeriodSchema
    signal_counts: SignalCounts
    severity_breakdown: SeverityBreakdown
    data_sufficiency_status: str

class AnalyticsRunResult(BaseModel):
    cse_id: uuid.UUID
    findings_created: int
    baselines_created: int
    signal_matrix: SupervisorySignalMatrix

    model_config = ConfigDict(from_attributes=True)
