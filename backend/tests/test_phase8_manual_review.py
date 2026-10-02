import uuid
import pytest
from datetime import datetime, timezone, timedelta
from fastapi.testclient import TestClient

from app.main import app
from app.models.cse import CSE
from app.models.finding import Finding, FindingEvidence
from app.models.alert import Alert
from app.models.case import Case
from app.models.user import User, UserCSE
from app.services.auth_service import AuthService
from app.utils.security import create_access_token

client = TestClient(app)

@pytest.fixture
def phase8_test_data(db_session):
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    admin_headers = {"Authorization": f"Bearer {admin_token}"}

    # CSE Alpha
    cse_a = CSE(
        id=uuid.uuid4(),
        name="Phase8 Test CSE Alpha",
        cse_code=f"CSE-P8-A-{uuid.uuid4().hex[:6]}",
        sector="BANKING",
        criticality_tier="TIER_1"
    )
    # CSE Beta
    cse_b = CSE(
        id=uuid.uuid4(),
        name="Phase8 Test CSE Beta",
        cse_code=f"CSE-P8-B-{uuid.uuid4().hex[:6]}",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    db_session.add_all([cse_a, cse_b])
    db_session.commit()

    # Create dummy Alert and Case for evidence linkage
    alert_obj = Alert(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        external_alert_id=f"ALT-P8-{uuid.uuid4().hex[:6]}",
        title="P8 Test Alert",
        category="THREAT_DETECTION",
        severity="CRITICAL",
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    db_session.add(alert_obj)
    db_session.commit()

    case_obj = Case(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        alert_id=alert_obj.id,
        external_case_id=f"CAS-P8-{uuid.uuid4().hex[:6]}",
        title="P8 Test Case",
        status="CLOSED",
        opened_at=datetime.now(timezone.utc) - timedelta(hours=2),
        closed_at=datetime.now(timezone.utc)
    )
    db_session.add(case_obj)
    db_session.commit()

    now = datetime.now(timezone.utc)

    # Finding 1 (Detected 1 hour ago) with explicit metrics_json
    finding_1 = Finding(
        id=uuid.uuid4(),
        finding_code=f"FND-EG03-{cse_a.id.hex[:6]}-{case_obj.id.hex[:6]}",
        cse_id=cse_a.id,
        category="EXECUTION_GAP",
        severity="MEDIUM",
        title="Rapid Case Closure Pattern",
        description="Case closed rapidly under lower-tail P5",
        rationale="P5 duration threshold breached",
        detection_method="Lower-tail P5 Interpolation",
        metrics_json={
            "rule_code": "EG-03",
            "evidence_strength": "STRONG",
            "capability": "Investigation"
        },
        status="NEW",
        detected_at=now - timedelta(hours=1)
    )
    # Finding 2 (Detected 10 minutes ago - newest) with explicit metrics_json
    finding_2 = Finding(
        id=uuid.uuid4(),
        finding_code=f"FND-AN01-{cse_a.id.hex[:6]}-2026-09-30",
        cse_id=cse_a.id,
        category="ANOMALY",
        severity="HIGH",
        title="Alert Volume Anomaly",
        description="Statistical anomaly in daily alert volume",
        rationale="MAD score exceeded threshold",
        detection_method="Median Absolute Deviation",
        metrics_json={
            "rule_code": "AN-01",
            "evidence_strength": "MODERATE",
            "capability": "Threat Detection"
        },
        status="UNDER_REVIEW",
        detected_at=now - timedelta(minutes=10)
    )
    # Finding 3 for CSE B (Detected now) with explicit metrics_json
    finding_3_b = Finding(
        id=uuid.uuid4(),
        finding_code=f"FND-BM01-{cse_b.id.hex[:6]}-2026-09-30",
        cse_id=cse_b.id,
        category="BENCHMARK",
        severity="MEDIUM",
        title="Peer Benchmarking Deviation",
        description="Sector benchmark deviation detected",
        rationale="Z-score > 2.0",
        detection_method="Z-Score Analysis",
        metrics_json={
            "rule_code": "BM-01",
            "evidence_strength": "STRONG",
            "capability": "Governance and Oversight"
        },
        status="NEW",
        detected_at=now
    )
    db_session.add_all([finding_1, finding_2, finding_3_b])
    db_session.commit()

    # Evidence Links
    ev_1 = FindingEvidence(
        id=uuid.uuid4(),
        finding_id=finding_1.id,
        evidence_type="CASE",
        case_id=case_obj.id,
        notes="Rapid closure case evidence pointer"
    )
    ev_2 = FindingEvidence(
        id=uuid.uuid4(),
        finding_id=finding_2.id,
        evidence_type="ALERT",
        alert_id=alert_obj.id,
        notes="Anomaly alert evidence pointer"
    )
    ev_3_b = FindingEvidence(
        id=uuid.uuid4(),
        finding_id=finding_3_b.id,
        evidence_type="ALERT",
        alert_id=alert_obj.id,
        notes="CSE B benchmark evidence pointer"
    )
    db_session.add_all([ev_1, ev_2, ev_3_b])
    db_session.commit()

    # Create restricted CSE user using valid Phase 2 role: SUPERVISOR
    uname = f"supervisor_p8_{uuid.uuid4().hex[:6]}"
    supervisor_user = User(
        id=uuid.uuid4(),
        username=uname,
        email=f"{uname}@example.com",
        hashed_password="pw",
        role="SUPERVISOR",
        is_active=True
    )
    db_session.add(supervisor_user)
    db_session.commit()
    db_session.add(UserCSE(user_id=supervisor_user.id, cse_id=cse_a.id))
    db_session.commit()

    supervisor_token = create_access_token({"sub": str(supervisor_user.id), "role": "SUPERVISOR"})
    supervisor_headers = {"Authorization": f"Bearer {supervisor_token}"}

    return {
        "admin_headers": admin_headers,
        "supervisor_headers": supervisor_headers,
        "cse_a": cse_a,
        "cse_b": cse_b,
        "finding_1": finding_1,
        "finding_2": finding_2,
        "finding_3_b": finding_3_b,
        "ev_1": ev_1,
        "ev_2": ev_2,
        "ev_3_b": ev_3_b,
    }

def test_get_manual_review_queue_empty(phase8_test_data):
    """Verify GET /api/v1/manual-review/queue returns valid paginated response."""
    headers = phase8_test_data["admin_headers"]
    res = client.get("/api/v1/manual-review/queue", headers=headers)
    assert res.status_code == 200
    data = res.json()
    assert "items" in data
    assert "pagination" in data
    assert "filters_applied" in data

def test_get_manual_review_queue_success(db_session, phase8_test_data):
    """Verify manual review queue retrieval with single transparent chronological ordering (detected_at DESC) and metrics_json reuse."""
    headers = phase8_test_data["admin_headers"]
    cse_a_id = str(phase8_test_data["cse_a"].id)

    res = client.get(f"/api/v1/manual-review/queue?cse_id={cse_a_id}", headers=headers)
    assert res.status_code == 200
    data = res.json()
    assert data["pagination"]["total"] == 2
    items = data["items"]

    # Verify chronological ordering: finding_2 (detected 10 mins ago) should be BEFORE finding_1 (detected 1 hour ago)
    assert items[0]["finding_id"] == str(phase8_test_data["finding_2"].id)
    assert items[0]["capability"] == "Threat Detection"
    assert items[0]["evidence_strength"] == "MODERATE"  # Verified persisted value reused
    assert items[0]["record_type"] == "ALERT"
    assert items[0]["explainability"] is not None

    assert items[1]["finding_id"] == str(phase8_test_data["finding_1"].id)
    assert items[1]["capability"] == "Investigation"
    assert items[1]["evidence_strength"] == "STRONG"  # Verified persisted value reused
    assert items[1]["record_type"] == "CASE"

def test_get_manual_review_queue_filtering(db_session, phase8_test_data):
    """Verify manual review queue filtering by record_type, category, and status."""
    headers = phase8_test_data["admin_headers"]

    # Filter by record_type=CASE
    res_case = client.get("/api/v1/manual-review/queue?record_type=CASE", headers=headers)
    assert res_case.status_code == 200
    for item in res_case.json()["items"]:
        assert item["record_type"] == "CASE"

    # Filter by status=NEW
    res_status = client.get("/api/v1/manual-review/queue?status=NEW", headers=headers)
    assert res_status.status_code == 200
    for item in res_status.json()["items"]:
        assert item["review_status"] == "NEW"

def test_get_manual_review_queue_cse_isolation(db_session, phase8_test_data):
    """Verify server-side CSE isolation on GET /api/v1/manual-review/queue for restricted SUPERVISOR role."""
    supervisor_headers = phase8_test_data["supervisor_headers"]
    cse_b_id = str(phase8_test_data["cse_b"].id)

    # Supervisor assigned to CSE A attempts to query CSE B review queue -> HTTP 403 Forbidden
    res = client.get(f"/api/v1/manual-review/queue?cse_id={cse_b_id}", headers=supervisor_headers)
    assert res.status_code == 403

def test_get_manual_review_recommendation_detail_success(db_session, phase8_test_data):
    """Verify retrieval of single manual review recommendation detail."""
    headers = phase8_test_data["admin_headers"]
    ev_1_id = str(phase8_test_data["ev_1"].id)

    res = client.get(f"/api/v1/manual-review/recommendation/{ev_1_id}", headers=headers)
    assert res.status_code == 200
    data = res.json()
    assert data["recommendation_id"] == f"REC-{ev_1_id}"
    assert data["finding_id"] == str(phase8_test_data["finding_1"].id)
    assert data["capability"] == "Investigation"
    assert data["evidence_strength"] == "STRONG"
    assert data["record_type"] == "CASE"
    assert data["explainability"] is not None

def test_get_manual_review_recommendation_detail_isolation(db_session, phase8_test_data):
    """Verify HTTP 403 on unauthorized single recommendation retrieval for SUPERVISOR user."""
    supervisor_headers = phase8_test_data["supervisor_headers"]
    ev_3_b_id = str(phase8_test_data["ev_3_b"].id)

    # Supervisor assigned to CSE A attempts to retrieve CSE B's recommendation -> HTTP 403 Forbidden
    res = client.get(f"/api/v1/manual-review/recommendation/{ev_3_b_id}", headers=supervisor_headers)
    assert res.status_code == 403
