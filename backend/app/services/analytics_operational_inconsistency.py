import uuid
import datetime
from typing import List, Tuple, Optional
from sqlalchemy.orm import Session
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.finding import Finding, FindingEvidence
from app.services.analytics_helpers import calculate_evidence_strength, map_rule_to_capability

class OperationalInconsistencyAnalyzer:
    """
    Analyzes operational evidence for Inconsistencies (OI-01).
    Detects evidence linkage gaps (e.g. Case closed as resolved with 0 linked investigations).
    """

    @staticmethod
    def analyze_oi01_evidence_linkage_gaps(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime.datetime] = None,
        obs_end: Optional[datetime.datetime] = None,
        batch_id: Optional[uuid.UUID] = None
    ) -> List[Tuple[Finding, List[FindingEvidence]]]:
        """
        OI-01: Operational Evidence Inconsistency.
        Detects closed/resolved cases that possess ZERO linked investigation records.
        """
        query = db.query(Case).filter(
            Case.cse_id == cse_id,
            Case.closed_at.isnot(None)
        )
        if obs_start:
            query = query.filter(Case.closed_at >= obs_start)
        if obs_end:
            query = query.filter(Case.closed_at <= obs_end)

        closed_cases = query.all()
        results: List[Tuple[Finding, List[FindingEvidence]]] = []

        for case_obj in closed_cases:
            investigation_count = db.query(Investigation).filter(Investigation.case_id == case_obj.id).count()
            if investigation_count == 0:
                date_tag = obs_start.strftime("%Y%m%d") if obs_start else "obs"
                finding_code = f"FND-OI01-{cse_id.hex[:6]}-{case_obj.id.hex[:6]}-{date_tag}"

                existing = db.query(Finding).filter(Finding.finding_code == finding_code).first()
                if existing:
                    continue

                ev_strength = calculate_evidence_strength(sample_size=1, has_explicit_evidence=True)
                capability = map_rule_to_capability(category="EXECUTION_GAP", rule_code="OI01")

                finding = Finding(
                    id=uuid.uuid4(),
                    finding_code=finding_code,
                    cse_id=cse_id,
                    batch_id=batch_id,
                    category="EXECUTION_GAP",
                    severity="MEDIUM",
                    title="Operational Evidence Inconsistency",
                    description=(
                        f"Case '{case_obj.external_case_id}' was closed as resolved, "
                        "but possesses zero linked investigation activity records."
                    ),
                    rationale=(
                        f"Resolved case '{case_obj.external_case_id}' lacks supporting investigation evidence, "
                        "representing an operational documentation inconsistency requiring supervisory review."
                    ),
                    detection_method="EVIDENCE_LINKAGE_CHECK",
                    metrics_json={
                        "rule_code": "OI-01",
                        "metric": "linked_investigation_count",
                        "observed_value": 0,
                        "baseline_value": ">= 1 expected investigation",
                        "affected_case_id": str(case_obj.id),
                        "external_case_id": case_obj.external_case_id,
                        "evidence_strength": ev_strength,
                        "capability": capability,
                        "supervisory_relevance": "Case closure without logged investigation evidence indicates potential administrative bypass."
                    },
                    status="NEW"
                )

                evidence = FindingEvidence(
                    id=uuid.uuid4(),
                    evidence_type="CASE",
                    case_id=case_obj.id,
                    notes=f"Inconsistency evidence: case {case_obj.external_case_id} closed without investigation logs."
                )

                results.append((finding, [evidence]))

        return results
