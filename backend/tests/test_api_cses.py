import uuid
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_create_cse_success():
    """Verify POST /api/v1/cses/ creates a new CSE in PostgreSQL database."""
    unique_code = f"CSE_API_{uuid.uuid4().hex[:8]}"
    payload = {
        "cse_code": unique_code,
        "name": "API Test Financial Entity",
        "sector": "Banking",
        "criticality_tier": "TIER_1",
        "contact_email": "admin@apitest.org"
    }
    response = client.post("/api/v1/cses/", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert data["cse_code"] == unique_code
    assert data["name"] == "API Test Financial Entity"
    assert "id" in data
    assert "created_at" in data

def test_create_cse_duplicate_rejection():
    """Verify POST /api/v1/cses/ rejects duplicate cse_code with 409 Conflict."""
    unique_code = f"CSE_DUP_{uuid.uuid4().hex[:8]}"
    payload = {
        "cse_code": unique_code,
        "name": "Original Entity",
        "sector": "Energy"
    }
    res1 = client.post("/api/v1/cses/", json=payload)
    assert res1.status_code == 201

    # Attempt duplicate creation
    res2 = client.post("/api/v1/cses/", json=payload)
    assert res2.status_code == 409
    data = res2.json()
    assert "error" in data
    assert data["error"]["code"] == "DUPLICATE_ENTITY"

def test_list_cses():
    """Verify GET /api/v1/cses/ returns a list of CSEs."""
    response = client.get("/api/v1/cses/")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)

def test_get_cse_by_id_success():
    """Verify GET /api/v1/cses/{cse_id} retrieves entity details."""
    unique_code = f"CSE_GET_{uuid.uuid4().hex[:8]}"
    payload = {
        "cse_code": unique_code,
        "name": "Target Retrieval Entity",
        "sector": "Defense"
    }
    create_res = client.post("/api/v1/cses/", json=payload)
    assert create_res.status_code == 201
    created_id = create_res.json()["id"]

    get_res = client.get(f"/api/v1/cses/{created_id}")
    assert get_res.status_code == 200
    data = get_res.json()
    assert data["id"] == created_id
    assert data["cse_code"] == unique_code

def test_get_cse_not_found():
    """Verify GET /api/v1/cses/{cse_id} returns 404 for non-existent UUID."""
    random_id = str(uuid.uuid4())
    response = client.get(f"/api/v1/cses/{random_id}")
    assert response.status_code == 404
    data = response.json()
    assert "error" in data
    assert data["error"]["code"] == "ENTITY_NOT_FOUND"

def test_create_cse_validation_failure():
    """Verify POST /api/v1/cses/ returns 422 for invalid payloads."""
    invalid_payload = {
        "cse_code": "X", # Too short (min 2 chars)
        "name": "Invalid Entity"
    }
    response = client.post("/api/v1/cses/", json=invalid_payload)
    assert response.status_code == 422
