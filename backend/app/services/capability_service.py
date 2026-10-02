import uuid
from datetime import datetime, timezone
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
from app.models.ingestion import IngestionBatch

from app.schemas.capability import (
    CapabilitySufficiencyStatus,
    EvidenceClassificationType,
    FindingCapabilitySummarySchema,
    CapabilityAssessmentItem,
    AssessmentContextSchema,
    EntityCapabilityAssessmentResponse
)
from app.schemas.reporting import ObservationPeriodSchema, ExplainabilitySchema
from app.services.analytics_helpers import calculate_evidence_strength
from app.utils.exceptions import EntityNotFoundException

SEVERITY_WEIGHTS = {"CRITICAL": 4, "HIGH": 3, "MEDIUM": 2, "LOW": 1, "NONE": 0}

# Authoritative V2 Phase 9 Capability Canonical Mapping
CAPABILITY_RULE_MAPPING: Dict[str, Dict[str, List[str]]] = {
    "Threat Detection": {
        "direct": [],
        "indirect": ["AN-01"]
    },
    "Investigation": {
        "direct": ["EG-03", "EG-04"],
        "indirect": []
    },
    "Escalation": {
        "direct": ["EG-02"],
        "indirect": ["NS-02"]
    },
    "Incident Response": {
        "direct": ["EG-01"],
        "indirect": ["EG-03"]
    },
    "Security Operations": {
        "direct": [],
        "indirect": ["EG-01", "AN-01"]
    },
    "Governance and Oversight": {
        "direct": [],
        "indirect": ["BM-01"]
    },
    "Operational Discipline": {
        "direct": ["EG-01", "EG-02", "EG-03", "EG-04"],
        "indirect": []
    },
    "Cyber Resilience": {
        "direct": ["NS-01"],
        "indirect": ["NS-02"]
    }
}

class CapabilityService:
    """
    Service handling Eight Capability Assessment derivations.
    Enforces factual, non-scoring, non-ranking capability evaluations
    strictly using canonical metrics_json['rule_code'] extraction.
    """

    @staticmethod
    def _extract_canonical_rule_code(f: Finding) -> Optional[str]:
        """
        Extracts canonical rule code exclusively from Finding.metrics_json['rule_code'].
        Does NOT infer or fallback to category, finding_code, or detection_method.
        """
        if f.metrics_json and isinstance(f.metrics_json, dict):
            return f.metrics_json.get("rule_code")
        return None

    @staticmethod
    def _check_telemetry_sufficiency(db: Session, cse_id: uuid.UUID) -> bool:
        """
        Checks whether minimum required operational telemetry exists for the CSE.
        Returns True if telemetry objects (alerts, cases, investigations, escalations, coverages, batches) exist.
        """
        alerts_cnt = db.query(Alert).filter(Alert.cse_id == cse_id).count()
        if alerts_cnt > 0:
            return True
        coverages_cnt = db.query(MonitoringCoverage).filter(MonitoringCoverage.cse_id == cse_id).count()
        if coverages_cnt > 0:
            return True
        batches_cnt = db.query(IngestionBatch).filter(IngestionBatch.cse_id == cse_id).count()
        if batches_cnt > 0:
            return True
        cases_cnt = db.query(Case).join(Alert, Case.alert_id == Alert.id).filter(Alert.cse_id == cse_id).count()
        if cases_cnt > 0:
            return True
        return False

    @classmethod
    def get_entity_capability_assessment(
        cls,
        db: Session,
        cse_id: uuid.UUID
    ) -> EntityCapabilityAssessmentResponse:
        """
        Generates Eight Capability Assessment response for a given CSE.
        """
        cse = db.query(CSE).filter(CSE.id == cse_id).first()
        if not cse:
            raise EntityNotFoundException("CSE", cse_id)

        has_telemetry = cls._check_telemetry_sufficiency(db, cse_id)

        # Retrieve all findings for CSE
        all_findings = db.query(Finding).filter(Finding.cse_id == cse_id).all()
        if len(all_findings) > 0:
            has_telemetry = True

        # Determine observation period
        if all_findings:
            start_date = min(f.detected_at for f in all_findings)
            end_date = max(f.detected_at for f in all_findings)
            is_bounded = True
        else:
            start_date = None
            end_date = None
            is_bounded = False

        obs_period = ObservationPeriodSchema(
            start=start_date,
            end=end_date,
            is_bounded=is_bounded
        )

        capability_items: List[CapabilityAssessmentItem] = []
        total_active_findings = 0
        evaluated_caps_count = 0
        insufficient_ev_caps_count = 0

        # Process all 8 capability dimensions in deterministic order
        for cap_name, rule_config in CAPABILITY_RULE_MAPPING.items():
            direct_rule_codes = rule_config["direct"]
            indirect_rule_codes = rule_config["indirect"]

            direct_findings_list: List[FindingCapabilitySummarySchema] = []
            indirect_findings_list: List[FindingCapabilitySummarySchema] = []

            for f in all_findings:
                rule_code = cls._extract_canonical_rule_code(f)
                if not rule_code:
                    continue

                evidence_cnt = db.query(FindingEvidence).filter(FindingEvidence.finding_id == f.id).count()

                summary_item = FindingCapabilitySummarySchema(
                    finding_id=f.id,
                    finding_code=f.finding_code,
                    canonical_rule_code=rule_code,
                    title=f.title,
                    category=f.category,
                    severity=f.severity,
                    status=f.status,
                    evidence_classification=EvidenceClassificationType.DIRECT if rule_code in direct_rule_codes else EvidenceClassificationType.INDIRECT,
                    detected_at=f.detected_at
                )

                if rule_code in direct_rule_codes:
                    direct_findings_list.append(summary_item)
                elif rule_code in indirect_rule_codes:
                    indirect_findings_list.append(summary_item)

            total_cap_findings = len(direct_findings_list) + len(indirect_findings_list)
            active_cap_findings = len([f for f in direct_findings_list + indirect_findings_list if f.status in ("NEW", "UNDER_REVIEW", "NEEDS_MORE_EVIDENCE", "CONFIRMED")])
            total_active_findings += active_cap_findings

            # Derive status indicator
            if total_cap_findings > 0:
                status_ind = CapabilitySufficiencyStatus.SUPERVISORY_FINDINGS_PRESENT
                status_desc = "Supervisory findings detected for evaluated canonical rules."
                evaluated_caps_count += 1
            elif has_telemetry:
                status_ind = CapabilitySufficiencyStatus.NO_FINDINGS_EVALUATED
                status_desc = "Evaluated from available telemetry; zero supervisory findings generated by canonical rules."
                evaluated_caps_count += 1
            else:
                status_ind = CapabilitySufficiencyStatus.INSUFFICIENT_EVIDENCE
                status_desc = "Insufficient telemetry or evidence available to evaluate canonical rules."
                insufficient_ev_caps_count += 1

            # Max severity calculation
            all_cap_severities = [f.severity for f in direct_findings_list + indirect_findings_list]
            if all_cap_severities:
                max_sev = max(all_cap_severities, key=lambda s: SEVERITY_WEIGHTS.get(s, 0))
            else:
                max_sev = "NONE"

            # Evidence count and distribution
            cap_finding_ids = [f.finding_id for f in direct_findings_list + indirect_findings_list]
            total_evidence_records = 0
            strength_dist = {"STRONG": 0, "MODERATE": 0, "LIMITED": 0}

            for f_id in cap_finding_ids:
                ev_cnt = db.query(FindingEvidence).filter(FindingEvidence.finding_id == f_id).count()
                total_evidence_records += ev_cnt
                strength = calculate_evidence_strength(sample_size=ev_cnt, has_explicit_evidence=ev_cnt > 0)
                strength_dist[strength] = strength_dist.get(strength, 0) + 1

            # Explainability
            explainability = ExplainabilitySchema(
                what=f"Assessment of {cap_name} capability dimension across canonical supervisory analytics rules.",
                why=f"Evaluation based on {len(direct_rule_codes)} direct canonical rule(s) and {len(indirect_rule_codes)} indirect signal rule(s).",
                how=f"Direct findings: {len(direct_findings_list)}, Indirect associated signals: {len(indirect_findings_list)}.",
                evidence=f"{total_evidence_records} total operational evidence record(s) linked across capability findings.",
                baseline="Canonical V2 supervisory baseline standards for SOC capability evaluation.",
                impact=f"Status: {status_ind.value}. Maximum finding severity: {max_sev}."
            )

            cap_item = CapabilityAssessmentItem(
                capability=cap_name,
                status_indicator=status_ind,
                status_description=status_desc,
                direct_rules_evaluated=direct_rule_codes,
                indirect_signals_evaluated=indirect_rule_codes,
                direct_findings=direct_findings_list,
                indirect_findings=indirect_findings_list,
                active_findings_count=active_cap_findings,
                max_severity=max_sev,
                evidence_count=total_evidence_records,
                evidence_strength_distribution=strength_dist,
                explainability=explainability
            )

            capability_items.append(cap_item)

        return EntityCapabilityAssessmentResponse(
            cse_id=cse.id,
            cse_code=cse.cse_code,
            cse_name=cse.name,
            sector=cse.sector,
            criticality_tier=cse.criticality_tier,
            assessment_context=AssessmentContextSchema(
                assessment_id=uuid.uuid4()
            ),
            observation_period=obs_period,
            capabilities=capability_items,
            total_active_findings=total_active_findings,
            evaluated_capabilities_count=evaluated_caps_count,
            insufficient_evidence_capabilities_count=insufficient_ev_caps_count
        )

    @classmethod
    def get_capability_detail(
        cls,
        db: Session,
        cse_id: uuid.UUID,
        capability_name: str
    ) -> CapabilityAssessmentItem:
        """
        Retrieves detail for a single capability dimension for a CSE.
        """
        assessment = cls.get_entity_capability_assessment(db, cse_id)
        for cap in assessment.capabilities:
            if cap.capability.lower() == capability_name.lower():
                return cap
        raise EntityNotFoundException("CapabilityDimension", capability_name)

capability_service = CapabilityService()
