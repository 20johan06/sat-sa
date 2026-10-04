import uuid
from datetime import datetime
from typing import Dict, Optional
from pydantic import BaseModel, Field

class PackageManifest(BaseModel):
    package_format: str = Field("SAT-SA-OFFLINE-PACKAGE", description="Identifier for SAT-SA offline package format")
    format_version: str = Field("1.0.0", description="Specification version of the package format")
    app_version: str = Field("v2.0.0", description="SAT-SA application schema version")
    package_id: uuid.UUID = Field(..., description="Unique UUID identifier for this exported package")
    created_at: datetime = Field(..., description="UTC creation timestamp")
    exported_by_user: Optional[str] = Field(None, description="Username of the user who performed the export")
    export_host_name: Optional[str] = Field(None, description="Non-identity diagnostic host metadata")
    cse_id: uuid.UUID = Field(..., description="Primary Critical Sector Entity ID")
    cse_code: str = Field(..., description="Primary Critical Sector Entity code")
    assessment_id: uuid.UUID = Field(..., description="Exported Assessment ID")
    assessment_name: str = Field(..., description="Exported Assessment name")
    record_counts: Dict[str, int] = Field(default_factory=dict, description="Counts of exported records by entity")
    is_encrypted: bool = Field(True, description="Payload is always encrypted at rest using AES-256-GCM")
    key_protection_mode: str = Field("PASSPHRASE", description="Key protection mode: 'PASSPHRASE' or 'SYSTEM_KEY'")
    kdf_salt: str = Field(..., description="Hex salt for PBKDF2 key derivation")
    kdf_iterations: int = Field(100000, description="PBKDF2 iteration count")
    aead_algorithm: str = Field("AES-256-GCM", description="Authenticated encryption algorithm")
    aead_nonce: str = Field(..., description="12-byte hex nonce for AES-256-GCM AEAD encryption")
    data_hash_sha256: str = Field(..., description="SHA-256 application-level payload digest for post-decryption integrity verification")

class PackageValidationResponse(BaseModel):
    is_valid: bool = Field(..., description="Whether the package is structurally and cryptographically valid")
    message: str = Field(..., description="Validation summary or error description")
    manifest: Optional[PackageManifest] = Field(None, description="Decoded package manifest if valid")
    conflict_detected: bool = Field(False, description="Whether an assessment with the same ID already exists locally")
    conflict_details: Optional[str] = Field(None, description="Details of any detected conflicts")
    record_counts_preview: Dict[str, int] = Field(default_factory=dict, description="Preview of record counts to be imported")

class PackageExportRequest(BaseModel):
    passphrase: Optional[str] = Field(None, description="Optional passphrase to protect package payload key. If omitted, system key protection is used.")

class PackageImportResponse(BaseModel):
    success: bool = Field(..., description="Import operation result")
    message: str = Field(..., description="Import summary description")
    imported_assessment_id: uuid.UUID = Field(..., description="UUID of the imported Assessment")
    imported_cse_id: uuid.UUID = Field(..., description="UUID of the imported CSE")
    record_counts: Dict[str, int] = Field(default_factory=dict, description="Counts of records imported per entity")
    imported_at: datetime = Field(..., description="UTC timestamp when import completed")
