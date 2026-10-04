import io
import json
import uuid
import zipfile
import secrets
import pytest
from datetime import datetime, timezone, timedelta
from typing import Tuple
from fastapi.testclient import TestClient

from app.main import app
from app.config.settings import settings
from app.api.deps import get_db
from app.models.cse import CSE
from app.models.assessment import Assessment
from app.models.dataset_version import DatasetVersion
from app.models.analysis_run import AnalysisRun
from app.models.finding import Finding, FindingEvidence, FindingReviewHistory
from app.models.report import ReportRecord
from app.models.user import User, UserCSE
from app.services.data_exchange_service import DataExchangeService
from app.utils.security import create_access_token, get_password_hash
from app.utils.exceptions import SATSAException

client = TestClient(app)

@pytest.fixture(autouse=True)
def override_db_dependency(db_session):
    """Ensure all API requests route to the test database session."""
    app.dependency_overrides[get_db] = lambda: db_session
    yield
    app.dependency_overrides.clear()

@pytest.fixture
def test_setup_data(db_session):
    """Fixture initializing real test entities for data exchange testing."""
    now = datetime.now(timezone.utc)

    user = User(
        id=uuid.uuid4(),
        username=f"tester_{uuid.uuid4().hex[:6]}",
        email=f"tester_{uuid.uuid4().hex[:6]}@satsa.org",
        hashed_password=get_password_hash("Password#123"),
        role="SUPERVISOR",
        is_active=True
    )
    db_session.add(user)

    cse = CSE(
        id=uuid.uuid4(),
        cse_code=f"CSE-P18-{uuid.uuid4().hex[:6]}",
        name="Phase 18 Banking Sector CSE",
        sector="FINANCIAL",
        criticality_tier="TIER_1",
        contact_email="soc@p18bank.com",
        is_active=True
    )
    db_session.add(cse)

    # Grant explicit CSE authorization to user
    uc = UserCSE(id=uuid.uuid4(), user_id=user.id, cse_id=cse.id)
    db_session.add(uc)

    assessment = Assessment(
        id=uuid.uuid4(),
        cse_id=cse.id,
        name="Phase 18 Q3 Audit Assessment",
        description="Comprehensive offline data exchange test assessment",
        period_start=now - timedelta(days=30),
        period_end=now,
        status="UNDER_REVIEW",
        created_by_user_id=user.id
    )
    db_session.add(assessment)

    dv = DatasetVersion(
        id=uuid.uuid4(),
        cse_id=cse.id,
        assessment_id=assessment.id,
        version_tag="v1.0.0",
        dataset_type="SIEM_LOGS",
        source_filename="logs_q3.csv",
        content_hash="a"*64,
        record_count=1500,
        created_by_user_id=user.id
    )
    db_session.add(dv)

    ar = AnalysisRun(
        id=uuid.uuid4(),
        cse_id=cse.id,
        assessment_id=assessment.id,
        dataset_version_id=dv.id,
        obs_start=now - timedelta(days=30),
        obs_end=now,
        rules_evaluated=["EG-01", "NS-01", "AN-01"],
        status="COMPLETED",
        findings_created=1,
        executed_by_user_id=user.id
    )
    db_session.add(ar)

    finding = Finding(
        id=uuid.uuid4(),
        finding_code=f"FIND-P18-{uuid.uuid4().hex[:6]}",
        cse_id=cse.id,
        analysis_run_id=ar.id,
        category="EXECUTION_GAP",
        severity="CRITICAL",
        title="Unmonitored Core Payment Server",
        description="Core payment processing node is missing log ingestion",
        rationale="EG-01 rule triggered due to 0 EPS received",
        detection_method="CANONICAL_RULES",
        metrics_json={"eps": 0, "asset": "PAY-01"},
        status="NEW"
    )
    db_session.add(finding)

    fe = FindingEvidence(
        id=uuid.uuid4(),
        finding_id=finding.id,
        evidence_type="LOG_METRIC",
        notes="Zero logs registered during 30-day window"
    )
    db_session.add(fe)

    fr = FindingReviewHistory(
        id=uuid.uuid4(),
        finding_id=finding.id,
        user_id=user.id,
        cse_id=cse.id,
        action_type="STATUS_CHANGE",
        previous_status="NEW",
        new_status="IN_REVIEW",
        note_text="Examiner flagged for tier-2 SOC escalation"
    )
    db_session.add(fr)

    report = ReportRecord(
        id=uuid.uuid4(),
        report_code=f"REP-P18-{uuid.uuid4().hex[:6]}",
        cse_id=cse.id,
        assessment_id=assessment.id,
        dataset_version_id=dv.id,
        analysis_run_id=ar.id,
        generated_by_user_id=user.id,
        summary_json={"supervisory_score": 88.5},
        metadata_json={"engine": "v2.0.0"}
    )
    db_session.add(report)

    db_session.commit()

    return {
        "user": user,
        "cse": cse,
        "assessment": assessment,
        "dataset_version": dv,
        "analysis_run": ar,
        "finding": finding,
        "evidence": fe,
        "review": fr,
        "report": report
    }

@pytest.fixture
def auth_tokens(db_session, test_setup_data):
    """Fixture providing tokens for Admin, Supervisor, and Viewer roles."""
    cse = test_setup_data["cse"]
    def _create_user(role: str) -> Tuple[User, str]:
        user = User(
            id=uuid.uuid4(),
            username=f"user_{role.lower()}_{uuid.uuid4().hex[:6]}",
            email=f"{role.lower()}_{uuid.uuid4().hex[:6]}@satsa.org",
            hashed_password=get_password_hash("Password#123"),
            role=role,
            is_active=True
        )
        db_session.add(user)
        if role == "SUPERVISOR":
            uc = UserCSE(id=uuid.uuid4(), user_id=user.id, cse_id=cse.id)
            db_session.add(uc)
        db_session.commit()
        token = create_access_token({"sub": str(user.id), "role": role})
        return user, token

    admin_user, admin_token = _create_user("ADMIN")
    sup_user, sup_token = _create_user("SUPERVISOR")
    view_user, view_token = _create_user("VIEWER")

    return {
        "admin": (admin_user, admin_token),
        "supervisor": (sup_user, sup_token),
        "viewer": (view_user, view_token)
    }

class TestPhase18SecurityCorrection:

    def test_A_every_package_is_encrypted(self, db_session, test_setup_data):
        """Requirement A: Every exported package containing sensitive data is encrypted."""
        ass = test_setup_data["assessment"]

        # Export without passphrase (uses system key protection)
        pkg_sys = DataExchangeService.export_assessment_package(db_session, ass.id)
        manifest_sys, _ = DataExchangeService._read_and_verify_package(pkg_sys)
        assert manifest_sys.is_encrypted is True
        assert manifest_sys.key_protection_mode == "SYSTEM_KEY"
        assert manifest_sys.aead_algorithm == "AES-256-GCM"

        # Export with explicit passphrase
        pkg_pass = DataExchangeService.export_assessment_package(db_session, ass.id, passphrase="Passphrase#2026")
        manifest_pass, _ = DataExchangeService._read_and_verify_package(pkg_pass, passphrase="Passphrase#2026")
        assert manifest_pass.is_encrypted is True
        assert manifest_pass.key_protection_mode == "PASSPHRASE"
        assert manifest_pass.aead_algorithm == "AES-256-GCM"

    def test_B_no_plaintext_data_json_in_package(self, db_session, test_setup_data):
        """Requirement B: No plaintext data.json containing sensitive records exists in package."""
        ass = test_setup_data["assessment"]
        pkg_bytes = DataExchangeService.export_assessment_package(db_session, ass.id)

        zf = zipfile.ZipFile(io.BytesIO(pkg_bytes))
        file_list = zf.namelist()

        assert "data/data.enc" in file_list
        assert "data/data.json" not in file_list

        # Verify that if an attacker manually inserts plaintext data.json into a package, import rejects it
        manifest_bytes = zf.read("manifest.json")
        bad_buf = io.BytesIO()
        with zipfile.ZipFile(bad_buf, "w") as bad_zf:
            bad_zf.writestr("manifest.json", manifest_bytes)
            bad_zf.writestr("data/data.json", json.dumps({"secret": "sensitive"}).encode("utf-8"))

        with pytest.raises(SATSAException) as exc:
            DataExchangeService._read_and_verify_package(bad_buf.getvalue())
        assert exc.value.code == "PLAINTEXT_PAYLOAD_REJECTED"

    def test_C_correct_passphrase_decrypts_successfully(self, db_session, test_setup_data):
        """Requirement C: Correct passphrase decrypts successfully."""
        ass = test_setup_data["assessment"]
        passphrase = "CorrectOfflinePassphrase#2026"
        pkg_bytes = DataExchangeService.export_assessment_package(db_session, ass.id, passphrase=passphrase)

        manifest, data = DataExchangeService._read_and_verify_package(pkg_bytes, passphrase=passphrase)
        assert manifest.is_encrypted is True
        assert len(data["findings"]) == 1
        assert data["findings"][0]["title"] == "Unmonitored Core Payment Server"

    def test_D_wrong_passphrase_fails(self, db_session, test_setup_data):
        """Requirement D: Wrong passphrase fails decryption and AEAD authentication."""
        ass = test_setup_data["assessment"]
        passphrase = "CorrectOfflinePassphrase#2026"
        pkg_bytes = DataExchangeService.export_assessment_package(db_session, ass.id, passphrase=passphrase)

        with pytest.raises(SATSAException) as exc:
            DataExchangeService._read_and_verify_package(pkg_bytes, passphrase="WRONG_PASSPHRASE")
        assert exc.value.code == "AEAD_AUTHENTICATION_FAILED"

    def test_E_one_bit_ciphertext_modification_fails(self, db_session, test_setup_data):
        """Requirement E: One-bit ciphertext modification fails AEAD authentication."""
        ass = test_setup_data["assessment"]
        passphrase = "SecretPassphrase#2026"
        pkg_bytes = DataExchangeService.export_assessment_package(db_session, ass.id, passphrase=passphrase)

        zf = zipfile.ZipFile(io.BytesIO(pkg_bytes))
        manifest_bytes = zf.read("manifest.json")
        enc_payload = bytearray(zf.read("data/data.enc"))

        # Flip 1 bit in ciphertext body (after 12-byte nonce)
        enc_payload[15] ^= 0x01

        tampered_buf = io.BytesIO()
        with zipfile.ZipFile(tampered_buf, "w") as t_zf:
            t_zf.writestr("manifest.json", manifest_bytes)
            t_zf.writestr("data/data.enc", bytes(enc_payload))

        with pytest.raises(SATSAException) as exc:
            DataExchangeService._read_and_verify_package(tampered_buf.getvalue(), passphrase=passphrase)
        assert exc.value.code == "AEAD_AUTHENTICATION_FAILED"

    def test_F_one_bit_tag_modification_fails(self, db_session, test_setup_data):
        """Requirement F: One-bit authentication tag modification fails AEAD verification."""
        ass = test_setup_data["assessment"]
        passphrase = "SecretPassphrase#2026"
        pkg_bytes = DataExchangeService.export_assessment_package(db_session, ass.id, passphrase=passphrase)

        zf = zipfile.ZipFile(io.BytesIO(pkg_bytes))
        manifest_bytes = zf.read("manifest.json")
        enc_payload = bytearray(zf.read("data/data.enc"))

        # Flip 1 bit in tag (last 16 bytes)
        enc_payload[-1] ^= 0x01

        tampered_buf = io.BytesIO()
        with zipfile.ZipFile(tampered_buf, "w") as t_zf:
            t_zf.writestr("manifest.json", manifest_bytes)
            t_zf.writestr("data/data.enc", bytes(enc_payload))

        with pytest.raises(SATSAException) as exc:
            DataExchangeService._read_and_verify_package(tampered_buf.getvalue(), passphrase=passphrase)
        assert exc.value.code == "AEAD_AUTHENTICATION_FAILED"

    def test_G_manifest_tampering_fails_aad_verification(self, db_session, test_setup_data):
        """Requirement G: Manifest tampering fails AAD binding verification."""
        ass = test_setup_data["assessment"]
        passphrase = "SecretPassphrase#2026"
        pkg_bytes = DataExchangeService.export_assessment_package(db_session, ass.id, passphrase=passphrase)

        zf = zipfile.ZipFile(io.BytesIO(pkg_bytes))
        manifest_dict = json.loads(zf.read("manifest.json"))
        enc_payload = zf.read("data/data.enc")

        # Tamper package_id in manifest
        manifest_dict["package_id"] = str(uuid.uuid4())
        mod_manifest_bytes = json.dumps(manifest_dict).encode("utf-8")

        tampered_buf = io.BytesIO()
        with zipfile.ZipFile(tampered_buf, "w") as t_zf:
            t_zf.writestr("manifest.json", mod_manifest_bytes)
            t_zf.writestr("data/data.enc", enc_payload)

        with pytest.raises(SATSAException) as exc:
            DataExchangeService._read_and_verify_package(tampered_buf.getvalue(), passphrase=passphrase)
        assert exc.value.code == "AEAD_AUTHENTICATION_FAILED"

    def test_H_export_import_round_trip_identical_data(self, db_session, test_setup_data):
        """Requirement H: Export -> import round trip still produces identical data."""
        ass = test_setup_data["assessment"]
        passphrase = "RoundTripPassphrase#2026"
        pkg_bytes = DataExchangeService.export_assessment_package(db_session, ass.id, passphrase=passphrase)

        # Delete local records to simulate import to Database B
        db_session.delete(test_setup_data["review"])
        db_session.delete(test_setup_data["evidence"])
        db_session.delete(test_setup_data["finding"])
        db_session.delete(test_setup_data["analysis_run"])
        db_session.delete(test_setup_data["dataset_version"])
        db_session.delete(test_setup_data["report"])
        db_session.delete(ass)
        db_session.commit()

        res = DataExchangeService.import_assessment_package(db_session, pkg_bytes, passphrase=passphrase)
        assert res.success is True
        assert res.imported_assessment_id == ass.id

        imp_ass = db_session.query(Assessment).filter(Assessment.id == ass.id).first()
        assert imp_ass is not None
        assert imp_ass.name == "Phase 18 Q3 Audit Assessment"
        assert len(imp_ass.analysis_runs) == 1
        assert len(imp_ass.analysis_runs[0].findings) == 1

        imp_finding = imp_ass.analysis_runs[0].findings[0]
        assert imp_finding.category == "EXECUTION_GAP"
        assert len(imp_finding.evidence_links) == 1
        assert len(imp_finding.review_history) == 1
        assert imp_finding.review_history[0].note_text == "Examiner flagged for tier-2 SOC escalation"

    def test_I_transaction_rollback_works(self, db_session, test_setup_data):
        """Requirement I: Transaction rollback still works on import failure."""
        ass = test_setup_data["assessment"]
        pkg_bytes = DataExchangeService.export_assessment_package(db_session, ass.id)

        manifest, data_dict = DataExchangeService._read_and_verify_package(pkg_bytes)
        # Corrupt CSE ID to invalid UUID reference in findings
        data_dict["findings"][0]["cse_id"] = str(uuid.uuid4())

        json_bytes = json.dumps(data_dict).encode("utf-8")
        salt_bytes = secrets.token_bytes(16)
        nonce_bytes = secrets.token_bytes(12)
        aes_key = DataExchangeService._derive_aes256_key if hasattr(DataExchangeService, "_derive_aes256_key") else None

        from app.services.data_exchange_service import _derive_aes256_key, _construct_aad
        from cryptography.hazmat.primitives.ciphers.aead import AESGCM

        key = _derive_aes256_key(settings.JWT_SECRET_KEY, salt_bytes, 100000)
        aad = _construct_aad("SAT-SA-OFFLINE-PACKAGE", "1.0.0", str(manifest.package_id))
        aesgcm = AESGCM(key)
        enc_payload = nonce_bytes + aesgcm.encrypt(nonce_bytes, json_bytes, aad)

        manifest_dict = manifest.model_dump(mode="json")
        manifest_dict["kdf_salt"] = salt_bytes.hex()
        manifest_dict["aead_nonce"] = nonce_bytes.hex()
        manifest_dict["data_hash_sha256"] = __import__("hashlib").sha256(json_bytes).hexdigest()

        mod_buf = io.BytesIO()
        with zipfile.ZipFile(mod_buf, "w") as mod_zf:
            mod_zf.writestr("manifest.json", json.dumps(manifest_dict))
            mod_zf.writestr("data/data.enc", enc_payload)

        # Delete local records to attempt import
        db_session.delete(test_setup_data["review"])
        db_session.delete(test_setup_data["evidence"])
        db_session.delete(test_setup_data["finding"])
        db_session.delete(test_setup_data["analysis_run"])
        db_session.delete(test_setup_data["dataset_version"])
        db_session.delete(test_setup_data["report"])
        db_session.delete(ass)
        db_session.commit()

        with pytest.raises(SATSAException) as exc:
            DataExchangeService.import_assessment_package(db_session, mod_buf.getvalue())
        assert exc.value.code == "IMPORT_TRANSACTION_FAILED"

        # Verify DB rollback: assessment was NOT partially inserted
        assert db_session.query(Assessment).filter(Assessment.id == ass.id).first() is None

    def test_J_K_rbac_enforcement(self, test_setup_data, auth_tokens):
        """Requirements J & K: ADMIN/SUPERVISOR RBAC works; VIEWER remains blocked."""
        ass = test_setup_data["assessment"]
        _, viewer_token = auth_tokens["viewer"]
        _, sup_token = auth_tokens["supervisor"]
        _, admin_token = auth_tokens["admin"]

        # Viewer export blocked (403)
        res_exp_v = client.post(
            f"/api/v1/assessments/{ass.id}/export",
            headers={"Authorization": f"Bearer {viewer_token}"}
        )
        assert res_exp_v.status_code == 403

        # Supervisor export allowed (200)
        res_exp_s = client.post(
            f"/api/v1/assessments/{ass.id}/export",
            headers={"Authorization": f"Bearer {sup_token}"}
        )
        assert res_exp_s.status_code == 200

        # Admin export allowed (200)
        res_exp_a = client.post(
            f"/api/v1/assessments/{ass.id}/export",
            headers={"Authorization": f"Bearer {admin_token}"}
        )
        assert res_exp_a.status_code == 200

        pkg_bytes = res_exp_s.content

        # Viewer import blocked (403)
        res_imp_v = client.post(
            "/api/v1/assessments/import",
            files={"file": ("test.satsa", pkg_bytes, "application/octet-stream")},
            headers={"Authorization": f"Bearer {viewer_token}"}
        )
        assert res_imp_v.status_code == 403

        # Supervisor validate allowed (200)
        res_val_s = client.post(
            "/api/v1/assessments/import/validate",
            files={"file": ("test.satsa", pkg_bytes, "application/octet-stream")},
            headers={"Authorization": f"Bearer {sup_token}"}
        )
        assert res_val_s.status_code == 200
        val_data = res_val_s.json()
        assert val_data["is_valid"] is True
        assert val_data["conflict_detected"] is True

    def test_L_cse_isolation_remains_enforced(self, db_session, test_setup_data, auth_tokens):
        """Requirement L: CSE isolation remains enforced on export and import."""
        ass = test_setup_data["assessment"]

        # Create another supervisor user NOT authorized for this CSE
        unauth_sup = User(
            id=uuid.uuid4(),
            username=f"unauth_sup_{uuid.uuid4().hex[:6]}",
            email=f"unauth_{uuid.uuid4().hex[:6]}@satsa.org",
            hashed_password=get_password_hash("Password#123"),
            role="SUPERVISOR",
            is_active=True
        )
        db_session.add(unauth_sup)
        db_session.commit()
        unauth_token = create_access_token({"sub": str(unauth_sup.id), "role": "SUPERVISOR"})

        # Export attempted by unauthorized supervisor blocked (403)
        res = client.post(
            f"/api/v1/assessments/{ass.id}/export",
            headers={"Authorization": f"Bearer {unauth_token}"}
        )
        assert res.status_code == 403
