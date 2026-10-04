import io
import json
import uuid
import hashlib
import secrets
import zipfile
import platform
from datetime import datetime, timezone
from typing import Dict, List, Any, Optional, Tuple

from sqlalchemy.orm import Session
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.exceptions import InvalidTag

from app.config.settings import settings
from app.models.cse import CSE
from app.models.assessment import Assessment
from app.models.dataset_version import DatasetVersion
from app.models.analysis_run import AnalysisRun
from app.models.finding import Finding, FindingEvidence, FindingReviewHistory
from app.models.report import ReportRecord
from app.models.ingestion import IngestionBatch
from app.models.alert import Alert
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.escalation import Escalation
from app.models.coverage import MonitoringCoverage
from app.models.asset import Asset
from app.models.user import User
from app.services.auth_service import AuthService
from app.schemas.data_exchange import (
    PackageManifest,
    PackageValidationResponse,
    PackageImportResponse
)
from app.utils.exceptions import EntityNotFoundException, SATSAException

def _iso_datetime(dt: Optional[datetime]) -> Optional[str]:
    if dt is None:
        return None
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.isoformat()

def _parse_datetime(dt_str: Optional[str]) -> Optional[datetime]:
    if dt_str is None:
        return None
    dt = datetime.fromisoformat(dt_str)
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt

def _derive_aes256_key(secret_str: str, salt_bytes: bytes, iterations: int = 100000) -> bytes:
    """
    Derives a 256-bit (32-byte) AES key using standard PBKDF2-HMAC-SHA256 from PyCA cryptography.
    """
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt_bytes,
        iterations=iterations
    )
    return kdf.derive(secret_str.encode("utf-8"))

def _construct_aad(package_format: str, format_version: str, package_id_str: str) -> bytes:
    """Constructs Additional Authenticated Data (AAD) for AES-GCM tag binding."""
    return f"{package_format}:{format_version}:{package_id_str}".encode("utf-8")

class DataExchangeService:
    """
    Offline Data Exchange Engine for .satsa package export, import,
    AES-256-GCM AEAD decryption, payload checksum verification, and transactional DB restoration.
    """

    @staticmethod
    def export_assessment_package(
        db: Session,
        assessment_id: uuid.UUID,
        passphrase: Optional[str] = None,
        exporting_user: Optional[User] = None
    ) -> bytes:
        assessment = db.query(Assessment).filter(Assessment.id == assessment_id).first()
        if not assessment:
            raise EntityNotFoundException("Assessment", assessment_id)

        cse = db.query(CSE).filter(CSE.id == assessment.cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", assessment.cse_id)

        # 1. Gather dependent records
        dataset_versions = db.query(DatasetVersion).filter(DatasetVersion.assessment_id == assessment_id).all()
        analysis_runs = db.query(AnalysisRun).filter(AnalysisRun.assessment_id == assessment_id).all()
        analysis_run_ids = [ar.id for ar in analysis_runs]

        # Scope findings strictly to analysis runs of this assessment
        findings = db.query(Finding).filter(Finding.analysis_run_id.in_(analysis_run_ids)).all() if analysis_run_ids else []
        finding_ids = [f.id for f in findings]

        evidence_links = []
        review_history = []
        if finding_ids:
            evidence_links = db.query(FindingEvidence).filter(FindingEvidence.finding_id.in_(finding_ids)).all()
            review_history = db.query(FindingReviewHistory).filter(FindingReviewHistory.finding_id.in_(finding_ids)).all()

        reports = db.query(ReportRecord).filter(ReportRecord.assessment_id == assessment_id).all()

        # Collect operational evidence entities referenced by evidence_links
        alert_ids = list(set([e.alert_id for e in evidence_links if e.alert_id]))
        case_ids = list(set([e.case_id for e in evidence_links if e.case_id]))
        investigation_ids = list(set([e.investigation_id for e in evidence_links if e.investigation_id]))
        escalation_ids = list(set([e.escalation_id for e in evidence_links if e.escalation_id]))
        coverage_ids = list(set([e.coverage_id for e in evidence_links if e.coverage_id]))

        alerts = db.query(Alert).filter(Alert.id.in_(alert_ids)).all() if alert_ids else []
        cases = db.query(Case).filter(Case.id.in_(case_ids)).all() if case_ids else []
        investigations = db.query(Investigation).filter(Investigation.id.in_(investigation_ids)).all() if investigation_ids else []
        escalations = db.query(Escalation).filter(Escalation.id.in_(escalation_ids)).all() if escalation_ids else []
        coverages = db.query(MonitoringCoverage).filter(MonitoringCoverage.id.in_(coverage_ids)).all() if coverage_ids else []
        assets = db.query(Asset).filter(Asset.cse_id == cse.id).all()

        # 2. Serialize to JSON-compatible data dictionary
        data_payload = {
            "cses": [{
                "id": str(cse.id),
                "cse_code": cse.cse_code,
                "name": cse.name,
                "sector": cse.sector,
                "criticality_tier": cse.criticality_tier,
                "contact_email": cse.contact_email,
                "is_active": cse.is_active,
                "created_at": _iso_datetime(cse.created_at),
                "updated_at": _iso_datetime(cse.updated_at),
            }],
            "assessments": [{
                "id": str(assessment.id),
                "cse_id": str(assessment.cse_id),
                "name": assessment.name,
                "description": assessment.description,
                "period_start": _iso_datetime(assessment.period_start),
                "period_end": _iso_datetime(assessment.period_end),
                "status": assessment.status,
                "created_at": _iso_datetime(assessment.created_at),
                "updated_at": _iso_datetime(assessment.updated_at),
                "created_by_user_id": str(assessment.created_by_user_id) if assessment.created_by_user_id else None,
            }],
            "dataset_versions": [{
                "id": str(dv.id),
                "cse_id": str(dv.cse_id),
                "assessment_id": str(dv.assessment_id) if dv.assessment_id else None,
                "batch_id": str(dv.batch_id) if dv.batch_id else None,
                "version_tag": dv.version_tag,
                "dataset_type": dv.dataset_type,
                "source_filename": dv.source_filename,
                "content_hash": dv.content_hash,
                "record_count": dv.record_count,
                "is_immutable": dv.is_immutable,
                "created_at": _iso_datetime(dv.created_at),
                "created_by_user_id": str(dv.created_by_user_id) if dv.created_by_user_id else None,
            } for dv in dataset_versions],
            "analysis_runs": [{
                "id": str(ar.id),
                "cse_id": str(ar.cse_id),
                "assessment_id": str(ar.assessment_id) if ar.assessment_id else None,
                "dataset_version_id": str(ar.dataset_version_id) if ar.dataset_version_id else None,
                "obs_start": _iso_datetime(ar.obs_start),
                "obs_end": _iso_datetime(ar.obs_end),
                "engine_version": ar.engine_version,
                "rules_evaluated": ar.rules_evaluated,
                "status": ar.status,
                "findings_created": ar.findings_created,
                "baselines_persisted": ar.baselines_persisted,
                "error_message": ar.error_message,
                "started_at": _iso_datetime(ar.started_at),
                "completed_at": _iso_datetime(ar.completed_at),
                "executed_by_user_id": str(ar.executed_by_user_id) if ar.executed_by_user_id else None,
            } for ar in analysis_runs],
            "findings": [{
                "id": str(f.id),
                "finding_code": f.finding_code,
                "cse_id": str(f.cse_id),
                "batch_id": str(f.batch_id) if f.batch_id else None,
                "analysis_run_id": str(f.analysis_run_id) if f.analysis_run_id else None,
                "category": f.category,
                "severity": f.severity,
                "title": f.title,
                "description": f.description,
                "rationale": f.rationale,
                "detection_method": f.detection_method,
                "metrics_json": f.metrics_json,
                "status": f.status,
                "detected_at": _iso_datetime(f.detected_at),
                "updated_at": _iso_datetime(f.updated_at),
            } for f in findings],
            "finding_evidence": [{
                "id": str(fe.id),
                "finding_id": str(fe.finding_id),
                "evidence_type": fe.evidence_type,
                "alert_id": str(fe.alert_id) if fe.alert_id else None,
                "case_id": str(fe.case_id) if fe.case_id else None,
                "investigation_id": str(fe.investigation_id) if fe.investigation_id else None,
                "escalation_id": str(fe.escalation_id) if fe.escalation_id else None,
                "coverage_id": str(fe.coverage_id) if fe.coverage_id else None,
                "notes": fe.notes,
                "created_at": _iso_datetime(fe.created_at),
            } for fe in evidence_links],
            "finding_review_history": [{
                "id": str(fr.id),
                "finding_id": str(fr.finding_id),
                "user_id": str(fr.user_id) if fr.user_id else None,
                "cse_id": str(fr.cse_id),
                "action_type": fr.action_type,
                "previous_status": fr.previous_status,
                "new_status": fr.new_status,
                "note_text": fr.note_text,
                "evidence_request_details": fr.evidence_request_details,
                "created_at": _iso_datetime(fr.created_at),
            } for fr in review_history],
            "reports": [{
                "id": str(rp.id),
                "report_code": rp.report_code,
                "cse_id": str(rp.cse_id),
                "assessment_id": str(rp.assessment_id) if rp.assessment_id else None,
                "dataset_version_id": str(rp.dataset_version_id) if rp.dataset_version_id else None,
                "analysis_run_id": str(rp.analysis_run_id) if rp.analysis_run_id else None,
                "obs_start": _iso_datetime(rp.obs_start),
                "obs_end": _iso_datetime(rp.obs_end),
                "generated_by_user_id": str(rp.generated_by_user_id),
                "created_at": _iso_datetime(rp.created_at),
                "summary_json": rp.summary_json,
                "metadata_json": rp.metadata_json,
            } for rp in reports],
            "alerts": [{
                "id": str(a.id),
                "cse_id": str(a.cse_id),
                "batch_id": str(a.batch_id) if a.batch_id else None,
                "alert_reference": a.alert_reference,
                "source_system": a.source_system,
                "rule_name": a.rule_name,
                "severity": a.severity,
                "status": a.status,
                "event_timestamp": _iso_datetime(a.event_timestamp),
                "ingested_at": _iso_datetime(a.ingested_at),
                "raw_data_json": a.raw_data_json,
            } for a in alerts],
            "cases": [{
                "id": str(c.id),
                "cse_id": str(c.cse_id),
                "batch_id": str(c.batch_id) if c.batch_id else None,
                "case_reference": c.case_reference,
                "title": c.title,
                "severity": c.severity,
                "status": c.status,
                "assigned_team": c.assigned_team,
                "opened_at": _iso_datetime(c.opened_at),
                "closed_at": _iso_datetime(c.closed_at),
                "details_json": c.details_json,
            } for c in cases],
            "investigations": [{
                "id": str(inv.id),
                "case_id": str(inv.case_id),
                "investigation_reference": inv.investigation_reference,
                "lead_analyst": inv.lead_analyst,
                "status": inv.status,
                "summary": inv.summary,
                "started_at": _iso_datetime(inv.started_at),
                "completed_at": _iso_datetime(inv.completed_at),
            } for inv in investigations],
            "escalations": [{
                "id": str(esc.id),
                "case_id": str(esc.case_id),
                "escalation_reference": esc.escalation_reference,
                "escalated_to": esc.escalated_to,
                "reason": esc.reason,
                "escalated_at": _iso_datetime(esc.escalated_at),
            } for esc in escalations],
            "monitoring_coverages": [{
                "id": str(mc.id),
                "cse_id": str(mc.cse_id),
                "log_source_type": mc.log_source_type,
                "coverage_status": mc.coverage_status,
                "expected_eps": mc.expected_eps,
                "last_seen_at": _iso_datetime(mc.last_seen_at),
            } for mc in coverages],
            "assets": [{
                "id": str(ast.id),
                "cse_id": str(ast.cse_id),
                "asset_identifier": ast.asset_identifier,
                "asset_name": ast.asset_name,
                "asset_type": ast.asset_type,
                "ip_address": ast.ip_address,
                "criticality": ast.criticality,
                "is_monitored": ast.is_monitored,
                "created_at": _iso_datetime(ast.created_at),
            } for ast in assets]
        }

        json_bytes = json.dumps(data_payload, sort_keys=True, indent=2).encode("utf-8")
        data_hash_sha256 = hashlib.sha256(json_bytes).hexdigest()

        record_counts = {k: len(v) for k, v in data_payload.items()}
        package_id = uuid.uuid4()
        now_utc = datetime.now(timezone.utc)

        # 3. MANDATORY AES-256-GCM AEAD ENCRYPTION
        salt_bytes = secrets.token_bytes(16)
        nonce_bytes = secrets.token_bytes(12)
        iterations = 100000

        if passphrase:
            key_protection_mode = "PASSPHRASE"
            aes_key = _derive_aes256_key(passphrase, salt_bytes, iterations)
        else:
            key_protection_mode = "SYSTEM_KEY"
            aes_key = _derive_aes256_key(settings.JWT_SECRET_KEY, salt_bytes, iterations)

        aad_bytes = _construct_aad("SAT-SA-OFFLINE-PACKAGE", "1.0.0", str(package_id))
        aesgcm = AESGCM(aes_key)
        # encrypt returns ciphertext + 16-byte authentication tag
        encrypted_payload_bytes = aesgcm.encrypt(nonce_bytes, json_bytes, aad_bytes)

        # Nonce is prepended to ciphertext in data.enc
        final_payload_bytes = nonce_bytes + encrypted_payload_bytes

        # Non-identity host environment metadata
        try:
            host_meta = platform.node() or "SATSA-HOST"
        except Exception:
            host_meta = "SATSA-HOST"

        # 4. Construct Manifest
        manifest = PackageManifest(
            package_format="SAT-SA-OFFLINE-PACKAGE",
            format_version="1.0.0",
            app_version="v2.0.0",
            package_id=package_id,
            created_at=now_utc,
            exported_by_user=exporting_user.username if exporting_user else "SYSTEM",
            export_host_name=host_meta,
            cse_id=cse.id,
            cse_code=cse.cse_code,
            assessment_id=assessment.id,
            assessment_name=assessment.name,
            record_counts=record_counts,
            is_encrypted=True,
            key_protection_mode=key_protection_mode,
            kdf_salt=salt_bytes.hex(),
            kdf_iterations=iterations,
            aead_algorithm="AES-256-GCM",
            aead_nonce=nonce_bytes.hex(),
            data_hash_sha256=data_hash_sha256
        )

        manifest_json_bytes = json.dumps(manifest.model_dump(mode="json"), sort_keys=True, indent=2).encode("utf-8")

        # 5. Build ZIP Package (data/data.enc is ALWAYS used; data/data.json is NEVER present)
        zip_buffer = io.BytesIO()
        with zipfile.ZipFile(zip_buffer, mode="w", compression=zipfile.ZIP_DEFLATED) as zf:
            zf.writestr("manifest.json", manifest_json_bytes)
            zf.writestr("data/data.enc", final_payload_bytes)

        # 6. Audit Trail Logging
        if exporting_user:
            AuthService.log_audit_event(
                db=db,
                user_id=exporting_user.id,
                username=exporting_user.username,
                action_type="ASSESSMENT_PACKAGE_EXPORT",
                target_entity="Assessment",
                target_id=assessment.id,
                cse_id=cse.id,
                status="SUCCESS",
                details_json={
                    "package_id": str(package_id),
                    "aead_algorithm": "AES-256-GCM",
                    "key_protection_mode": key_protection_mode,
                    "record_counts": record_counts
                }
            )

        zip_buffer.seek(0)
        return zip_buffer.getvalue()

    @staticmethod
    def _read_and_verify_package(
        file_bytes: bytes,
        passphrase: Optional[str] = None
    ) -> Tuple[PackageManifest, dict]:
        try:
            zip_file = zipfile.ZipFile(io.BytesIO(file_bytes), mode="r")
        except zipfile.BadZipFile:
            raise SATSAException(
                message="Corrupted file structure. The uploaded package is not a valid ZIP archive.",
                code="INVALID_PACKAGE_FORMAT",
                status_code=400
            )

        if "manifest.json" not in zip_file.namelist():
            raise SATSAException(
                message="Package manifest missing. Package is invalid or tampered.",
                code="MISSING_MANIFEST",
                status_code=400
            )

        if "data/data.json" in zip_file.namelist():
            raise SATSAException(
                message="Security violation: Unencrypted plaintext payload detected. Only encrypted packages are accepted.",
                code="PLAINTEXT_PAYLOAD_REJECTED",
                status_code=400
            )

        try:
            manifest_dict = json.loads(zip_file.read("manifest.json").decode("utf-8"))
            manifest = PackageManifest(**manifest_dict)
        except Exception as e:
            raise SATSAException(
                message=f"Invalid package manifest metadata: {str(e)}",
                code="MALFORMED_MANIFEST",
                status_code=400
            )

        if manifest.package_format != "SAT-SA-OFFLINE-PACKAGE":
            raise SATSAException(
                message=f"Unsupported package format: '{manifest.package_format}'. Expected 'SAT-SA-OFFLINE-PACKAGE'.",
                code="UNSUPPORTED_PACKAGE_FORMAT",
                status_code=400
            )

        if manifest.format_version != "1.0.0":
            raise SATSAException(
                message=f"Unsupported package format version: '{manifest.format_version}'. Expected '1.0.0'.",
                code="UNSUPPORTED_FORMAT_VERSION",
                status_code=400
            )

        if manifest.aead_algorithm != "AES-256-GCM":
            raise SATSAException(
                message=f"Unsupported AEAD cipher algorithm: '{manifest.aead_algorithm}'. Expected 'AES-256-GCM'.",
                code="UNSUPPORTED_AEAD_ALGORITHM",
                status_code=400
            )

        if "data/data.enc" not in zip_file.namelist():
            raise SATSAException(
                message="Encrypted data payload missing from package.",
                code="CORRUPTED_PACKAGE",
                status_code=400
            )

        raw_enc_payload = zip_file.read("data/data.enc")
        # 12 bytes nonce + 16 bytes minimum tag = 28 bytes minimum
        if len(raw_enc_payload) < 28:
            raise SATSAException(
                message="Encrypted payload is corrupted or truncated.",
                code="CORRUPTED_PAYLOAD",
                status_code=400
            )

        # Extract Nonce and Ciphertext+Tag
        nonce_bytes = raw_enc_payload[:12]
        ciphertext_and_tag = raw_enc_payload[12:]

        # Derive AES key based on key_protection_mode
        salt_bytes = bytes.fromhex(manifest.kdf_salt)
        if manifest.key_protection_mode == "PASSPHRASE":
            if not passphrase:
                raise SATSAException(
                    message="Package is protected with a user passphrase. Passphrase is required for decryption.",
                    code="PASSPHRASE_REQUIRED",
                    status_code=400
                )
            aes_key = _derive_aes256_key(passphrase, salt_bytes, manifest.kdf_iterations)
        else:
            aes_key = _derive_aes256_key(settings.JWT_SECRET_KEY, salt_bytes, manifest.kdf_iterations)

        aad_bytes = _construct_aad(manifest.package_format, manifest.format_version, str(manifest.package_id))
        aesgcm = AESGCM(aes_key)

        # Authenticate and Decrypt with AES-256-GCM
        try:
            json_bytes = aesgcm.decrypt(nonce_bytes, ciphertext_and_tag, aad_bytes)
        except InvalidTag:
            raise SATSAException(
                message="AES-256-GCM AEAD authentication tag verification failed. Incorrect passphrase or tampered package.",
                code="AEAD_AUTHENTICATION_FAILED",
                status_code=400
            )
        except Exception as e:
            raise SATSAException(
                message=f"AEAD decryption failed: {str(e)}",
                code="DECRYPTION_FAILED",
                status_code=400
            )

        # Integrity hash check post-decryption
        computed_hash = hashlib.sha256(json_bytes).hexdigest()
        if computed_hash != manifest.data_hash_sha256:
            raise SATSAException(
                message="Data integrity checksum mismatch. Post-decryption payload is corrupted.",
                code="CHECKSUM_MISMATCH",
                status_code=400
            )

        try:
            data_payload = json.loads(json_bytes.decode("utf-8"))
        except Exception as e:
            raise SATSAException(
                message=f"Malformed data JSON payload inside package: {str(e)}",
                code="MALFORMED_DATA_PAYLOAD",
                status_code=400
            )

        return manifest, data_payload

    @staticmethod
    def validate_package(
        db: Session,
        file_bytes: bytes,
        passphrase: Optional[str] = None
    ) -> PackageValidationResponse:
        try:
            manifest, data_payload = DataExchangeService._read_and_verify_package(file_bytes, passphrase)
        except SATSAException as se:
            return PackageValidationResponse(
                is_valid=False,
                message=se.message,
                conflict_detected=False
            )
        except Exception as e:
            return PackageValidationResponse(
                is_valid=False,
                message=f"Validation failed: {str(e)}",
                conflict_detected=False
            )

        # Conflict check for Assessment ID
        existing_assessment = db.query(Assessment).filter(Assessment.id == manifest.assessment_id).first()
        conflict_detected = existing_assessment is not None
        conflict_details = f"Assessment '{existing_assessment.name}' (ID: {existing_assessment.id}) already exists in the local database." if existing_assessment else None

        counts_preview = {k: len(v) for k, v in data_payload.items()}

        return PackageValidationResponse(
            is_valid=True,
            message="Package passed AES-256-GCM AEAD authentication and SHA-256 integrity verification.",
            manifest=manifest,
            conflict_detected=conflict_detected,
            conflict_details=conflict_details,
            record_counts_preview=counts_preview
        )

    @staticmethod
    def import_assessment_package(
        db: Session,
        file_bytes: bytes,
        passphrase: Optional[str] = None,
        importing_user: Optional[User] = None
    ) -> PackageImportResponse:
        manifest, data_payload = DataExchangeService._read_and_verify_package(file_bytes, passphrase)

        existing_assessment = db.query(Assessment).filter(Assessment.id == manifest.assessment_id).first()
        if existing_assessment:
            raise SATSAException(
                message=f"Cannot import: Assessment '{existing_assessment.name}' (ID: {manifest.assessment_id}) already exists locally.",
                code="DUPLICATE_ASSESSMENT_CONFLICT",
                status_code=409
            )

        imported_counts: Dict[str, int] = {}
        now_utc = datetime.now(timezone.utc)

        # Atomic Transactional DB Import
        try:
            with db.begin_nested():
                # 1. CSE
                for c_data in data_payload.get("cses", []):
                    c_id = uuid.UUID(c_data["id"])
                    cse_obj = db.query(CSE).filter(CSE.id == c_id).first()
                    if not cse_obj:
                        cse_obj = CSE(
                            id=c_id,
                            cse_code=c_data["cse_code"],
                            name=c_data["name"],
                            sector=c_data["sector"],
                            criticality_tier=c_data.get("criticality_tier", "TIER_1"),
                            contact_email=c_data.get("contact_email"),
                            is_active=c_data.get("is_active", True),
                            created_at=_parse_datetime(c_data.get("created_at")) or now_utc,
                            updated_at=_parse_datetime(c_data.get("updated_at")) or now_utc,
                        )
                        db.add(cse_obj)
                        imported_counts["cses"] = imported_counts.get("cses", 0) + 1

                # 2. Assets
                for ast_data in data_payload.get("assets", []):
                    ast_id = uuid.UUID(ast_data["id"])
                    if not db.query(Asset).filter(Asset.id == ast_id).first():
                        db.add(Asset(
                            id=ast_id,
                            cse_id=uuid.UUID(ast_data["cse_id"]),
                            asset_identifier=ast_data["asset_identifier"],
                            asset_name=ast_data["asset_name"],
                            asset_type=ast_data["asset_type"],
                            ip_address=ast_data.get("ip_address"),
                            criticality=ast_data.get("criticality", "TIER_1"),
                            is_monitored=ast_data.get("is_monitored", True),
                            created_at=_parse_datetime(ast_data.get("created_at")) or now_utc
                        ))
                        imported_counts["assets"] = imported_counts.get("assets", 0) + 1

                # 3. Operational evidence tables (Alerts, Cases, Investigations, Escalations, Coverages)
                for a_data in data_payload.get("alerts", []):
                    a_id = uuid.UUID(a_data["id"])
                    if not db.query(Alert).filter(Alert.id == a_id).first():
                        db.add(Alert(
                            id=a_id,
                            cse_id=uuid.UUID(a_data["cse_id"]),
                            batch_id=uuid.UUID(a_data["batch_id"]) if a_data.get("batch_id") else None,
                            alert_reference=a_data["alert_reference"],
                            source_system=a_data["source_system"],
                            rule_name=a_data["rule_name"],
                            severity=a_data["severity"],
                            status=a_data.get("status", "NEW"),
                            event_timestamp=_parse_datetime(a_data.get("event_timestamp")) or now_utc,
                            ingested_at=_parse_datetime(a_data.get("ingested_at")) or now_utc,
                            raw_data_json=a_data.get("raw_data_json")
                        ))
                        imported_counts["alerts"] = imported_counts.get("alerts", 0) + 1

                for c_data in data_payload.get("cases", []):
                    c_id = uuid.UUID(c_data["id"])
                    if not db.query(Case).filter(Case.id == c_id).first():
                        db.add(Case(
                            id=c_id,
                            cse_id=uuid.UUID(c_data["cse_id"]),
                            batch_id=uuid.UUID(c_data["batch_id"]) if c_data.get("batch_id") else None,
                            case_reference=c_data["case_reference"],
                            title=c_data["title"],
                            severity=c_data["severity"],
                            status=c_data.get("status", "OPEN"),
                            assigned_team=c_data.get("assigned_team"),
                            opened_at=_parse_datetime(c_data.get("opened_at")) or now_utc,
                            closed_at=_parse_datetime(c_data.get("closed_at")),
                            details_json=c_data.get("details_json")
                        ))
                        imported_counts["cases"] = imported_counts.get("cases", 0) + 1

                for inv_data in data_payload.get("investigations", []):
                    inv_id = uuid.UUID(inv_data["id"])
                    if not db.query(Investigation).filter(Investigation.id == inv_id).first():
                        db.add(Investigation(
                            id=inv_id,
                            case_id=uuid.UUID(inv_data["case_id"]),
                            investigation_reference=inv_data["investigation_reference"],
                            lead_analyst=inv_data.get("lead_analyst"),
                            status=inv_data.get("status", "ACTIVE"),
                            summary=inv_data.get("summary"),
                            started_at=_parse_datetime(inv_data.get("started_at")) or now_utc,
                            completed_at=_parse_datetime(inv_data.get("completed_at"))
                        ))
                        imported_counts["investigations"] = imported_counts.get("investigations", 0) + 1

                for esc_data in data_payload.get("escalations", []):
                    esc_id = uuid.UUID(esc_data["id"])
                    if not db.query(Escalation).filter(Escalation.id == esc_id).first():
                        db.add(Escalation(
                            id=esc_id,
                            case_id=uuid.UUID(esc_data["case_id"]),
                            escalation_reference=esc_data["escalation_reference"],
                            escalated_to=esc_data["escalated_to"],
                            reason=esc_data["reason"],
                            escalated_at=_parse_datetime(esc_data.get("escalated_at")) or now_utc
                        ))
                        imported_counts["escalations"] = imported_counts.get("escalations", 0) + 1

                for mc_data in data_payload.get("monitoring_coverages", []):
                    mc_id = uuid.UUID(mc_data["id"])
                    if not db.query(MonitoringCoverage).filter(MonitoringCoverage.id == mc_id).first():
                        db.add(MonitoringCoverage(
                            id=mc_id,
                            cse_id=uuid.UUID(mc_data["cse_id"]),
                            log_source_type=mc_data["log_source_type"],
                            coverage_status=mc_data["coverage_status"],
                            expected_eps=mc_data.get("expected_eps"),
                            last_seen_at=_parse_datetime(mc_data.get("last_seen_at"))
                        ))
                        imported_counts["monitoring_coverages"] = imported_counts.get("monitoring_coverages", 0) + 1

                # 4. Assessment
                for ass_data in data_payload.get("assessments", []):
                    ass_id = uuid.UUID(ass_data["id"])
                    db.add(Assessment(
                        id=ass_id,
                        cse_id=uuid.UUID(ass_data["cse_id"]),
                        name=ass_data["name"],
                        description=ass_data.get("description"),
                        period_start=_parse_datetime(ass_data["period_start"]),
                        period_end=_parse_datetime(ass_data["period_end"]),
                        status=ass_data["status"],
                        created_at=_parse_datetime(ass_data.get("created_at")) or now_utc,
                        updated_at=_parse_datetime(ass_data.get("updated_at")) or now_utc,
                        created_by_user_id=importing_user.id if importing_user else None
                    ))
                    imported_counts["assessments"] = imported_counts.get("assessments", 0) + 1

                # 5. DatasetVersions
                for dv_data in data_payload.get("dataset_versions", []):
                    dv_id = uuid.UUID(dv_data["id"])
                    if not db.query(DatasetVersion).filter(DatasetVersion.id == dv_id).first():
                        db.add(DatasetVersion(
                            id=dv_id,
                            cse_id=uuid.UUID(dv_data["cse_id"]),
                            assessment_id=uuid.UUID(dv_data["assessment_id"]) if dv_data.get("assessment_id") else None,
                            batch_id=uuid.UUID(dv_data["batch_id"]) if dv_data.get("batch_id") else None,
                            version_tag=dv_data["version_tag"],
                            dataset_type=dv_data["dataset_type"],
                            source_filename=dv_data["source_filename"],
                            content_hash=dv_data["content_hash"],
                            record_count=dv_data.get("record_count", 0),
                            is_immutable=dv_data.get("is_immutable", True),
                            created_at=_parse_datetime(dv_data.get("created_at")) or now_utc,
                            created_by_user_id=importing_user.id if importing_user else None
                        ))
                        imported_counts["dataset_versions"] = imported_counts.get("dataset_versions", 0) + 1

                # 6. AnalysisRuns
                for ar_data in data_payload.get("analysis_runs", []):
                    ar_id = uuid.UUID(ar_data["id"])
                    if not db.query(AnalysisRun).filter(AnalysisRun.id == ar_id).first():
                        db.add(AnalysisRun(
                            id=ar_id,
                            cse_id=uuid.UUID(ar_data["cse_id"]),
                            assessment_id=uuid.UUID(ar_data["assessment_id"]) if ar_data.get("assessment_id") else None,
                            dataset_version_id=uuid.UUID(ar_data["dataset_version_id"]) if ar_data.get("dataset_version_id") else None,
                            obs_start=_parse_datetime(ar_data.get("obs_start")),
                            obs_end=_parse_datetime(ar_data.get("obs_end")),
                            engine_version=ar_data.get("engine_version", "v2.0.0-phase5-canonical"),
                            rules_evaluated=ar_data["rules_evaluated"],
                            status=ar_data["status"],
                            findings_created=ar_data.get("findings_created", 0),
                            baselines_persisted=ar_data.get("baselines_persisted", 0),
                            error_message=ar_data.get("error_message"),
                            started_at=_parse_datetime(ar_data.get("started_at")) or now_utc,
                            completed_at=_parse_datetime(ar_data.get("completed_at")),
                            executed_by_user_id=importing_user.id if importing_user else None
                        ))
                        imported_counts["analysis_runs"] = imported_counts.get("analysis_runs", 0) + 1

                # 7. Findings
                for f_data in data_payload.get("findings", []):
                    f_id = uuid.UUID(f_data["id"])
                    if not db.query(Finding).filter(Finding.id == f_id).first():
                        db.add(Finding(
                            id=f_id,
                            finding_code=f_data["finding_code"],
                            cse_id=uuid.UUID(f_data["cse_id"]),
                            batch_id=uuid.UUID(f_data["batch_id"]) if f_data.get("batch_id") else None,
                            analysis_run_id=uuid.UUID(f_data["analysis_run_id"]) if f_data.get("analysis_run_id") else None,
                            category=f_data["category"],
                            severity=f_data["severity"],
                            title=f_data["title"],
                            description=f_data["description"],
                            rationale=f_data["rationale"],
                            detection_method=f_data["detection_method"],
                            metrics_json=f_data.get("metrics_json"),
                            status=f_data.get("status", "NEW"),
                            detected_at=_parse_datetime(f_data.get("detected_at")) or now_utc,
                            updated_at=_parse_datetime(f_data.get("updated_at")) or now_utc
                        ))
                        imported_counts["findings"] = imported_counts.get("findings", 0) + 1

                # 8. FindingEvidence
                for fe_data in data_payload.get("finding_evidence", []):
                    fe_id = uuid.UUID(fe_data["id"])
                    if not db.query(FindingEvidence).filter(FindingEvidence.id == fe_id).first():
                        db.add(FindingEvidence(
                            id=fe_id,
                            finding_id=uuid.UUID(fe_data["finding_id"]),
                            evidence_type=fe_data["evidence_type"],
                            alert_id=uuid.UUID(fe_data["alert_id"]) if fe_data.get("alert_id") else None,
                            case_id=uuid.UUID(fe_data["case_id"]) if fe_data.get("case_id") else None,
                            investigation_id=uuid.UUID(fe_data["investigation_id"]) if fe_data.get("investigation_id") else None,
                            escalation_id=uuid.UUID(fe_data["escalation_id"]) if fe_data.get("escalation_id") else None,
                            coverage_id=uuid.UUID(fe_data["coverage_id"]) if fe_data.get("coverage_id") else None,
                            notes=fe_data.get("notes"),
                            created_at=_parse_datetime(fe_data.get("created_at")) or now_utc
                        ))
                        imported_counts["finding_evidence"] = imported_counts.get("finding_evidence", 0) + 1

                # 9. FindingReviewHistory
                for fr_data in data_payload.get("finding_review_history", []):
                    fr_id = uuid.UUID(fr_data["id"])
                    if not db.query(FindingReviewHistory).filter(FindingReviewHistory.id == fr_id).first():
                        db.add(FindingReviewHistory(
                            id=fr_id,
                            finding_id=uuid.UUID(fr_data["finding_id"]),
                            user_id=importing_user.id if importing_user else None,
                            cse_id=uuid.UUID(fr_data["cse_id"]),
                            action_type=fr_data["action_type"],
                            previous_status=fr_data.get("previous_status"),
                            new_status=fr_data.get("new_status"),
                            note_text=fr_data.get("note_text"),
                            evidence_request_details=fr_data.get("evidence_request_details"),
                            created_at=_parse_datetime(fr_data.get("created_at")) or now_utc
                        ))
                        imported_counts["finding_review_history"] = imported_counts.get("finding_review_history", 0) + 1

                # 10. Reports
                for rp_data in data_payload.get("reports", []):
                    rp_id = uuid.UUID(rp_data["id"])
                    if not db.query(ReportRecord).filter(ReportRecord.id == rp_id).first():
                        db.add(ReportRecord(
                            id=rp_id,
                            report_code=rp_data["report_code"],
                            cse_id=uuid.UUID(rp_data["cse_id"]),
                            assessment_id=uuid.UUID(rp_data["assessment_id"]) if rp_data.get("assessment_id") else None,
                            dataset_version_id=uuid.UUID(rp_data["dataset_version_id"]) if rp_data.get("dataset_version_id") else None,
                            analysis_run_id=uuid.UUID(rp_data["analysis_run_id"]) if rp_data.get("analysis_run_id") else None,
                            obs_start=_parse_datetime(rp_data.get("obs_start")),
                            obs_end=_parse_datetime(rp_data.get("obs_end")),
                            generated_by_user_id=importing_user.id if importing_user else uuid.UUID(rp_data["generated_by_user_id"]),
                            created_at=_parse_datetime(rp_data.get("created_at")) or now_utc,
                            summary_json=rp_data["summary_json"],
                            metadata_json=rp_data["metadata_json"]
                        ))
                        imported_counts["reports"] = imported_counts.get("reports", 0) + 1

                db.flush()

        except Exception as err:
            db.rollback()
            raise SATSAException(
                message=f"Database import failed. Transaction rolled back: {str(err)}",
                code="IMPORT_TRANSACTION_FAILED",
                status_code=500
            )

        db.commit()

        if importing_user:
            AuthService.log_audit_event(
                db=db,
                user_id=importing_user.id,
                username=importing_user.username,
                action_type="ASSESSMENT_PACKAGE_IMPORT",
                target_entity="Assessment",
                target_id=manifest.assessment_id,
                cse_id=manifest.cse_id,
                status="SUCCESS",
                details_json={
                    "package_id": str(manifest.package_id),
                    "imported_counts": imported_counts
                }
            )

        return PackageImportResponse(
            success=True,
            message="Assessment package imported successfully.",
            imported_assessment_id=manifest.assessment_id,
            imported_cse_id=manifest.cse_id,
            record_counts=imported_counts,
            imported_at=now_utc
        )
