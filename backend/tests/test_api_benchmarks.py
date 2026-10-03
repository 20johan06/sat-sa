import uuid
import pytest
from datetime import datetime, timezone, timedelta
from fastapi.testclient import TestClient
from app.main import app

from app.models.baseline import PeerBaseline

from app.services.auth_service import AuthService
from app.utils.security import create_access_token

client = TestClient(app)

@pytest.fixture
def auth_headers(db_session):
    admin = AuthService.ensure_initial_admin(db_session)
    token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    return {"Authorization": f"Bearer {token}"}

def test_get_benchmarks_invalid_cse(auth_headers):
    """Verify GET /api/v1/benchmarks/{cse_id} returns 404 for non-existent CSE."""
    random_id = str(uuid.uuid4())
    res = client.get(f"/api/v1/benchmarks/{random_id}", headers=auth_headers)
    assert res.status_code == 404
    assert res.json()["error"]["code"] == "ENTITY_NOT_FOUND"

def test_get_benchmarks_no_baselines(db_session, auth_headers):
    """Verify GET /api/v1/benchmarks/{cse_id} returns NO_APPLICABLE_BASELINE when zero baselines exist."""
    db_session.query(PeerBaseline).delete()
    db_session.commit()

    unique_code = f"CSE_BM_{uuid.uuid4().hex[:8]}"
    cse_res = client.post("/api/v1/cses/", json={
        "cse_code": unique_code,
        "name": "Benchmark Test Entity",
        "sector": "DEFENCE"
    }, headers=auth_headers)
    cse_id = cse_res.json()["id"]

    res = client.get(f"/api/v1/benchmarks/{cse_id}", headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["cse_id"] == cse_id
    assert data["peer_group_status"] == "NO_APPLICABLE_BASELINE"
    assert data["baselines"] == []

def test_get_benchmarks_invalid_dates(auth_headers):
    """Verify GET /api/v1/benchmarks/{cse_id} returns 422 for invalid observation window."""
    unique_code = f"CSE_BMDATE_{uuid.uuid4().hex[:8]}"
    cse_res = client.post("/api/v1/cses/", json={
        "cse_code": unique_code,
        "name": "Benchmark Date Test Entity",
        "sector": "DEFENCE"
    }, headers=auth_headers)
    cse_id = cse_res.json()["id"]

    now = datetime.now(timezone.utc)
    res = client.get(
        f"/api/v1/benchmarks/{cse_id}?obs_start={now.isoformat()}&obs_end={(now - timedelta(days=1)).isoformat()}",
        headers=auth_headers
    )
    assert res.status_code == 422
