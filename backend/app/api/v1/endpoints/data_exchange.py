import uuid
from typing import Optional
from fastapi import APIRouter, Depends, status, File, UploadFile, Form, Response
from sqlalchemy.orm import Session

from app.api.deps import get_db, require_roles, verify_cse_access
from app.models.user import User
from app.models.assessment import Assessment
from app.schemas.data_exchange import (
    PackageExportRequest,
    PackageValidationResponse,
    PackageImportResponse
)
from app.services.data_exchange_service import DataExchangeService
from app.services.assessment_service import assessment_service

router = APIRouter(tags=["Offline Data Exchange"])

@router.post(
    "/assessments/{assessment_id}/export",
    summary="Export an Assessment to an encrypted/signed .satsa offline package",
    responses={
        200: {
            "content": {"application/octet-stream": {}},
            "description": "Returns .satsa ZIP package binary file"
        }
    }
)
def export_assessment_package(
    assessment_id: uuid.UUID,
    payload: Optional[PackageExportRequest] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Exports a versioned, encrypted, and integrity-verified .satsa package containing
    an assessment and all dependent CSE, findings, evidence, review history, and report records.
    Enforces server-side CSE isolation and RBAC role restrictions.
    """
    assessment = assessment_service.get_assessment(db, assessment_id)
    verify_cse_access(cse_id=assessment.cse_id, current_user=current_user, db=db)

    passphrase = payload.passphrase if payload else None
    pkg_bytes = DataExchangeService.export_assessment_package(
        db=db,
        assessment_id=assessment_id,
        passphrase=passphrase,
        exporting_user=current_user
    )

    filename = f"SAT-SA_Assessment_{assessment.cse_id}_{assessment_id}.satsa"
    return Response(
        content=pkg_bytes,
        media_type="application/octet-stream",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'}
    )

@router.post(
    "/assessments/import/validate",
    response_model=PackageValidationResponse,
    summary="Validate an offline .satsa package before import"
)
async def validate_assessment_package(
    file: UploadFile = File(..., description=".satsa package ZIP archive"),
    passphrase: Optional[str] = Form(None, description="Decryption passphrase if package is encrypted"),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Validates structure, format version, cryptographic signatures, checksum digests,
    and conflicts of an offline .satsa package without modifying database state.
    """
    file_bytes = await file.read()
    return DataExchangeService.validate_package(
        db=db,
        file_bytes=file_bytes,
        passphrase=passphrase
    )

@router.post(
    "/assessments/import",
    response_model=PackageImportResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Import an offline .satsa package into the local database"
)
async def import_assessment_package(
    file: UploadFile = File(..., description=".satsa package ZIP archive"),
    passphrase: Optional[str] = Form(None, description="Decryption passphrase if package is encrypted"),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles("ADMIN", "SUPERVISOR"))
):
    """
    Transactionally imports an offline .satsa assessment package into the local database.
    Performs manifest validation, key derivation, checksum verification, and atomic insertion.
    Rolls back automatically if any insertion fails.
    """
    file_bytes = await file.read()
    return DataExchangeService.import_assessment_package(
        db=db,
        file_bytes=file_bytes,
        passphrase=passphrase,
        importing_user=current_user
    )
