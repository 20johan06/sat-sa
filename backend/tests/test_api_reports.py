import uuid
import pytest
from datetime import datetime, timezone, timedelta
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_generate_report_invalid_cse():
    """Verify GET /api/v1/reports/cse/{cse_id} returns 404 for missing CSE."""
    random_id = str(uuid.uuid4())
    res = client.get(f"/api/v1/reports/cse/{random_id}")
    assert res.status_code == 404
    assert res.json()["error"]["code"] == "ENTITY_NOT_FOUND"

def test_generate_report_invalid_format():
    """Verify GET /api/v1/reports/cse/{cse_id} returns 422 for unsupported format."""
    unique_code = f"CSE_RPTFMT_{uuid.uuid4().hex[:8]}"
    cse_res = client.post("/api/v1/cses/", json={
        "cse_code": unique_code,
        "name": "Report Format Test Entity",
        "sector": "TELECOM"
    })
    cse_id = cse_res.json()["id"]

    res = client.get(f"/api/v1/reports/cse/{cse_id}?format=xml")
    assert res.status_code == 422

def test_generate_report_json():
    """Verify GET /api/v1/reports/cse/{cse_id} returns structured JSON report."""
    unique_code = f"CSE_RPTJSON_{uuid.uuid4().hex[:8]}"
    cse_res = client.post("/api/v1/cses/", json={
        "cse_code": unique_code,
        "name": "Report JSON Test Entity",
        "sector": "FINANCIAL"
    })
    cse_id = cse_res.json()["id"]

    res = client.get(f"/api/v1/reports/cse/{cse_id}?format=json")
    assert res.status_code == 200
    data = res.json()
    assert "report_metadata" in data
    assert "cse_profile" in data
    assert "telemetry_summary" in data
    assert "supervisory_signals_summary" in data
    assert data["cse_profile"]["code"] == unique_code

def test_generate_report_markdown():
    """Verify GET /api/v1/reports/cse/{cse_id}?format=markdown returns markdown document."""
    unique_code = f"CSE_RPTMD_{uuid.uuid4().hex[:8]}"
    cse_res = client.post("/api/v1/cses/", json={
        "cse_code": unique_code,
        "name": "Report Markdown Test Entity",
        "sector": "HEALTHCARE"
    })
    cse_id = cse_res.json()["id"]

    res = client.get(f"/api/v1/reports/cse/{cse_id}?format=markdown")
    assert res.status_code == 200
    assert "text/markdown" in res.headers["content-type"]
    assert "# SAT-SA Supervisory Executive Report" in res.text
