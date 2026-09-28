import uuid
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.models.cse import CSE
from app.models.alert import Alert
from app.models.case import Case
from app.models.ingestion import IngestionBatch

client = TestClient(app)

@pytest.fixture
def test_cse(db_session):
    cse = CSE(
        id=uuid.uuid4(),
        name="Ingestion Test CSE",
        cse_code=f"INGEST-{uuid.uuid4().hex[:8].upper()}",
        sector="DEFENSE",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()
    db_session.refresh(cse)
    return cse


def test_upload_csv_alerts_success(test_cse, db_session):
    csv_content = (
        "external_alert_id,title,category,severity,status,detected_at\n"
        "ALT-2001,Unusual Outbound Traffic,NETWORK,HIGH,OPEN,2026-09-28T14:00:00Z\n"
        "ALT-2002,Brute Force Attempt,AUTHENTICATION,MEDIUM,CLOSED,2026-09-28T14:10:00Z\n"
    )
    
    response = client.post(
        "/api/v1/ingestion/upload",
        data={
            "cse_id": str(test_cse.id),
            "dataset_type": "alerts"
        },
        files={
            "file": ("alerts_sample.csv", csv_content.encode("utf-8"), "text/csv")
        }
    )
    
    assert response.status_code == 201
    data = response.json()
    assert data["cse_id"] == str(test_cse.id)
    assert data["source_type"] == "CSV"
    assert data["source_filename"] == "alerts_sample.csv"
    assert data["total_records"] == 2
    assert data["valid_records"] == 2
    assert data["status"] == "COMPLETED"
    assert data["batch_reference"].startswith("BATCH-")

    # Verify Database Provenance & Traceability
    batch_id = uuid.UUID(data["id"])
    persisted_alerts = db_session.query(Alert).filter(Alert.batch_id == batch_id).all()
    assert len(persisted_alerts) == 2
    assert persisted_alerts[0].external_alert_id in ["ALT-2001", "ALT-2002"]
    assert persisted_alerts[0].cse_id == test_cse.id


def test_upload_json_cases_success(test_cse, db_session):
    json_payload = {
        "cse_id": str(test_cse.id),
        "dataset_type": "cases",
        "records": [
            {
                "external_case_id": "CASE-9001",
                "title": "Data Exfiltration Investigation",
                "status": "OPEN",
                "priority": "HIGH",
                "opened_at": "2026-09-28T15:00:00Z"
            }
        ]
    }

    response = client.post(
        "/api/v1/ingestion/json",
        json=json_payload
    )

    assert response.status_code == 201
    data = response.json()
    assert data["total_records"] == 1
    assert data["valid_records"] == 1
    assert data["status"] == "COMPLETED"

    # Verify Database persistence
    persisted_cases = db_session.query(Case).filter(Case.cse_id == test_cse.id).all()
    assert len(persisted_cases) == 1
    assert persisted_cases[0].external_case_id == "CASE-9001"


def test_ingestion_transactional_rollback_on_invalid_schema(test_cse, db_session):
    """Verify that batch is marked FAILED and operational tables have zero orphaned records on validation failure."""
    invalid_csv = (
        "external_alert_id,title,category,severity,status,detected_at\n"
        "ALT-3001,Valid Alert,NETWORK,HIGH,OPEN,2026-09-28T14:00:00Z\n"
        "ALT-3002,Invalid Alert,NETWORK,HIGH,OPEN,INVALID_DATE_FORMAT\n"  # Invalid ISO datetime
    )

    response = client.post(
        "/api/v1/ingestion/upload",
        data={
            "cse_id": str(test_cse.id),
            "dataset_type": "alerts"
        },
        files={
            "file": ("invalid_alerts.csv", invalid_csv.encode("utf-8"), "text/csv")
        }
    )

    assert response.status_code == 422
    err_data = response.json()
    assert err_data["error"]["code"] == "SCHEMA_VALIDATION_ERROR"

    # Verify Provenance Record updated to FAILED and zero alerts persisted
    batch = db_session.query(IngestionBatch).filter(
        IngestionBatch.cse_id == test_cse.id,
        IngestionBatch.source_filename == "invalid_alerts.csv"
    ).first()
    assert batch is not None
    assert batch.status == "FAILED"
    assert "SCHEMA_VALIDATION_ERROR" in batch.error_summary or "Validation failed" in batch.error_summary

    alerts_in_db = db_session.query(Alert).filter(Alert.cse_id == test_cse.id).all()
    assert len(alerts_in_db) == 0  # Atomic Rollback verified


def test_list_and_get_ingestion_batches(test_cse, db_session):
    # Perform an ingestion first
    csv_content = (
        "external_alert_id,title,category,severity,status,detected_at\n"
        "ALT-4001,Port Scan Detected,RECON,LOW,OPEN,2026-09-28T16:00:00Z\n"
    )
    upload_res = client.post(
        "/api/v1/ingestion/upload",
        data={"cse_id": str(test_cse.id), "dataset_type": "alerts"},
        files={"file": ("list_test.csv", csv_content.encode("utf-8"), "text/csv")}
    )
    batch_data = upload_res.json()
    batch_id = batch_data["id"]

    # Test GET /api/v1/ingestion/batches
    list_res = client.get(f"/api/v1/ingestion/batches?cse_id={test_cse.id}")
    assert list_res.status_code == 200
    list_data = list_res.json()
    assert list_data["total"] >= 1
    assert any(b["id"] == batch_id for b in list_data["items"])

    # Test GET /api/v1/ingestion/batches/{batch_id}
    detail_res = client.get(f"/api/v1/ingestion/batches/{batch_id}")
    assert detail_res.status_code == 200
    assert detail_res.json()["id"] == batch_id


def test_ingestion_nonexistent_cse():
    fake_uuid = str(uuid.uuid4())
    csv_content = "external_alert_id,title,category,severity,status,detected_at\n"
    response = client.post(
        "/api/v1/ingestion/upload",
        data={"cse_id": fake_uuid, "dataset_type": "alerts"},
        files={"file": ("test.csv", csv_content.encode("utf-8"), "text/csv")}
    )
    assert response.status_code == 404
    assert response.json()["error"]["code"] == "ENTITY_NOT_FOUND"
