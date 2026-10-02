import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, ConfigDict
from app.schemas.reporting import ExplainabilitySchema, ObservationPeriodSchema

class ManualReviewRecommendationItem(BaseModel):
    recommendation_id: str
    finding_id: uuid.UUID
    finding_code: str
    finding_title: str
    cse_id: uuid.UUID
    cse_code: str
    cse_name: str
    record_type: str  # ALERT, CASE, INVESTIGATION, ESCALATION, COVERAGE
    record_id: Optional[str] = None
    category: str
    capability: str
    severity: str
    evidence_strength: str  # STRONG, MODERATE, LIMITED
    reason: str
    review_status: str  # NEW, UNDER_REVIEW, CONFIRMED, NOT_SUBSTANTIATED, DISMISSED, NEEDS_MORE_EVIDENCE
    evidence_count: int
    detected_at: datetime
    explainability: Optional[ExplainabilitySchema] = None

    model_config = ConfigDict(from_attributes=True)

class PaginatedManualReviewResponse(BaseModel):
    items: List[ManualReviewRecommendationItem]
    pagination: Dict[str, Any]
    filters_applied: Dict[str, Any]
