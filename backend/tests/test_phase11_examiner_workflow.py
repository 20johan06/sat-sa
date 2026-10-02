import uuid
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.main import app
from app.models.cse import CSE
from app.models.finding import Finding, FindingEvidence, FindingReviewHistory
from app.models.user import User, UserCSE
from app.services.auth_service import AuthService
from app.utils.security import get_password_hash, create_access_token

client = TestClient(app)

@pytest.fixture
def phase11_setup(db_session: Session):
    """Fixture initializing CSE, Admin, Supervisor, Viewer users, and a test Finding."""
    cse = CSE(
        cse_code=f"CSE-P11-{uuid.uuid4().hex[:6]}",
        name="Phase 11 Test CSE",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()
    db_session.refresh(cse)

    # Admin user
    admin_user = User(
        username=f"p11_admin_{uuid.uuid4().hex[:6]}",
        email=f"admin_{uuid.uuid4().hex[:6]}@test.com",
        hashed_password=get_password_hash("AdminPass123!"),
        role="ADMIN",
        is_active=True
    )
    db_session.add(admin_user)

    # Supervisor user with access to CSE
    sup_user = User(
        username=f"p11_sup_{uuid.uuid4().hex[:6]}",
        email=f"sup_{uuid.uuid4().hex[:6]}@test.com",
        hashed_password=get_password_hash("SupPass123!"),
        role="SUPERVISOR",
        is_active=True
    )
    db_session.add(sup_user)

    # Viewer user with access to CSE
    viewer_user = User(
        username=f"p11_viewer_{uuid.uuid4().hex[:6]}",
        email=f"viewer_{uuid.uuid4().hex[:6]}@test.com",
        hashed_password=get_password_hash("ViewerPass123!"),
        role="VIEWER",
        is_active=True
    )
    db_session.add(viewer_user)

    # Unauthorized Supervisor without access to CSE
    unauth_sup = User(
        username=f"p11_unauth_{uuid.uuid4().hex[:6]}",
        email=f"unauth_{uuid.uuid4().hex[:6]}@test.com",
        hashed_password=get_password_hash("UnauthPass123!"),
        role="SUPERVISOR",
        is_active=True
    )
    db_session.add(unauth_sup)
    db_session.commit()

    # Link CSE to sup_user and viewer_user
    db_session.add(UserCSE(user_id=sup_user.id, cse_id=cse.id))
    db_session.add(UserCSE(user_id=viewer_user.id, cse_id=cse.id))
    db_session.commit()

    # Finding
    finding = Finding(
        finding_code=f"FINDING-P11-{uuid.uuid4().hex[:6]}",
        cse_id=cse.id,
        category="EXECUTION_GAP",
        severity="HIGH",
        title="Test Egress Volatility",
        description="Unusual egress burst observed.",
        rationale="Exceeds baseline threshold.",
        detection_method="STATISTICAL_ANOMALY",
        metrics_json={"rule_code": "EG-01", "burst_ratio": 4.5},
        status="NEW"
    )
    db_session.add(finding)
    db_session.commit()
    db_session.refresh(finding)

    # Generate tokens
    admin_token = create_access_token({"sub": str(admin_user.id), "role": "ADMIN"})
    sup_token = create_access_token({"sub": str(sup_user.id), "role": "SUPERVISOR"})
    viewer_token = create_access_token({"sub": str(viewer_user.id), "role": "VIEWER"})
    unauth_token = create_access_token({"sub": str(unauth_sup.id), "role": "SUPERVISOR"})

    return {
        "cse": cse,
        "finding": finding,
        "admin_user": admin_user,
        "sup_user": sup_user,
        "viewer_user": viewer_user,
        "unauth_sup": unauth_sup,
        "admin_headers": {"Authorization": f"Bearer {admin_token}"},
        "sup_headers": {"Authorization": f"Bearer {sup_token}"},
        "viewer_headers": {"Authorization": f"Bearer {viewer_token}"},
        "unauth_headers": {"Authorization": f"Bearer {unauth_token}"}
    }

def test_status_transition_new_to_under_review(phase11_setup: dict):
    finding_id = phase11_setup["finding"].id
    headers = phase11_setup["sup_headers"]

    resp = client.patch(
        f"/api/v1/findings/{finding_id}/status",
        headers=headers,
        json={"status": "UNDER_REVIEW", "notes": "Initiating supervisory review."}
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "UNDER_REVIEW"
    assert len(data["review_history"]) == 1
    assert data["review_history"][0]["previous_status"] == "NEW"
    assert data["review_history"][0]["new_status"] == "UNDER_REVIEW"
    assert data["review_history"][0]["action_type"] == "STATUS_CHANGE"

def test_mandatory_note_validation(phase11_setup: dict):
    finding_id = phase11_setup["finding"].id
    headers = phase11_setup["sup_headers"]

    # Transition to CONFIRMED without note should fail
    resp = client.patch(
        f"/api/v1/findings/{finding_id}/status",
        headers=headers,
        json={"status": "CONFIRMED", "notes": ""}
    )
    assert resp.status_code == 422
    assert "rationale is required" in resp.json()["detail"].lower()

def test_terminal_status_reopening_forbidden(db_session: Session, phase11_setup: dict):
    finding = phase11_setup["finding"]
    finding.status = "CONFIRMED"
    db_session.commit()

    headers = phase11_setup["sup_headers"]
    resp = client.patch(
        f"/api/v1/findings/{finding.id}/status",
        headers=headers,
        json={"status": "UNDER_REVIEW", "notes": "Attempting to reopen confirmed finding."}
    )
    assert resp.status_code == 422
    assert "forbidden" in resp.json()["detail"].lower()

def test_add_examiner_note(phase11_setup: dict):
    finding_id = phase11_setup["finding"].id
    headers = phase11_setup["sup_headers"]

    resp = client.post(
        f"/api/v1/findings/{finding_id}/notes",
        headers=headers,
        json={"note_text": "Examined baseline telemetry; waiting for firewall logs."}
    )
    assert resp.status_code == 201
    note_data = resp.json()
    assert note_data["action_type"] == "EXAMINER_NOTE"
    assert note_data["note_text"] == "Examined baseline telemetry; waiting for firewall logs."

def test_request_more_evidence(db_session: Session, phase11_setup: dict):
    finding = phase11_setup["finding"]
    finding.status = "UNDER_REVIEW"
    db_session.commit()

    headers = phase11_setup["sup_headers"]
    payload = {
        "note_text": "Current syslog sample insufficient to verify anomaly duration.",
        "required_data_types": ["syslog", "auth_log"],
        "requested_time_window": "2026-10-01 to 2026-10-02",
        "description": "Please provide raw netflow PCAP files."
    }

    resp = client.post(
        f"/api/v1/findings/{finding.id}/request-evidence",
        headers=headers,
        json=payload
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "NEEDS_MORE_EVIDENCE"
    assert len(data["review_history"]) == 1
    assert data["review_history"][0]["action_type"] == "EVIDENCE_REQUEST"
    assert data["review_history"][0]["evidence_request_details"]["required_data_types"] == ["syslog", "auth_log"]

def test_viewer_role_mutations_forbidden(phase11_setup: dict):
    finding_id = phase11_setup["finding"].id
    headers = phase11_setup["viewer_headers"]

    # Status update forbidden
    r1 = client.patch(f"/api/v1/findings/{finding_id}/status", headers=headers, json={"status": "UNDER_REVIEW"})
    assert r1.status_code == 403

    # Add note forbidden
    r2 = client.post(f"/api/v1/findings/{finding_id}/notes", headers=headers, json={"note_text": "Viewer note"})
    assert r2.status_code == 403

    # Request evidence forbidden
    r3 = client.post(
        f"/api/v1/findings/{finding_id}/request-evidence",
        headers=headers,
        json={"note_text": "Note", "required_data_types": ["log"]}
    )
    assert r3.status_code == 403

    # History read ALLOWED for viewer
    r4 = client.get(f"/api/v1/findings/{finding_id}/history", headers=headers)
    assert r4.status_code == 200

def test_cse_isolation_enforcement(phase11_setup: dict):
    finding_id = phase11_setup["finding"].id
    unauth_headers = phase11_setup["unauth_headers"]

    # History access unauthorized CSE
    r1 = client.get(f"/api/v1/findings/{finding_id}/history", headers=unauth_headers)
    assert r1.status_code == 403

    # Status update unauthorized CSE
    r2 = client.patch(f"/api/v1/findings/{finding_id}/status", headers=unauth_headers, json={"status": "UNDER_REVIEW"})
    assert r2.status_code == 403

def test_finding_deletion_prevented_when_review_history_exists(db_session: Session, phase11_setup: dict):
    finding = phase11_setup["finding"]
    headers = phase11_setup["sup_headers"]

    # Add a review note to create a FindingReviewHistory record
    resp = client.post(
        f"/api/v1/findings/{finding.id}/notes",
        headers=headers,
        json={"note_text": "Supervisory audit note created to test RESTRICT ondelete."}
    )
    assert resp.status_code == 201

    # Attempting to delete the parent Finding in DB must raise IntegrityError due to ON DELETE RESTRICT
    from sqlalchemy.exc import IntegrityError
    db_session.delete(finding)
    with pytest.raises(IntegrityError):
        db_session.commit()
    db_session.rollback()
