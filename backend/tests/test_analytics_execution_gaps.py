import uuid
import datetime
import pytest
from app.models.cse import CSE
from app.models.case import Case
from app.models.investigation import Investigation
from app.services.analytics_execution_gaps import ExecutionGapAnalyzer
from app.config.analytics_settings import analytics_settings

@pytest.fixture
def test_cse(db_session):
    cse = CSE(
        id=uuid.uuid4(),
        name="Execution Gap Test CSE",
        cse_code=f"EG-CSE-{uuid.uuid4().hex[:8].upper()}",
        sector="FINANCE",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()
    db_session.refresh(cse)
    return cse


def test_eg01_and_eg02_expectation_unconfigured(test_cse, db_session):
    """EG-01 & EG-02 return empty list when workflow expectation is unconfigured in schema."""
    res1 = ExecutionGapAnalyzer.analyze_eg01_critical_alert_workflow(db_session, test_cse.id)
    assert res1 == []

    res2 = ExecutionGapAnalyzer.analyze_eg02_critical_incident_escalation(db_session, test_cse.id)
    assert res2 == []


def test_eg03_rapid_case_closure_detection(test_cse, db_session):
    """EG-03 detects cases resolved below P5 cutoff when N >= 10 closed cases."""
    now = datetime.datetime.now(datetime.timezone.utc)

    # Insert 12 cases: 11 cases with 3600s duration, 1 rapid case with 5s duration
    for i in range(11):
        c = Case(
            id=uuid.uuid4(),
            cse_id=test_cse.id,
            external_case_id=f"CASE-NORM-{i}",
            title=f"Normal Case {i}",
            status="CLOSED",
            priority="MEDIUM",
            opened_at=now - datetime.timedelta(seconds=3600),
            closed_at=now
        )
        db_session.add(c)

    rapid_case = Case(
        id=uuid.uuid4(),
        cse_id=test_cse.id,
        external_case_id="CASE-RAPID-01",
        title="Rapid Case",
        status="CLOSED",
        priority="MEDIUM",
        opened_at=now - datetime.timedelta(seconds=5),
        closed_at=now
    )
    db_session.add(rapid_case)
    db_session.commit()

    findings = ExecutionGapAnalyzer.analyze_eg03_rapid_case_closure(db_session, test_cse.id)
    assert len(findings) == 1
    finding, evidences = findings[0]
    assert finding.category == "EXECUTION_GAP"
    assert finding.detection_method == "P5_PERCENTILE"
    assert finding.metrics_json["case_id"] == str(rapid_case.id)
    assert len(evidences) == 1
    assert evidences[0].case_id == rapid_case.id


def test_eg03_rapid_case_closure_insufficient_data(test_cse, db_session):
    """EG-03 returns empty list when N < 10 closed cases (insufficient data)."""
    now = datetime.datetime.now(datetime.timezone.utc)
    for i in range(5):  # Only 5 cases
        c = Case(
            id=uuid.uuid4(),
            cse_id=test_cse.id,
            external_case_id=f"CASE-SPARSE-{i}",
            title=f"Sparse Case {i}",
            status="CLOSED",
            priority="MEDIUM",
            opened_at=now - datetime.timedelta(seconds=5),
            closed_at=now
        )
        db_session.add(c)
    db_session.commit()

    findings = ExecutionGapAnalyzer.analyze_eg03_rapid_case_closure(db_session, test_cse.id)
    assert len(findings) == 0  # Insufficient data guard enforced


def test_eg04_repeated_investigation_pattern(test_cse, db_session):
    """EG-04 detects repeated investigation notes across distinct cases when count >= threshold."""
    now = datetime.datetime.now(datetime.timezone.utc)
    repeated_note = "Standard boilerplate investigation note text for suspicious activity."

    for i in range(3):  # 3 distinct cases with matching note
        c = Case(
            id=uuid.uuid4(),
            cse_id=test_cse.id,
            external_case_id=f"CASE-REP-{i}",
            title=f"Case Rep {i}",
            status="OPEN",
            priority="HIGH",
            opened_at=now
        )
        db_session.add(c)
        db_session.flush()

        inv = Investigation(
            id=uuid.uuid4(),
            case_id=c.id,
            action_type="ANALYSIS",
            notes=repeated_note,
            started_at=now
        )
        db_session.add(inv)

    db_session.commit()

    findings = ExecutionGapAnalyzer.analyze_eg04_repeated_investigations(db_session, test_cse.id)
    assert len(findings) == 1
    finding, evidences = findings[0]
    assert finding.title == "Repeated Investigation Pattern Detected"
    assert finding.severity == "LOW"
    assert len(evidences) == 3
