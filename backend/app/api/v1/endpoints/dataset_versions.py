import uuid
from typing import Optional
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user, verify_cse_access, require_roles
from app.models.user import User
from app.schemas.dataset_version import (
    DatasetVersionCreate,
    DatasetVersionResponse,
    DatasetVersionListResponse
)
from app.services.dataset_version_service import dataset_version_service
from app.services.auth_service import AuthService

router = APIRouter(prefix="/dataset-versions", tags=["Dataset Versions"])

@router.post(
    "/",
    response_model=DatasetVersionResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create an immutable Dataset Version"
)
def create_dataset_version(
    req: DatasetVersionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Creates an immutable dataset version record with SHA-256 integrity hash.
    Enforces server-side CSE isolation and RBAC role restrictions.
    """
    verify_cse_access(cse_id=req.cse_id, current_user=current_user, db=db)
    return dataset_version_service.create_dataset_version(
        db=db,
        req=req,
        user_id=current_user.id
    )

@router.get(
    "/",
    response_model=DatasetVersionListResponse,
    summary="List Dataset Versions"
)
def list_dataset_versions(
    cse_id: Optional[uuid.UUID] = Query(None, description="Filter by CSE ID"),
    assessment_id: Optional[uuid.UUID] = Query(None, description="Filter by Assessment ID"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Lists immutable dataset versions with pagination.
    Restricts non-admin users to explicitly authorized CSEs.
    """
    allowed_cse_ids = None
    if cse_id:
        verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    elif current_user.role != "ADMIN":
        allowed_cse_ids = AuthService.get_user_allowed_cses(db, current_user)

    total, items = dataset_version_service.list_dataset_versions(
        db=db,
        cse_id=cse_id,
        assessment_id=assessment_id,
        allowed_cse_ids=allowed_cse_ids,
        skip=skip,
        limit=limit
    )
    return DatasetVersionListResponse(total=total, items=items)

@router.get(
    "/{version_id}",
    response_model=DatasetVersionResponse,
    summary="Get Dataset Version details"
)
def get_dataset_version(
    version_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves details for a single immutable dataset version.
    Enforces object-level server-side CSE data isolation.
    """
    dv = dataset_version_service.get_dataset_version(db, version_id)
    verify_cse_access(cse_id=dv.cse_id, current_user=current_user, db=db)
    return dv
