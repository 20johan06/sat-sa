import uuid
from datetime import datetime, timezone, timedelta
from typing import List, Dict, Any, Optional
from sqlalchemy.orm import Session
from sqlalchemy import func, desc

from app.models.cse import CSE
from app.models.finding import Finding, FindingEvidence
from app.models.alert import Alert
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.escalation import Escalation
from app.models.coverage import MonitoringCoverage
from app.models.baseline import PeerBaseline

from app.schemas.trends import (
    TrendMetricItemSchema,
    FindingStatusTrendItemSchema,
    CapabilityTrendSummaryItemSchema,
    CSETrendAnalysisResponse
)
from app.schemas.reporting import ObservationPeriodSchema
from app.services.analytics_helpers import calculate_evidence_strength
from app.services.capability_service import CAPABILITY_RULE_MAPPING
from app.utils.exceptions import EntityNotFoundException

CANONICAL_RULES = ["EG-01", "EG-02", "EG-03", "EG-04", "NS-01", "NS-02", "AN-01", "BM-01"]
FINDING_STATUSES = ["NEW", "UNDER_REVIEW", "CONFIRMED", "NOT_SUBSTANTIATED", "DISMISSED", "NEEDS_MORE_EVIDENCE"]

class TrendService:
    """
    Service handling historical trend derivations and period comparisons.
    Preserves strict neutral prose, zero scoring/ranking, and evidence traceability.
    """

    @staticmethod
    def _extract_rule_code(f: Finding) -> Optional[str]:
        if f.metrics_json and isinstance(f.metrics_json, dict):
            return f.metrics_json.get("rule_code")
        return None

    @classmethod
    def get_cse_trends(
        cls,
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None,
        window_days: int = 30
    ) -> CSETrendAnalysisResponse:
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        now = datetime.now(timezone.utc)
        if not obs_end:
            obs_end = now
        if not obs_start:
            obs_start = obs_end - timedelta(days=window_days)

        delta = obs_end - obs_start
        prev_end = obs_start
        prev_start = obs_start - delta

        curr_obs_period = ObservationPeriodSchema(start=obs_start, end=obs_end, is_bounded=True)
        prev_obs_period = ObservationPeriodSchema(start=prev_start, end=prev_end, is_bounded=True)

        # Retrieve findings for current and previous periods
        curr_findings = db.query(Finding).filter(
            Finding.cse_id == cse_id,
            Finding.detected_at >= obs_start,
            Finding.detected_at <= obs_end
        ).all()

        prev_findings = db.query(Finding).filter(
            Finding.cse_id == cse_id,
            Finding.detected_at >= prev_start,
            Finding.detected_at <= prev_end
        ).all()

        # Telemetry counts for Current Period
        curr_alerts = db.query(Alert).filter(Alert.cse_id == cse_id, Alert.detected_at >= obs_start, Alert.detected_at <= obs_end).count()
        prev_alerts = db.query(Alert).filter(Alert.cse_id == cse_id, Alert.detected_at >= prev_start, Alert.detected_at <= prev_end).count()

        curr_cases = db.query(Case).join(Alert, Case.alert_id == Alert.id).filter(Alert.cse_id == cse_id, Case.created_at >= obs_start, Case.created_at <= obs_end).count()
        prev_cases = db.query(Case).join(Alert, Case.alert_id == Alert.id).filter(Alert.cse_id == cse_id, Case.created_at >= prev_start, Case.created_at <= prev_end).count()

        curr_investigations = db.query(Investigation).join(Case, Investigation.case_id == Case.id).join(Alert, Case.alert_id == Alert.id).filter(Alert.cse_id == cse_id, Investigation.created_at >= obs_start, Investigation.created_at <= obs_end).count()
        prev_investigations = db.query(Investigation).join(Case, Investigation.case_id == Case.id).join(Alert, Case.alert_id == Alert.id).filter(Alert.cse_id == cse_id, Investigation.created_at >= prev_start, Investigation.created_at <= prev_end).count()

        curr_escalations = db.query(Escalation).join(Alert, Escalation.alert_id == Alert.id).filter(Alert.cse_id == cse_id, Escalation.created_at >= obs_start, Escalation.created_at <= obs_end).count()
        prev_escalations = db.query(Escalation).join(Alert, Escalation.alert_id == Alert.id).filter(Alert.cse_id == cse_id, Escalation.created_at >= prev_start, Escalation.created_at <= prev_end).count()

        # Build Telemetry Volume Metrics
        metrics_list: List[TrendMetricItemSchema] = []

        def build_metric_item(
            name: str,
            curr_val: float,
            prev_val: Optional[float],
            rule_code: Optional[str] = None,
            category: Optional[str] = None
        ) -> TrendMetricItemSchema:
            abs_change = curr_val - prev_val if prev_val is not None else None
            if prev_val is not None and prev_val > 0:
                pct_change = (abs_change / prev_val) * 100.0
            else:
                pct_change = None

            limitation = None
            if prev_val is None or prev_val == 0:
                limitation = "Zero or missing telemetry in previous period; percentage change undefined."

            strength = calculate_evidence_strength(sample_size=int(curr_val), has_explicit_evidence=curr_val > 0)

            return TrendMetricItemSchema(
                metric_name=name,
                rule_code=rule_code,
                category=category,
                current_value=float(curr_val),
                previous_value=float(prev_val) if prev_val is not None else None,
                historical_baseline=float(prev_val) if prev_val is not None else None,
                absolute_change=float(abs_change) if abs_change is not None else None,
                percentage_change=float(pct_change) if pct_change is not None else None,
                evidence_strength=strength,
                limitation=limitation
            )

        metrics_list.append(build_metric_item("Source Operational Alert Volume", curr_alerts, prev_alerts))
        metrics_list.append(build_metric_item("Case Triage Volume", curr_cases, prev_cases))
        metrics_list.append(build_metric_item("Investigation Volume", curr_investigations, prev_investigations))
        metrics_list.append(build_metric_item("Escalation Volume", curr_escalations, prev_escalations))

        # Group findings by canonical rule_code
        curr_rule_counts: Dict[str, int] = {r: 0 for r in CANONICAL_RULES}
        prev_rule_counts: Dict[str, int] = {r: 0 for r in CANONICAL_RULES}

        for f in curr_findings:
            r = cls._extract_rule_code(f)
            if r in curr_rule_counts:
                curr_rule_counts[r] += 1

        for f in prev_findings:
            r = cls._extract_rule_code(f)
            if r in prev_rule_counts:
                prev_rule_counts[r] += 1

        rule_categories = {
            "EG-01": "EXECUTION_GAP", "EG-02": "EXECUTION_GAP", "EG-03": "EXECUTION_GAP", "EG-04": "EXECUTION_GAP",
            "NS-01": "NEGATIVE_SPACE", "NS-02": "NEGATIVE_SPACE",
            "AN-01": "ANOMALY",
            "BM-01": "BENCHMARK"
        }

        for r in CANONICAL_RULES:
            metrics_list.append(build_metric_item(
                name=f"Canonical Rule Findings ({r})",
                curr_val=curr_rule_counts[r],
                prev_val=prev_rule_counts[r],
                rule_code=r,
                category=rule_categories.get(r)
            ))

        # Finding Status Distribution Trends
        curr_status_counts = {s: 0 for s in FINDING_STATUSES}
        prev_status_counts = {s: 0 for s in FINDING_STATUSES}

        for f in curr_findings:
            if f.status in curr_status_counts:
                curr_status_counts[f.status] += 1

        for f in prev_findings:
            if f.status in prev_status_counts:
                prev_status_counts[f.status] += 1

        status_trends_list = [
            FindingStatusTrendItemSchema(
                status=s,
                current_count=curr_status_counts[s],
                previous_count=prev_status_counts[s],
                absolute_change=curr_status_counts[s] - prev_status_counts[s]
            )
            for s in FINDING_STATUSES
        ]

        # Capability Trend Summary
        capability_trends_list: List[CapabilityTrendSummaryItemSchema] = []

        for cap_name, config in CAPABILITY_RULE_MAPPING.items():
            direct_rules = config["direct"]
            indirect_rules = config["indirect"]

            curr_direct = sum(curr_rule_counts.get(r, 0) for r in direct_rules)
            prev_direct = sum(prev_rule_counts.get(r, 0) for r in direct_rules)
            curr_indirect = sum(curr_rule_counts.get(r, 0) for r in indirect_rules)
            prev_indirect = sum(prev_rule_counts.get(r, 0) for r in indirect_rules)

            capability_trends_list.append(
                CapabilityTrendSummaryItemSchema(
                    capability=cap_name,
                    direct_findings_current=curr_direct,
                    direct_findings_previous=prev_direct,
                    indirect_signals_current=curr_indirect,
                    indirect_signals_previous=prev_indirect
                )
            )

        return CSETrendAnalysisResponse(
            cse_id=cse.id,
            cse_code=cse.cse_code,
            cse_name=cse.name,
            sector=cse.sector,
            criticality_tier=cse.criticality_tier,
            current_period=curr_obs_period,
            previous_period=prev_obs_period,
            metrics=metrics_list,
            finding_status_trends=status_trends_list,
            capability_trends=capability_trends_list
        )

trend_service = TrendService()
