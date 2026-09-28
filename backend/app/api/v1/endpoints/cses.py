import uuid
from typing import List
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.schemas.cse import CSECreate, CSEResponse
from app.services.cse_service import cse_service

router = APIRouter(prefix="/cses", tags=["CSE Management"])

@router.post(
    "/",
    response_model=CSEResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register a new Critical Sector Entity (CSE)"
)
def create_cse(
    cse_in: CSECreate,
    db: Session = Depends(get_db)
):
    """
    Registers a new Critical Sector Entity in the supervisory database.
    """
    return cse_service.create_cse(db=db, cse_in=cse_in)

@router.get(
    "/",
    response_model=List[CSEResponse],
    summary="List registered Critical Sector Entities"
)
def list_cses(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=500),
    db: Session = Depends(get_db)
):
    """
    Retrieves a list of Critical Sector Entities.
    """
    return cse_service.list_cses(db=db, skip=skip, limit=limit)

@router.get(
    "/{cse_id}",
    response_model=CSEResponse,
    summary="Get Critical Sector Entity details"
)
def get_cse(
    cse_id: uuid.UUID,
    db: Session = Depends(get_db)
):
    """
    Fetches details for a specific Critical Sector Entity by ID.
    """
    return cse_service.get_cse_or_404(db=db, cse_id=cse_id)
