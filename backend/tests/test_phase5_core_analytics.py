import pytest
import uuid
import datetime
from datetime import timezone, timedelta
from app.models.cse import CSE
from app.models.alert import Alert
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.coverage import MonitoringCoverage
from app.models.escalation import Escalation
from app.models.finding import Finding, FindingEvidence
from app.services.analytics_runner import AnalyticsRunnerService
from app.services.analytics_execution_gaps import ExecutionGapAnalyzer
from app.services.analytics_negative_space import NegativeSpaceAnalyzer
from app.services.analytics_anomalies import AnomalyAnalyzer
from app.services.analytics_benchmarks import BenchmarkAnalyzer
from app.services.analytics_helpers import calculate_evidence_strength, map_rule_to_capability

def test_evidence_strength_calculation():
    """Verify deterministic evidence strength calculation (STRONG, MODERATE, LIMITED)."""
    assert calculate_evidence_strength(sample_size=15, has_explicit_evidence=True) == "STRONG"
    assert calculate_evidence_strength(sample_size=5, has_explicit_evidence=True) == "MODERATE"
    assert calculate_evidence_strength(sample_size=1, has_explicit_evidence=True) == "LIMITED"

def test_capability_mapping():
    """Verify deterministic mapping of rules to V2 capability dimensions."""
    assert map_rule_to_capability("ANOMALY", "AN01") == "Threat Detection"
    assert map_rule_to_capability("EXECUTION_GAP", "EG03") == "Investigation"
    assert map_rule_to_capability("EXECUTION_GAP", "EG02") == "Escalation"
    assert map_rule_to_capability("NEGATIVE_SPACE", "NS01") == "Security Operations"
    assert map_rule_to_capability("BENCHMARK", "BM01") == "Governance and Oversight"

def test_eg01_unconfigured_expectation_returns_no_finding(db_session):
    """EG-01 must return NO FINDING when workflow expectation is unconfigured."""
    cse_id = uuid.uuid4()
    findings = ExecutionGapAnalyzer.analyze_eg01_critical_alert_workflow(db_session, cse_id)
    assert len(findings) == 0

def test_eg02_unconfigured_escalation_returns_no_finding(db_session):
    """EG-02 must return NO FINDING when escalation expectation is unconfigured."""
    cse_id = uuid.uuid4()
    findings = ExecutionGapAnalyzer.analyze_eg02_critical_incident_escalation(db_session, cse_id)
    assert len(findings) == 0

def test_eg03_rapid_case_closure_n_guard(db_session):
    """EG-03: Under minimum sample size N < 10 returns no finding."""
    cse = CSE(
        id=uuid.uuid4(),
        cse_code=f"CSE-EG03-N-{uuid.uuid4().hex[:4]}",
        name="EG03 N Guard CSE",
        sector="TEST",
        criticality_tier="TIER_1",
        is_active=True
    )
    db_session.add(cse)
    db_session.commit()

    now = datetime.datetime.now(timezone.utc)
    # Insert 5 cases (less than required N=10)
    for i in range(5):
        c = Case(
            id=uuid.uuid4(),
            cse_id=cse.id,
            external_case_id=f"CASE-SMALL-{i}",
            title="Small Sample Case",
            priority="MEDIUM",
            status="RESOLVED",
            opened_at=now - timedelta(seconds=100),
            closed_at=now
        )
        db_session.add(c)
    db_session.commit()

    findings = ExecutionGapAnalyzer.analyze_eg03_rapid_case_closure(db_session, cse.id)
    assert len(findings) == 0

def test_eg03_rapid_case_closure(db_session):
    """EG-03: Statistically rapid case closure using P5 percentile ($N \\ge 10$)."""
    cse = CSE(
        id=uuid.uuid4(),
        cse_code=f"CSE-EG03-{uuid.uuid4().hex[:4]}",
        name="EG03 Test CSE",
        sector="TEST",
        criticality_tier="TIER_1",
        is_active=True
    )
    db_session.add(cse)
    db_session.commit()

    now = datetime.datetime.now(timezone.utc)
    # Create 12 normal cases (duration 1000s) and 1 rapid case (duration 10s)
    cases = []
    for i in range(12):
        c = Case(
            id=uuid.uuid4(),
            cse_id=cse.id,
            external_case_id=f"CASE-NORM-{i}",
            title="Normal Case",
            priority="MEDIUM",
            status="RESOLVED",
            opened_at=now - timedelta(seconds=1000),
            closed_at=now
        )
        cases.append(c)

    rapid_case = Case(
        id=uuid.uuid4(),
        cse_id=cse.id,
        external_case_id="CASE-RAPID-01",
        title="Rapid Case",
        priority="HIGH",
        status="RESOLVED",
        opened_at=now - timedelta(seconds=10),
        closed_at=now
    )
    cases.append(rapid_case)

    db_session.add_all(cases)
    db_session.commit()

    findings_with_ev = ExecutionGapAnalyzer.analyze_eg03_rapid_case_closure(db_session, cse.id)
    assert len(findings_with_ev) > 0

    finding, evidences = findings_with_ev[0]
    assert finding.category == "EXECUTION_GAP"
    assert finding.title == "Statistically Rapid Case Closure"
    assert finding.metrics_json["rule_code"] == "EG-03"
    assert finding.metrics_json["case_id"] == str(rapid_case.id)
    assert len(evidences) == 1
    assert evidences[0].case_id == rapid_case.id

def test_eg04_repeated_investigation_patterns(db_session):
    """EG-04: Repeated investigation notes across >= 3 distinct cases."""
    cse = CSE(
        id=uuid.uuid4(),
        cse_code=f"CSE-EG04-{uuid.uuid4().hex[:4]}",
        name="EG04 Test CSE",
        sector="TEST",
        criticality_tier="TIER_1",
        is_active=True
    )
    db_session.add(cse)
    db_session.commit()

    now = datetime.datetime.now(timezone.utc)
    repeat_note = "Exact identical investigation procedure performed for incident triage."

    # Create 4 distinct cases with exact same investigation note
    for i in range(4):
        c = Case(
            id=uuid.uuid4(),
            cse_id=cse.id,
            external_case_id=f"CASE-REP-{i}",
            title="Repeat Case",
            priority="MEDIUM",
            status="OPEN",
            opened_at=now
        )
        db_session.add(c)
        db_session.flush()

        inv = Investigation(
            id=uuid.uuid4(),
            case_id=c.id,
            investigator_ref="USR-01",
            action_type="TRIAGE",
            notes=repeat_note,
            started_at=now
        )
        db_session.add(inv)

    db_session.commit()

    findings_with_ev = ExecutionGapAnalyzer.analyze_eg04_repeated_investigations(db_session, cse.id)
    assert len(findings_with_ev) == 1

    finding, evidences = findings_with_ev[0]
    assert finding.category == "EXECUTION_GAP"
    assert finding.detection_method == "PATTERN_REPETITION"
    assert finding.metrics_json["distinct_cases_count"] == 4
    assert len(evidences) == 4

def test_ns01_inactive_expected_coverage(db_session):
    """NS-01: Inactive expected log source coverage."""
    cse = CSE(
        id=uuid.uuid4(),
        cse_code=f"CSE-NS01-{uuid.uuid4().hex[:4]}",
        name="NS01 Test CSE",
        sector="TEST",
        criticality_tier="TIER_1",
        is_active=True
    )
    db_session.add(cse)
    db_session.commit()

    cov = MonitoringCoverage(
        id=uuid.uuid4(),
        cse_id=cse.id,
        log_source_category="ENDPOINT_EDR",
        is_expected=True,
        is_active=False,
        coverage_percentage=0.0
    )
    db_session.add(cov)
    db_session.commit()

    findings_with_ev = NegativeSpaceAnalyzer.analyze_ns01_inactive_expected_coverage(db_session, cse.id)
    assert len(findings_with_ev) == 1

    finding, evidences = findings_with_ev[0]
    assert finding.category == "NEGATIVE_SPACE"
    assert finding.severity == "HIGH"
    assert finding.metrics_json["rule_code"] == "NS-01"
    assert len(evidences) == 1
    assert evidences[0].coverage_id == cov.id

def test_ns02_unconfigured_expectation_returns_no_finding(db_session):
    """NS-02 must return NO FINDING when expectation is unconfigured."""
    cse_id = uuid.uuid4()
    findings = NegativeSpaceAnalyzer.analyze_ns02_absent_high_priority_escalation(db_session, cse_id)
    assert len(findings) == 0

def test_an01_zero_variance_guard(db_session):
    """AN-01: MAD == 0 variance guard returns no finding."""
    cse = CSE(
        id=uuid.uuid4(),
        cse_code=f"CSE-AN01-{uuid.uuid4().hex[:4]}",
        name="AN01 Constant Test CSE",
        sector="TEST",
        criticality_tier="TIER_1",
        is_active=True
    )
    db_session.add(cse)
    db_session.commit()

    now = datetime.datetime.now(timezone.utc)
    # Insert exactly 10 alerts on 10 distinct days (1 per day -> MAD == 0)
    for d in range(10):
        alt = Alert(
            id=uuid.uuid4(),
            cse_id=cse.id,
            external_alert_id=f"ALT-CONST-{d}",
            title="Brute Force Alert",
            category="BRUTE_FORCE",
            severity="MEDIUM",
            status="OPEN",
            detected_at=now - timedelta(days=d)
        )
        db_session.add(alt)
    db_session.commit()

    findings = AnomalyAnalyzer.analyze_an01_daily_alert_volume(db_session, cse.id)
    assert len(findings) == 0

def test_full_canonical_analytics_runner_pipeline(db_session):
    """Full execution test of AnalyticsRunnerService pipeline for a target CSE."""
    cse = CSE(
        id=uuid.uuid4(),
        cse_code=f"CSE-RUN-{uuid.uuid4().hex[:4]}",
        name="Analytics Runner Test CSE",
        sector="BANKING",
        criticality_tier="TIER_1",
        is_active=True
    )
    db_session.add(cse)
    db_session.commit()

    res = AnalyticsRunnerService.run_analytics(db_session, cse.id)
    assert res.cse_id == cse.id
    assert res.signal_matrix is not None
    assert res.signal_matrix.data_sufficiency_status in ("SUFFICIENT", "NO_FINDINGS_SUFFICIENT")
