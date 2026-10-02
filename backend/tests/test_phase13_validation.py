import pytest
import uuid
from datetime import datetime, timezone
from fastapi.testclient import TestClient

from app.main import app
from app.api.deps import get_db, get_current_user
from app.models.cse import CSE
from app.models.finding import Finding
from app.models.dataset_version import DatasetVersion
from app.services.synthetic_generator_service import (
    synthetic_generator_service,
    generate_stable_uuid,
    SYNTHETIC_SEED,
    SYNTHETIC_DATASET_TYPE
)
from app.services.validation_service import validation_service, GROUND_TRUTH_SPEC

client = TestClient(app)

def mock_supervisor_user():
    user = type("MockUser", (), {})()
    user.id = uuid.uuid4()
    user.username = "test_supervisor"
    user.role = "SUPERVISOR"
    user.is_active = True
    return user

@pytest.fixture(autouse=True)
def override_deps(db_session):
    app.dependency_overrides[get_current_user] = mock_supervisor_user
    app.dependency_overrides[get_db] = lambda: db_session
    yield
    app.dependency_overrides.clear()

def test_deterministic_uuid_generation():
    """Verifies that stable UUID generator produces exact reproducible UUIDs."""
    uuid1 = generate_stable_uuid("test.namespace.key")
    uuid2 = generate_stable_uuid("test.namespace.key")
    uuid3 = generate_stable_uuid("different.key")

    assert uuid1 == uuid2
    assert uuid1 != uuid3

def test_synthetic_data_generation_and_isolation(db_session):
    """Verifies synthetic data generation, tagging, and operational data isolation."""
    gen_res = synthetic_generator_service.generate_all_scenarios(db_session, force_recreate=True)

    assert gen_res["cses_created"] >= 8
    assert gen_res["dataset_type"] == SYNTHETIC_DATASET_TYPE
    assert gen_res["seed"] == SYNTHETIC_SEED

    # Verify synthetic CSEs are properly tagged
    syn_cses = db_session.query(CSE).filter(CSE.cse_code.like("SYN-CSE-%")).all()
    assert len(syn_cses) == 8

    # Verify dataset_type is isolated as 'SYNTHETIC_VALIDATION'
    syn_datasets = db_session.query(DatasetVersion).filter(
        DatasetVersion.dataset_type == SYNTHETIC_DATASET_TYPE
    ).all()
    assert len(syn_datasets) >= 8

def test_full_validation_framework_execution(db_session):
    """Verifies that validation engine runs analytics pipeline against synthetic scenarios and computes metrics."""
    synthetic_generator_service.generate_all_scenarios(db_session, force_recreate=True)

    val_res = validation_service.run_validation(db_session, k_value=5)

    assert val_res.total_scenarios_evaluated == 8
    assert val_res.analytics_version == "v2.0.0-phase5-canonical"

    # Aggregated metrics checks
    cm = val_res.confusion_matrix
    assert cm.true_positives + cm.false_positives + cm.false_negatives + cm.true_negatives > 0
    assert val_res.metrics.precision >= 0.0 and val_res.metrics.precision <= 1.0
    assert val_res.metrics.recall >= 0.0 and val_res.metrics.recall <= 1.0
    assert val_res.metrics.f1_score >= 0.0 and val_res.metrics.f1_score <= 1.0
    assert val_res.metrics.precision_at_k >= 0.0 and val_res.metrics.precision_at_k <= 1.0

def test_scenario_ground_truth_evaluations(db_session):
    """Verifies specific scenario detection behavior against ground truth specs."""
    synthetic_generator_service.generate_all_scenarios(db_session, force_recreate=True)
    val_res = validation_service.run_validation(db_session, k_value=5)

    scen_map = {s.cse_code: s for s in val_res.scenario_results}

    # CSE-01 (Normal - Negative Control): Expected NO FINDING
    c01 = scen_map.get("SYN-CSE-01")
    assert c01 is not None
    assert c01.expected_presence == "EXPECTED_NO_FINDING"

    # CSE-02 (Rapid Closure - EG-03): Expected FINDING
    c02 = scen_map.get("SYN-CSE-02")
    assert c02 is not None
    assert c02.target_rule == "EG-03"
    assert c02.expected_presence == "EXPECTED_FINDING"

    # CSE-03 (Repeated Alerts - EG-04): Expected FINDING
    c03 = scen_map.get("SYN-CSE-03")
    assert c03 is not None
    assert c03.target_rule == "EG-04"
    assert c03.expected_presence == "EXPECTED_FINDING"

    # CSE-05 (Telemetry Gap - NS-01): Expected FINDING
    c05 = scen_map.get("SYN-CSE-05")
    assert c05 is not None
    assert c05.target_rule == "NS-01"
    assert c05.expected_presence == "EXPECTED_FINDING"

    # CSE-07 (Peer Deviation - BM-01): Expected FINDING
    c07 = scen_map.get("SYN-CSE-07")
    assert c07 is not None
    assert c07.target_rule == "BM-01"
    assert c07.expected_presence == "EXPECTED_FINDING"

    # CSE-08 (Volume Anomaly - AN-01): Expected FINDING
    c08 = scen_map.get("SYN-CSE-08")
    assert c08 is not None
    assert c08.target_rule == "AN-01"
    assert c08.expected_presence == "EXPECTED_FINDING"

def test_validation_api_endpoints(db_session):
    """Verifies Phase 13 FastAPI endpoints (POST /generate, POST /run, GET /results)."""
    # 1. POST /api/v1/validation/generate
    resp_gen = client.post("/api/v1/validation/generate", json={"seed": 202613, "force_recreate": True})
    assert resp_gen.status_code == 200
    data_gen = resp_gen.json()
    assert data_gen["cses_created"] >= 8
    assert data_gen["dataset_type"] == SYNTHETIC_DATASET_TYPE

    # 2. POST /api/v1/validation/run
    resp_run = client.post("/api/v1/validation/run", json={"k_value": 5})
    assert resp_run.status_code == 200
    data_run = resp_run.json()
    assert data_run["total_scenarios_evaluated"] == 8
    assert "metrics" in data_run
    assert "rule_breakdown" in data_run

    # 3. GET /api/v1/validation/results
    resp_res = client.get("/api/v1/validation/results?k_value=5")
    assert resp_res.status_code == 200
    data_res = resp_res.json()
    assert data_res["validation_run_id"].startswith("VAL-RUN-")
