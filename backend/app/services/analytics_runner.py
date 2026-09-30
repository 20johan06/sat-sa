import uuid
from datetime import datetime, timezone
from typing import List, Tuple, Optional
from sqlalchemy.orm import Session

from app.models.cse import CSE
from app.models.finding import Finding, FindingEvidence
from app.models.baseline import PeerBaseline
from app.models.analysis_run import AnalysisRun
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
    Orchestrates the Canonical Phase 5 Supervisory Analytics Engine pipeline for a target CSE.
    Evaluates the 8 canonical rules: EG-01, EG-02, EG-03, EG-04, NS-01, NS-02, AN-01, BM-01.
    Persists AnalysisRun execution trace, findings, and traceable finding_evidence records.
    Generates a decomposable SupervisorySignalMatrix.
    """

    @staticmethod
    def run_analytics(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None,
        batch_id: Optional[uuid.UUID] = None,
        assessment_id: Optional[uuid.UUID] = None,
        dataset_version_id: Optional[uuid.UUID] = None,
        executed_by_user_id: Optional[uuid.UUID] = None
    ) -> AnalyticsRunResult:
        # 1. Verify target CSE exists
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        # 2. Create AnalysisRun execution record
        now_utc = datetime.now(timezone.utc)
        run_record = AnalysisRun(
            id=uuid.uuid4(),
            cse_id=cse_id,
            assessment_id=assessment_id,
            dataset_version_id=dataset_version_id,
            obs_start=obs_start,
            obs_end=obs_end,
            engine_version="v2.0.0-phase5-canonical",
            rules_evaluated=[
                "EG-01", "EG-02", "EG-03", "EG-04",
                "NS-01", "NS-02", "AN-01", "BM-01"
            ],
            status="RUNNING",
            findings_created=0,
            baselines_persisted=0,
            started_at=now_utc,
            executed_by_user_id=executed_by_user_id
        )
        db.add(run_record)
        db.flush()

        all_findings_with_evidence: List[Tuple[Finding, List[FindingEvidence]]] = []

        try:
            # 3. Run Execution Gap Analyzer (Canonical Rules EG-01 to EG-04)
            eg01 = ExecutionGapAnalyzer.analyze_eg01_critical_alert_workflow(db, cse_id, batch_id)
            eg02 = ExecutionGapAnalyzer.analyze_eg02_critical_incident_escalation(db, cse_id, batch_id)
            eg03 = ExecutionGapAnalyzer.analyze_eg03_rapid_case_closure(db, cse_id, obs_start, obs_end, batch_id)
            eg04 = ExecutionGapAnalyzer.analyze_eg04_repeated_investigations(db, cse_id, obs_start, obs_end, batch_id)

            all_findings_with_evidence.extend(eg01)
            all_findings_with_evidence.extend(eg02)
            all_findings_with_evidence.extend(eg03)
            all_findings_with_evidence.extend(eg04)

            # 4. Run Negative Space Analyzer (Canonical Rules NS-01 to NS-02)
            ns01 = NegativeSpaceAnalyzer.analyze_ns01_inactive_expected_coverage(db, cse_id, obs_start, obs_end, batch_id)
            ns02 = NegativeSpaceAnalyzer.analyze_ns02_absent_high_priority_escalation(db, cse_id, batch_id)

            all_findings_with_evidence.extend(ns01)
            all_findings_with_evidence.extend(ns02)

            # 5. Run Anomaly Analyzer (Canonical Rule AN-01)
            an01 = AnomalyAnalyzer.analyze_an01_daily_alert_volume(db, cse_id, obs_start, obs_end, batch_id)
            all_findings_with_evidence.extend(an01)

            # 6. Run Peer Benchmark Analyzer (Canonical Rule BM-01)
            baselines, bm01 = BenchmarkAnalyzer.analyze_bm01_peer_benchmarks(db, cse_id, obs_start, obs_end, batch_id)
            all_findings_with_evidence.extend(bm01)

            # 7. Persist PeerBaselines
            db.add_all(baselines)

            # 8. Persist Findings & Traceable FindingEvidence
            created_findings_count = 0
            for finding, evidences in all_findings_with_evidence:
                finding.analysis_run_id = run_record.id
                existing = db.query(Finding).filter(Finding.finding_code == finding.finding_code).first()
                if existing:
                    continue

                db.add(finding)
                db.flush()

                for ev in evidences:
                    ev.finding_id = finding.id
                    db.add(ev)

                created_findings_count += 1

            # Update AnalysisRun status
            run_record.status = "SUCCESS"
            run_record.findings_created = created_findings_count
            run_record.baselines_persisted = len(baselines)
            run_record.completed_at = datetime.now(timezone.utc)

            db.commit()

        except Exception as e:
            db.rollback()
            run_record.status = "FAILED"
            run_record.error_message = str(e)
            run_record.completed_at = datetime.now(timezone.utc)
            db.add(run_record)
            db.commit()
            raise e

        # 9. Query all findings for CSE to build Supervisory Signal Matrix
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
