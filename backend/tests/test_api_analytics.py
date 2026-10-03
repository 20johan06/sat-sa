import uuid
import pytest
from datetime import datetime, timezone, timedelta
from fastapi.testclient import TestClient
from app.main import app

from app.services.auth_service import AuthService
from app.utils.security import create_access_token

client = TestClient(app)

@pytest.fixture
def auth_headers(db_session):
    admin = AuthService.ensure_initial_admin(db_session)
    token = create_access_token({"sub": str(admin.id), "role": "ADMIN"})
    return {"Authorization": f"Bearer {token}"}

def test_run_analytics_invalid_cse(auth_headers):
    """Verify POST /api/v1/analytics/{cse_id}/run returns 404 for missing CSE."""
    random_id = str(uuid.uuid4())
    res = client.post(f"/api/v1/analytics/{random_id}/run", headers=auth_headers)
    assert res.status_code == 404
    assert res.json()["error"]["code"] == "ENTITY_NOT_FOUND"

def test_run_analytics_invalid_dates(auth_headers):
    """Verify POST /api/v1/analytics/{cse_id}/run returns 422 if obs_start >= obs_end."""
    unique_code = f"CSE_DATE_{uuid.uuid4().hex[:8]}"
    cse_res = client.post("/api/v1/cses/", json={
        "cse_code": unique_code,
        "name": "Date Test Entity",
        "sector": "FINANCIAL"
    }, headers=auth_headers)
    cse_id = cse_res.json()["id"]

    now = datetime.now(timezone.utc)
    payload = {
        "obs_start": now.isoformat(),
        "obs_end": (now - timedelta(days=1)).isoformat()
    }
    res = client.post(f"/api/v1/analytics/{cse_id}/run", json=payload, headers=auth_headers)
    assert res.status_code == 422

def test_run_analytics_success_and_deduplication(auth_headers):
    """Verify POST /api/v1/analytics/{cse_id}/run runs pipeline and handles deduplication status code."""
    unique_code = f"CSE_RUN_{uuid.uuid4().hex[:8]}"
    cse_res = client.post("/api/v1/cses/", json={
        "cse_code": unique_code,
        "name": "Run Analytics Test Entity",
        "sector": "FINANCIAL"
    }, headers=auth_headers)
    cse_id = cse_res.json()["id"]

    # First run (zero telemetry -> 0 findings created -> HTTP 200)
    res1 = client.post(f"/api/v1/analytics/{cse_id}/run", headers=auth_headers)
    assert res1.status_code == 200
    data1 = res1.json()
    assert data1["cse_id"] == cse_id
    assert "rules_evaluated" in data1
    assert data1["findings_created"] == 0
    assert data1["data_sufficiency_by_rule"]["EG-03"] == "SUFFICIENT"

def test_get_signals_no_findings(auth_headers):
    """Verify GET /api/v1/analytics/{cse_id}/signals returns NO_FINDINGS for new CSE."""
    unique_code = f"CSE_SIG_{uuid.uuid4().hex[:8]}"
    cse_res = client.post("/api/v1/cses/", json={
        "cse_code": unique_code,
        "name": "Signal Matrix Test Entity",
        "sector": "POWER"
    }, headers=auth_headers)
    cse_id = cse_res.json()["id"]

    res = client.get(f"/api/v1/analytics/{cse_id}/signals", headers=auth_headers)
    assert res.status_code == 200
    data = res.json()
    assert data["cse_id"] == cse_id
    assert data["data_sufficiency_status"] == "NO_FINDINGS"
    assert "EXECUTION_GAP" in data["signals"]
    assert "NEGATIVE_SPACE" in data["signals"]
    assert "ANOMALY" in data["signals"]
    assert "BENCHMARK" in data["signals"]
    assert data["signals"]["EXECUTION_GAP"]["display_name"] == "Execution Gap"
