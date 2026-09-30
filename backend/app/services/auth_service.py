import uuid
from datetime import datetime, timezone
from typing import List, Optional, Dict, Any
from sqlalchemy.orm import Session
from sqlalchemy import select
from app.models.user import User, UserCSE, AuditLog
from app.models.cse import CSE
from app.schemas.auth import UserCreateRequest, UserUpdateRequest, UserResponse
from app.utils.security import get_password_hash, verify_password
from app.utils.exceptions import SATSAException, EntityNotFoundException, DuplicateEntityException
from app.config.settings import settings

class AuthService:

    @staticmethod
    def ensure_initial_admin(db: Session) -> User:
        """
        Ensures initial bootstrap admin account exists securely.
        Uses environment configuration for username and initial password hash.
        """
        admin = db.query(User).filter(User.username == settings.INITIAL_ADMIN_USERNAME).first()
        if not admin:
            admin = User(
                id=uuid.uuid4(),
                username=settings.INITIAL_ADMIN_USERNAME,
                email=settings.INITIAL_ADMIN_EMAIL,
                hashed_password=get_password_hash(settings.INITIAL_ADMIN_PASSWORD),
                full_name="System Administrator",
                role="ADMIN",
                is_active=True
            )
            db.add(admin)
            db.commit()
            db.refresh(admin)
            
            # Log admin bootstrap event
            AuthService.log_audit_event(
                db=db,
                user_id=admin.id,
                username=admin.username,
                action_type="SYSTEM_BOOTSTRAP_ADMIN",
                target_entity="User",
                target_id=admin.id,
                status="SUCCESS",
                details_json={"message": "Initial bootstrap admin account created successfully."}
            )
        return admin

    @staticmethod
    def authenticate_user(
        db: Session,
        username: str,
        password: str,
        ip_address: Optional[str] = None
    ) -> User:
        """Authenticates user credentials and records login audit log."""
        user = db.query(User).filter(User.username == username).first()
        if not user or not verify_password(password, user.hashed_password):
            # Log authentication failure
            AuthService.log_audit_event(
                db=db,
                user_id=user.id if user else None,
                username=username,
                action_type="AUTH_LOGIN_FAILURE",
                status="FAILURE",
                ip_address=ip_address,
                details_json={"reason": "Invalid credentials provided."}
            )
            raise SATSAException(
                message="Invalid username or password.",
                code="INVALID_CREDENTIALS",
                status_code=401
            )

        if not user.is_active:
            AuthService.log_audit_event(
                db=db,
                user_id=user.id,
                username=username,
                action_type="AUTH_LOGIN_INACTIVE",
                status="FAILURE",
                ip_address=ip_address,
                details_json={"reason": "Account is disabled."}
            )
            raise SATSAException(
                message="User account is deactivated. Please contact an administrator.",
                code="ACCOUNT_INACTIVE",
                status_code=403
            )

        # Update last login timestamp
        user.last_login_at = datetime.now(timezone.utc)
        db.commit()
        db.refresh(user)

        # Log authentication success
        AuthService.log_audit_event(
            db=db,
            user_id=user.id,
            username=user.username,
            action_type="AUTH_LOGIN_SUCCESS",
            status="SUCCESS",
            ip_address=ip_address,
            details_json={"role": user.role}
        )
        return user

    @staticmethod
    def create_user(
        db: Session,
        req: UserCreateRequest,
        acting_user: Optional[User] = None
    ) -> User:
        """Creates a new user account with explicit CSE permission assignments."""
        existing_username = db.query(User).filter(User.username == req.username).first()
        if existing_username:
            raise DuplicateEntityException("User", "username", req.username)

        existing_email = db.query(User).filter(User.email == req.email).first()
        if existing_email:
            raise DuplicateEntityException("User", "email", req.email)

        user = User(
            id=uuid.uuid4(),
            username=req.username,
            email=req.email,
            hashed_password=get_password_hash(req.password),
            full_name=req.full_name,
            role=req.role,
            is_active=True
        )
        db.add(user)
        db.flush()

        # Assign allowed CSE IDs
        if req.allowed_cse_ids:
            for cse_id in req.allowed_cse_ids:
                cse = db.query(CSE).filter(CSE.id == cse_id).first()
                if cse:
                    uc = UserCSE(id=uuid.uuid4(), user_id=user.id, cse_id=cse.id)
                    db.add(uc)

        db.commit()
        db.refresh(user)

        if acting_user:
            AuthService.log_audit_event(
                db=db,
                user_id=acting_user.id,
                username=acting_user.username,
                action_type="ADMIN_CREATE_USER",
                target_entity="User",
                target_id=user.id,
                status="SUCCESS",
                details_json={"new_username": user.username, "role": user.role}
            )

        return user

    @staticmethod
    def update_user(
        db: Session,
        user_id: uuid.UUID,
        req: UserUpdateRequest,
        acting_user: Optional[User] = None
    ) -> User:
        """Updates user details, role, status, or CSE assignments."""
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise EntityNotFoundException("User", user_id)

        if req.email and req.email != user.email:
            existing = db.query(User).filter(User.email == req.email).first()
            if existing:
                raise DuplicateEntityException("User", "email", req.email)
            user.email = req.email

        if req.full_name is not None:
            user.full_name = req.full_name

        if req.role:
            user.role = req.role

        if req.is_active is not None:
            user.is_active = req.is_active

        if req.password:
            user.hashed_password = get_password_hash(req.password)

        if req.allowed_cse_ids is not None:
            # Replace existing CSE permissions
            db.query(UserCSE).filter(UserCSE.user_id == user.id).delete()
            for cse_id in req.allowed_cse_ids:
                cse = db.query(CSE).filter(CSE.id == cse_id).first()
                if cse:
                    uc = UserCSE(id=uuid.uuid4(), user_id=user.id, cse_id=cse.id)
                    db.add(uc)

        user.updated_at = datetime.now(timezone.utc)
        db.commit()
        db.refresh(user)

        if acting_user:
            AuthService.log_audit_event(
                db=db,
                user_id=acting_user.id,
                username=acting_user.username,
                action_type="ADMIN_UPDATE_USER",
                target_entity="User",
                target_id=user.id,
                status="SUCCESS",
                details_json={"updated_username": user.username}
            )

        return user

    @staticmethod
    def get_user_allowed_cses(db: Session, user: User) -> List[uuid.UUID]:
        """Returns list of CSE IDs the user is authorized to access."""
        if user.role == "ADMIN":
            all_cses = db.query(CSE.id).all()
            return [c[0] for c in all_cses]
        user_cses = db.query(UserCSE.cse_id).filter(UserCSE.user_id == user.id).all()
        return [uc[0] for uc in user_cses]

    @staticmethod
    def serialize_user_response(db: Session, user: User) -> UserResponse:
        """Serializes User model into UserResponse schema with allowed CSE IDs."""
        allowed_cses = AuthService.get_user_allowed_cses(db, user)
        return UserResponse(
            id=user.id,
            username=user.username,
            email=user.email,
            full_name=user.full_name,
            role=user.role,
            is_active=user.is_active,
            allowed_cse_ids=allowed_cses,
            created_at=user.created_at,
            updated_at=user.updated_at,
            last_login_at=user.last_login_at
        )

    @staticmethod
    def log_audit_event(
        db: Session,
        action_type: str,
        user_id: Optional[uuid.UUID] = None,
        username: Optional[str] = None,
        target_entity: Optional[str] = None,
        target_id: Optional[uuid.UUID] = None,
        cse_id: Optional[uuid.UUID] = None,
        status: str = "SUCCESS",
        ip_address: Optional[str] = None,
        details_json: Optional[Dict[str, Any]] = None
    ) -> AuditLog:
        """Logs security and administrative events to the append-only audit_logs table."""
        audit_entry = AuditLog(
            id=uuid.uuid4(),
            user_id=user_id,
            username=username,
            action_type=action_type,
            target_entity=target_entity,
            target_id=target_id,
            cse_id=cse_id,
            status=status,
            ip_address=ip_address,
            details_json=details_json or {}
        )
        db.add(audit_entry)
        db.commit()
        db.refresh(audit_entry)
        return audit_entry
