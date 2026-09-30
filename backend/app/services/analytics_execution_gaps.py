import uuid
import math
import datetime
from typing import List, Tuple, Optional, Dict
from sqlalchemy.orm import Session
from app.models.case import Case
from app.models.investigation import Investigation
from app.models.finding import Finding, FindingEvidence
from app.config.analytics_settings import analytics_settings
from app.services.analytics_helpers import calculate_evidence_strength, map_rule_to_capability

def _calculate_p5(values: List[float]) -> float:
    """Calculates 5th percentile of a list of floats using linear interpolation."""
    if not values:
        return 0.0
    sorted_vals = sorted(values)
    k = (len(sorted_vals) - 1) * 0.05
    f = math.floor(k)
    c = math.ceil(k)
    if f == c:
        return float(sorted_vals[int(k)])
    return float(sorted_vals[int(f)] * (c - k) + sorted_vals[int(c)] * (k - f))

class ExecutionGapAnalyzer:
    """
    Analyzes operational evidence for Canonical Execution Gaps (EG-01 to EG-04).
    """

    @staticmethod
    def analyze_eg01_critical_alert_workflow(
        db: Session,
        cse_id: uuid.UUID,
        batch_id: Optional[uuid.UUID] = None
    ) -> List[Tuple[Finding, List[FindingEvidence]]]:
        """
        EG-01: Expectation-based Execution/Evidence Gap.
        Requires explicit workflow expectation configuration (requires_case_workflow).
        Returns NO FINDING when workflow expectation is unconfigured (state EXPECTATION_NOT_CONFIGURED).
        """
        # Explicit workflow expectation is unconfigured in base schema.
        return []

    @staticmethod
    def analyze_eg02_critical_incident_escalation(
        db: Session,
        cse_id: uuid.UUID,
        batch_id: Optional[uuid.UUID] = None
    ) -> List[Tuple[Finding, List[FindingEvidence]]]:
        """
        EG-02: Expectation-based Escalation Evidence Gap.
        Requires explicit escalation expectation configuration (requires_escalation).
        Returns NO FINDING when escalation expectation is unconfigured (state EXPECTATION_NOT_CONFIGURED).
        """
        # Explicit escalation expectation is unconfigured in base schema.
        return []

    @staticmethod
    def analyze_eg03_rapid_case_closure(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime.datetime] = None,
        obs_end: Optional[datetime.datetime] = None,
        batch_id: Optional[uuid.UUID] = None
    ) -> List[Tuple[Finding, List[FindingEvidence]]]:
        """
        EG-03: Statistically Rapid Case Closure.
        Uses runtime lower-tail 5th percentile (P5) from observed case resolution durations.
        Enforces minimum sample size N >= 10 closed cases.
        """
        query = db.query(Case).filter(
            Case.cse_id == cse_id,
            Case.closed_at.isnot(None),
            Case.opened_at.isnot(None)
        )
        if obs_start:
            query = query.filter(Case.closed_at >= obs_start)
        if obs_end:
            query = query.filter(Case.closed_at <= obs_end)

        closed_cases = query.all()
        if len(closed_cases) < analytics_settings.MIN_CASE_DURATION_SAMPLE_SIZE:
            return []

        durations = [(c, (c.closed_at - c.opened_at).total_seconds()) for c in closed_cases]
        valid_durations = [(c, d) for c, d in durations if d >= 0]

        if len(valid_durations) < analytics_settings.MIN_CASE_DURATION_SAMPLE_SIZE:
            return []

        raw_seconds = [d for _, d in valid_durations]
        p5_cutoff = _calculate_p5(raw_seconds)

        rapid_cases = [(c, d) for c, d in valid_durations if d < p5_cutoff]

        results: List[Tuple[Finding, List[FindingEvidence]]] = []
        sample_size = len(valid_durations)
        ev_strength = calculate_evidence_strength(sample_size=sample_size, has_explicit_evidence=True)
        capability = map_rule_to_capability(category="EXECUTION_GAP", rule_code="EG03")

        for case_obj, duration in rapid_cases:
            finding_code = f"FND-EG03-{cse_id.hex[:6]}-{case_obj.id.hex[:6]}"

            existing = db.query(Finding).filter(Finding.finding_code == finding_code).first()
            if existing:
                continue

            finding = Finding(
                id=uuid.uuid4(),
                finding_code=finding_code,
                cse_id=cse_id,
                batch_id=batch_id,
                category="EXECUTION_GAP",
                severity="MEDIUM",
                title="Statistically Rapid Case Closure",
                description=(
                    f"Case '{case_obj.external_case_id}' was resolved in {duration:.1f} seconds, "
                    f"which is below the 5th percentile baseline cutoff ({p5_cutoff:.1f} seconds) "
                    f"of observed case resolution durations for this entity."
                ),
                rationale=(
                    f"Statistically rapid resolution (< P5 cutoff of {p5_cutoff:.1f}s across N={sample_size} cases) "
                    "indicates potential superficial handling requiring supervisory review."
                ),
                detection_method="P5_PERCENTILE",
                metrics_json={
                    "rule_code": "EG-03",
                    "metric": "case_resolution_duration_seconds",
                    "case_id": str(case_obj.id),
                    "duration_seconds": duration,
                    "p5_cutoff_seconds": p5_cutoff,
                    "observed_value": round(duration, 1),
                    "baseline_value": round(p5_cutoff, 1),
                    "deviation": round(p5_cutoff - duration, 1),
                    "percentile_method": "P5_LINEAR_INTERPOLATION",
                    "sample_size": sample_size,
                    "external_case_id": case_obj.external_case_id,
                    "evidence_strength": ev_strength,
                    "capability": capability,
                    "supervisory_relevance": "Unusually rapid case closure indicates potential superficial investigation or hasty disposition."
                },
                status="NEW"
            )

            evidence = FindingEvidence(
                id=uuid.uuid4(),
                evidence_type="CASE",
                case_id=case_obj.id,
                notes=f"Rapid closure evidence: duration {duration:.1f}s < P5 threshold {p5_cutoff:.1f}s."
            )
            results.append((finding, [evidence]))

        return results

    @staticmethod
    def analyze_eg04_repeated_investigations(
        db: Session,
        cse_id: uuid.UUID,
        obs_start: Optional[datetime.datetime] = None,
        obs_end: Optional[datetime.datetime] = None,
        batch_id: Optional[uuid.UUID] = None
    ) -> List[Tuple[Finding, List[FindingEvidence]]]:
        """
        EG-04: Repeated Investigation Pattern Detected.
        Supervisory review signal based on exact matching investigation notes across >= 3 distinct cases.
        Configurable review threshold (default N >= 3 distinct cases).
        """
        query = db.query(Investigation).join(Case).filter(Case.cse_id == cse_id)
        if obs_start:
            query = query.filter(Investigation.started_at >= obs_start)
        if obs_end:
            query = query.filter(Investigation.started_at <= obs_end)

        investigations = query.all()

        note_map: Dict[str, List[Investigation]] = {}
        for inv in investigations:
            if inv.notes and len(inv.notes.strip()) > 15:
                clean_note = inv.notes.strip()
                note_map.setdefault(clean_note, []).append(inv)

        results: List[Tuple[Finding, List[FindingEvidence]]] = []

        for note_text, inv_list in note_map.items():
            distinct_case_ids = {inv.case_id for inv in inv_list}
            if len(distinct_case_ids) >= analytics_settings.REPETITION_REVIEW_THRESHOLD:
                hash_snippet = uuid.uuid5(uuid.NAMESPACE_DNS, note_text).hex[:8]
                finding_code = f"FND-EG04-{cse_id.hex[:6]}-{hash_snippet}"

                existing = db.query(Finding).filter(Finding.finding_code == finding_code).first()
                if existing:
                    continue

                sample_size = len(distinct_case_ids)
                ev_strength = calculate_evidence_strength(sample_size=sample_size, has_explicit_evidence=True)
                capability = map_rule_to_capability(category="EXECUTION_GAP", rule_code="EG04")

                finding = Finding(
                    id=uuid.uuid4(),
                    finding_code=finding_code,
                    cse_id=cse_id,
                    batch_id=batch_id,
                    category="EXECUTION_GAP",
                    severity="LOW",
                    title="Repeated Investigation Pattern Detected",
                    description=(
                        f"Repeated investigation pattern detected across {sample_size} distinct cases. "
                        f"Pattern snippet: '{note_text[:100]}...'"
                    ),
                    rationale=(
                        f"Identical investigation notes observed in {sample_size} distinct cases "
                        f"(exceeding review threshold of {analytics_settings.REPETITION_REVIEW_THRESHOLD}). "
                        "This signal is provided for supervisory review of investigation thoroughness."
                    ),
                    detection_method="PATTERN_REPETITION",
                    metrics_json={
                        "rule_code": "EG-04",
                        "metric": "repeated_investigation_notes",
                        "observed_value": sample_size,
                        "baseline_value": analytics_settings.REPETITION_REVIEW_THRESHOLD,
                        "repetition_threshold": analytics_settings.REPETITION_REVIEW_THRESHOLD,
                        "deviation": sample_size - analytics_settings.REPETITION_REVIEW_THRESHOLD,
                        "method": "TEXT_EXACT_HASH_MATCH",
                        "distinct_cases_count": sample_size,
                        "total_investigations": len(inv_list),
                        "sample_investigation_ids": [str(i.id) for i in inv_list[:10]],
                        "evidence_strength": ev_strength,
                        "capability": capability,
                        "supervisory_relevance": "Template or copy-paste investigation text across multiple cases may indicate superficial investigation."
                    },
                    status="NEW"
                )

                evidences: List[FindingEvidence] = []
                for inv in inv_list:
                    ev = FindingEvidence(
                        id=uuid.uuid4(),
                        evidence_type="INVESTIGATION",
                        investigation_id=inv.id,
                        case_id=inv.case_id,
                        notes="Repeated investigation pattern evidence."
                    )
                    evidences.append(ev)

                results.append((finding, evidences))

        return results
