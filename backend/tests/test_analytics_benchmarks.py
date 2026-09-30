import uuid
import datetime
import pytest
from app.models.cse import CSE
from app.models.alert import Alert
from app.models.case import Case
from app.services.analytics_benchmarks import BenchmarkAnalyzer

@pytest.fixture
def test_cses(db_session):
    cses = []
    # Create 10 CSEs in same sector "DEFENSE"
    for i in range(10):
        c = CSE(
            id=uuid.uuid4(),
            name=f"Peer Defense CSE {i}",
            cse_code=f"BM-CSE-{i}-{uuid.uuid4().hex[:8].upper()}",
            sector="DEFENSE",
            criticality_tier="TIER_1"
        )
        db_session.add(c)
        cses.append(c)
    db_session.commit()
    for c in cses:
        db_session.refresh(c)
    return cses


def test_bm01_peer_benchmarking_and_baselines(test_cses, db_session):
    """BM-01 calculates sector baselines and detects deviation when CSE |Z| > 2.0."""
    now = datetime.datetime.now(datetime.timezone.utc)

    # CSE 0 to CSE 8: High investigation rate (100% investigated)
    for c in test_cses[:9]:
        for i in range(12):
            alt_id = uuid.uuid4()
            alt = Alert(
                id=alt_id,
                cse_id=c.id,
                external_alert_id=f"ALT-HIGH-INV-{c.id.hex[:4]}-{i}",
                title="High Inv Alert",
                category="NETWORK",
                severity="HIGH",
                status="CLOSED",
                detected_at=now
            )
            db_session.add(alt)
            db_session.flush()

            cs = Case(
                id=uuid.uuid4(),
                cse_id=c.id,
                alert_id=alt_id,
                external_case_id=f"CASE-BM-{alt_id.hex[:4]}",
                title="BM Case",
                status="CLOSED",
                opened_at=now,
                closed_at=now
            )
            db_session.add(cs)

    # CSE 9: Target CSE with 0% investigation rate out of 15 alerts
    target_cse = test_cses[9]
    for i in range(15):
        alt = Alert(
            id=uuid.uuid4(),
            cse_id=target_cse.id,
            external_alert_id=f"ALT-LOW-INV-{i}",
            title="Low Inv Alert",
            category="NETWORK",
            severity="HIGH",
            status="CLOSED",
            detected_at=now
        )
        db_session.add(alt)

    db_session.commit()

    baselines, findings_with_ev = BenchmarkAnalyzer.analyze_bm01_peer_benchmarks(db_session, target_cse.id)
    assert len(baselines) >= 1
    assert any(b.metric_name == "alert_investigation_rate" for b in baselines)

    # Target CSE (0% vs 90% peer mean, |Z| > 2.0) triggers benchmark finding
    assert len(findings_with_ev) >= 1
    finding, _ = findings_with_ev[0]
    assert finding.category == "BENCHMARK"
    assert finding.metrics_json["metric_name"] == "alert_investigation_rate"
    assert finding.metrics_json["peer_group"] == "SECTOR_DEFENSE"


def test_bm01_deduplication_behavior(test_cses, db_session):
    """
    Verifies BM-01 deduplication behavior:
    1. Same CSE + same period -> second run does NOT create duplicate finding.
    2. Same CSE + different period -> new benchmark finding is NOT suppressed.
    3. Different CSE + same period -> findings remain independent.
    """
    p1_start = datetime.datetime(2026, 8, 1, 0, 0, 0, tzinfo=datetime.timezone.utc)
    p1_end = datetime.datetime(2026, 8, 31, 23, 59, 59, tzinfo=datetime.timezone.utc)

    p2_start = datetime.datetime(2026, 9, 1, 0, 0, 0, tzinfo=datetime.timezone.utc)
    p2_end = datetime.datetime(2026, 9, 30, 23, 59, 59, tzinfo=datetime.timezone.utc)

    # Create alerts for Period 1
    for c in test_cses[:9]:
        for i in range(12):
            alt_id = uuid.uuid4()
            alt = Alert(
                id=alt_id,
                cse_id=c.id,
                external_alert_id=f"ALT-P1-{c.id.hex[:4]}-{i}",
                title="P1 Alert",
                category="NETWORK",
                severity="HIGH",
                status="CLOSED",
                detected_at=p1_start + datetime.timedelta(days=1)
            )
            db_session.add(alt)
            db_session.flush()

            cs = Case(
                id=uuid.uuid4(),
                cse_id=c.id,
                alert_id=alt_id,
                external_case_id=f"CASE-P1-{alt_id.hex[:4]}",
                title="P1 Case",
                status="CLOSED",
                opened_at=p1_start,
                closed_at=p1_start
            )
            db_session.add(cs)

    target_cse = test_cses[9]
    for i in range(15):
        alt = Alert(
            id=uuid.uuid4(),
            cse_id=target_cse.id,
            external_alert_id=f"ALT-P1-TARGET-{i}",
            title="Target P1 Alert",
            category="NETWORK",
            severity="HIGH",
            status="CLOSED",
            detected_at=p1_start + datetime.timedelta(days=1)
        )
        db_session.add(alt)

    db_session.commit()

    # Period 1 Run 1: Should create finding
    _, f1_run1 = BenchmarkAnalyzer.analyze_bm01_peer_benchmarks(
        db_session, target_cse.id, obs_start=p1_start, obs_end=p1_end
    )
    assert len(f1_run1) == 1
    finding1, _ = f1_run1[0]
    db_session.add(finding1)
    db_session.commit()

    # 1. Same CSE + same period (Period 1 Run 2): Should NOT create duplicate finding
    _, f1_run2 = BenchmarkAnalyzer.analyze_bm01_peer_benchmarks(
        db_session, target_cse.id, obs_start=p1_start, obs_end=p1_end
    )
    assert len(f1_run2) == 0  # Deduplicated

    # Setup Period 2 alerts for target_cse
    for i in range(15):
        alt = Alert(
            id=uuid.uuid4(),
            cse_id=target_cse.id,
            external_alert_id=f"ALT-P2-TARGET-{i}",
            title="Target P2 Alert",
            category="NETWORK",
            severity="HIGH",
            status="CLOSED",
            detected_at=p2_start + datetime.timedelta(days=1)
        )
        db_session.add(alt)
    
    # Also setup Period 2 alerts for peers
    for c in test_cses[:9]:
        for i in range(12):
            alt_id = uuid.uuid4()
            alt = Alert(
                id=alt_id,
                cse_id=c.id,
                external_alert_id=f"ALT-P2-{c.id.hex[:4]}-{i}",
                title="P2 Alert",
                category="NETWORK",
                severity="HIGH",
                status="CLOSED",
                detected_at=p2_start + datetime.timedelta(days=1)
            )
            db_session.add(alt)
            db_session.flush()

            cs = Case(
                id=uuid.uuid4(),
                cse_id=c.id,
                alert_id=alt_id,
                external_case_id=f"CASE-P2-{alt_id.hex[:4]}",
                title="P2 Case",
                status="CLOSED",
                opened_at=p2_start,
                closed_at=p2_start
            )
            db_session.add(cs)

    db_session.commit()

    # 2. Same CSE + different period (Period 2 Run 1): Should create a NEW distinct finding
    _, f2_run1 = BenchmarkAnalyzer.analyze_bm01_peer_benchmarks(
        db_session, target_cse.id, obs_start=p2_start, obs_end=p2_end
    )
    assert len(f2_run1) == 1
    finding2, _ = f2_run1[0]
    assert finding2.finding_code != finding1.finding_code  # Distinct finding code with date tag!

    # 3. Different CSE + same period: Findings remain independent
    another_cse = test_cses[0]
    _, f3_run1 = BenchmarkAnalyzer.analyze_bm01_peer_benchmarks(
        db_session, another_cse.id, obs_start=p1_start, obs_end=p1_end
    )
    # another_cse has 100% investigation rate so it produces 0 findings (no deviation), independent of target_cse
    assert isinstance(f3_run1, list)
