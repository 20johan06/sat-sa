import uuid
import datetime
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from app.main import app
from app.models.cse import CSE
from app.models.user import User
from app.models.dataset_version import DatasetVersion
from app.utils.security import create_access_token

@pytest.fixture
def client() -> TestClient:
    return TestClient(app)

@pytest.fixture
def test_cse_phase4(db_session: Session) -> CSE:
    cse = CSE(
        id=uuid.uuid4(),
        cse_code=f"CSE-P4-{uuid.uuid4().hex[:6]}",
        name="Phase 4 Test Entity",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()
    db_session.refresh(cse)
    return cse

@pytest.fixture
def supervisor_user(db_session: Session, test_cse_phase4: CSE) -> User:
    user = User(
        id=uuid.uuid4(),
        email=f"sup_p4_{uuid.uuid4().hex[:6]}@example.com",
        username=f"supervisor_p4_{uuid.uuid4().hex[:6]}",
        hashed_password="hash",
        role="SUPERVISOR",
        is_active=True
    )
    db_session.add(user)
    db_session.commit()
    
    from app.models.user import UserCSE
    uc = UserCSE(user_id=user.id, cse_id=test_cse_phase4.id)
    db_session.add(uc)
    db_session.commit()
    return user

@pytest.fixture
def viewer_user(db_session: Session, test_cse_phase4: CSE) -> User:
    user = User(
        id=uuid.uuid4(),
        email=f"view_p4_{uuid.uuid4().hex[:6]}@example.com",
        username=f"viewer_p4_{uuid.uuid4().hex[:6]}",
        hashed_password="hash",
        role="VIEWER",
        is_active=True
    )
    db_session.add(user)
    db_session.commit()
    
    from app.models.user import UserCSE
    uc = UserCSE(user_id=user.id, cse_id=test_cse_phase4.id)
    db_session.add(uc)
    db_session.commit()
    return user

def test_phase4_valid_csv_ingestion(client: TestClient, test_cse_phase4: CSE, supervisor_user: User, db_session: Session):
    token = create_access_token({"sub": str(supervisor_user.id)})
    headers = {"Authorization": f"Bearer {token}"}
    
    csv_content = (
        "external_alert_id,title,category,severity,status,detected_at\n"
        "ALT-P4-001,Suspicious Exfiltration,NETWORK,HIGH,OPEN,2026-09-28T10:00:00Z\n"
        "ALT-P4-002,Credential Spray,IDENTITY,CRITICAL,OPEN,2026-09-28T11:00:00Z\n"
    )
    
    files = {"file": ("alerts.csv", csv_content, "text/csv")}
    data = {"cse_id": str(test_cse_phase4.id), "dataset_type": "alerts"}
    
    response = client.post("/api/v1/ingestion/upload", data=data, files=files, headers=headers)
    assert response.status_code == 201
    res = response.json()
    assert res["total_records"] == 2
    assert res["valid_records"] == 2
    assert res["rejected_records"] == 0
    assert res["status"] == "COMPLETED"
    assert "quality_report" in res
    assert res["quality_report"]["duplicate_records_count"] == 0
    
    # Verify created DatasetVersion
    dv = db_session.query(DatasetVersion).filter(DatasetVersion.batch_id == uuid.UUID(res["id"])).first()
    assert dv is not None
    assert dv.record_count == 2
    assert len(dv.content_hash) == 64

def test_phase4_invalid_severity_and_impossible_timestamp_rejection(client: TestClient, test_cse_phase4: CSE, supervisor_user: User):
    token = create_access_token({"sub": str(supervisor_user.id)})
    headers = {"Authorization": f"Bearer {token}"}
    
    # 1 invalid severity (SUPER_HIGH), 1 future timestamp (2099)
    payload = {
        "cse_id": str(test_cse_phase4.id),
        "dataset_type": "alerts",
        "records": [
            {
                "external_alert_id": "ALT-INV-001",
                "title": "Bad Severity Alert",
                "category": "NETWORK",
                "severity": "INVALID_SEVERITY_NAME",
                "status": "OPEN",
                "detected_at": "2026-09-28T10:00:00Z"
            },
            {
                "external_alert_id": "ALT-INV-002",
                "title": "Future Alert",
                "category": "NETWORK",
                "severity": "HIGH",
                "status": "OPEN",
                "detected_at": "2099-01-01T10:00:00Z"
            }
        ]
    }
    
    response = client.post("/api/v1/ingestion/json", json=payload, headers=headers)
    assert response.status_code == 422
    err = response.json()
    assert err["error"]["code"] == "DATA_QUALITY_REJECTION"

def test_phase4_duplicate_external_id_detection(client: TestClient, test_cse_phase4: CSE, supervisor_user: User):
    token = create_access_token({"sub": str(supervisor_user.id)})
    headers = {"Authorization": f"Bearer {token}"}
    
    # Duplicate ID in same payload
    payload = {
        "cse_id": str(test_cse_phase4.id),
        "dataset_type": "alerts",
        "records": [
            {
                "external_alert_id": "ALT-DUP-001",
                "title": "First Alert",
                "category": "NETWORK",
                "severity": "HIGH",
                "status": "OPEN",
                "detected_at": "2026-09-28T10:00:00Z"
            },
            {
                "external_alert_id": "ALT-DUP-001",
                "title": "Duplicate Alert",
                "category": "NETWORK",
                "severity": "HIGH",
                "status": "OPEN",
                "detected_at": "2026-09-28T11:00:00Z"
            }
        ]
    }
    
    response = client.post("/api/v1/ingestion/json", json=payload, headers=headers)
    assert response.status_code == 422

def test_phase4_broken_reference_detection(client: TestClient, test_cse_phase4: CSE, supervisor_user: User):
    token = create_access_token({"sub": str(supervisor_user.id)})
    headers = {"Authorization": f"Bearer {token}"}
    
    fake_case_id = str(uuid.uuid4())
    payload = {
        "cse_id": str(test_cse_phase4.id),
        "dataset_type": "investigations",
        "records": [
            {
                "case_id": fake_case_id,
                "action_type": "FORENSIC_ACQUISITION",
                "started_at": "2026-09-28T10:00:00Z"
            }
        ]
    }
    
    response = client.post("/api/v1/ingestion/json", json=payload, headers=headers)
    assert response.status_code == 422

def test_phase4_viewer_role_mutation_forbidden(client: TestClient, test_cse_phase4: CSE, viewer_user: User):
    token = create_access_token({"sub": str(viewer_user.id)})
    headers = {"Authorization": f"Bearer {token}"}
    
    payload = {
        "cse_id": str(test_cse_phase4.id),
        "dataset_type": "alerts",
        "records": [
            {
                "external_alert_id": "ALT-VIEW-001",
                "title": "Viewer Alert Attempt",
                "category": "NETWORK",
                "severity": "HIGH",
                "status": "OPEN",
                "detected_at": "2026-09-28T10:00:00Z"
            }
        ]
    }
    
    response = client.post("/api/v1/ingestion/json", json=payload, headers=headers)
    assert response.status_code == 403
