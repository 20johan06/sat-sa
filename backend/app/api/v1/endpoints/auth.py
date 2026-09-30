from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user
from app.schemas.auth import UserLoginRequest, TokenResponse, UserResponse
from app.services.auth_service import AuthService
from app.utils.security import create_access_token
from app.models.user import User

router = APIRouter()

@router.post("/login", response_model=TokenResponse)
def login(
    req: UserLoginRequest,
    request: Request,
    db: Session = Depends(get_db)
):
    """
    Authenticates user credentials and returns JWT access token with profile.
    """
    # Ensure initial admin exists if DB is empty
    AuthService.ensure_initial_admin(db)

    ip_address = request.client.host if request.client else None
    user = AuthService.authenticate_user(
        db=db,
        username=req.username,
        password=req.password,
        ip_address=ip_address
    )

    access_token = create_access_token(data={"sub": str(user.id), "role": user.role})
    user_response = AuthService.serialize_user_response(db, user)

    return TokenResponse(
        access_token=access_token,
        token_type="bearer",
        user=user_response
    )

@router.get("/me", response_model=UserResponse)
def get_me(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Returns current authenticated user identity, role, and authorized CSE IDs."""
    return AuthService.serialize_user_response(db, current_user)

@router.post("/logout")
def logout(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Logs out user and records audit log event."""
    ip_address = request.client.host if request.client else None
    AuthService.log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action_type="AUTH_LOGOUT",
        status="SUCCESS",
        ip_address=ip_address
    )
    return {"message": "Successfully logged out."}
