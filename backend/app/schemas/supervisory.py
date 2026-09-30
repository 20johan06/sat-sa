import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, ConfigDict

from app.schemas.reporting import ObservationPeriodSchema

class SupervisoryAttentionIndicators(BaseModel):
    active_findings_count: int
    active_critical_findings_count: int
    active_high_findings_count: int
    high_attention_findings_count: int  # CRITICAL + HIGH
    execution_gap_findings_count: int
    negative_space_findings_count: int
    anomaly_findings_count: int
    benchmark_deviations_count: int
    evidence_strength_distribution: Dict[str, int]  # STRONG, MODERATE, LIMITED, NONE
    affected_record_count: int
    affected_critical_high_records: int
    peer_deviations_count: int
    repeated_signals_count: int

class ExplainableRationaleSchema(BaseModel):
    what: str
    why: str
    how: str
    evidence: str
    baseline: str
    impact: str

class SupervisoryAttentionItem(BaseModel):
    cse_id: uuid.UUID
    cse_code: str
    cse_name: str
    sector: str
    criticality_tier: str
    indicators: SupervisoryAttentionIndicators
    dominant_categories: List[str]
    latest_analysis_run_at: Optional[str] = None
    observation_period: ObservationPeriodSchema
    concise_rationale: ExplainableRationaleSchema
    drilldown_context: Dict[str, Any]

class SupervisoryAttentionQueueResponse(BaseModel):
    items: List[SupervisoryAttentionItem]
    total_cses: int
    total_cses_with_active_findings: int
    total_active_findings: int
    total_critical_findings: int
    total_high_findings: int
    observation_period: ObservationPeriodSchema

class CapabilityBreakdownSchema(BaseModel):
    capability: str
    findings_count: int
    max_severity: str
    evidence_count: int

class EntitySupervisoryOverviewResponse(BaseModel):
    cse_id: uuid.UUID
    code: str
    name: str
    sector: str
    criticality_tier: str
    indicators: SupervisoryAttentionIndicators
    findings_by_category: Dict[str, int]
    findings_by_severity: Dict[str, int]
    evidence_strength_distribution: Dict[str, int]
    capabilities_breakdown: List[CapabilityBreakdownSchema]
    peer_benchmarks_summary: Dict[str, Any]
    observation_period: ObservationPeriodSchema
    latest_analysis_run: Optional[Dict[str, Any]] = None
    data_quality_limitations: List[str]
    why_attention: ExplainableRationaleSchema
