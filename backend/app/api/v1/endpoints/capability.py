import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, verify_cse_access
from app.models.user import User
from app.schemas.capability import (
    EntityCapabilityAssessmentResponse,
    CapabilityAssessmentItem
)
from app.services.capability_service import capability_service

router = APIRouter(prefix="/supervisory/cse", tags=["Capability Assessment"])

@router.get(
    "/{cse_id}/capability-assessment",
    response_model=EntityCapabilityAssessmentResponse,
    summary="Retrieve Eight Capability Assessment for a CSE"
)
def get_entity_capability_assessment(
    cse_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves the Eight Capability Assessment for a specific Critical Sector Entity (CSE).
    Enforces server-side CSE data isolation via verify_cse_access.
    """
    verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    try:
        return capability_service.get_entity_capability_assessment(db=db, cse_id=cse_id)
    except ValueError as ve:
        raise HTTPException(status_code=422, detail=str(ve))

@router.get(
    "/{cse_id}/capability/{capability_name}/detail",
    response_model=CapabilityAssessmentItem,
    summary="Retrieve single capability dimension detail for a CSE"
)
def get_capability_detail(
    cse_id: uuid.UUID,
    capability_name: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Retrieves detailed assessment for a single capability dimension.
    Enforces server-side CSE data isolation via verify_cse_access.
    """
    verify_cse_access(cse_id=cse_id, current_user=current_user, db=db)
    try:
        return capability_service.get_capability_detail(db=db, cse_id=cse_id, capability_name=capability_name)
    except ValueError as ve:
        raise HTTPException(status_code=422, detail=str(ve))
