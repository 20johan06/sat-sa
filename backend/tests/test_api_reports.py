import uuid
import pytest
from datetime import datetime, timezone
from fastapi.testclient import TestClient

from app.main import app
from app.models.cse import CSE
from app.models.user import User, UserCSE
from app.utils.security import get_password_hash, create_access_token

client = TestClient(app)

def create_api_test_cse(db_session, suffix: str = "API") -> CSE:
    cse = CSE(
        cse_code=f"CSE-API-{suffix}-{uuid.uuid4().hex[:6].upper()}",
        name=f"Report API Test CSE {suffix}",
        sector="TELECOM",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()
    db_session.refresh(cse)
    return cse

def create_api_test_user(db_session, role: str, cse: CSE) -> User:
    u = User(
        username=f"api_user_{role.lower()}_{uuid.uuid4().hex[:6]}",
        email=f"api_test_{uuid.uuid4().hex[:6]}@example.com",
        hashed_password=get_password_hash("password123"),
        role=role,
        is_active=True
    )
    db_session.add(u)
    db_session.commit()
    db_session.refresh(u)
    db_session.add(UserCSE(user_id=u.id, cse_id=cse.id))
    db_session.commit()
    return u

def get_auth_headers(user: User) -> dict:
    token = create_access_token({"sub": str(user.id), "role": user.role})
    return {"Authorization": f"Bearer {token}"}

def test_generate_report_invalid_cse(db_session):
    """Verify POST /api/v1/reports/generate returns 403 for unauthorized CSE access."""
    cse_a = create_api_test_cse(db_session, "INVA")
    cse_b = create_api_test_cse(db_session, "INVB")
    user = create_api_test_user(db_session, "SUPERVISOR", cse_a)
    headers = get_auth_headers(user)

    res = client.post("/api/v1/reports/generate", json={"cse_id": str(cse_b.id)}, headers=headers)
    assert res.status_code == 403


def test_list_cse_reports(db_session):
    """Verify GET /api/v1/reports/cse/{cse_id} returns paginated report items."""
    cse = create_api_test_cse(db_session, "LIST")
    supervisor = create_api_test_user(db_session, "SUPERVISOR", cse)
    headers = get_auth_headers(supervisor)

    # Generate a report first
    gen_res = client.post("/api/v1/reports/generate", json={"cse_id": str(cse.id)}, headers=headers)
    assert gen_res.status_code == 200

    # List reports
    list_res = client.get(f"/api/v1/reports/cse/{cse.id}", headers=headers)
    assert list_res.status_code == 200
    data = list_res.json()
    assert "items" in data
    assert data["total"] >= 1
    assert data["items"][0]["cse_id"] == str(cse.id)

def test_generate_and_export_report(db_session):
    """Verify PDF, CSV, and JSON exports for a generated report."""
    cse = create_api_test_cse(db_session, "EXP")
    supervisor = create_api_test_user(db_session, "SUPERVISOR", cse)
    headers = get_auth_headers(supervisor)

    gen_res = client.post("/api/v1/reports/generate", json={"cse_id": str(cse.id)}, headers=headers)
    assert gen_res.status_code == 200
    rep_code = gen_res.json()["report_metadata"]["report_code"]

    list_res = client.get(f"/api/v1/reports/cse/{cse.id}", headers=headers)
    report_id = list_res.json()["items"][0]["id"]

    # PDF Export
    pdf_res = client.get(f"/api/v1/reports/{report_id}/export/pdf", headers=headers)
    assert pdf_res.status_code == 200
    assert pdf_res.headers["content-type"] == "application/pdf"
    assert pdf_res.content.startswith(b"%PDF-")

    # CSV Export
    csv_res = client.get(f"/api/v1/reports/{report_id}/export/csv", headers=headers)
    assert csv_res.status_code == 200
    assert csv_res.headers["content-type"].startswith("text/csv")
    assert "report_id" in csv_res.text

    # JSON Export
    json_res = client.get(f"/api/v1/reports/{report_id}/export/json", headers=headers)
    assert json_res.status_code == 200
    assert json_res.headers["content-type"].startswith("application/json")
    assert "report_metadata" in json_res.json()
