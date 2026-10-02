import uuid
from datetime import datetime, timezone
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError

from app.main import app
from app.models.cse import CSE
from app.models.user import User
from app.models.finding import Finding, FindingEvidence, FindingReviewHistory
from app.models.report import ReportRecord
from app.services.auth_service import AuthService
from app.utils.security import get_password_hash, create_access_token
from app.services.report_generator_service import CANONICAL_RULE_CODES

client = TestClient(app)

def create_test_cse(db: Session, suffix: str = "P12") -> CSE:
    cse = CSE(
        cse_code=f"CSE-{suffix}-{uuid.uuid4().hex[:6].upper()}",
        name=f"Report Test CSE {suffix}",
        sector="BANKING",
        criticality_tier="TIER_1"
    )
    db.add(cse)
    db.commit()
    db.refresh(cse)
    return cse

from app.models.user import User, UserCSE

def create_test_user(db: Session, role: str, cse: CSE, username: str = None) -> User:
    u = User(
        username=username or f"user_{role.lower()}_{uuid.uuid4().hex[:6]}",
        email=f"test_{uuid.uuid4().hex[:6]}@example.com",
        hashed_password=get_password_hash("password123"),
        role=role,
        is_active=True
    )
    db.add(u)
    db.commit()
    db.refresh(u)
    db.add(UserCSE(user_id=u.id, cse_id=cse.id))
    db.commit()
    return u



def get_auth_headers(user: User) -> dict:
    token = create_access_token({"sub": str(user.id), "role": user.role})
    return {"Authorization": f"Bearer {token}"}

def test_canonical_rule_list_is_exactly_eight():
    assert len(CANONICAL_RULE_CODES) == 8
    expected = {"EG-01", "EG-02", "EG-03", "EG-04", "NS-01", "NS-02", "AN-01", "BM-01"}
    assert CANONICAL_RULE_CODES == expected
    assert "AN-02" not in CANONICAL_RULE_CODES

def test_report_generation_and_provenance(db_session: Session):
    cse = create_test_cse(db_session, "GEN")
    supervisor = create_test_user(db_session, "SUPERVISOR", cse)
    headers = get_auth_headers(supervisor)

    # Create finding
    f = Finding(
        cse_id=cse.id,
        finding_code=f"EG-01-{uuid.uuid4().hex[:6]}",
        category="EXECUTION_GAP",
        severity="HIGH",
        title="Escalation SLA Breach",
        description="Critical alert not escalated within 15 min",
        rationale="Exceeded SLA threshold",
        detection_method="Rule Engine EG-01",
        metrics_json={"breach_minutes": 45},
        status="NEW"
    )
    db_session.add(f)
    db_session.commit()


    # Generate Report
    res = client.post(
        "/api/v1/reports/generate",
        json={"cse_id": str(cse.id)},
        headers=headers
    )
    assert res.status_code == 200
    data = res.json()
    assert "report_metadata" in data
    assert data["report_metadata"]["cse_id"] == str(cse.id)
    assert data["report_metadata"]["cse_code"] == cse.cse_code
    assert "active_findings" in data
    assert len(data["active_findings"]) >= 1

def test_report_regeneration_creates_new_snapshot(db_session: Session):
    cse = create_test_cse(db_session, "REGEN")
    supervisor = create_test_user(db_session, "SUPERVISOR", cse)
    headers = get_auth_headers(supervisor)

    res1 = client.post("/api/v1/reports/generate", json={"cse_id": str(cse.id)}, headers=headers)
    assert res1.status_code == 200
    rep1_code = res1.json()["report_metadata"]["report_code"]

    res2 = client.post("/api/v1/reports/generate", json={"cse_id": str(cse.id)}, headers=headers)
    assert res2.status_code == 200
    rep2_code = res2.json()["report_metadata"]["report_code"]

    assert rep1_code != rep2_code

    # Verify both records exist in DB
    recs = db_session.query(ReportRecord).filter(ReportRecord.cse_id == cse.id).all()
    assert len(recs) == 2

def test_csv_export_left_outer_join_zero_evidence(db_session: Session):
    cse = create_test_cse(db_session, "CSV0")
    supervisor = create_test_user(db_session, "SUPERVISOR", cse)
    headers = get_auth_headers(supervisor)

    # Finding with 0 evidence
    f_no_ev = Finding(
        cse_id=cse.id,
        finding_code=f"NS-01-{uuid.uuid4().hex[:6]}",
        category="NEGATIVE_SPACE",
        severity="CRITICAL",
        title="Zero Evidence Finding",
        description="Coverage gap",
        rationale="Telemetry missing",
        detection_method="Rule Engine NS-01",
        status="NEW"
    )
    db_session.add(f_no_ev)
    db_session.commit()


    # Generate Report Record
    gen_res = client.post("/api/v1/reports/generate", json={"cse_id": str(cse.id)}, headers=headers)
    assert gen_res.status_code == 200

    recs = db_session.query(ReportRecord).filter(ReportRecord.cse_id == cse.id).all()
    report_id = str(recs[0].id)

    # Export CSV
    csv_res = client.get(f"/api/v1/reports/{report_id}/export/csv", headers=headers)
    assert csv_res.status_code == 200
    assert csv_res.headers["content-type"].startswith("text/csv")
    csv_text = csv_res.text

    # Verify zero-evidence finding is present in CSV
    assert "NS-01" in csv_text
    assert "Zero Evidence Finding" in csv_text

def test_pdf_export_binary(db_session: Session):
    cse = create_test_cse(db_session, "PDF")
    supervisor = create_test_user(db_session, "SUPERVISOR", cse)
    headers = get_auth_headers(supervisor)

    gen_res = client.post("/api/v1/reports/generate", json={"cse_id": str(cse.id)}, headers=headers)
    assert gen_res.status_code == 200

    recs = db_session.query(ReportRecord).filter(ReportRecord.cse_id == cse.id).all()
    report_id = str(recs[0].id)

    pdf_res = client.get(f"/api/v1/reports/{report_id}/export/pdf", headers=headers)
    assert pdf_res.status_code == 200
    assert pdf_res.headers["content-type"] == "application/pdf"
    assert pdf_res.content.startswith(b"%PDF-")

def test_json_export(db_session: Session):
    cse = create_test_cse(db_session, "JSON")
    viewer = create_test_user(db_session, "VIEWER", cse)
    headers = get_auth_headers(viewer)

    supervisor = create_test_user(db_session, "SUPERVISOR", cse)
    gen_res = client.post("/api/v1/reports/generate", json={"cse_id": str(cse.id)}, headers=get_auth_headers(supervisor))
    assert gen_res.status_code == 200

    recs = db_session.query(ReportRecord).filter(ReportRecord.cse_id == cse.id).all()
    report_id = str(recs[0].id)

    json_res = client.get(f"/api/v1/reports/{report_id}/export/json", headers=headers)
    assert json_res.status_code == 200
    assert json_res.headers["content-type"].startswith("application/json")
    data = json_res.json()
    assert "report_metadata" in data
    assert "capability_assessment" in data

def test_cse_isolation_unauthorized_returns_403(db_session: Session):
    cse_a = create_test_cse(db_session, "CSEA")
    cse_b = create_test_cse(db_session, "CSEB")
    user_a = create_test_user(db_session, "SUPERVISOR", cse_a)
    headers_a = get_auth_headers(user_a)

    # Try generating report for CSE B with User A's credentials
    res = client.post("/api/v1/reports/generate", json={"cse_id": str(cse_b.id)}, headers=headers_a)
    assert res.status_code == 403

def test_rbac_viewer_cannot_generate_report(db_session: Session):
    cse = create_test_cse(db_session, "RBACV")
    viewer = create_test_user(db_session, "VIEWER", cse)
    headers = get_auth_headers(viewer)

    res = client.post("/api/v1/reports/generate", json={"cse_id": str(cse.id)}, headers=headers)
    assert res.status_code == 403

def test_report_provenance_fk_restrict_protection(db_session: Session):
    cse = create_test_cse(db_session, "FKREST")
    supervisor = create_test_user(db_session, "SUPERVISOR", cse)

    report_rec = ReportRecord(
        report_code=f"REP-{uuid.uuid4().hex}",
        cse_id=cse.id,
        generated_by_user_id=supervisor.id,
        created_at=datetime.now(timezone.utc),
        summary_json={},
        metadata_json={}
    )
    db_session.add(report_rec)
    db_session.commit()

    # Attempting to delete CSE should raise IntegrityError due to ON DELETE RESTRICT
    with pytest.raises(IntegrityError):
        db_session.delete(cse)
        db_session.commit()
    db_session.rollback()

