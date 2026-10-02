from pydantic import BaseModel, Field
from typing import Optional, Any

class ErrorDetail(BaseModel):
    code: str = Field(..., description="Unique machine-readable error code")
    message: str = Field(..., description="Human-readable error description")
    details: Optional[Any] = Field(None, description="Optional diagnostic details")

class HTTPErrorResponse(BaseModel):
    error: ErrorDetail


