import uuid
from typing import List
from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session
from app.api.deps import get_db, require_roles
from app.schemas.auth import UserCreateRequest, UserUpdateRequest, UserResponse
from app.services.auth_service import AuthService
from app.models.user import User

router = APIRouter()

@router.get("", response_model=List[UserResponse])
def list_users(
    db: Session = Depends(get_db),
    admin_user: User = Depends(require_roles("ADMIN"))
):
    """Lists all registered users (Admin only)."""
    users = db.query(User).all()
    return [AuthService.serialize_user_response(db, u) for u in users]

@router.post("", response_model=UserResponse, status_code=201)
def create_user(
    req: UserCreateRequest,
    db: Session = Depends(get_db),
    admin_user: User = Depends(require_roles("ADMIN"))
):
    """Creates a new user account with role and explicit CSE permissions (Admin only)."""
    user = AuthService.create_user(db=db, req=req, acting_user=admin_user)
    return AuthService.serialize_user_response(db, user)

@router.get("/{user_id}", response_model=UserResponse)
def get_user(
    user_id: uuid.UUID,
    db: Session = Depends(get_db),
    admin_user: User = Depends(require_roles("ADMIN"))
):
    """Gets user profile by ID (Admin only)."""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        from app.utils.exceptions import EntityNotFoundException
        raise EntityNotFoundException("User", user_id)
    return AuthService.serialize_user_response(db, user)

@router.put("/{user_id}", response_model=UserResponse)
def update_user(
    user_id: uuid.UUID,
    req: UserUpdateRequest,
    db: Session = Depends(get_db),
    admin_user: User = Depends(require_roles("ADMIN"))
):
    """Updates user role, active status, or CSE assignments (Admin only)."""
    user = AuthService.update_user(db=db, user_id=user_id, req=req, acting_user=admin_user)
    return AuthService.serialize_user_response(db, user)
