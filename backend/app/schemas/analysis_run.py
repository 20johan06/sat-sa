import uuid
from datetime import datetime
from typing import List, Optional, Any, Dict
from pydantic import BaseModel, Field

class AnalysisRunCreate(BaseModel):
    cse_id: uuid.UUID = Field(..., description="Target Critical Sector Entity ID")
    assessment_id: Optional[uuid.UUID] = Field(None, description="Linked Assessment ID")
    dataset_version_id: Optional[uuid.UUID] = Field(None, description="Linked Dataset Version ID")
    obs_start: Optional[datetime] = Field(None, description="Start of observation window")
    obs_end: Optional[datetime] = Field(None, description="End of observation window")

class AnalysisRunResponse(BaseModel):
    id: uuid.UUID
    cse_id: uuid.UUID
    assessment_id: Optional[uuid.UUID] = None
    dataset_version_id: Optional[uuid.UUID] = None
    obs_start: Optional[datetime] = None
    obs_end: Optional[datetime] = None
    engine_version: str
    rules_evaluated: List[str]
    status: str
    findings_created: int
    baselines_persisted: int
    error_message: Optional[str] = None
    started_at: datetime
    completed_at: Optional[datetime] = None
    executed_by_user_id: Optional[uuid.UUID] = None

    class Config:
        from_attributes = True

class AnalysisRunListResponse(BaseModel):
    total: int
    items: List[AnalysisRunResponse]
