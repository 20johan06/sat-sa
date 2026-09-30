import uuid
import pytest
from datetime import datetime, timezone, timedelta
from fastapi.testclient import TestClient

from app.main import app
from app.models.cse import CSE
from app.models.alert import Alert
from app.models.finding import Finding, FindingEvidence
from app.models.user import User
from app.services.auth_service import AuthService
from app.schemas.auth import UserCreateRequest
from app.utils.security import create_access_token
from app.services.supervisory_service import supervisory_service

client = TestClient(app)

@pytest.fixture
def phase6_test_data(db_session):
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})

    cse_a = CSE(
        id=uuid.uuid4(),
        name="Phase6 Test CSE Alpha",
        cse_code=f"CSE-P6-A-{uuid.uuid4().hex[:6]}",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    cse_b = CSE(
        id=uuid.uuid4(),
        name="Phase6 Test CSE Beta",
        cse_code=f"CSE-P6-B-{uuid.uuid4().hex[:6]}",
        sector="FINANCE",
        criticality_tier="TIER_2"
    )
    db_session.add(cse_a)
    db_session.add(cse_b)
    db_session.commit()

    # Create real Alert for CSE A
    alert1 = Alert(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        external_alert_id=f"ALT-P6-1-{uuid.uuid4().hex[:6]}",
        title="Critical Suspicious Alert",
        category="MALWARE",
        severity="CRITICAL",
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    db_session.add(alert1)
    db_session.commit()

    # Create critical finding for CSE A with unique finding_code
    f1 = Finding(
        id=uuid.uuid4(),
        finding_code=f"EG-01-P6A-{uuid.uuid4().hex[:6]}",
        cse_id=cse_a.id,
        category="EXECUTION_GAP",
        severity="CRITICAL",
        title="Uninvestigated Alerts Detected",
        description="Execution gap on critical alerts.",
        rationale="Alerts lacked linked cases.",
        detection_method="EG-01",
        metrics_json={"evidence_strength": "STRONG", "capability": "Incident Response"},
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    ev1 = FindingEvidence(
        id=uuid.uuid4(),
        finding_id=f1.id,
        evidence_type="ALERT",
        alert_id=alert1.id
    )

    # Create medium finding for CSE B with unique finding_code
    f2 = Finding(
        id=uuid.uuid4(),
        finding_code=f"BM-01-P6B-{uuid.uuid4().hex[:6]}",
        cse_id=cse_b.id,
        category="BENCHMARK",
        severity="MEDIUM",
        title="Peer Investigation Rate Deviation",
        description="Deviation from peer mean.",
        rationale="Z-score exceeded threshold.",
        detection_method="BM-01",
        metrics_json={"evidence_strength": "MODERATE", "capability": "Peer Performance Alignment", "baseline_value": 0.85, "observed_value": 0.50, "deviation": -2.1},
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )

    db_session.add(f1)
    db_session.add(ev1)
    db_session.add(f2)
    db_session.commit()

    # Create a supervisor authorized only for CSE A
    sup = AuthService.create_user(
        db=db_session,
        req=UserCreateRequest(
            username=f"p6_sup_{uuid.uuid4().hex[:6]}",
            email=f"p6_sup_{uuid.uuid4().hex[:6]}@example.com",
            password="SupPass123!",
            role="SUPERVISOR",
            allowed_cse_ids=[cse_a.id]
        )
    )
    sup_token = create_access_token({"sub": str(sup.id), "role": "SUPERVISOR"})

    return {
        "admin_token": admin_token,
        "sup_token": sup_token,
        "cse_a": cse_a,
        "cse_b": cse_b,
        "finding_a": f1,
        "finding_b": f2
    }

def test_attention_queue_admin(phase6_test_data):
    """Verify ADMIN can query full attention queue with transparent deterministic indicators."""
    admin_token = phase6_test_data["admin_token"]
    res = client.get(
        "/api/v1/supervisory/attention-queue",
        headers={"Authorization": f"Bearer {admin_token}"}
    )
    assert res.status_code == 200
    data = res.json()
    assert "items" in data
    assert data["total_cses"] >= 2
    assert "total_active_findings" in data
    assert "total_critical_findings" in data

    # Find items for CSE Alpha and CSE Beta
    items = data["items"]
    cse_a_item = next((i for i in items if i["cse_id"] == str(phase6_test_data["cse_a"].id)), None)
    cse_b_item = next((i for i in items if i["cse_id"] == str(phase6_test_data["cse_b"].id)), None)

    assert cse_a_item is not None
    assert cse_a_item["indicators"]["active_critical_findings_count"] == 1
    assert cse_a_item["indicators"]["active_findings_count"] >= 1
    assert cse_a_item["indicators"]["affected_record_count"] >= 1
    assert cse_a_item["concise_rationale"]["what"] != ""

    assert cse_b_item is not None
    assert cse_b_item["indicators"]["active_critical_findings_count"] == 0
    assert cse_b_item["indicators"]["benchmark_deviations_count"] == 1

def test_attention_queue_cse_isolation(phase6_test_data):
    """Verify non-admin SUPERVISOR only sees authorized CSEs in the attention queue."""
    sup_token = phase6_test_data["sup_token"]
    res = client.get(
        "/api/v1/supervisory/attention-queue",
        headers={"Authorization": f"Bearer {sup_token}"}
    )
    assert res.status_code == 200
    data = res.json()
    items = data["items"]

    # Must contain CSE Alpha, MUST NOT contain CSE Beta
    cse_ids = [i["cse_id"] for i in items]
    assert str(phase6_test_data["cse_a"].id) in cse_ids
    assert str(phase6_test_data["cse_b"].id) not in cse_ids

def test_entity_supervisory_overview_success(phase6_test_data):
    """Verify detailed entity supervisory overview endpoint returns structured explainability & indicators."""
    admin_token = phase6_test_data["admin_token"]
    cse_a_id = str(phase6_test_data["cse_a"].id)
    
    res = client.get(
        f"/api/v1/supervisory/cse/{cse_a_id}/attention-overview",
        headers={"Authorization": f"Bearer {admin_token}"}
    )
    assert res.status_code == 200
    data = res.json()

    assert data["cse_id"] == cse_a_id
    assert "indicators" in data
    assert data["indicators"]["active_critical_findings_count"] == 1
    assert "capabilities_breakdown" in data
    assert "why_attention" in data
    
    why = data["why_attention"]
    assert "what" in why
    assert "why" in why
    assert "how" in why
    assert "evidence" in why
    assert "baseline" in why
    assert "impact" in why

def test_entity_supervisory_overview_isolation(phase6_test_data):
    """Verify server-side CSE isolation blocks unauthorized supervisor access."""
    sup_token = phase6_test_data["sup_token"]
    cse_b_id = str(phase6_test_data["cse_b"].id)

    res = client.get(
        f"/api/v1/supervisory/cse/{cse_b_id}/attention-overview",
        headers={"Authorization": f"Bearer {sup_token}"}
    )
    assert res.status_code == 403
    assert res.json()["error"]["code"] == "UNAUTHORIZED_CSE_ACCESS"

def test_supervisory_overview_not_found(phase6_test_data):
    """Verify 404 response for invalid CSE ID."""
    admin_token = phase6_test_data["admin_token"]
    random_id = str(uuid.uuid4())

    res = client.get(
        f"/api/v1/supervisory/cse/{random_id}/attention-overview",
        headers={"Authorization": f"Bearer {admin_token}"}
    )
    assert res.status_code == 404

def test_invalid_date_range_rejection(phase6_test_data):
    """Verify 422 error when obs_start >= obs_end."""
    admin_token = phase6_test_data["admin_token"]
    now = datetime.now(timezone.utc)
    
    res = client.get(
        f"/api/v1/supervisory/attention-queue?obs_start={now.isoformat()}&obs_end={(now - timedelta(days=1)).isoformat()}",
        headers={"Authorization": f"Bearer {admin_token}"}
    )
    assert res.status_code == 422

def test_transparent_indicator_aggregation(db_session, phase6_test_data):
    """Unit test for SupervisoryService indicator calculation without attention levels."""
    cse_a = phase6_test_data["cse_a"]
    findings = db_session.query(Finding).filter(Finding.cse_id == cse_a.id).all()
    indicators = supervisory_service._calculate_indicators(db_session, cse_a.id, findings)

    assert indicators.active_findings_count >= 1
    assert indicators.active_critical_findings_count == 1
    assert indicators.execution_gap_findings_count == 1
