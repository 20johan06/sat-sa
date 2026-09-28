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
