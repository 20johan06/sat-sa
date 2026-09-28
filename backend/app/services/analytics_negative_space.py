import uuid
from datetime import datetime, timezone
from typing import List, Tuple, Optional
from sqlalchemy.orm import Session
from app.models.coverage import MonitoringCoverage
from app.models.finding import Finding, FindingEvidence

class NegativeSpaceAnalyzer:
    """
    Analyzes operational evidence for Negative Space signals (NS-01 to NS-02).
    """

    @staticmethod
    def analyze_ns01_inactive_expected_coverage(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime] = None,
        obs_end: Optional[datetime] = None,
        batch_id: Optional[uuid.UUID] = None
    ) -> List[Tuple[Finding, List[FindingEvidence]]]:
        """
        NS-01: Expected Log Source Coverage Inactive.
        Strictly requires an explicit MonitoringCoverage record with is_expected == True.
        """
        query = db.query(MonitoringCoverage).filter(
            MonitoringCoverage.cse_id == cse_id,
            MonitoringCoverage.is_expected == True
        )

        coverages = query.all()
        results: List[Tuple[Finding, List[FindingEvidence]]] = []

        now_utc = datetime.now(timezone.utc)

        for cov in coverages:
            is_inactive = (cov.is_active == False)
            is_stale = False
            if cov.period_end and cov.period_end < now_utc and cov.last_received_at is None:
                is_stale = True

            if is_inactive or is_stale:
                finding_code = f"FND-NS01-{cse_id.hex[:6]}-{cov.id.hex[:6]}"

                existing = db.query(Finding).filter(Finding.finding_code == finding_code).first()
                if existing:
                    continue

                reason_str = "marked inactive" if is_inactive else "no telemetry received in expected period"

                finding = Finding(
                    id=uuid.uuid4(),
                    finding_code=finding_code,
                    cse_id=cse_id,
                    batch_id=batch_id,
                    category="NEGATIVE_SPACE",
                    severity="HIGH",
                    title="Expected Log Source Coverage Inactive",
                    description=(
                        f"Log source category '{cov.log_source_category}' is explicitly configured "
                        f"as expected (is_expected=True), but is currently {reason_str}."
                    ),
                    rationale=(
                        f"Expected monitoring category '{cov.log_source_category}' lacks active log collection, "
                        "representing an operational monitoring blind spot."
                    ),
                    detection_method="EXPLICIT_COVERAGE_CHECK",
                    metrics_json={
                        "coverage_id": str(cov.id),
                        "log_source_category": cov.log_source_category,
                        "is_expected": cov.is_expected,
                        "is_active": cov.is_active,
                        "coverage_percentage": cov.coverage_percentage,
                        "last_received_at": cov.last_received_at.isoformat() if cov.last_received_at else None
                    },
                    status="NEW"
                )

                evidence = FindingEvidence(
                    id=uuid.uuid4(),
                    evidence_type="COVERAGE",
                    coverage_id=cov.id,
                    notes=f"Coverage evidence: category '{cov.log_source_category}' expected but inactive/stale."
                )

                results.append((finding, [evidence]))

        return results

    @staticmethod
    def analyze_ns02_absent_high_priority_escalation(
        db: Session,
        cse_id: uuid.UUID,
        batch_id: Optional[uuid.UUID] = None
    ) -> List[Tuple[Finding, List[FindingEvidence]]]:
        """
        NS-02: Absent Escalation Evidence for High-Priority Incident Case.
        Constraint: Requires explicit high-priority escalation expectation flag (requires_high_priority_escalation).
        Returns EXPECTATION_NOT_CONFIGURED in locked schema.
        """
        # Explicit expectation is unconfigured in current schema
        return []
