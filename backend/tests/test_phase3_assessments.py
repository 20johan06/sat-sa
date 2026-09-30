import uuid
import pytest
from datetime import datetime, timedelta, timezone
from fastapi.testclient import TestClient
from app.main import app
from app.services.auth_service import AuthService
from app.schemas.auth import UserCreateRequest
from app.models.cse import CSE
from app.utils.security import create_access_token

client = TestClient(app)

@pytest.fixture
def test_cses_p3(db_session):
    cse1 = CSE(
        id=uuid.uuid4(),
        name="Phase 3 CSE Alpha",
        cse_code=f"CSE-P3-A-{uuid.uuid4().hex[:6]}",
        sector="FINANCE"
    )
    cse2 = CSE(
        id=uuid.uuid4(),
        name="Phase 3 CSE Beta",
        cse_code=f"CSE-P3-B-{uuid.uuid4().hex[:6]}",
        sector="ENERGY"
    )
    db_session.add(cse1)
    db_session.add(cse2)
    db_session.commit()
    return cse1, cse2

def test_assessment_creation_and_period_validation(db_session, test_cses_p3):
    cse1, _ = test_cses_p3
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    headers = {"Authorization": f"Bearer {admin_token}"}

    now = datetime.now(timezone.utc)

    # 1. Valid assessment creation
    res = client.post(
        "/api/v1/assessments",
        headers=headers,
        json={
            "cse_id": str(cse1.id),
            "name": "Q3 Supervisory Assessment",
            "description": "Routine SOC supervisory audit",
            "period_start": (now - timedelta(days=30)).isoformat(),
            "period_end": now.isoformat()
        }
    )
    assert res.status_code == 201
    data = res.json()
    assert data["name"] == "Q3 Supervisory Assessment"
    assert data["status"] == "DRAFT"
    assert data["cse_id"] == str(cse1.id)

    # 2. Invalid period (period_start >= period_end) -> HTTP 422
    res_invalid = client.post(
        "/api/v1/assessments",
        headers=headers,
        json={
            "cse_id": str(cse1.id),
            "name": "Invalid Period Assessment",
            "period_start": now.isoformat(),
            "period_end": (now - timedelta(days=1)).isoformat()
        }
    )
    assert res_invalid.status_code == 422

def test_assessment_lifecycle_state_transitions(db_session, test_cses_p3):
    cse1, _ = test_cses_p3
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    headers = {"Authorization": f"Bearer {admin_token}"}

    now = datetime.now(timezone.utc)
    res = client.post(
        "/api/v1/assessments",
        headers=headers,
        json={
            "cse_id": str(cse1.id),
            "name": "Lifecycle Assessment",
            "period_start": (now - timedelta(days=10)).isoformat(),
            "period_end": now.isoformat()
        }
    )
    asmt_id = res.json()["id"]

    # Valid transitions: DRAFT -> DATASET_ATTACHED -> IN_ANALYSIS -> UNDER_REVIEW -> COMPLETED
    t1 = client.patch(f"/api/v1/assessments/{asmt_id}/status", headers=headers, json={"status": "DATASET_ATTACHED"})
    assert t1.status_code == 200 and t1.json()["status"] == "DATASET_ATTACHED"

    t2 = client.patch(f"/api/v1/assessments/{asmt_id}/status", headers=headers, json={"status": "IN_ANALYSIS"})
    assert t2.status_code == 200 and t2.json()["status"] == "IN_ANALYSIS"

    t3 = client.patch(f"/api/v1/assessments/{asmt_id}/status", headers=headers, json={"status": "UNDER_REVIEW"})
    assert t3.status_code == 200 and t3.json()["status"] == "UNDER_REVIEW"

    t4 = client.patch(f"/api/v1/assessments/{asmt_id}/status", headers=headers, json={"status": "COMPLETED"})
    assert t4.status_code == 200 and t4.json()["status"] == "COMPLETED"

    # Invalid transition from COMPLETED -> DRAFT -> HTTP 422
    t_inv = client.patch(f"/api/v1/assessments/{asmt_id}/status", headers=headers, json={"status": "DRAFT"})
    assert t_inv.status_code == 422

def test_dataset_versioning_and_sha256(db_session, test_cses_p3):
    cse1, _ = test_cses_p3
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    headers = {"Authorization": f"Bearer {admin_token}"}

    res = client.post(
        "/api/v1/dataset-versions",
        headers=headers,
        json={
            "cse_id": str(cse1.id),
            "dataset_type": "alerts",
            "source_filename": "telemetry_q3.csv",
            "version_tag": "DSV-TEST-001"
        }
    )
    assert res.status_code == 201
    data = res.json()
    assert data["version_tag"] == "DSV-TEST-001"
    assert data["is_immutable"] is True
    assert len(data["content_hash"]) == 64  # SHA-256 hex digest length

def test_analysis_run_provenance(db_session, test_cses_p3):
    cse1, _ = test_cses_p3
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    headers = {"Authorization": f"Bearer {admin_token}"}

    res = client.post(
        "/api/v1/analysis-runs",
        headers=headers,
        json={
            "cse_id": str(cse1.id)
        }
    )
    assert res.status_code == 201
    data = res.json()
    assert data["engine_version"] == "v2.0.0-phase5-canonical"
    assert "EG-01" in data["rules_evaluated"]
    assert data["status"] == "COMPLETED"

def test_phase3_cse_isolation(db_session, test_cses_p3):
    cse1, cse2 = test_cses_p3
    now = datetime.now(timezone.utc)

    # Create supervisor authorized ONLY for cse1
    supervisor = AuthService.create_user(
        db=db_session,
        req=UserCreateRequest(
            username=f"sup_p3_{uuid.uuid4().hex[:6]}",
            email=f"sup_p3_{uuid.uuid4().hex[:6]}@example.com",
            password="SupervisorPass123!",
            role="SUPERVISOR",
            allowed_cse_ids=[cse1.id]
        )
    )
    sup_token = create_access_token({"sub": str(supervisor.id), "role": "SUPERVISOR"})
    headers = {"Authorization": f"Bearer {sup_token}"}

    # 1. Assessment creation for unauthorized CSE-2 -> 403
    r1 = client.post(
        "/api/v1/assessments",
        headers=headers,
        json={
            "cse_id": str(cse2.id),
            "name": "Illegal Assessment",
            "period_start": (now - timedelta(days=5)).isoformat(),
            "period_end": now.isoformat()
        }
    )
    assert r1.status_code == 403

    # 2. Dataset version creation for unauthorized CSE-2 -> 403
    r2 = client.post(
        "/api/v1/dataset-versions",
        headers=headers,
        json={
            "cse_id": str(cse2.id),
            "dataset_type": "alerts",
            "source_filename": "illegal.csv"
        }
    )
    assert r2.status_code == 403

    # 3. Analysis run creation for unauthorized CSE-2 -> 403
    r3 = client.post(
        "/api/v1/analysis-runs",
        headers=headers,
        json={
            "cse_id": str(cse2.id)
        }
    )
    assert r3.status_code == 403
