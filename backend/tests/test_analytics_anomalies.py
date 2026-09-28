import uuid
import datetime
import pytest
from app.models.cse import CSE
from app.models.alert import Alert
from app.services.analytics_anomalies import AnomalyAnalyzer

@pytest.fixture
def test_cse(db_session):
    cse = CSE(
        id=uuid.uuid4(),
        name="Anomaly Test CSE",
        cse_code=f"AN-CSE-{uuid.uuid4().hex[:8].upper()}",
        sector="TELECOM",
        criticality_tier="TIER_1"
    )
    db_session.add(cse)
    db_session.commit()
    db_session.refresh(cse)
    return cse


def test_an01_daily_alert_volume_anomaly_detection(test_cse, db_session):
    """AN-01 detects a daily alert volume anomaly when |Modified Z| > 3.5 and N >= 10 days."""
    base_date = datetime.datetime(2026, 9, 1, 12, 0, 0, tzinfo=datetime.timezone.utc)

    # 10 days with slightly varying normal volume (1-3 alerts/day) to produce non-zero MAD
    counts_pattern = [1, 2, 3, 2, 1, 2, 3, 2, 1, 2]
    for day, num_alerts in enumerate(counts_pattern):
        dt = base_date + datetime.timedelta(days=day)
        for i in range(num_alerts):
            alt = Alert(
                id=uuid.uuid4(),
                cse_id=test_cse.id,
                external_alert_id=f"ALT-NORM-{day}-{i}",
                title="Normal Alert",
                category="NETWORK",
                severity="LOW",
                status="OPEN",
                detected_at=dt
            )
            db_session.add(alt)

    # 1 anomalous day (day 11) with 100 alerts
    anom_date = base_date + datetime.timedelta(days=11)
    for i in range(100):
        alt = Alert(
            id=uuid.uuid4(),
            cse_id=test_cse.id,
            external_alert_id=f"ALT-ANOM-{i}",
            title="Anomalous Spike Alert",
            category="NETWORK",
            severity="CRITICAL",
            status="OPEN",
            detected_at=anom_date
        )
        db_session.add(alt)

    db_session.commit()

    findings = AnomalyAnalyzer.analyze_an01_daily_alert_volume(db_session, test_cse.id)
    assert len(findings) == 1
    finding, evidences = findings[0]
    assert finding.category == "ANOMALY"
    assert finding.detection_method == "MAD_MODIFIED_Z_SCORE"
    assert finding.metrics_json["metric"] == "daily_alert_volume"
    assert finding.metrics_json["observed_value"] == 100
    assert len(evidences) > 0


def test_an01_insufficient_observation_days(test_cse, db_session):
    """AN-01 returns empty list when distinct days N < 10 (insufficient data)."""
    base_date = datetime.datetime(2026, 9, 1, 12, 0, 0, tzinfo=datetime.timezone.utc)
    for day in range(5):  # Only 5 days
        dt = base_date + datetime.timedelta(days=day)
        alt = Alert(
            id=uuid.uuid4(),
            cse_id=test_cse.id,
            external_alert_id=f"ALT-SPARSE-{day}",
            title="Sparse Alert",
            category="NETWORK",
            severity="LOW",
            status="OPEN",
            detected_at=dt
        )
        db_session.add(alt)
    db_session.commit()

    findings = AnomalyAnalyzer.analyze_an01_daily_alert_volume(db_session, test_cse.id)
    assert len(findings) == 0  # Insufficient data guard enforced


def test_an01_zero_variance_mad(test_cse, db_session):
    """AN-01 returns empty list when MAD == 0 (constant daily alert counts across all days)."""
    base_date = datetime.datetime(2026, 9, 1, 12, 0, 0, tzinfo=datetime.timezone.utc)
    for day in range(12):
        dt = base_date + datetime.timedelta(days=day)
        # Exactly 5 alerts every single day -> MAD = 0
        for i in range(5):
            alt = Alert(
                id=uuid.uuid4(),
                cse_id=test_cse.id,
                external_alert_id=f"ALT-CONST-{day}-{i}",
                title="Constant Alert",
                category="NETWORK",
                severity="LOW",
                status="OPEN",
                detected_at=dt
            )
            db_session.add(alt)
    db_session.commit()

    findings = AnomalyAnalyzer.analyze_an01_daily_alert_volume(db_session, test_cse.id)
    assert len(findings) == 0  # Zero variance MAD guard enforced
