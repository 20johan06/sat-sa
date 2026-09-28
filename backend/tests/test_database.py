import uuid
from datetime import datetime, timezone
import pytest
from sqlalchemy import inspect, text
from sqlalchemy.exc import IntegrityError
from app.db.session import SessionLocal, engine
from app.models.cse import CSE
from app.models.asset import Asset
from app.models.ingestion import IngestionBatch
from app.models.alert import Alert
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.escalation import Escalation
from app.models.coverage import MonitoringCoverage
from app.models.finding import Finding, FindingEvidence
from app.models.baseline import PeerBaseline

@pytest.fixture
def db_session():
    """Provides a transactional database session for tests with cleanup."""
    session = SessionLocal()
    try:
        yield session
    finally:
        session.rollback()
        session.close()

def test_database_connection(db_session):
    """1. Verify real database connection executes simple SELECT 1."""
    result = db_session.execute(text("SELECT 1")).scalar()
    assert result == 1

def test_schema_tables_exist():
    """2 & 3. Verify all 11 required tables exist in PostgreSQL database schema."""
    inspector = inspect(engine)
    existing_tables = set(inspector.get_table_names())
    
    required_tables = {
        "cses",
        "assets",
        "ingestion_batches",
        "alerts",
        "cases",
        "investigations",
        "escalations",
        "monitoring_coverages",
        "findings",
        "finding_evidence",
        "peer_baselines",
        "alembic_version"
    }
    
    assert required_tables.issubset(existing_tables), f"Missing tables: {required_tables - existing_tables}"

def test_cse_creation_and_primary_key(db_session):
    """4. Verify primary key creation and retrieval for CSE model."""
    test_cse = CSE(
        cse_code=f"TEST_CSE_{uuid.uuid4().hex[:8]}",
        name="Test Defense Sector Entity",
        sector="Defense",
        criticality_tier="TIER_1"
    )
    db_session.add(test_cse)
    db_session.commit()
    db_session.refresh(test_cse)

    assert isinstance(test_cse.id, uuid.UUID)
    assert test_cse.is_active is True

    # Cleanup
    db_session.delete(test_cse)
    db_session.commit()

def test_foreign_key_and_relationship(db_session):
    """5 & 7. Verify foreign keys and SQLAlchemy relationships (CSE -> Alert -> FindingEvidence)."""
    test_cse = CSE(
        cse_code=f"TEST_CSE_{uuid.uuid4().hex[:8]}",
        name="Test Financial Sector Entity",
        sector="Banking"
    )
    db_session.add(test_cse)
    db_session.commit()

    test_alert = Alert(
        cse_id=test_cse.id,
        external_alert_id="ALT-1001",
        title="Suspicious Outbound Volume",
        category="EXFILTRATION",
        severity="HIGH",
        status="OPEN",
        detected_at=datetime.now(timezone.utc)
    )
    db_session.add(test_alert)
    db_session.commit()

    # Query relationship
    retrieved_cse = db_session.query(CSE).filter(CSE.id == test_cse.id).first()
    assert len(retrieved_cse.alerts) == 1
    assert retrieved_cse.alerts[0].external_alert_id == "ALT-1001"

    # Cleanup test data explicitly
    db_session.delete(test_alert)
    db_session.delete(test_cse)
    db_session.commit()

def test_unique_constraint_rejection(db_session):
    """6 & 9. Verify database integrity constraint rejects duplicate cse_code."""
    code = f"DUP_CODE_{uuid.uuid4().hex[:8]}"
    cse1 = CSE(cse_code=code, name="CSE 1", sector="Energy")
    cse2 = CSE(cse_code=code, name="CSE 2", sector="Energy")

    db_session.add(cse1)
    db_session.commit()

    db_session.add(cse2)
    with pytest.raises(IntegrityError):
        db_session.commit()
    
    db_session.rollback()
    
    # Cleanup cse1
    existing = db_session.query(CSE).filter(CSE.cse_code == code).first()
    if existing:
        db_session.delete(existing)
        db_session.commit()

def test_invalid_foreign_key_rejection(db_session):
    """9. Verify DB rejects inserting alert with non-existent CSE FK."""
    fake_cse_id = uuid.uuid4()
    invalid_alert = Alert(
        cse_id=fake_cse_id,
        external_alert_id="ALT-INVALID",
        title="Orphan Alert",
        category="ANOMALY",
        severity="LOW",
        status="NEW",
        detected_at=datetime.now(timezone.utc)
    )
    db_session.add(invalid_alert)
    with pytest.raises(IntegrityError):
        db_session.commit()
    db_session.rollback()

def test_finding_and_evidence_drilldown(db_session):
    """7 & 8. Verify supervisory finding to evidence drill-down relationship."""
    test_cse = CSE(cse_code=f"CSE_{uuid.uuid4().hex[:8]}", name="Telecom CSE", sector="Telecom")
    db_session.add(test_cse)
    db_session.commit()

    alert = Alert(
        cse_id=test_cse.id,
        external_alert_id="ALT-500",
        title="Rapid Closure Without Action",
        category="EXECUTION_GAP",
        severity="HIGH",
        status="CLOSED",
        detected_at=datetime.now(timezone.utc)
    )
    db_session.add(alert)
    db_session.commit()

    finding = Finding(
        finding_code=f"FND_{uuid.uuid4().hex[:8]}",
        cse_id=test_cse.id,
        category="EXECUTION_GAP",
        severity="HIGH",
        title="Alert Closed Under 30 Seconds",
        description="High severity alert closed automatically without human triage.",
        rationale="Closure velocity exceeds human review threshold.",
        detection_method="RULE_ENGINE"
    )
    db_session.add(finding)
    db_session.commit()

    evidence_link = FindingEvidence(
        finding_id=finding.id,
        evidence_type="ALERT",
        alert_id=alert.id,
        notes="Primary alert flagged for rapid closure."
    )
    db_session.add(evidence_link)
    db_session.commit()

    # Query drill-down
    retrieved_finding = db_session.query(Finding).filter(Finding.id == finding.id).first()
    assert len(retrieved_finding.evidence_links) == 1
    assert retrieved_finding.evidence_links[0].alert.external_alert_id == "ALT-500"

    # Cleanup
    db_session.delete(evidence_link)
    db_session.delete(finding)
    db_session.delete(alert)
    db_session.delete(test_cse)
    db_session.commit()

# --- RESTRICT DELETION PROTECTION TESTS ---

def test_restrict_cse_deletion_with_alert(db_session):
    """Deletion protection: CSE with dependent alert cannot be deleted."""
    cse = CSE(cse_code=f"CSE_ALT_{uuid.uuid4().hex[:8]}", name="CSE Alert Protect", sector="Banking")
    db_session.add(cse)
    db_session.commit()

    alert = Alert(cse_id=cse.id, external_alert_id="ALT-PROT", title="Test Alert", category="TEST", severity="LOW", status="NEW", detected_at=datetime.now(timezone.utc))
    db_session.add(alert)
    db_session.commit()

    db_session.delete(cse)
    with pytest.raises(IntegrityError):
        db_session.commit()
    db_session.rollback()

    # Clean up
    db_session.delete(alert)
    db_session.delete(cse)
    db_session.commit()

def test_restrict_cse_deletion_with_case(db_session):
    """Deletion protection: CSE with dependent case cannot be deleted."""
    cse = CSE(cse_code=f"CSE_CAS_{uuid.uuid4().hex[:8]}", name="CSE Case Protect", sector="Energy")
    db_session.add(cse)
    db_session.commit()

    case = Case(cse_id=cse.id, external_case_id="CAS-PROT", title="Test Case", status="OPEN", opened_at=datetime.now(timezone.utc))
    db_session.add(case)
    db_session.commit()

    db_session.delete(cse)
    with pytest.raises(IntegrityError):
        db_session.commit()
    db_session.rollback()

    # Clean up
    db_session.delete(case)
    db_session.delete(cse)
    db_session.commit()

def test_restrict_cse_deletion_with_ingestion_batch(db_session):
    """Deletion protection: CSE with dependent ingestion batch cannot be deleted."""
    cse = CSE(cse_code=f"CSE_ING_{uuid.uuid4().hex[:8]}", name="CSE Ingestion Protect", sector="Telecom")
    db_session.add(cse)
    db_session.commit()

    batch = IngestionBatch(cse_id=cse.id, batch_reference=f"REF_{uuid.uuid4().hex[:8]}", source_filename="test.csv")
    db_session.add(batch)
    db_session.commit()

    db_session.delete(cse)
    with pytest.raises(IntegrityError):
        db_session.commit()
    db_session.rollback()

    # Clean up
    db_session.delete(batch)
    db_session.delete(cse)
    db_session.commit()

def test_restrict_cse_deletion_with_finding(db_session):
    """Deletion protection: CSE with dependent finding cannot be deleted."""
    cse = CSE(cse_code=f"CSE_FND_{uuid.uuid4().hex[:8]}", name="CSE Finding Protect", sector="Defense")
    db_session.add(cse)
    db_session.commit()

    finding = Finding(
        finding_code=f"FND_PROT_{uuid.uuid4().hex[:8]}",
        cse_id=cse.id,
        category="ANOMALY",
        severity="HIGH",
        title="Anomaly Finding",
        description="Desc",
        rationale="Rat",
        detection_method="STATISTICAL"
    )
    db_session.add(finding)
    db_session.commit()

    db_session.delete(cse)
    with pytest.raises(IntegrityError):
        db_session.commit()
    db_session.rollback()

    # Clean up
    db_session.delete(finding)
    db_session.delete(cse)
    db_session.commit()

def test_restrict_cse_deletion_with_monitoring_coverage(db_session):
    """Deletion protection: CSE with dependent monitoring coverage cannot be deleted."""
    cse = CSE(cse_code=f"CSE_COV_{uuid.uuid4().hex[:8]}", name="CSE Coverage Protect", sector="Banking")
    db_session.add(cse)
    db_session.commit()

    cov = MonitoringCoverage(cse_id=cse.id, log_source_category="FIREWALL_LOGS")
    db_session.add(cov)
    db_session.commit()

    db_session.delete(cse)
    with pytest.raises(IntegrityError):
        db_session.commit()
    db_session.rollback()

    # Clean up
    db_session.delete(cov)
    db_session.delete(cse)
    db_session.commit()
