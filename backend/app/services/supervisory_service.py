import uuid
from datetime import datetime, timezone
from typing import List, Dict, Any, Optional, Tuple
from sqlalchemy.orm import Session
from sqlalchemy import func, select, desc

from app.models.cse import CSE
from app.models.alert import Alert
from app.models.finding import Finding, FindingEvidence
from app.models.baseline import PeerBaseline
from app.models.analysis_run import AnalysisRun
from app.models.ingestion import IngestionBatch

from app.schemas.reporting import ObservationPeriodSchema
from app.schemas.supervisory import (
    SupervisoryAttentionIndicators,
    ExplainableRationaleSchema,
    SupervisoryAttentionItem,
    SupervisoryAttentionQueueResponse,
    CapabilityBreakdownSchema,
    EntitySupervisoryOverviewResponse
)
from app.utils.exceptions import EntityNotFoundException

SEVERITY_ORDER = {"CRITICAL": 4, "HIGH": 3, "MEDIUM": 2, "LOW": 1}

CAPABILITY_MAPPING = {
    "EG-01": "Incident Response & Case Management",
    "EG-02": "Crisis Escalation & Response",
    "EG-03": "Case Investigation Thoroughness",
    "EG-04": "Repeated Signal Response Discipline",
    "NS-01": "Telemetry & Monitoring Coverage",
    "NS-02": "Log Source Availability",
    "AN-01": "Alert Processing Consistency",
    "BM-01": "Peer Performance Alignment"
}

RULE_EXPLANATION_MAP = {
    "EG-01": {
        "what": "Alert Execution Gap Detected",
        "why": "Alerts generated during the observation period lacked linked case investigations, indicating unhandled potential threats.",
        "how": "Rule EG-01 evaluated alert-to-case linkage.",
        "impact": "Uninvestigated alerts may lead to uncontained security incidents."
    },
    "EG-02": {
        "what": "Escalation Execution Gap Detected",
        "why": "Critical severity alerts lacked mandatory escalation tracking.",
        "how": "Rule EG-02 verified escalation records for critical alerts.",
        "impact": "Un-escalated critical alerts bypass senior supervisory governance."
    },
    "EG-03": {
        "what": "Rapid Case Closure Anomaly",
        "why": "Cases were closed with investigation durations significantly below the lower-tail threshold.",
        "how": "Rule EG-03 evaluated runtime lower-tail P5 closure time with N>=10.",
        "impact": "Premature closure may indicate superficial or incomplete triage."
    },
    "EG-04": {
        "what": "Repeated Investigation Pattern",
        "why": "Multiple distinct cases were opened for identical alert signatures within a short window.",
        "how": "Rule EG-04 aggregated recurring alert signatures across >=3 distinct cases.",
        "impact": "Repeated alerts indicate persistent unmitigated threats or ineffective remediation."
    },
    "NS-01": {
        "what": "Monitoring Coverage Gap",
        "why": "Registered critical assets had no active log or telemetry monitoring coverage.",
        "how": "Rule NS-01 cross-referenced asset inventory with monitoring coverage records.",
        "impact": "Unmonitored assets create operational blind spots for security monitoring."
    },
    "NS-02": {
        "what": "Telemetry Ingestion Silence",
        "why": "Critical assets produced zero telemetry logs during the observation period.",
        "how": "Rule NS-02 evaluated log emission rates against asset criticality.",
        "impact": "Telemetry silence impairs real-time threat detection capability."
    },
    "AN-01": {
        "what": "Statistical Triage Speed Anomaly",
        "why": "Case creation rate or triage latency deviated significantly from historical baseline.",
        "how": "Rule AN-01 evaluated Z-score of operational triage metrics.",
        "impact": "Operational bottleneck or process disruption detected."
    },
    "BM-01": {
        "what": "Peer Performance Benchmark Deviation",
        "why": "CSE operational metrics deviated significantly (|Z| > 2.0) from sector or population baseline.",
        "how": "Rule BM-01 calculated sector Z-scores for investigation and escalation rates.",
        "impact": "Peer deviation detected — supervisory review may be warranted."
    }
}

class SupervisoryService:
    """Supervisory Analytics Layer converting Phase 5 signals into explainable attention."""

    @staticmethod
    def _calculate_indicators(db: Session, cse_id: uuid.UUID, findings: List[Finding]) -> SupervisoryAttentionIndicators:
        active_findings = [f for f in findings if f.status == "NEW"]
        
        active_count = len(active_findings)
        active_crit_count = sum(1 for f in active_findings if f.severity == "CRITICAL")
        active_high_count = sum(1 for f in active_findings if f.severity == "HIGH")
        high_attention_count = active_crit_count + active_high_count
        
        exec_gap_count = sum(1 for f in active_findings if f.category == "EXECUTION_GAP")
        neg_space_count = sum(1 for f in active_findings if f.category == "NEGATIVE_SPACE")
        anomaly_count = sum(1 for f in active_findings if f.category == "ANOMALY")
        bm_count = sum(1 for f in active_findings if f.category == "BENCHMARK")

        # Evidence strength distribution & record counts
        ev_strength_dist = {"STRONG": 0, "MODERATE": 0, "LIMITED": 0, "NONE": 0}
        total_affected_records = 0
        critical_high_affected_records = 0

        finding_ids = [f.id for f in active_findings]
        ev_counts_by_finding = {}
        if finding_ids:
            ev_rows = db.query(FindingEvidence.finding_id, func.count(FindingEvidence.id))\
                .filter(FindingEvidence.finding_id.in_(finding_ids))\
                .group_by(FindingEvidence.finding_id).all()
            for fid, count in ev_rows:
                ev_counts_by_finding[fid] = count

        for f in active_findings:
            ev_count = ev_counts_by_finding.get(f.id, 0)
            total_affected_records += ev_count
            if f.severity in ("CRITICAL", "HIGH"):
                critical_high_affected_records += ev_count

            # Extract evidence_strength from metrics_json if present
            strength = "MODERATE"
            if f.metrics_json and isinstance(f.metrics_json, dict):
                strength = f.metrics_json.get("evidence_strength", "MODERATE").upper()
            if ev_count == 0:
                strength = "NONE"
            if strength not in ev_strength_dist:
                strength = "MODERATE"
            ev_strength_dist[strength] += 1

        peer_deviations_count = bm_count
        repeated_signals_count = sum(1 for f in active_findings if f.finding_code.startswith("EG-04"))

        return SupervisoryAttentionIndicators(
            active_findings_count=active_count,
            active_critical_findings_count=active_crit_count,
            active_high_findings_count=active_high_count,
            high_attention_findings_count=high_attention_count,
            execution_gap_findings_count=exec_gap_count,
            negative_space_findings_count=neg_space_count,
            anomaly_findings_count=anomaly_count,
            benchmark_deviations_count=bm_count,
            evidence_strength_distribution=ev_strength_dist,
            affected_record_count=total_affected_records,
            affected_critical_high_records=critical_high_affected_records,
            peer_deviations_count=peer_deviations_count,
            repeated_signals_count=repeated_signals_count
        )

    @staticmethod
    def _build_explainable_rationale(cse: CSE, active_findings: List[Finding], indicators: SupervisoryAttentionIndicators) -> ExplainableRationaleSchema:
        if not active_findings:
            return ExplainableRationaleSchema(
                what="No Active Supervisory Signals Detected",
                why=f"CSE {cse.name} currently displays no active execution gaps, negative space, or benchmark deviations.",
                how="System periodically evaluates canonical rules EG-01..04, NS-01..02, AN-01, BM-01 against ingested telemetry.",
                evidence="0 active findings detected in the observation period.",
                baseline="CSE metrics remain within established operational baselines.",
                impact="Standard supervisory oversight applies."
            )

        # Sort findings by severity and rule importance
        sorted_f = sorted(active_findings, key=lambda f: (SEVERITY_ORDER.get(f.severity, 0)), reverse=True)
        top_finding = sorted_f[0]
        rule_code = top_finding.finding_code
        rule_meta = RULE_EXPLANATION_MAP.get(rule_code, {
            "what": f"Supervisory Finding {rule_code}",
            "why": top_finding.description,
            "how": f"Evaluated by analytic rule {rule_code}.",
            "impact": "Requires supervisory attention."
        })

        what_text = f"{rule_meta['what']} ({indicators.active_findings_count} total active findings)"
        why_text = f"Primary trigger: {top_finding.title}. {rule_meta['why']}"
        how_text = rule_meta["how"]
        evidence_text = f"{indicators.affected_record_count} total affected records linked across {indicators.active_findings_count} active finding(s)."
        
        baseline_text = "Evaluated against historical CSE metrics and peer group standards."
        if top_finding.metrics_json and isinstance(top_finding.metrics_json, dict):
            bv = top_finding.metrics_json.get("baseline_value")
            ov = top_finding.metrics_json.get("observed_value")
            dev = top_finding.metrics_json.get("deviation")
            if bv is not None and ov is not None:
                try:
                    ov_f = float(ov)
                    bv_f = float(bv)
                    dev_str = f" (Deviation: {float(dev):+.2f})" if dev is not None else ""
                    baseline_text = f"Observed {ov_f:.4f} vs Baseline {bv_f:.4f}{dev_str}"
                except (ValueError, TypeError):
                    baseline_text = f"Observed {ov} vs Baseline {bv}"

        impact_text = rule_meta["impact"]

        return ExplainableRationaleSchema(
            what=what_text,
            why=why_text,
            how=how_text,
            evidence=evidence_text,
            baseline=baseline_text,
            impact=impact_text
        )

    @staticmethod
    def get_attention_queue(
        db: Session,
        allowed_cse_ids: Optional[List[uuid.UUID]] = None,
        sector: Optional[str] = None,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None,
        page: int = 1,
        page_size: int = 50
    ) -> SupervisoryAttentionQueueResponse:
        """
        Builds the supervisory Attention Queue.
        Help examiners identify which CSEs require inspection based on deterministic indicators.
        Enforces server-side CSE isolation.
        """
        query = db.query(CSE).filter(~CSE.cse_code.like("SYN-%")).filter(~CSE.sector.like("%SYNTHETIC%"))
        if allowed_cse_ids is not None:
            query = query.filter(CSE.id.in_(allowed_cse_ids))
        if sector:
            query = query.filter(CSE.sector == sector)

        cses = query.all()

        queue_items: List[SupervisoryAttentionItem] = []

        for cse in cses:
            # Query findings for CSE
            f_query = db.query(Finding).filter(Finding.cse_id == cse.id)
            if obs_start:
                f_query = f_query.filter(Finding.detected_at >= obs_start)
            if obs_end:
                f_query = f_query.filter(Finding.detected_at <= obs_end)

            findings = f_query.all()
            active_findings = [f for f in findings if f.status == "NEW"]

            indicators = SupervisoryService._calculate_indicators(db, cse.id, findings)
            
            # Dominant categories
            cat_counts = {}
            for f in active_findings:
                cat_counts[f.category] = cat_counts.get(f.category, 0) + 1
            sorted_cats = sorted(cat_counts.items(), key=lambda x: x[1], reverse=True)
            dominant_cats = [c[0] for c in sorted_cats[:2]]

            # Latest analysis run
            latest_run = db.query(AnalysisRun).filter(AnalysisRun.cse_id == cse.id).order_by(desc(AnalysisRun.started_at)).first()
            latest_run_at = latest_run.started_at.isoformat() if latest_run else None

            rationale = SupervisoryService._build_explainable_rationale(cse, active_findings, indicators)

            drilldown = {
                "cse_id": str(cse.id),
                "cse_code": cse.cse_code,
                "active_finding_ids": [str(f.id) for f in active_findings[:5]],
                "primary_rule": active_findings[0].finding_code if active_findings else None
            }

            queue_items.append(
                SupervisoryAttentionItem(
                    cse_id=cse.id,
                    cse_code=cse.cse_code,
                    cse_name=cse.name,
                    sector=cse.sector,
                    criticality_tier=cse.criticality_tier,
                    indicators=indicators,
                    dominant_categories=dominant_cats,
                    latest_analysis_run_at=latest_run_at,
                    observation_period=ObservationPeriodSchema(
                        start=obs_start,
                        end=obs_end,
                        is_bounded=bool(obs_start or obs_end)
                    ),
                    concise_rationale=rationale,
                    drilldown_context=drilldown
                )
            )

        # Deterministic sorting: 1. active_findings_count DESC, 2. affected_critical_high_records DESC, 3. cse_code DESC
        queue_items.sort(
            key=lambda x: (
                x.indicators.active_findings_count,
                x.indicators.affected_critical_high_records,
                x.indicators.high_attention_findings_count,
                x.cse_code
            ),
            reverse=True
        )

        total_cses = len(queue_items)
        cses_with_active = sum(1 for item in queue_items if item.indicators.active_findings_count > 0)
        tot_active = sum(item.indicators.active_findings_count for item in queue_items)
        tot_crit = sum(item.indicators.active_critical_findings_count for item in queue_items)
        tot_high = sum(item.indicators.active_high_findings_count for item in queue_items)

        return SupervisoryAttentionQueueResponse(
            items=queue_items,
            total_cses=total_cses,
            total_cses_with_active_findings=cses_with_active,
            total_active_findings=tot_active,
            total_critical_findings=tot_crit,
            total_high_findings=tot_high,
            observation_period=ObservationPeriodSchema(
                start=obs_start,
                end=obs_end,
                is_bounded=bool(obs_start or obs_end)
            )
        )

    @staticmethod
    def get_entity_supervisory_overview(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None
    ) -> EntitySupervisoryOverviewResponse:
        """
        Concise entity-level supervisory overview answering:
        WHY IS THIS CSE SHOWING SUPERVISORY ATTENTION?
        Enforces server-side CSE isolation.
        """
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        f_query = db.query(Finding).filter(Finding.cse_id == cse_id)
        if obs_start:
            f_query = f_query.filter(Finding.detected_at >= obs_start)
        if obs_end:
            f_query = f_query.filter(Finding.detected_at <= obs_end)

        findings = f_query.all()
        active_findings = [f for f in findings if f.status == "NEW"]

        indicators = SupervisoryService._calculate_indicators(db, cse_id, findings)

        # Findings breakdown by category and severity
        findings_by_cat = {"EXECUTION_GAP": 0, "NEGATIVE_SPACE": 0, "ANOMALY": 0, "BENCHMARK": 0}
        findings_by_sev = {"CRITICAL": 0, "HIGH": 0, "MEDIUM": 0, "LOW": 0}
        
        for f in active_findings:
            if f.category in findings_by_cat:
                findings_by_cat[f.category] += 1
            if f.severity in findings_by_sev:
                findings_by_sev[f.severity] += 1

        # Capabilities breakdown from active findings
        capability_dict: Dict[str, Dict[str, Any]] = {}
        for f in active_findings:
            cap_name = CAPABILITY_MAPPING.get(f.finding_code, "Operational Oversight")
            if f.metrics_json and isinstance(f.metrics_json, dict) and "capability" in f.metrics_json:
                cap_name = f.metrics_json["capability"]

            if cap_name not in capability_dict:
                capability_dict[cap_name] = {
                    "capability": cap_name,
                    "findings_count": 0,
                    "max_severity": "LOW",
                    "evidence_count": 0
                }

            ev_cnt = db.query(FindingEvidence).filter(FindingEvidence.finding_id == f.id).count()
            capability_dict[cap_name]["findings_count"] += 1
            capability_dict[cap_name]["evidence_count"] += ev_cnt
            
            cur_max = capability_dict[cap_name]["max_severity"]
            if SEVERITY_ORDER.get(f.severity, 0) > SEVERITY_ORDER.get(cur_max, 0):
                capability_dict[cap_name]["max_severity"] = f.severity

        capabilities_list = [
            CapabilityBreakdownSchema(**data) for data in capability_dict.values()
        ]

        # Peer benchmarks summary
        peer_baselines = db.query(PeerBaseline).filter(
            PeerBaseline.peer_group.in_([f"SECTOR_{cse.sector}", "POPULATION_ALL"])
        ).all()
        
        bm_summary = {
            "sector": cse.sector,
            "peer_group": f"SECTOR_{cse.sector}" if len(peer_baselines) >= 3 else "POPULATION_ALL",
            "data_sufficiency": "SUFFICIENT" if len(peer_baselines) >= 3 else "POPULATION_FALLBACK",
            "active_bm_findings_count": indicators.benchmark_deviations_count
        }

        # Latest analysis run
        latest_run = db.query(AnalysisRun).filter(AnalysisRun.cse_id == cse_id).order_by(desc(AnalysisRun.started_at)).first()
        latest_run_dict = None
        if latest_run:
            latest_run_dict = {
                "id": str(latest_run.id),
                "executed_at": latest_run.started_at.isoformat(),
                "rules_evaluated": latest_run.rules_evaluated,
                "findings_created": latest_run.findings_created
            }

        # Data quality limitations check
        limitations = []
        alerts_count = db.query(Alert).filter(Alert.cse_id == cse_id).count()
        if alerts_count < 10:
            limitations.append(f"Low alert volume ({alerts_count} alerts). BM-01 investigation rate check requires >= 10 alerts.")
        crit_alerts = db.query(Alert).filter(Alert.cse_id == cse_id, Alert.severity == "CRITICAL").count()
        if crit_alerts < 5:
            limitations.append(f"Low critical alert volume ({crit_alerts} critical alerts). BM-01 critical escalation rate check requires >= 5 critical alerts.")

        why_attention = SupervisoryService._build_explainable_rationale(cse, active_findings, indicators)

        return EntitySupervisoryOverviewResponse(
            cse_id=cse.id,
            code=cse.cse_code,
            name=cse.name,
            sector=cse.sector,
            criticality_tier=cse.criticality_tier,
            indicators=indicators,
            findings_by_category=findings_by_cat,
            findings_by_severity=findings_by_sev,
            evidence_strength_distribution=indicators.evidence_strength_distribution,
            capabilities_breakdown=capabilities_list,
            peer_benchmarks_summary=bm_summary,
            observation_period=ObservationPeriodSchema(
                start=obs_start,
                end=obs_end,
                is_bounded=bool(obs_start or obs_end)
            ),
            latest_analysis_run=latest_run_dict,
            data_quality_limitations=limitations,
            why_attention=why_attention
        )

supervisory_service = SupervisoryService()
