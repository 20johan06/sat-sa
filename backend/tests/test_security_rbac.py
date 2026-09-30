import uuid
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.config.settings import settings
from app.services.auth_service import AuthService
from app.schemas.auth import UserCreateRequest
from app.models.cse import CSE
from app.utils.security import create_access_token

client = TestClient(app)

@pytest.fixture
def test_cses(db_session):
    cse1 = CSE(
        id=uuid.uuid4(),
        name="Allowed CSE One",
        cse_code=f"CSE-ISOLATE-1-{uuid.uuid4().hex[:6]}",
        sector="FINANCE"
    )
    cse2 = CSE(
        id=uuid.uuid4(),
        name="Forbidden CSE Two",
        cse_code=f"CSE-ISOLATE-2-{uuid.uuid4().hex[:6]}",
        sector="ENERGY"
    )
    db_session.add(cse1)
    db_session.add(cse2)
    db_session.commit()
    return cse1, cse2

def test_admin_create_user(db_session, test_cses):
    """Verify ADMIN can create new users with specific CSE access assignments."""
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    cse1, _ = test_cses

    new_username = f"supervisor_{uuid.uuid4().hex[:6]}"
    res = client.post(
        "/api/v1/users",
        headers={"Authorization": f"Bearer {admin_token}"},
        json={
            "username": new_username,
            "email": f"{new_username}@example.com",
            "password": "SupervisorPass123!",
            "role": "SUPERVISOR",
            "allowed_cse_ids": [str(cse1.id)]
        }
    )
    assert res.status_code == 201
    data = res.json()
    assert data["username"] == new_username
    assert data["role"] == "SUPERVISOR"
    assert str(cse1.id) in data["allowed_cse_ids"]

def test_non_admin_user_management_forbidden(db_session):
    """Verify VIEWER or SUPERVISOR cannot create users (HTTP 403 Forbidden)."""
    viewer = AuthService.create_user(
        db=db_session,
        req=UserCreateRequest(
            username=f"viewer_{uuid.uuid4().hex[:6]}",
            email=f"viewer_{uuid.uuid4().hex[:6]}@example.com",
            password="ViewerPass123!",
            role="VIEWER"
        )
    )
    viewer_token = create_access_token({"sub": str(viewer.id), "role": "VIEWER"})

    res = client.post(
        "/api/v1/users",
        headers={"Authorization": f"Bearer {viewer_token}"},
        json={
            "username": "illegal_admin",
            "email": "illegal@example.com",
            "password": "IllegalPass123!",
            "role": "ADMIN"
        }
    )
    assert res.status_code == 403
    assert res.json()["error"]["code"] == "FORBIDDEN_ROLE"

def test_cse_data_isolation_enforcement(db_session, test_cses):
    """Verify server-side CSE isolation restricts SUPERVISOR/VIEWER from accessing unauthorized CSE data."""
    cse1, cse2 = test_cses
    
    # Create supervisor authorized ONLY for cse1
    supervisor = AuthService.create_user(
        db=db_session,
        req=UserCreateRequest(
            username=f"sup_iso_{uuid.uuid4().hex[:6]}",
            email=f"sup_iso_{uuid.uuid4().hex[:6]}@example.com",
            password="SupervisorPass123!",
            role="SUPERVISOR",
            allowed_cse_ids=[cse1.id]
        )
    )
    sup_token = create_access_token({"sub": str(supervisor.id), "role": "SUPERVISOR"})

    # 1. Access to authorized cse1 -> Success (HTTP 200)
    res_allowed = client.get(
        f"/api/v1/cses/{cse1.id}",
        headers={"Authorization": f"Bearer {sup_token}"}
    )
    assert res_allowed.status_code == 200
    assert res_allowed.json()["id"] == str(cse1.id)

    # 2. Access to unauthorized cse2 -> Forbidden (HTTP 403)
    res_forbidden = client.get(
        f"/api/v1/cses/{cse2.id}",
        headers={"Authorization": f"Bearer {sup_token}"}
    )
    assert res_forbidden.status_code == 403
    assert res_forbidden.json()["error"]["code"] == "UNAUTHORIZED_CSE_ACCESS"

def test_all_cse_scoped_endpoints_isolation(db_session, test_cses):
    """Verify server-side CSE data isolation across ALL CSE-scoped endpoints."""
    from app.models.finding import Finding
    from app.models.ingestion import IngestionBatch

    cse1, cse2 = test_cses

    # Create test finding and batch for CSE 1 and CSE 2
    f1 = Finding(id=uuid.uuid4(), finding_code=f"FND1-{uuid.uuid4().hex[:6]}", cse_id=cse1.id, category="EXECUTION_GAP", severity="HIGH", title="F1", description="D1", rationale="R1", detection_method="EG-01", status="NEW")
    f2 = Finding(id=uuid.uuid4(), finding_code=f"FND2-{uuid.uuid4().hex[:6]}", cse_id=cse2.id, category="EXECUTION_GAP", severity="HIGH", title="F2", description="D2", rationale="R2", detection_method="EG-01", status="NEW")
    b1 = IngestionBatch(id=uuid.uuid4(), cse_id=cse1.id, batch_reference=f"BAT1-{uuid.uuid4().hex[:6]}", source_type="CSV", source_filename="1.csv", total_records=5, valid_records=5, rejected_records=0, status="COMPLETED")
    b2 = IngestionBatch(id=uuid.uuid4(), cse_id=cse2.id, batch_reference=f"BAT2-{uuid.uuid4().hex[:6]}", source_type="CSV", source_filename="2.csv", total_records=5, valid_records=5, rejected_records=0, status="COMPLETED")
    
    db_session.add(f1)
    db_session.add(f2)
    db_session.add(b1)
    db_session.add(b2)
    db_session.commit()

    supervisor = AuthService.create_user(
        db=db_session,
        req=UserCreateRequest(
            username=f"sup_all_{uuid.uuid4().hex[:6]}",
            email=f"sup_all_{uuid.uuid4().hex[:6]}@example.com",
            password="SupervisorPass123!",
            role="SUPERVISOR",
            allowed_cse_ids=[cse1.id]
        )
    )
    sup_token = create_access_token({"sub": str(supervisor.id), "role": "SUPERVISOR"})
    headers = {"Authorization": f"Bearer {sup_token}"}

    # 1. CSE Summary
    assert client.get(f"/api/v1/cses/{cse1.id}/summary", headers=headers).status_code == 200
    assert client.get(f"/api/v1/cses/{cse2.id}/summary", headers=headers).status_code == 403

    # 2. Analytics Run
    assert client.post(f"/api/v1/analytics/{cse1.id}/run", headers=headers, json={}).status_code == 200
    assert client.post(f"/api/v1/analytics/{cse2.id}/run", headers=headers, json={}).status_code == 403

    # 3. Analytics Signals
    assert client.get(f"/api/v1/analytics/{cse1.id}/signals", headers=headers).status_code == 200
    assert client.get(f"/api/v1/analytics/{cse2.id}/signals", headers=headers).status_code == 403

    # 4. Findings List
    assert client.get(f"/api/v1/findings?cse_id={cse1.id}", headers=headers).status_code == 200
    assert client.get(f"/api/v1/findings?cse_id={cse2.id}", headers=headers).status_code == 403

    # 5. Finding Detail (Object Level)
    assert client.get(f"/api/v1/findings/{f1.id}", headers=headers).status_code == 200
    assert client.get(f"/api/v1/findings/{f2.id}", headers=headers).status_code == 403

    # 6. Benchmarks
    assert client.get(f"/api/v1/benchmarks/{cse1.id}", headers=headers).status_code == 200
    assert client.get(f"/api/v1/benchmarks/{cse2.id}", headers=headers).status_code == 403

    # 7. Reports
    assert client.get(f"/api/v1/reports/cse/{cse1.id}", headers=headers).status_code == 200
    assert client.get(f"/api/v1/reports/cse/{cse2.id}", headers=headers).status_code == 403

    # 8. Ingestion JSON
    assert client.post("/api/v1/ingestion/json", headers=headers, json={"cse_id": str(cse1.id), "dataset_type": "alerts", "records": []}).status_code == 400
    assert client.post("/api/v1/ingestion/json", headers=headers, json={"cse_id": str(cse2.id), "dataset_type": "alerts", "records": []}).status_code == 403

    # 9. Ingestion Batches List
    assert client.get(f"/api/v1/ingestion/batches?cse_id={cse1.id}", headers=headers).status_code == 200
    assert client.get(f"/api/v1/ingestion/batches?cse_id={cse2.id}", headers=headers).status_code == 403

    # 10. Ingestion Batch Detail (Object Level)
    assert client.get(f"/api/v1/ingestion/batches/{b1.id}", headers=headers).status_code == 200
    assert client.get(f"/api/v1/ingestion/batches/{b2.id}", headers=headers).status_code == 403

def test_audit_logs_retrieval(db_session):
    """Verify ADMIN can retrieve security audit logs."""
    admin = AuthService.ensure_initial_admin(db_session)
    admin_token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})

    res = client.get(
        "/api/v1/audit/logs",
        headers={"Authorization": f"Bearer {admin_token}"}
    )
    assert res.status_code == 200
    logs = res.json()
    assert isinstance(logs, list)
    assert len(logs) > 0
