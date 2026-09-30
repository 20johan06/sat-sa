import uuid
import statistics
import datetime
from typing import List, Tuple, Optional, Dict
from sqlalchemy.orm import Session
from app.models.alert import Alert
from app.models.finding import Finding, FindingEvidence
from app.config.analytics_settings import analytics_settings
from app.services.analytics_helpers import calculate_evidence_strength, map_rule_to_capability

class AnomalyAnalyzer:
    """
    Analyzes operational metrics for statistical anomalies using MAD (Median Absolute Deviation)
    and Modified Z-score techniques. Every finding is fully explainable.
    """

    @staticmethod
    def analyze_an01_daily_alert_volume(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime.datetime] = None,
        obs_end: Optional[datetime.datetime] = None,
        batch_id: Optional[uuid.UUID] = None
    ) -> List[Tuple[Finding, List[FindingEvidence]]]:
        """
        AN-01: Daily Alert Volume Statistical Anomaly.
        Aggregates Alert.detected_at by UTC calendar day.
        Calculates median, MAD, and Modified Z-score.
        Requires N >= 10 days. MAD == 0 returns insufficient variance (no finding).
        Exposes WHAT, WHY, HOW, OBSERVED, BASELINE, DEVIATION, EVIDENCE, and SUPERVISORY RELEVANCE.
        """
        query = db.query(Alert).filter(Alert.cse_id == cse_id)
        if obs_start:
            query = query.filter(Alert.detected_at >= obs_start)
        if obs_end:
            query = query.filter(Alert.detected_at <= obs_end)

        alerts = query.all()

        daily_counts: Dict[datetime.date, List[Alert]] = {}
        for alt in alerts:
            dt_key = alt.detected_at.date()
            daily_counts.setdefault(dt_key, []).append(alt)

        distinct_days = list(daily_counts.keys())

        if len(distinct_days) < analytics_settings.MIN_ANOMALY_OBSERVATION_DAYS:
            return []

        counts = [float(len(daily_counts[d])) for d in distinct_days]

        median_val = float(statistics.median(counts))
        abs_deviations = [abs(x - median_val) for x in counts]
        mad_val = float(statistics.median(abs_deviations))

        if mad_val == 0.0:
            return []

        results: List[Tuple[Finding, List[FindingEvidence]]] = []
        sample_size = len(distinct_days)
        ev_strength = calculate_evidence_strength(sample_size=sample_size, has_explicit_evidence=True)
        capability = map_rule_to_capability(category="ANOMALY", rule_code="AN01")

        for d, count in zip(distinct_days, counts):
            mod_z = 0.6745 * (count - median_val) / mad_val

            if abs(mod_z) > analytics_settings.MAD_MODIFIED_Z_THRESHOLD:
                day_str = d.isoformat()
                finding_code = f"FND-AN01-{cse_id.hex[:6]}-{day_str}"

                existing = db.query(Finding).filter(Finding.finding_code == finding_code).first()
                if existing:
                    continue

                day_alerts = daily_counts[d]
                finding = Finding(
                    id=uuid.uuid4(),
                    finding_code=finding_code,
                    cse_id=cse_id,
                    batch_id=batch_id,
                    category="ANOMALY",
                    severity="MEDIUM",
                    title="Daily Alert Volume Statistical Anomaly",
                    description=(
                        f"Daily alert volume on {day_str} was {int(count)} alerts, "
                        f"representing a statistical anomaly (Modified Z-score: {mod_z:.2f})."
                    ),
                    rationale=(
                        f"Observed daily alert volume ({int(count)}) significantly deviates "
                        f"from the CSE median ({median_val:.1f}) with MAD={mad_val:.1f} "
                        f"(|Modified Z| > {analytics_settings.MAD_MODIFIED_Z_THRESHOLD})."
                    ),
                    detection_method="MAD_MODIFIED_Z_SCORE",
                    metrics_json={
                        "rule_code": "AN-01",
                        "metric": "daily_alert_volume",
                        "observed_value": int(count),
                        "baseline_value": round(median_val, 1),
                        "mad": round(mad_val, 1),
                        "deviation": round(mod_z, 4),
                        "modified_z_score": round(mod_z, 4),
                        "observation_days_count": sample_size,
                        "date": day_str,
                        "evidence_strength": ev_strength,
                        "capability": capability,
                        "supervisory_relevance": "Unusual volume spikes or drops indicate potential cyber attacks, system misconfigurations, or ingestion telemetry anomalies."
                    },
                    status="NEW"
                )

                evidences: List[FindingEvidence] = []
                for sample_alt in day_alerts[:5]:
                    ev = FindingEvidence(
                        id=uuid.uuid4(),
                        evidence_type="ALERT",
                        alert_id=sample_alt.id,
                        notes=f"Anomaly evidence: alert on anomalous day {day_str} (Z={mod_z:.2f})."
                    )
                    evidences.append(ev)

                results.append((finding, evidences))

        return results
