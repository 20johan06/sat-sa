import uuid
from datetime import datetime
from enum import Enum
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, ConfigDict

from app.schemas.reporting import ObservationPeriodSchema, ExplainabilitySchema

class CapabilitySufficiencyStatus(str, Enum):
    SUPERVISORY_FINDINGS_PRESENT = "SUPERVISORY_FINDINGS_PRESENT"
    NO_FINDINGS_EVALUATED = "NO_FINDINGS_EVALUATED"
    INSUFFICIENT_EVIDENCE = "INSUFFICIENT_EVIDENCE"

class EvidenceClassificationType(str, Enum):
    DIRECT = "DIRECT"
    INDIRECT = "INDIRECT"

class FindingCapabilitySummarySchema(BaseModel):
    finding_id: uuid.UUID
    finding_code: str
    canonical_rule_code: str
    title: str
    category: str
    severity: str
    status: str
    evidence_classification: EvidenceClassificationType
    detected_at: datetime

    model_config = ConfigDict(from_attributes=True)

class CapabilityAssessmentItem(BaseModel):
    capability: str
    status_indicator: CapabilitySufficiencyStatus
    status_description: str
    direct_rules_evaluated: List[str]
    indirect_signals_evaluated: List[str]
    direct_findings: List[FindingCapabilitySummarySchema]
    indirect_findings: List[FindingCapabilitySummarySchema]
    active_findings_count: int
    max_severity: str  # CRITICAL, HIGH, MEDIUM, LOW, NONE
    evidence_count: int
    evidence_strength_distribution: Dict[str, int]  # STRONG, MODERATE, LIMITED
    explainability: ExplainabilitySchema

    model_config = ConfigDict(from_attributes=True)

class AssessmentContextSchema(BaseModel):
    assessment_id: Optional[uuid.UUID] = None
    dataset_version_id: Optional[uuid.UUID] = None
    analysis_run_id: Optional[uuid.UUID] = None

class EntityCapabilityAssessmentResponse(BaseModel):
    cse_id: uuid.UUID
    cse_code: str
    cse_name: str
    sector: str
    criticality_tier: str
    assessment_context: Optional[AssessmentContextSchema] = None
    observation_period: ObservationPeriodSchema
    capabilities: List[CapabilityAssessmentItem]
    total_active_findings: int
    evaluated_capabilities_count: int
    insufficient_evidence_capabilities_count: int

    model_config = ConfigDict(from_attributes=True)
