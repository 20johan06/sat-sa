import uuid
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, Field

class DatasetVersionCreate(BaseModel):
    cse_id: uuid.UUID = Field(..., description="Target Critical Sector Entity ID")
    assessment_id: Optional[uuid.UUID] = Field(None, description="Linked Assessment ID")
    batch_id: Optional[uuid.UUID] = Field(None, description="Linked Ingestion Batch ID for provenance")
    dataset_type: str = Field(..., description="Type of dataset (alerts, cases, investigations, escalations, monitoring_coverages)")
    source_filename: str = Field(..., max_length=255, description="Source filename or payload reference")
    version_tag: Optional[str] = Field(None, description="Optional custom version tag")

class DatasetVersionResponse(BaseModel):
    id: uuid.UUID
    cse_id: uuid.UUID
    assessment_id: Optional[uuid.UUID] = None
    batch_id: Optional[uuid.UUID] = None
    version_tag: str
    dataset_type: str
    source_filename: str
    content_hash: str
    record_count: int
    is_immutable: bool
    created_at: datetime
    created_by_user_id: Optional[uuid.UUID] = None

    class Config:
        from_attributes = True

class DatasetVersionListResponse(BaseModel):
    total: int
    items: List[DatasetVersionResponse]
