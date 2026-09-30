import uuid
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, Field, EmailStr

class UserLoginRequest(BaseModel):
    username: str = Field(..., min_length=1, max_length=50)
    password: str = Field(..., min_length=1)

class UserResponse(BaseModel):
    id: uuid.UUID
    username: str
    email: str
    full_name: Optional[str] = None
    role: str
    is_active: bool
    allowed_cse_ids: List[uuid.UUID] = []
    created_at: datetime
    updated_at: datetime
    last_login_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse

class UserCreateRequest(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    email: EmailStr
    password: str = Field(..., min_length=6, max_length=100)
    full_name: Optional[str] = None
    role: str = Field("VIEWER", pattern="^(ADMIN|SUPERVISOR|VIEWER)$")
    allowed_cse_ids: Optional[List[uuid.UUID]] = []

class UserUpdateRequest(BaseModel):
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None
    role: Optional[str] = Field(None, pattern="^(ADMIN|SUPERVISOR|VIEWER)$")
    is_active: Optional[bool] = None
    password: Optional[str] = Field(None, min_length=6, max_length=100)
    allowed_cse_ids: Optional[List[uuid.UUID]] = None

class AuditLogResponse(BaseModel):
    id: uuid.UUID
    user_id: Optional[uuid.UUID] = None
    username: Optional[str] = None
    action_type: str
    target_entity: Optional[str] = None
    target_id: Optional[uuid.UUID] = None
    cse_id: Optional[uuid.UUID] = None
    status: str
    ip_address: Optional[str] = None
    details_json: dict = {}
    created_at: datetime

    class Config:
        from_attributes = True
