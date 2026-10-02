import uuid
import statistics
import datetime
from typing import List, Tuple, Optional, Dict
from sqlalchemy.orm import Session
from app.models.cse import CSE
from app.models.alert import Alert
from app.models.case import Case
from app.models.escalation import Escalation
from app.models.baseline import PeerBaseline
from app.models.finding import Finding, FindingEvidence
from app.config.analytics_settings import analytics_settings
from app.services.analytics_helpers import calculate_evidence_strength, map_rule_to_capability

class BenchmarkAnalyzer:
    """
    Analyzes CSE operational metrics relative to peer groups or population baselines.
    """

    @staticmethod
    def analyze_bm01_peer_benchmarks(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime.datetime] = None,
        obs_end: Optional[datetime.datetime] = None,
        batch_id: Optional[uuid.UUID] = None
    ) -> Tuple[List[PeerBaseline], List[Tuple[Finding, List[FindingEvidence]]]]:
        """
        BM-01: Peer Benchmarking for alert_investigation_rate and critical_escalation_rate.
        Calculates sector peer baselines (or POPULATION_ALL fallback if sector size < 3).
        Persists PeerBaseline records and generates benchmark deviation findings if |Z| > 2.0.
        """
        target_cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not target_cse:
            return [], []

        all_cses = db.query(CSE).filter(CSE.is_active == True).all()
        sector_cses = [c for c in all_cses if c.sector == target_cse.sector]

        if len(sector_cses) >= analytics_settings.MIN_PEER_GROUP_SIZE:
            peer_group_name = f"SECTOR_{target_cse.sector}"
            group_cses = sector_cses
        else:
            peer_group_name = "POPULATION_ALL"
            group_cses = all_cses

        baselines: List[PeerBaseline] = []
        findings_with_evidence: List[Tuple[Finding, List[FindingEvidence]]] = []

        now_utc = datetime.datetime.now(datetime.timezone.utc)
        p_start = obs_start or datetime.datetime(2026, 1, 1, tzinfo=datetime.timezone.utc)
        p_end = obs_end or now_utc

        capability = map_rule_to_capability(category="BENCHMARK", rule_code="BM01")

        # --- Metric 1: alert_investigation_rate ---
        cse_investigation_rates: Dict[uuid.UUID, float] = {}
        for c in group_cses:
            alerts_query = db.query(Alert).filter(Alert.cse_id == c.id)
            if obs_start:
                alerts_query = alerts_query.filter(Alert.detected_at >= obs_start)
            if obs_end:
                alerts_query = alerts_query.filter(Alert.detected_at <= obs_end)

            c_alerts = alerts_query.all()
            if len(c_alerts) < analytics_settings.MIN_ALERT_BENCHMARK_DENOMINATOR:
                continue

            investigated_count = 0
            for alt in c_alerts:
                has_case = db.query(Case).filter(Case.alert_id == alt.id).first() is not None
                if has_case:
                    investigated_count += 1

            cse_investigation_rates[c.id] = investigated_count / len(c_alerts)

        peer_investigation_rates = [v for cid, v in cse_investigation_rates.items() if cid != cse_id]
        if len(peer_investigation_rates) >= analytics_settings.MIN_PEER_GROUP_SIZE and cse_id in cse_investigation_rates:
            peer_rates_list = peer_investigation_rates
            mean_rate = float(statistics.mean(peer_rates_list))
            std_rate = float(statistics.stdev(peer_rates_list)) if len(peer_rates_list) > 1 else 0.0

            pb1 = PeerBaseline(
                id=uuid.uuid4(),
                peer_group=peer_group_name,
                metric_name="alert_investigation_rate",
                baseline_value=mean_rate,
                min_value=float(min(peer_investigation_rates)),
                max_value=float(max(peer_investigation_rates)),
                sample_size=len(peer_investigation_rates),
                period_start=p_start,
                period_end=p_end,
                metadata_json={"std_dev": std_rate}
            )
            baselines.append(pb1)

            target_val = cse_investigation_rates[cse_id]
            if std_rate > 0:
                z_score = (target_val - mean_rate) / std_rate
                if abs(z_score) > analytics_settings.BENCHMARK_SIGMA_THRESHOLD:
                    date_tag = p_start.strftime("%Y%m%d")
                    finding_code = f"FND-BM01-INV-{cse_id.hex[:6]}-{date_tag}"
                    existing = db.query(Finding).filter(Finding.finding_code == finding_code).first()
                    if not existing:
                        ev_strength = calculate_evidence_strength(sample_size=len(peer_investigation_rates), has_explicit_evidence=True)
                        finding = Finding(
                            id=uuid.uuid4(),
                            finding_code=finding_code,
                            cse_id=cse_id,
                            batch_id=batch_id,
                            category="BENCHMARK",
                            severity="MEDIUM",
                            title="Significant Peer Group Deviation: Alert Investigation Rate",
                            description=(
                                f"Alert investigation rate ({target_val:.1%}) significantly deviates "
                                f"from {peer_group_name} baseline mean ({mean_rate:.1%}, Z={z_score:.2f})."
                            ),
                            rationale=(
                                f"CSE alert investigation rate of {target_val:.1%} deviates by {abs(z_score):.2f} "
                                f"standard deviations from peer baseline mean ({mean_rate:.1%})."
                            ),
                            detection_method="PEER_BENCHMARK_Z_SCORE",
                            metrics_json={
                                "rule_code": "BM-01-INV",
                                "metric_name": "alert_investigation_rate",
                                "metric": "alert_investigation_rate",
                                "peer_group": peer_group_name,
                                "observed_value": round(target_val, 4),
                                "baseline_value": round(mean_rate, 4),
                                "peer_mean": round(mean_rate, 4),
                                "peer_std": round(std_rate, 4),
                                "deviation": round(z_score, 4),
                                "z_score": round(z_score, 4),
                                "peer_sample_size": len(peer_investigation_rates),
                                "evidence_strength": ev_strength,
                                "capability": capability,
                                "supervisory_relevance": "Deviating from peer investigation rates indicates potential operational under-reporting or over-filtering."
                            },
                            status="NEW"
                        )
                        findings_with_evidence.append((finding, []))

        # --- Metric 2: critical_escalation_rate ---
        cse_critical_rates: Dict[uuid.UUID, float] = {}
        for c in group_cses:
            crit_query = db.query(Alert).filter(Alert.cse_id == c.id, Alert.severity == "CRITICAL")
            if obs_start:
                crit_query = crit_query.filter(Alert.detected_at >= obs_start)
            if obs_end:
                crit_query = crit_query.filter(Alert.detected_at <= obs_end)

            c_crits = crit_query.all()
            if len(c_crits) < analytics_settings.MIN_CRITICAL_BENCHMARK_DENOMINATOR:
                continue

            escalated_count = 0
            for alt in c_crits:
                has_esc = db.query(Escalation).filter(Escalation.alert_id == alt.id).first() is not None
                if has_esc:
                    escalated_count += 1

            cse_critical_rates[c.id] = escalated_count / len(c_crits)

        peer_critical_rates = [v for cid, v in cse_critical_rates.items() if cid != cse_id]
        if len(peer_critical_rates) >= analytics_settings.MIN_PEER_GROUP_SIZE and cse_id in cse_critical_rates:
            peer_crit_list = peer_critical_rates
            mean_crit = float(statistics.mean(peer_crit_list))
            std_crit = float(statistics.stdev(peer_crit_list)) if len(peer_crit_list) > 1 else 0.0

            pb2 = PeerBaseline(
                id=uuid.uuid4(),
                peer_group=peer_group_name,
                metric_name="critical_escalation_rate",
                baseline_value=mean_crit,
                min_value=float(min(peer_critical_rates)),
                max_value=float(max(peer_critical_rates)),
                sample_size=len(peer_critical_rates),
                period_start=p_start,
                period_end=p_end,
                metadata_json={"std_dev": std_crit}
            )
            baselines.append(pb2)

            target_crit_val = cse_critical_rates[cse_id]
            if std_crit > 0:
                z_score_crit = (target_crit_val - mean_crit) / std_crit
                if abs(z_score_crit) > analytics_settings.BENCHMARK_SIGMA_THRESHOLD:
                    date_tag = p_start.strftime("%Y%m%d")
                    finding_code = f"FND-BM01-ESC-{cse_id.hex[:6]}-{date_tag}"
                    existing = db.query(Finding).filter(Finding.finding_code == finding_code).first()
                    if not existing:
                        ev_strength = calculate_evidence_strength(sample_size=len(peer_critical_rates), has_explicit_evidence=True)
                        finding = Finding(
                            id=uuid.uuid4(),
                            finding_code=finding_code,
                            cse_id=cse_id,
                            batch_id=batch_id,
                            category="BENCHMARK",
                            severity="MEDIUM",
                            title="Significant Peer Group Deviation: Critical Escalation Rate",
                            description=(
                                f"Critical alert escalation rate ({target_crit_val:.1%}) significantly deviates "
                                f"from {peer_group_name} baseline mean ({mean_crit:.1%}, Z={z_score_crit:.2f})."
                            ),
                            rationale=(
                                f"Critical escalation rate of {target_crit_val:.1%} deviates by {abs(z_score_crit):.2f} "
                                f"standard deviations from peer baseline mean ({mean_crit:.1%})."
                            ),
                            detection_method="PEER_BENCHMARK_Z_SCORE",
                            metrics_json={
                                "rule_code": "BM-01-ESC",
                                "metric_name": "critical_escalation_rate",
                                "metric": "critical_escalation_rate",
                                "peer_group": peer_group_name,
                                "observed_value": round(target_crit_val, 4),
                                "baseline_value": round(mean_crit, 4),
                                "peer_mean": round(mean_crit, 4),
                                "peer_std": round(std_crit, 4),
                                "deviation": round(z_score_crit, 4),
                                "z_score": round(z_score_crit, 4),
                                "peer_sample_size": len(peer_critical_rates),
                                "evidence_strength": ev_strength,
                                "capability": capability,
                                "supervisory_relevance": "Low critical escalation rate compared to sector peers signals potential escalation suppression."
                            },
                            status="NEW"
                        )
                        findings_with_evidence.append((finding, []))

        return baselines, findings_with_evidence
