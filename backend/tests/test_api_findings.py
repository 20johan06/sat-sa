import uuid
import pytest
from datetime import datetime, timezone, timedelta
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_list_findings_empty():
    """Verify GET /api/v1/findings/ returns valid paginated structure even when empty."""
    res = client.get("/api/v1/findings/")
    assert res.status_code == 200
    data = res.json()
    assert "items" in data
    assert "pagination" in data
    assert "observation_period" in data
    assert isinstance(data["items"], list)

def test_list_findings_deprecated_category_rejection():
    """Verify GET /api/v1/findings/ rejects deprecated category values with 422."""
    res1 = client.get("/api/v1/findings/?category=EVIDENCE_GAP")
    assert res1.status_code == 422

    res2 = client.get("/api/v1/findings/?category=NON_STANDARD")
    assert res2.status_code == 422

def test_list_findings_invalid_category():
    """Verify GET /api/v1/findings/ rejects invalid categories with 422."""
    res = client.get("/api/v1/findings/?category=UNKNOWN_CAT")
    assert res.status_code == 422

def test_list_findings_invalid_dates():
    """Verify GET /api/v1/findings/ returns 422 if obs_start >= obs_end."""
    now = datetime.now(timezone.utc)
    res = client.get(
        f"/api/v1/findings/?obs_start={now.isoformat()}&obs_end={(now - timedelta(days=1)).isoformat()}"
    )
    assert res.status_code == 422

def test_get_finding_detail_not_found():
    """Verify GET /api/v1/findings/{finding_id} returns 404 for non-existent finding."""
    random_id = str(uuid.uuid4())
    res = client.get(f"/api/v1/findings/{random_id}")
    assert res.status_code == 404
    assert res.json()["error"]["code"] == "ENTITY_NOT_FOUND"

def test_update_finding_status_workflow(db_session):
    """
    Verify PATCH /api/v1/findings/{finding_id}/status accepts only the 6 authoritative V2 statuses:
    NEW, UNDER_REVIEW, CONFIRMED, NOT_SUBSTANTIATED, DISMISSED, NEEDS_MORE_EVIDENCE,
    and explicitly rejects legacy/unauthorized statuses (RESOLVED, CLOSED, ACKNOWLEDGED).
    """
    from app.models.cse import CSE
    from app.models.finding import Finding
    from app.services.auth_service import AuthService
    from app.utils.security import create_access_token

    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    headers = {"Authorization": f"Bearer {admin_token}"}

    cse_obj = CSE(
        id=uuid.uuid4(),
        name="Finding Status Test CSE",
        cse_code=f"CSE-STAT-{uuid.uuid4().hex[:6]}",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    db_session.add(cse_obj)
    db_session.commit()

    finding = Finding(
        id=uuid.uuid4(),
        finding_code=f"FIND-STAT-{uuid.uuid4().hex[:6]}",
        cse_id=cse_obj.id,
        category="EXECUTION_GAP",
        severity="HIGH",
        title="Test Status Workflow Finding",
        description="Test description",
        rationale="Test rationale",
        detection_method="Test method",
        status="NEW"
    )
    db_session.add(finding)
    db_session.commit()

    # 1. Authoritative V2 statuses MUST be accepted (200 OK)
    authoritative_statuses = [
        "NEW",
        "UNDER_REVIEW",
        "CONFIRMED",
        "NOT_SUBSTANTIATED",
        "DISMISSED",
        "NEEDS_MORE_EVIDENCE"
    ]
    for st in authoritative_statuses:
        res = client.patch(
            f"/api/v1/findings/{finding.id}/status",
            json={"status": st, "notes": f"Testing transition to {st}"},
            headers=headers
        )
        assert res.status_code == 200, f"Expected 200 for status {st}, got {res.status_code}"
        assert res.json()["status"] == st

    # 2. Legacy / unapproved statuses MUST be rejected (422 Unprocessable Entity)
    legacy_statuses = ["RESOLVED", "CLOSED", "ACKNOWLEDGED", "FIXED", "INVALID_STATUS"]
    for legacy_st in legacy_statuses:
        res = client.patch(
            f"/api/v1/findings/{finding.id}/status",
            json={"status": legacy_st, "notes": "Testing legacy status rejection"},
            headers=headers
        )
        assert res.status_code == 422, f"Expected 422 rejection for legacy status {legacy_st}, got {res.status_code}"

def test_update_finding_status_cse_isolation(db_session):
    """Verify object-level CSE isolation on PATCH /api/v1/findings/{finding_id}/status."""
    from app.models.cse import CSE
    from app.models.finding import Finding
    from app.models.user import User, UserCSE
    from app.services.auth_service import AuthService
    from app.utils.security import create_access_token

    admin = AuthService.ensure_initial_admin(db_session)

    cse_a = CSE(id=uuid.uuid4(), name="CSE Alpha", cse_code=f"CSE-A-{uuid.uuid4().hex[:6]}", sector="BANKING", criticality_tier="TIER_1")
    cse_b = CSE(id=uuid.uuid4(), name="CSE Beta", cse_code=f"CSE-B-{uuid.uuid4().hex[:6]}", sector="ENERGY", criticality_tier="TIER_1")
    db_session.add_all([cse_a, cse_b])
    db_session.commit()

    # Create CSE-scoped user restricted to CSE A
    uname = f"user_a_{uuid.uuid4().hex[:6]}"
    cse_user = User(id=uuid.uuid4(), username=uname, email=f"{uname}@example.com", hashed_password="pw", role="ANALYST", is_active=True)
    db_session.add(cse_user)
    db_session.commit()
    db_session.add(UserCSE(user_id=cse_user.id, cse_id=cse_a.id))
    db_session.commit()

    user_token = create_access_token({"sub": str(cse_user.id), "role": "ANALYST"})
    user_headers = {"Authorization": f"Bearer {user_token}"}

    # Finding belonging to CSE B
    finding_b = Finding(
        id=uuid.uuid4(),
        finding_code=f"FIND-B-{uuid.uuid4().hex[:6]}",
        cse_id=cse_b.id,
        category="ANOMALY",
        severity="MEDIUM",
        title="CSE B Finding",
        description="Test",
        rationale="Test",
        detection_method="Test",
        status="NEW"
    )
    db_session.add(finding_b)
    db_session.commit()

    # User restricted to CSE A attempts to mutate CSE B's finding -> HTTP 403 Forbidden
    res = client.patch(
        f"/api/v1/findings/{finding_b.id}/status",
        json={"status": "UNDER_REVIEW", "notes": "Unauthorized attempt"},
        headers=user_headers
    )
    assert res.status_code == 403

