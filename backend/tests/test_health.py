from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_root_endpoint():
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["project"] == "SAT-SA"
    assert "version" in data

def test_health_endpoint():
    response = client.get("/health")
    assert response.status_code in [200, 503]
    data = response.json()
    assert "status" in data
    assert "app" in data
    assert "database" in data
    assert data["app"] == "healthy"
