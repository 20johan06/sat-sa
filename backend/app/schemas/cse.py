import uuid
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, ConfigDict, Field

class CSEBase(BaseModel):
    cse_code: str = Field(..., min_length=2, max_length=50, description="Unique identifier code for the CSE")
    name: str = Field(..., min_length=2, max_length=255, description="Full name of the Critical Sector Entity")
    sector: str = Field(..., min_length=2, max_length=100, description="Industrial/Government sector")
    criticality_tier: str = Field("TIER_1", max_length=50, description="Criticality classification tier")
    contact_email: Optional[str] = Field(None, max_length=255, description="Contact email address")
    is_active: bool = Field(True, description="Active status flag")

class CSECreate(CSEBase):
    pass

class CSEUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=2, max_length=255)
    sector: Optional[str] = Field(None, min_length=2, max_length=100)
    criticality_tier: Optional[str] = Field(None, max_length=50)
    contact_email: Optional[str] = Field(None, max_length=255)
    is_active: Optional[bool] = None

class CSEResponse(CSEBase):
    id: uuid.UUID
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
