import uuid
import pytest
from datetime import datetime, timezone, timedelta
from fastapi.testclient import TestClient

from app.main import app
from app.models.cse import CSE
from app.models.finding import Finding
from app.models.alert import Alert
from app.models.user import User, UserCSE
from app.services.auth_service import AuthService
from app.utils.security import create_access_token

client = TestClient(app)

@pytest.fixture
def phase10_test_data(db_session):
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    admin_headers = {"Authorization": f"Bearer {admin_token}"}

    cse_a = CSE(
        id=uuid.uuid4(),
        name="Phase10 Test CSE Alpha",
        cse_code=f"CSE-P10-A-{uuid.uuid4().hex[:6]}",
        sector="BANKING",
        criticality_tier="TIER_1"
    )
    cse_b = CSE(
        id=uuid.uuid4(),
        name="Phase10 Test CSE Beta",
        cse_code=f"CSE-P10-B-{uuid.uuid4().hex[:6]}",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    db_session.add_all([cse_a, cse_b])
    db_session.commit()

    now = datetime.now(timezone.utc)
    curr_start = now - timedelta(days=30)
    prev_start = now - timedelta(days=60)

    # Telemetry for CSE Alpha (Current Period: 10 alerts, Previous Period: 5 alerts)
    for i in range(10):
        alert_curr = Alert(
            id=uuid.uuid4(),
            cse_id=cse_a.id,
            external_alert_id=f"ALT-P10-CURR-{i}-{uuid.uuid4().hex[:4]}",
            title=f"P10 Alert Current {i}",
            category="THREAT_DETECTION",
            severity="HIGH",
            status="NEW",
            detected_at=now - timedelta(days=5)
        )
        db_session.add(alert_curr)

    for i in range(5):
        alert_prev = Alert(
            id=uuid.uuid4(),
            cse_id=cse_a.id,
            external_alert_id=f"ALT-P10-PREV-{i}-{uuid.uuid4().hex[:4]}",
            title=f"P10 Alert Prev {i}",
            category="THREAT_DETECTION",
            severity="HIGH",
            status="NEW",
            detected_at=now - timedelta(days=45)
        )
        db_session.add(alert_prev)

    db_session.commit()

    # Findings for CSE Alpha (Current: EG-01 x 2, Previous: EG-01 x 1)
    f_curr1 = Finding(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        finding_code=f"FND-P10-EG01-1-{uuid.uuid4().hex[:4]}",
        category="EXECUTION_GAP",
        severity="HIGH",
        title="EG-01 Current 1",
        description="Incident SLA breach.",
        rationale="Unconfigured expectation.",
        detection_method="RULE_EVALUATION",
        metrics_json={"rule_code": "EG-01"},
        status="NEW",
        detected_at=now - timedelta(days=10)
    )
    f_curr2 = Finding(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        finding_code=f"FND-P10-EG01-2-{uuid.uuid4().hex[:4]}",
        category="EXECUTION_GAP",
        severity="MEDIUM",
        title="EG-01 Current 2",
        description="Incident SLA breach 2.",
        rationale="Unconfigured expectation.",
        detection_method="RULE_EVALUATION",
        metrics_json={"rule_code": "EG-01"},
        status="CONFIRMED",
        detected_at=now - timedelta(days=15)
    )
    f_prev1 = Finding(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        finding_code=f"FND-P10-EG01-P-{uuid.uuid4().hex[:4]}",
        category="EXECUTION_GAP",
        severity="HIGH",
        title="EG-01 Prev 1",
        description="Incident SLA breach prev.",
        rationale="Unconfigured expectation.",
        detection_method="RULE_EVALUATION",
        metrics_json={"rule_code": "EG-01"},
        status="NEW",
        detected_at=now - timedelta(days=40)
    )
    db_session.add_all([f_curr1, f_curr2, f_prev1])
    db_session.commit()

    # Restricted Analyst User assigned ONLY to CSE Alpha
    analyst = User(
        id=uuid.uuid4(),
        username=f"analyst_p10_{uuid.uuid4().hex[:6]}",
        email=f"analyst_p10_{uuid.uuid4().hex[:6]}@example.com",
        role="ANALYST",
        is_active=True,
        hashed_password="hash"
    )
    db_session.add(analyst)
    db_session.commit()

    user_cse = UserCSE(user_id=analyst.id, cse_id=cse_a.id)
    db_session.add(user_cse)
    db_session.commit()

    analyst_token = create_access_token({"sub": str(analyst.id), "role": "ANALYST"})
    analyst_headers = {"Authorization": f"Bearer {analyst_token}"}

    return {
        "admin_headers": admin_headers,
        "analyst_headers": analyst_headers,
        "cse_a": cse_a,
        "cse_b": cse_b
    }

def test_get_cse_trends_structure(db_session, phase10_test_data):
    """Verifies that trends endpoint returns structured period-over-period metric comparisons."""
    headers = phase10_test_data["admin_headers"]
    cse_id = phase10_test_data["cse_a"].id

    res = client.get(f"/api/v1/supervisory/cse/{cse_id}/trends", headers=headers)
    assert res.status_code == 200
    data = res.json()

    assert data["cse_id"] == str(cse_id)
    assert data["current_period"]["is_bounded"] is True
    assert data["previous_period"]["is_bounded"] is True
    assert len(data["metrics"]) > 0

    # Check Operational Alert Volume metric
    alert_metric = next((m for m in data["metrics"] if m["metric_name"] == "Source Operational Alert Volume"), None)
    assert alert_metric is not None
    assert alert_metric["current_value"] == 10.0
    assert alert_metric["previous_value"] == 5.0
    assert alert_metric["absolute_change"] == 5.0
    assert alert_metric["percentage_change"] == 100.0

def test_zero_denominator_percentage_guard(db_session, phase10_test_data):
    """Verifies that percentage_change evaluates to null when previous period is zero/missing."""
    headers = phase10_test_data["admin_headers"]
    cse_id = phase10_test_data["cse_b"].id  # CSE B has 0 telemetry in previous period

    res = client.get(f"/api/v1/supervisory/cse/{cse_id}/trends", headers=headers)
    assert res.status_code == 200
    data = res.json()

    alert_metric = next((m for m in data["metrics"] if m["metric_name"] == "Source Operational Alert Volume"), None)
    assert alert_metric is not None
    assert alert_metric["percentage_change"] is None
    assert alert_metric["limitation"] is not None

def test_cse_server_side_isolation(db_session, phase10_test_data):
    """Verifies that unauthorized user cannot access another CSE's trends (HTTP 403)."""
    analyst_headers = phase10_test_data["analyst_headers"]
    cse_b_id = phase10_test_data["cse_b"].id

    res = client.get(f"/api/v1/supervisory/cse/{cse_b_id}/trends", headers=analyst_headers)
    assert res.status_code == 403

def test_zero_database_mutation(db_session, phase10_test_data):
    """Verifies that GET trends call performs zero database mutations."""
    headers = phase10_test_data["admin_headers"]
    cse_id = phase10_test_data["cse_a"].id

    findings_before = db_session.query(Finding).count()

    res = client.get(f"/api/v1/supervisory/cse/{cse_id}/trends", headers=headers)
    assert res.status_code == 200

    findings_after = db_session.query(Finding).count()
    assert findings_before == findings_after
