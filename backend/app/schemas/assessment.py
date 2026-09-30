import uuid
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, Field, model_validator

class AssessmentBase(BaseModel):
    name: str = Field(..., max_length=255, description="Name or identifier of the assessment")
    description: Optional[str] = Field(None, description="Scope or objectives of the supervisory assessment")
    period_start: datetime = Field(..., description="Start of assessment window")
    period_end: datetime = Field(..., description="End of assessment window")

    @model_validator(mode="after")
    def validate_assessment_period(self) -> "AssessmentBase":
        if self.period_start >= self.period_end:
            raise ValueError("period_start must be strictly before period_end")
        return self

class AssessmentCreate(AssessmentBase):
    cse_id: uuid.UUID = Field(..., description="Target Critical Sector Entity ID")

class AssessmentUpdateStatus(BaseModel):
    status: str = Field(..., description="Target lifecycle state (DRAFT, DATASET_ATTACHED, IN_ANALYSIS, UNDER_REVIEW, COMPLETED)")

class AssessmentResponse(AssessmentBase):
    id: uuid.UUID
    cse_id: uuid.UUID
    status: str
    created_at: datetime
    updated_at: datetime
    created_by_user_id: Optional[uuid.UUID] = None

    class Config:
        from_attributes = True

class AssessmentListResponse(BaseModel):
    total: int
    items: List[AssessmentResponse]
