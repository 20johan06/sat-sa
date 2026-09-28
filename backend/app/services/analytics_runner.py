import uuid
from datetime import datetime
from typing import List, Tuple, Optional
from sqlalchemy.orm import Session
from app.models.cse import CSE
from app.models.finding import Finding, FindingEvidence
from app.models.baseline import PeerBaseline
from app.schemas.analytics import (
    AnalyticsRunResult,
    SupervisorySignalMatrix,
    SignalCounts,
    SeverityBreakdown,
    ObservationPeriodSchema
)
from app.services.analytics_execution_gaps import ExecutionGapAnalyzer
from app.services.analytics_negative_space import NegativeSpaceAnalyzer
from app.services.analytics_anomalies import AnomalyAnalyzer
from app.services.analytics_benchmarks import BenchmarkAnalyzer
from app.utils.exceptions import EntityNotFoundException

class AnalyticsRunnerService:
    """
    Orchestrates the Phase 5 Analytics Engine pipeline for a target CSE.
    Runs execution gap, negative space, anomaly, and benchmarking modules.
    Persists findings and traceable finding_evidence records.
    Generates a decomposable SupervisorySignalMatrix.
    """

    @staticmethod
    def run_analytics(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None,
        batch_id: Optional[uuid.UUID] = None
    ) -> AnalyticsRunResult:
        # 1. Verify target CSE exists
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        all_findings_with_evidence: List[Tuple[Finding, List[FindingEvidence]]] = []

        # 2. Run Execution Gap Analyzer
        eg01 = ExecutionGapAnalyzer.analyze_eg01_critical_alert_workflow(db, cse_id, batch_id)
        eg02 = ExecutionGapAnalyzer.analyze_eg02_critical_incident_escalation(db, cse_id, batch_id)
        eg03 = ExecutionGapAnalyzer.analyze_eg03_rapid_case_closure(db, cse_id, obs_start, obs_end, batch_id)
        eg04 = ExecutionGapAnalyzer.analyze_eg04_repeated_investigations(db, cse_id, obs_start, obs_end, batch_id)

        all_findings_with_evidence.extend(eg01)
        all_findings_with_evidence.extend(eg02)
        all_findings_with_evidence.extend(eg03)
        all_findings_with_evidence.extend(eg04)

        # 3. Run Negative Space Analyzer
        ns01 = NegativeSpaceAnalyzer.analyze_ns01_inactive_expected_coverage(db, cse_id, obs_start, obs_end, batch_id)
        ns02 = NegativeSpaceAnalyzer.analyze_ns02_absent_high_priority_escalation(db, cse_id, batch_id)

        all_findings_with_evidence.extend(ns01)
        all_findings_with_evidence.extend(ns02)

        # 4. Run Anomaly Analyzer
        an01 = AnomalyAnalyzer.analyze_an01_daily_alert_volume(db, cse_id, obs_start, obs_end, batch_id)
        all_findings_with_evidence.extend(an01)

        # 5. Run Peer Benchmark Analyzer
        baselines, bm01 = BenchmarkAnalyzer.analyze_bm01_peer_benchmarks(db, cse_id, obs_start, obs_end, batch_id)
        all_findings_with_evidence.extend(bm01)

        # 6. Persist PeerBaselines
        db.add_all(baselines)

        # 7. Persist Findings & Traceable FindingEvidence
        created_findings_count = 0
        for finding, evidences in all_findings_with_evidence:
            # Check duplicate finding code
            existing = db.query(Finding).filter(Finding.finding_code == finding.finding_code).first()
            if existing:
                continue

            db.add(finding)
            db.flush()  # Flush to get finding.id

            for ev in evidences:
                ev.finding_id = finding.id
                db.add(ev)

            created_findings_count += 1

        db.commit()

        # 8. Query all findings for CSE to build Supervisory Signal Matrix
        cse_findings = db.query(Finding).filter(Finding.cse_id == cse_id).all()

        signal_counts = SignalCounts(
            evidence_gaps=sum(1 for f in cse_findings if f.category in ("EXECUTION_GAP", "NEGATIVE_SPACE") and f.severity in ("HIGH", "CRITICAL")),
            statistical_anomalies=sum(1 for f in cse_findings if f.category == "ANOMALY"),
            benchmark_deviations=sum(1 for f in cse_findings if f.category == "BENCHMARK"),
            supervisory_signals=sum(1 for f in cse_findings if f.severity == "LOW" or f.detection_method == "PATTERN_REPETITION")
        )

        severity_breakdown = SeverityBreakdown(
            critical=sum(1 for f in cse_findings if f.severity == "CRITICAL"),
            high=sum(1 for f in cse_findings if f.severity == "HIGH"),
            medium=sum(1 for f in cse_findings if f.severity == "MEDIUM"),
            low=sum(1 for f in cse_findings if f.severity == "LOW")
        )

        matrix = SupervisorySignalMatrix(
            cse_id=cse_id,
            observation_period=ObservationPeriodSchema(start=obs_start, end=obs_end),
            signal_counts=signal_counts,
            severity_breakdown=severity_breakdown,
            data_sufficiency_status="SUFFICIENT" if len(cse_findings) > 0 else "NO_FINDINGS_SUFFICIENT"
        )

        return AnalyticsRunResult(
            cse_id=cse_id,
            findings_created=created_findings_count,
            baselines_created=len(baselines),
            signal_matrix=matrix
        )
