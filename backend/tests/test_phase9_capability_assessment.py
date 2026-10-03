import uuid
import pytest
from datetime import datetime, timezone
from fastapi.testclient import TestClient

from app.main import app
from app.models.cse import CSE
from app.models.finding import Finding, FindingEvidence
from app.models.alert import Alert
from app.models.user import User, UserCSE
from app.services.auth_service import AuthService
from app.utils.security import create_access_token

client = TestClient(app)

@pytest.fixture
def phase9_test_data(db_session):
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    admin_headers = {"Authorization": f"Bearer {admin_token}"}

    # CSE Alpha (Has findings and telemetry)
    cse_a = CSE(
        id=uuid.uuid4(),
        name="Phase9 Test CSE Alpha",
        cse_code=f"CSE-P9-A-{uuid.uuid4().hex[:6]}",
        sector="BANKING",
        criticality_tier="TIER_1"
    )
    # CSE Beta (Has telemetry but ZERO findings)
    cse_b = CSE(
        id=uuid.uuid4(),
        name="Phase9 Test CSE Beta",
        cse_code=f"CSE-P9-B-{uuid.uuid4().hex[:6]}",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    # CSE Gamma (Has NO telemetry and NO findings)
    cse_g = CSE(
        id=uuid.uuid4(),
        name="Phase9 Test CSE Gamma",
        cse_code=f"CSE-P9-G-{uuid.uuid4().hex[:6]}",
        sector="ENERGY",
        criticality_tier="TIER_2"
    )
    db_session.add_all([cse_a, cse_b, cse_g])
    db_session.commit()

    # Create telemetry for CSE Alpha and CSE Beta
    alert_a = Alert(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        external_alert_id=f"ALT-P9-A-{uuid.uuid4().hex[:6]}",
        title="P9 Telemetry Alert A",
        category="THREAT_DETECTION",
        severity="HIGH",
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    alert_b = Alert(
        id=uuid.uuid4(),
        cse_id=cse_b.id,
        external_alert_id=f"ALT-P9-B-{uuid.uuid4().hex[:6]}",
        title="P9 Telemetry Alert B",
        category="THREAT_DETECTION",
        severity="MEDIUM",
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    db_session.add_all([alert_a, alert_b])
    db_session.commit()

    # Create findings for CSE Alpha with explicit metrics_json['rule_code']
    f_an01 = Finding(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        finding_code=f"FND-P9-AN01-{uuid.uuid4().hex[:6]}",
        category="ANOMALY",
        severity="HIGH",
        title="Anomaly Signal AN-01",
        description="Statistical anomaly detected.",
        rationale="Unusual activity detected.",
        detection_method="ANOMALY_DETECTION",
        metrics_json={"rule_code": "AN-01", "z_score": 2.5},
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    f_eg03 = Finding(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        finding_code=f"FND-P9-EG03-{uuid.uuid4().hex[:6]}",
        category="EXECUTION_GAP",
        severity="CRITICAL",
        title="Execution Gap EG-03",
        description="Delayed investigation gap.",
        rationale="SLA breach in triage.",
        detection_method="RULE_EVALUATION",
        metrics_json={"rule_code": "EG-03"},
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    f_ns01 = Finding(
        id=uuid.uuid4(),
        cse_id=cse_a.id,
        finding_code=f"FND-P9-NS01-{uuid.uuid4().hex[:6]}",
        category="NEGATIVE_SPACE",
        severity="MEDIUM",
        title="Negative Space NS-01",
        description="Telemetry coverage gap.",
        rationale="Unmonitored subnet.",
        detection_method="NEGATIVE_SPACE",
        metrics_json={"rule_code": "NS-01"},
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    db_session.add_all([f_an01, f_eg03, f_ns01])
    db_session.commit()

    # Create linked evidence
    ev_a1 = FindingEvidence(
        id=uuid.uuid4(),
        finding_id=f_an01.id,
        evidence_type="ALERT",
        alert_id=alert_a.id,
        notes="Linked alert evidence"
    )
    ev_a2 = FindingEvidence(
        id=uuid.uuid4(),
        finding_id=f_eg03.id,
        evidence_type="ALERT",
        alert_id=alert_a.id,
        notes="Linked alert evidence 2"
    )
    db_session.add_all([ev_a1, ev_a2])
    db_session.commit()

    # Restricted Analyst User assigned ONLY to CSE Alpha
    analyst_user = User(
        id=uuid.uuid4(),
        username=f"analyst_p9_{uuid.uuid4().hex[:6]}",
        email=f"analyst_p9_{uuid.uuid4().hex[:6]}@example.com",
        role="ANALYST",
        is_active=True,
        hashed_password="hash"
    )
    db_session.add(analyst_user)
    db_session.commit()

    user_cse = UserCSE(
        user_id=analyst_user.id,
        cse_id=cse_a.id
    )
    db_session.add(user_cse)
    db_session.commit()

    analyst_token = create_access_token({"sub": str(analyst_user.id), "role": "ANALYST"})
    analyst_headers = {"Authorization": f"Bearer {analyst_token}"}

    return {
        "admin_headers": admin_headers,
        "analyst_headers": analyst_headers,
        "cse_a": cse_a,
        "cse_b": cse_b,
        "cse_g": cse_g,
        "f_an01": f_an01,
        "f_eg03": f_eg03,
        "f_ns01": f_ns01
    }

def test_get_eight_capability_assessment_structure(db_session, phase9_test_data):
    """Verifies that all 8 capability dimensions are returned for a CSE."""
    headers = phase9_test_data["admin_headers"]
    cse_id = phase9_test_data["cse_a"].id

    res = client.get(f"/api/v1/supervisory/cse/{cse_id}/capability-assessment", headers=headers)
    assert res.status_code == 200
    data = res.json()

    assert data["cse_id"] == str(cse_id)
    assert len(data["capabilities"]) == 8

    expected_caps = [
        "Threat Detection",
        "Investigation",
        "Escalation",
        "Incident Response",
        "Security Operations",
        "Governance and Oversight",
        "Operational Discipline",
        "Cyber Resilience"
    ]
    returned_caps = [c["capability"] for c in data["capabilities"]]
    assert returned_caps == expected_caps

def test_direct_vs_indirect_classification_guardrail(db_session, phase9_test_data):
    """
    CRITICAL GUARDRAIL: Verify that indirect signals are NEVER displayed as direct findings.
    - Threat Detection: Direct = NONE, Indirect = AN-01
    - Investigation: Direct = EG-03, EG-04
    - Security Operations: Direct = NONE, Indirect = EG-01, AN-01
    """
    headers = phase9_test_data["admin_headers"]
    cse_id = phase9_test_data["cse_a"].id

    res = client.get(f"/api/v1/supervisory/cse/{cse_id}/capability-assessment", headers=headers)
    assert res.status_code == 200
    data = res.json()

    caps_by_name = {c["capability"]: c for c in data["capabilities"]}

    # Threat Detection check
    td = caps_by_name["Threat Detection"]
    assert len(td["direct_findings"]) == 0, "Threat Detection must have ZERO direct findings when only AN-01 exists"
    assert len(td["indirect_findings"]) == 1, "AN-01 must be presented as an indirect associated signal for Threat Detection"
    assert td["indirect_findings"][0]["canonical_rule_code"] == "AN-01"
    assert td["indirect_findings"][0]["evidence_classification"] == "INDIRECT"

    # Investigation check
    inv = caps_by_name["Investigation"]
    assert len(inv["direct_findings"]) == 1, "EG-03 must be classified as a DIRECT finding for Investigation"
    assert inv["direct_findings"][0]["canonical_rule_code"] == "EG-03"
    assert inv["direct_findings"][0]["evidence_classification"] == "DIRECT"

    # Cyber Resilience check
    cr = caps_by_name["Cyber Resilience"]
    assert len(cr["direct_findings"]) == 1, "NS-01 must be classified as a DIRECT finding for Cyber Resilience"
    assert cr["direct_findings"][0]["canonical_rule_code"] == "NS-01"
    assert cr["direct_findings"][0]["evidence_classification"] == "DIRECT"

def test_capability_status_indicators(db_session, phase9_test_data):
    """
    Verifies capability status indicators:
    - CSE A (with findings): SUPERVISORY_FINDINGS_PRESENT for active capabilities
    - CSE B (with telemetry, 0 findings): NO_FINDINGS_EVALUATED
    - CSE G (0 telemetry, 0 findings): INSUFFICIENT_EVIDENCE
    """
    headers = phase9_test_data["admin_headers"]

    # Test CSE B (Telemetry present, zero findings)
    cse_b_id = phase9_test_data["cse_b"].id
    res_b = client.get(f"/api/v1/supervisory/cse/{cse_b_id}/capability-assessment", headers=headers)
    assert res_b.status_code == 200
    data_b = res_b.json()
    for cap in data_b["capabilities"]:
        assert cap["status_indicator"] == "NO_FINDINGS_EVALUATED"
        assert cap["status_description"] == "Evaluated from available telemetry; zero supervisory findings generated by canonical rules."

    # Test CSE G (Zero telemetry, zero findings)
    cse_g_id = phase9_test_data["cse_g"].id
    res_g = client.get(f"/api/v1/supervisory/cse/{cse_g_id}/capability-assessment", headers=headers)
    assert res_g.status_code == 200
    data_g = res_g.json()
    for cap in data_g["capabilities"]:
        assert cap["status_indicator"] == "INSUFFICIENT_EVIDENCE"
        assert cap["status_description"] == "Insufficient telemetry or evidence available to evaluate canonical rules."

def test_cse_server_side_isolation(db_session, phase9_test_data):
    """Verifies that non-authorized user cannot access another CSE's capability assessment (HTTP 403)."""
    analyst_headers = phase9_test_data["analyst_headers"]
    cse_b_id = phase9_test_data["cse_b"].id

    # Analyst trying to access CSE B (which they are NOT authorized for)
    res = client.get(f"/api/v1/supervisory/cse/{cse_b_id}/capability-assessment", headers=analyst_headers)
    assert res.status_code == 403, "Must return HTTP 403 Forbidden on unauthorized CSE capability access"

def test_single_capability_detail_endpoint(db_session, phase9_test_data):
    """Verifies retrieval of detail for a single capability dimension."""
    headers = phase9_test_data["admin_headers"]
    cse_id = phase9_test_data["cse_a"].id

    res = client.get(f"/api/v1/supervisory/cse/{cse_id}/capability/Investigation/detail", headers=headers)
    assert res.status_code == 200
    data = res.json()
    assert data["capability"] == "Investigation"
    assert len(data["direct_findings"]) == 1

def test_zero_database_mutation(db_session, phase9_test_data):
    """Verifies GET endpoint calls perform zero database mutations."""
    headers = phase9_test_data["admin_headers"]
    cse_id = phase9_test_data["cse_a"].id

    findings_before = db_session.query(Finding).count()

    res = client.get(f"/api/v1/supervisory/cse/{cse_id}/capability-assessment", headers=headers)
    assert res.status_code == 200

    findings_after = db_session.query(Finding).count()
    assert findings_before == findings_after, "Capability Assessment GET call must not mutate DB"

def test_capability_authentication_security(db_session, phase9_test_data):
    """Verifies missing authentication returns 401 and invalid token returns 401."""
    cse_id = phase9_test_data["cse_a"].id

    # 1. Missing Authorization header -> 401
    res_no_auth = client.get(f"/api/v1/supervisory/cse/{cse_id}/capability-assessment")
    assert res_no_auth.status_code == 401

    # 2. Invalid Bearer token -> 401
    res_bad_token = client.get(
        f"/api/v1/supervisory/cse/{cse_id}/capability-assessment",
        headers={"Authorization": "Bearer invalid_token_xyz"}
    )
    assert res_bad_token.status_code == 401
