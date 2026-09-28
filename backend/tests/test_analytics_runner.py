import uuid
import datetime
import pytest
from app.models.cse import CSE
from app.models.coverage import MonitoringCoverage
from app.models.finding import Finding
from app.services.analytics_runner import AnalyticsRunnerService

@pytest.fixture
def test_cse(db_session):
    cse = CSE(
        id=uuid.uuid4(),
        name="Runner Test CSE",
        cse_code=f"RUN-CSE-{uuid.uuid4().hex[:8].upper()}",
        sector="HEALTHCARE",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()
    db_session.refresh(cse)
    return cse


def test_analytics_runner_orchestration(test_cse, db_session):
    """AnalyticsRunnerService executes all analyzers, persists findings & baselines, and generates signal matrix."""
    cov = MonitoringCoverage(
        id=uuid.uuid4(),
        cse_id=test_cse.id,
        log_source_category="ACTIVE_DIRECTORY",
        is_expected=True,
        is_active=False,
        coverage_percentage=0.0
    )
    db_session.add(cov)
    db_session.commit()

    result = AnalyticsRunnerService.run_analytics(db_session, test_cse.id)

    assert result.cse_id == test_cse.id
    assert result.findings_created >= 1
    assert result.signal_matrix.cse_id == test_cse.id
    assert result.signal_matrix.signal_counts.evidence_gaps >= 1

    # Verify Finding and FindingEvidence persisted in DB
    persisted_findings = db_session.query(Finding).filter(Finding.cse_id == test_cse.id).all()
    assert len(persisted_findings) >= 1
    assert persisted_findings[0].evidence_links is not None


def test_analytics_runner_repeatability(test_cse, db_session):
    """Executing analytics twice over identical data produces identical findings without duplicates."""
    cov = MonitoringCoverage(
        id=uuid.uuid4(),
        cse_id=test_cse.id,
        log_source_category="SIEM_INGRESS",
        is_expected=True,
        is_active=False
    )
    db_session.add(cov)
    db_session.commit()

    res1 = AnalyticsRunnerService.run_analytics(db_session, test_cse.id)
    first_count = res1.findings_created

    res2 = AnalyticsRunnerService.run_analytics(db_session, test_cse.id)
    second_count = res2.findings_created

    assert first_count >= 1
    assert second_count == 0  # Duplicate finding code prevents redundant findings


def test_analytics_runner_nonexistent_cse(db_session):
    """Raises EntityNotFoundException on nonexistent CSE ID."""
    fake_uuid = uuid.uuid4()
    with pytest.raises(Exception) as exc_info:
        AnalyticsRunnerService.run_analytics(db_session, fake_uuid)
    assert exc_info.value.code == "ENTITY_NOT_FOUND"

