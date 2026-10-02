from typing import Any, Dict
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, require_roles
from app.models.user import User
from app.schemas.validation import (
    ValidationGenerateRequest,
    ValidationRunRequest,
    ValidationRunResult
)
from app.services.synthetic_generator_service import synthetic_generator_service
from app.services.validation_service import validation_service

router = APIRouter(prefix="/validation", tags=["Synthetic Data & Validation"])

@router.post(
    "/generate",
    response_model=Dict[str, Any],
    summary="Generate deterministic synthetic validation datasets"
)
def generate_synthetic_data(
    req: ValidationGenerateRequest = ValidationGenerateRequest(),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Generates reproducible, isolated synthetic operational datasets (SYN-CSE-01 to SYN-CSE-08).
    Sets dataset_type='SYNTHETIC_VALIDATION' to prevent operational dataset contamination.
    """
    res = synthetic_generator_service.generate_all_scenarios(db, force_recreate=req.force_recreate)
    return res

@router.post(
    "/run",
    response_model=ValidationRunResult,
    summary="Run validation framework and calculate precision/recall metrics"
)
def run_validation(
    req: ValidationRunRequest = ValidationRunRequest(),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Executes existing Phase 5 analytics against synthetic validation scenarios,
    compares findings against ground truth, and calculates TP/FP/FN/TN, Precision, Recall, F1, and Precision@K.
    """
    # Ensure synthetic dataset is generated first
    synthetic_generator_service.generate_all_scenarios(db, force_recreate=False)
    result = validation_service.run_validation(db=db, k_value=req.k_value)
    return result

@router.get(
    "/results",
    response_model=ValidationRunResult,
    summary="Get current synthetic validation run results"
)
def get_validation_results(
    k_value: int = Query(5, ge=1, le=50),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Retrieves current synthetic validation metrics and ground truth matrix."""
    synthetic_generator_service.generate_all_scenarios(db, force_recreate=False)
    result = validation_service.run_validation(db=db, k_value=k_value)
    return result
