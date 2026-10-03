import uuid
from typing import Generator, List, Callable, Optional
from fastapi import Depends, HTTPException, status, Request
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.models.user import User
from app.services.auth_service import AuthService
from app.utils.security import decode_access_token
from app.utils.exceptions import SATSAException

security_scheme = HTTPBearer(auto_error=False)

def get_current_user(
    request: Request,
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security_scheme),
    db: Session = Depends(get_db)
) -> User:
    """
    Extracts Bearer token from header, validates signature and expiry,
    and returns the authenticated active user.
    """
    if not credentials or not credentials.credentials:
        raise SATSAException(
            message="Authentication credentials were not provided.",
            code="AUTHENTICATION_REQUIRED",
            status_code=401
        )

    token = credentials.credentials
    payload = decode_access_token(token)
    user_id_str = payload.get("sub")
    if not user_id_str:
        raise SATSAException(
            message="Invalid authentication token payload.",
            code="INVALID_TOKEN",
            status_code=401
        )

    try:
        user_id = uuid.UUID(user_id_str)
    except ValueError:
        raise SATSAException(
            message="Invalid user identifier format in token.",
            code="INVALID_TOKEN",
            status_code=401
        )

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise SATSAException(
            message="User associated with token no longer exists.",
            code="USER_NOT_FOUND",
            status_code=401
        )

    if not user.is_active:
        raise SATSAException(
            message="User account is deactivated.",
            code="ACCOUNT_INACTIVE",
            status_code=403
        )

    return user

def require_roles(*allowed_roles: str) -> Callable:
    """
    FastAPI dependency factory enforcing server-side Role-Based Access Control (RBAC).
    """
    def role_checker(
        current_user: User = Depends(get_current_user),
        db: Session = Depends(get_db),
        request: Request = None
    ) -> User:
        if current_user.role not in allowed_roles:
            ip = request.client.host if request and request.client else None
            AuthService.log_audit_event(
                db=db,
                user_id=current_user.id,
                username=current_user.username,
                action_type="AUTH_FORBIDDEN_ACCESS",
                status="FAILURE",
                ip_address=ip,
                details_json={
                    "required_roles": list(allowed_roles),
                    "user_role": current_user.role,
                    "path": request.url.path if request else ""
                }
            )
            raise SATSAException(
                message=f"Access forbidden. Role '{current_user.role}' lacks permission for this action.",
                code="FORBIDDEN_ROLE",
                status_code=403
            )
        return current_user
    return role_checker

def verify_cse_access(
    cse_id: uuid.UUID,
    current_user: User,
    db: Session
) -> None:
    """
    Enforces server-side CSE data isolation.
    ADMIN users have access to all CSEs.
    SUPERVISOR and VIEWER users have access ONLY to CSEs assigned in user_cses.
    """
    if current_user.role == "ADMIN":
        return

    allowed_cses = AuthService.get_user_allowed_cses(db, current_user)
    if cse_id not in allowed_cses:
        AuthService.log_audit_event(
            db=db,
            user_id=current_user.id,
            username=current_user.username,
            action_type="AUTH_UNAUTHORIZED_CSE_ACCESS",
            cse_id=cse_id,
            status="FAILURE",
            details_json={
                "attempted_cse_id": str(cse_id),
                "allowed_cse_ids": [str(cid) for cid in allowed_cses]
            }
        )
        raise SATSAException(
            message="Access denied. You are not authorized to view or manage data for this Critical Sector Entity.",
            code="UNAUTHORIZED_CSE_ACCESS",
            status_code=403
        )
