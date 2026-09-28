import uuid
import datetime
import pytest
from app.models.cse import CSE
from app.models.coverage import MonitoringCoverage
from app.services.analytics_negative_space import NegativeSpaceAnalyzer

@pytest.fixture
def test_cse(db_session):
    cse = CSE(
        id=uuid.uuid4(),
        name="Negative Space Test CSE",
        cse_code=f"NS-CSE-{uuid.uuid4().hex[:8].upper()}",
        sector="ENERGY",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()
    db_session.refresh(cse)
    return cse


def test_ns01_inactive_expected_coverage_detection(test_cse, db_session):
    """NS-01 detects inactive coverage records explicitly declared as is_expected == True."""
    cov = MonitoringCoverage(
        id=uuid.uuid4(),
        cse_id=test_cse.id,
        log_source_category="FIREWALL",
        is_expected=True,
        is_active=False,  # Inactive expected source
        coverage_percentage=0.0
    )
    db_session.add(cov)
    db_session.commit()

    findings = NegativeSpaceAnalyzer.analyze_ns01_inactive_expected_coverage(db_session, test_cse.id)
    assert len(findings) == 1
    finding, evidences = findings[0]
    assert finding.category == "NEGATIVE_SPACE"
    assert finding.severity == "HIGH"
    assert finding.title == "Expected Log Source Coverage Inactive"
    assert len(evidences) == 1
    assert evidences[0].coverage_id == cov.id


def test_ns01_active_expected_coverage_no_finding(test_cse, db_session):
    """NS-01 produces no finding for active expected coverage."""
    cov = MonitoringCoverage(
        id=uuid.uuid4(),
        cse_id=test_cse.id,
        log_source_category="ENDPOINT",
        is_expected=True,
        is_active=True,
        coverage_percentage=95.0
    )
    db_session.add(cov)
    db_session.commit()

    findings = NegativeSpaceAnalyzer.analyze_ns01_inactive_expected_coverage(db_session, test_cse.id)
    assert len(findings) == 0


def test_ns02_expectation_unconfigured(test_cse, db_session):
    """NS-02 returns empty list when expectation is unconfigured in schema."""
    findings = NegativeSpaceAnalyzer.analyze_ns02_absent_high_priority_escalation(db_session, test_cse.id)
    assert findings == []
