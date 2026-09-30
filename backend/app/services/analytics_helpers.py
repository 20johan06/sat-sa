"""
Analytics Helper Utilities for Phase 5 Core Supervisory Analytics.
Provides deterministic evidence strength calculation and capability mapping according to V2 specification.
"""
from typing import Literal

EvidenceStrengthType = Literal["STRONG", "MODERATE", "LIMITED"]

def calculate_evidence_strength(
    sample_size: int,
    has_explicit_evidence: bool = True,
    baseline_quality: str = "HIGH",
    data_completeness_ratio: float = 1.0
) -> EvidenceStrengthType:
    """
    Deterministically calculates evidence strength (STRONG, MODERATE, LIMITED).
    
    - STRONG: Large sample size (>= 10), explicit linked evidence records, complete data.
    - MODERATE: Moderate sample size (3-9), valid evidence, complete or mostly complete data.
    - LIMITED: Small sample size (< 3) or incomplete telemetry coverage.
    """
    if sample_size >= 10 and has_explicit_evidence and data_completeness_ratio >= 0.8:
        return "STRONG"
    elif sample_size >= 3 and has_explicit_evidence and data_completeness_ratio >= 0.5:
        return "MODERATE"
    else:
        return "LIMITED"

def map_rule_to_capability(category: str, rule_code: str) -> str:
    """
    Deterministically maps analytics finding rules to 1 of 8 V2 capability dimensions:
    1. Threat Detection
    2. Investigation
    3. Escalation
    4. Incident Response
    5. Security Operations
    6. Governance and Oversight
    7. Operational Discipline
    8. Cyber Resilience
    """
    rule_code_upper = rule_code.upper()
    category_upper = category.upper()

    if "AN01" in rule_code_upper or "AN02" in rule_code_upper or "NS05" in rule_code_upper:
        return "Threat Detection"
    elif "EG03" in rule_code_upper or "EG04" in rule_code_upper or "EG05" in rule_code_upper:
        return "Investigation"
    elif "EG02" in rule_code_upper or "ESC" in rule_code_upper:
        return "Escalation"
    elif "EG01" in rule_code_upper or "EG06" in rule_code_upper or "OI01" in rule_code_upper:
        return "Incident Response"
    elif "NS01" in rule_code_upper or "NS06" in rule_code_upper:
        return "Security Operations"
    elif "BM01" in rule_code_upper:
        return "Governance and Oversight"
    elif category_upper == "EXECUTION_GAP":
        return "Operational Discipline"
    elif category_upper == "NEGATIVE_SPACE":
        return "Cyber Resilience"
    else:
        return "Operational Discipline"
