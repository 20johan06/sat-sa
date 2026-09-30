import uuid
from datetime import datetime, timezone
from typing import List, Dict, Any, Optional, Tuple
from sqlalchemy.orm import Session
from sqlalchemy import func, select, desc

from app.models.cse import CSE
from app.models.asset import Asset
from app.models.alert import Alert
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.escalation import Escalation
from app.models.coverage import MonitoringCoverage
from app.models.finding import Finding, FindingEvidence
from app.models.baseline import PeerBaseline
from app.models.ingestion import IngestionBatch

from app.schemas.reporting import (
    CSESummarySchema,
    ObservationPeriodSchema,
    SignalMatrixResponse,
    SignalGroupSchema,
    FindingItemSchema,
    FindingDetailSchema,
    FindingEvidenceResponse,
    PaginatedFindingsResponse,
    PeerBenchmarkResponse,
    PeerBaselineItemSchema,
    ReportJSONResponse
)
from app.utils.exceptions import EntityNotFoundException

VALID_CATEGORIES = {"EXECUTION_GAP", "NEGATIVE_SPACE", "ANOMALY", "BENCHMARK"}
DEPRECATED_CATEGORIES = {"EVIDENCE_GAP", "NON_STANDARD"}

SEVERITY_ORDER = {"CRITICAL": 4, "HIGH": 3, "MEDIUM": 2, "LOW": 1}

class ReportingService:
    """Service handling supervisory API reporting queries and aggregations."""

    @staticmethod
    def get_cse_summary(db: Session, cse_id: uuid.UUID) -> CSESummarySchema:
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        assets_count = db.query(Asset).filter(Asset.cse_id == cse_id).count()
        alerts_total = db.query(Alert).filter(Alert.cse_id == cse_id).count()

        # Severity breakdown for alerts
        sev_counts_raw = db.query(
            Alert.severity, func.count(Alert.id)
        ).filter(Alert.cse_id == cse_id).group_by(Alert.severity).all()
        alerts_by_severity = {sev: 0 for sev in ["CRITICAL", "HIGH", "MEDIUM", "LOW"]}
        for sev, count in sev_counts_raw:
            if sev in alerts_by_severity:
                alerts_by_severity[sev] = count

        cases_count = db.query(Case).join(Alert, Case.alert_id == Alert.id).filter(Alert.cse_id == cse_id).count()
        investigations_count = db.query(Investigation).join(Case, Investigation.case_id == Case.id).join(Alert, Case.alert_id == Alert.id).filter(Alert.cse_id == cse_id).count()
        escalations_count = db.query(Escalation).join(Alert, Escalation.alert_id == Alert.id).filter(Alert.cse_id == cse_id).count()
        coverages_count = db.query(MonitoringCoverage).filter(MonitoringCoverage.cse_id == cse_id).count()

        # Analytics summary
        findings_query = db.query(Finding).filter(Finding.cse_id == cse_id)
        active_findings_count = findings_query.filter(Finding.status == "NEW").count()

        cat_counts_raw = db.query(
            Finding.category, func.count(Finding.id)
        ).filter(Finding.cse_id == cse_id).group_by(Finding.category).all()
        findings_by_category = {cat: 0 for cat in ["EXECUTION_GAP", "NEGATIVE_SPACE", "ANOMALY", "BENCHMARK"]}
        for cat, count in cat_counts_raw:
            if cat in findings_by_category:
                findings_by_category[cat] = count

        latest_finding = findings_query.order_by(desc(Finding.detected_at)).first()
        latest_finding_at = latest_finding.detected_at.isoformat() if latest_finding else None

        latest_batch = db.query(IngestionBatch).filter(IngestionBatch.cse_id == cse_id).order_by(desc(IngestionBatch.imported_at)).first()
        last_ingestion_at = latest_batch.imported_at.isoformat() if latest_batch else None

        return CSESummarySchema(
            cse_id=cse.id,
            code=cse.cse_code,
            name=cse.name,
            sector=cse.sector,
            criticality_tier=cse.criticality_tier,
            telemetry_counts={
                "assets": assets_count,
                "alerts_total": alerts_total,
                "alerts_by_severity": alerts_by_severity,
                "cases": cases_count,
                "investigations": investigations_count,
                "escalations": escalations_count,
                "monitoring_coverages": coverages_count,
            },
            analytics_summary={
                "active_findings_count": active_findings_count,
                "findings_by_category": findings_by_category,
                "latest_finding_detected_at": latest_finding_at,
                "last_ingestion_batch_at": last_ingestion_at,
            }
        )

    @staticmethod
    def get_signals(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None
    ) -> SignalMatrixResponse:
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        query = db.query(Finding).filter(Finding.cse_id == cse_id)
        if obs_start:
            query = query.filter(Finding.detected_at >= obs_start)
        if obs_end:
            query = query.filter(Finding.detected_at <= obs_end)

        findings = query.all()
        data_sufficiency_status = "SUFFICIENT" if len(findings) > 0 else "NO_FINDINGS"

        category_groups = {
            "EXECUTION_GAP": {"display_name": "Execution Gap", "findings": []},
            "NEGATIVE_SPACE": {"display_name": "Negative Space", "findings": []},
            "ANOMALY": {"display_name": "Statistical Anomaly", "findings": []},
            "BENCHMARK": {"display_name": "Benchmark Deviation", "findings": []},
        }

        for f in findings:
            cat = f.category
            if cat in category_groups:
                category_groups[cat]["findings"].append({
                    "finding_id": str(f.id),
                    "finding_code": f.finding_code,
                    "title": f.title,
                    "severity": f.severity,
                    "detected_at": f.detected_at.isoformat(),
                })

        signals_output = {}
        for cat, group in category_groups.items():
            f_list = group["findings"]
            max_sev = None
            if f_list:
                sorted_f = sorted(f_list, key=lambda x: SEVERITY_ORDER.get(x["severity"], 0), reverse=True)
                max_sev = sorted_f[0]["severity"]

            signals_output[cat] = SignalGroupSchema(
                display_name=group["display_name"],
                count=len(f_list),
                max_severity=max_sev,
                findings=f_list
            )

        return SignalMatrixResponse(
            cse_id=cse_id,
            observation_period=ObservationPeriodSchema(
                start=obs_start,
                end=obs_end,
                is_bounded=bool(obs_start or obs_end)
            ),
            data_sufficiency_status=data_sufficiency_status,
            signals=signals_output
        )

    @staticmethod
    def get_findings(
        db: Session,
        cse_id: Optional[uuid.UUID] = None,
        allowed_cse_ids: Optional[List[uuid.UUID]] = None,
        category: Optional[str] = None,
        severity: Optional[str] = None,
        status: Optional[str] = None,
        rule_code: Optional[str] = None,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None,
        page: int = 1,
        page_size: int = 20
    ) -> PaginatedFindingsResponse:
        if category:
            cat_upper = category.upper()
            if cat_upper in DEPRECATED_CATEGORIES:
                raise ValueError(f"Category '{category}' is deprecated. Use one of {sorted(VALID_CATEGORIES)}.")
            if cat_upper not in VALID_CATEGORIES:
                raise ValueError(f"Invalid category '{category}'. Must be one of {sorted(VALID_CATEGORIES)}.")

        query = db.query(Finding)
        if cse_id:
            query = query.filter(Finding.cse_id == cse_id)
        elif allowed_cse_ids is not None:
            query = query.filter(Finding.cse_id.in_(allowed_cse_ids))
        if category:
            query = query.filter(Finding.category == category.upper())
        if severity:
            query = query.filter(Finding.severity == severity.upper())
        if status:
            query = query.filter(Finding.status == status.upper())
        if rule_code:
            query = query.filter(Finding.finding_code.ilike(f"%{rule_code}%"))
        if obs_start:
            query = query.filter(Finding.detected_at >= obs_start)
        if obs_end:
            query = query.filter(Finding.detected_at <= obs_end)

        total = query.count()
        total_pages = (total + page_size - 1) // page_size if page_size > 0 else 1
        offset = (page - 1) * page_size

        findings_list = query.order_by(desc(Finding.detected_at), desc(Finding.id)).offset(offset).limit(page_size).all()

        items = []
        for f in findings_list:
            ev_count = db.query(FindingEvidence).filter(FindingEvidence.finding_id == f.id).count()
            item = FindingItemSchema(
                id=f.id,
                finding_code=f.finding_code,
                cse_id=f.cse_id,
                batch_id=f.batch_id,
                category=f.category,
                severity=f.severity,
                title=f.title,
                description=f.description,
                rationale=f.rationale,
                detection_method=f.detection_method,
                metrics_json=f.metrics_json,
                status=f.status,
                evidence_count=ev_count,
                detected_at=f.detected_at
            )
            items.append(item)

        return PaginatedFindingsResponse(
            items=items,
            pagination={
                "total": total,
                "page": page,
                "page_size": page_size,
                "total_pages": total_pages
            },
            observation_period=ObservationPeriodSchema(
                start=obs_start,
                end=obs_end,
                is_bounded=bool(obs_start or obs_end)
            )
        )

    @staticmethod
    def get_finding_detail(db: Session, finding_id: uuid.UUID) -> FindingDetailSchema:
        f = db.query(Finding).filter(Finding.id == finding_id).first()
        if not f:
            raise EntityNotFoundException("Finding", finding_id)

        ev_records = db.query(FindingEvidence).filter(FindingEvidence.finding_id == f.id).all()
        evidence_list = [FindingEvidenceResponse.model_validate(ev) for ev in ev_records]

        return FindingDetailSchema(
            id=f.id,
            finding_code=f.finding_code,
            cse_id=f.cse_id,
            batch_id=f.batch_id,
            category=f.category,
            severity=f.severity,
            title=f.title,
            description=f.description,
            rationale=f.rationale,
            detection_method=f.detection_method,
            metrics_json=f.metrics_json,
            status=f.status,
            evidence_count=len(evidence_list),
            detected_at=f.detected_at,
            evidence=evidence_list
        )

    @staticmethod
    def get_benchmarks(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None
    ) -> PeerBenchmarkResponse:
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        sector_peer_name = f"SECTOR_{cse.sector}"

        # 1. Query sector baselines
        sector_query = db.query(PeerBaseline).filter(PeerBaseline.peer_group == sector_peer_name)
        if obs_start:
            sector_query = sector_query.filter(PeerBaseline.period_start >= obs_start)
        if obs_end:
            sector_query = sector_query.filter(PeerBaseline.period_end <= obs_end)

        sector_baselines = sector_query.order_by(desc(PeerBaseline.period_start)).all()

        n_sector_obs = sector_baselines[0].sample_size if sector_baselines else 0

        if sector_baselines and n_sector_obs >= 3:
            peer_group_status = "SECTOR_PEER_GROUP"
            peer_group_name = sector_peer_name
            selected_baselines = sector_baselines
        else:
            # Fallback to POPULATION_ALL
            pop_query = db.query(PeerBaseline).filter(PeerBaseline.peer_group == "POPULATION_ALL")
            if obs_start:
                pop_query = pop_query.filter(PeerBaseline.period_start >= obs_start)
            if obs_end:
                pop_query = pop_query.filter(PeerBaseline.period_end <= obs_end)

            pop_baselines = pop_query.order_by(desc(PeerBaseline.period_start)).all()

            if pop_baselines:
                peer_group_status = "POPULATION_FALLBACK"
                peer_group_name = "POPULATION_ALL"
                selected_baselines = pop_baselines
            else:
                peer_group_status = "NO_APPLICABLE_BASELINE"
                peer_group_name = sector_peer_name
                selected_baselines = []

        baseline_items = []
        for pb in selected_baselines:
            std_dev = 0.0
            if pb.metadata_json and isinstance(pb.metadata_json, dict):
                std_dev = float(pb.metadata_json.get("std_dev", 0.0))

            item = PeerBaselineItemSchema(
                id=pb.id,
                metric_name=pb.metric_name,
                peer_group=pb.peer_group,
                baseline_value=pb.baseline_value,
                min_value=pb.min_value,
                max_value=pb.max_value,
                sample_size=pb.sample_size,
                std_dev=std_dev,
                period_start=pb.period_start,
                period_end=pb.period_end
            )
            baseline_items.append(item)

        return PeerBenchmarkResponse(
            cse_id=cse.id,
            sector=cse.sector,
            peer_group_name=peer_group_name,
            peer_group_status=peer_group_status,
            n_sector_observations=n_sector_obs,
            observation_period=ObservationPeriodSchema(
                start=obs_start,
                end=obs_end,
                is_bounded=bool(obs_start or obs_end)
            ),
            baselines=baseline_items
        )

    @staticmethod
    def get_report(
        db: Session,
        cse_id: uuid.UUID,
        format_type: str = "json",
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None
    ) -> Any:
        cse_summary = ReportingService.get_cse_summary(db, cse_id)
        signals = ReportingService.get_signals(db, cse_id, obs_start, obs_end)
        benchmarks = ReportingService.get_benchmarks(db, cse_id, obs_start, obs_end)
        findings_resp = ReportingService.get_findings(
            db=db, cse_id=cse_id, obs_start=obs_start, obs_end=obs_end, page=1, page_size=10
        )

        now_str = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S")
        report_id = f"REP-CSE-{cse_summary.code}-{now_str}"

        cse_profile = {
            "code": cse_summary.code,
            "name": cse_summary.name,
            "sector": cse_summary.sector,
            "criticality_tier": cse_summary.criticality_tier,
        }

        telemetry_summary = cse_summary.telemetry_counts

        signals_summary = {
            cat: data.count for cat, data in signals.signals.items()
        }

        active_findings_list = [f.model_dump(mode="json") for f in findings_resp.items]
        baselines_list = [b.model_dump(mode="json") for b in benchmarks.baselines]

        report_json = {
            "report_metadata": {
                "report_id": report_id,
                "generated_at": datetime.now(timezone.utc).isoformat(),
                "cse_id": str(cse_id),
                "cse_name": cse_summary.name,
                "sector": cse_summary.sector,
                "observation_period": {
                    "start": obs_start.isoformat() if obs_start else None,
                    "end": obs_end.isoformat() if obs_end else None,
                    "is_bounded": bool(obs_start or obs_end)
                }
            },
            "cse_profile": cse_profile,
            "telemetry_summary": telemetry_summary,
            "supervisory_signals_summary": signals_summary,
            "active_findings": active_findings_list,
            "peer_baselines": baselines_list
        }

        if format_type.lower() == "markdown":
            md_lines = [
                f"# SAT-SA Supervisory Executive Report",
                f"**Report ID:** `{report_id}`",
                f"**Generated At:** `{datetime.now(timezone.utc).isoformat()}`",
                f"**CSE Name:** {cse_summary.name} ({cse_summary.code})",
                f"**Sector:** {cse_summary.sector} | **Criticality Tier:** {cse_summary.criticality_tier}",
                "",
                "## 1. Operational Telemetry Summary",
                f"- **Total Assets:** {telemetry_summary.get('assets', 0)}",
                f"- **Total Alerts:** {telemetry_summary.get('alerts_total', 0)}",
                f"- **Total Cases:** {telemetry_summary.get('cases', 0)}",
                f"- **Total Investigations:** {telemetry_summary.get('investigations', 0)}",
                f"- **Total Escalations:** {telemetry_summary.get('escalations', 0)}",
                "",
                "## 2. Supervisory Signals Breakdown",
            ]
            for cat, count in signals_summary.items():
                disp_name = signals.signals[cat].display_name if cat in signals.signals else cat
                md_lines.append(f"- **{disp_name} ({cat}):** {count}")

            md_lines.extend([
                "",
                "## 3. Top Active Supervisory Findings",
            ])
            if active_findings_list:
                for item in active_findings_list:
                    md_lines.append(f"### `{item['finding_code']}` - {item['title']}")
                    md_lines.append(f"- **Category:** {item['category']} | **Severity:** {item['severity']} | **Status:** {item['status']}")
                    md_lines.append(f"- **Description:** {item['description']}")
                    md_lines.append(f"- **Rationale:** {item['rationale']}")
                    md_lines.append("")
            else:
                md_lines.append("_No findings present in the requested observation window._")

            md_lines.extend([
                "",
                "## 4. Peer Group Baselines",
                f"**Peer Group:** `{benchmarks.peer_group_name}` ({benchmarks.peer_group_status})",
            ])
            if baselines_list:
                for b in baselines_list:
                    md_lines.append(f"- **{b['metric_name']}:** Mean = `{b['baseline_value']:.4f}` (StdDev = `{b['std_dev']:.4f}`, N = {b['sample_size']})")
            else:
                md_lines.append("_No peer baselines persisted for the applicable sector or population._")

            return "\n".join(md_lines)

        return ReportJSONResponse(**report_json)

reporting_service = ReportingService()
