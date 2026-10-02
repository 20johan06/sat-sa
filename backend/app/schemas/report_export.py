import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, Field

class ReportGenerateRequest(BaseModel):
    cse_id: uuid.UUID
    assessment_id: Optional[uuid.UUID] = None
    dataset_version_id: Optional[uuid.UUID] = None
    analysis_run_id: Optional[uuid.UUID] = None
    obs_start: Optional[datetime] = None
    obs_end: Optional[datetime] = None

class ReportProvenanceSchema(BaseModel):
    cse_id: uuid.UUID
    cse_code: str
    cse_name: str
    sector: str
    criticality_tier: str
    assessment_id: Optional[uuid.UUID] = None
    dataset_version_id: Optional[uuid.UUID] = None
    dataset_hash: Optional[str] = None
    analysis_run_id: Optional[uuid.UUID] = None
    rule_manifest_versions: List[str] = Field(default_factory=list)
    obs_start: Optional[datetime] = None
    obs_end: Optional[datetime] = None
    generated_by_user_id: uuid.UUID
    generated_by_username: str
    created_at: datetime

class ReportItemSchema(BaseModel):
    id: uuid.UUID
    report_code: str
    cse_id: uuid.UUID
    assessment_id: Optional[uuid.UUID] = None
    dataset_version_id: Optional[uuid.UUID] = None
    analysis_run_id: Optional[uuid.UUID] = None
    obs_start: Optional[datetime] = None
    obs_end: Optional[datetime] = None
    generated_by_user_id: uuid.UUID
    generated_by_username: str
    created_at: datetime

class PaginatedReportsResponse(BaseModel):
    items: List[ReportItemSchema]
    total: int
    page: int
    page_size: int
    total_pages: int
