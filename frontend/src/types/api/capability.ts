export type CapabilitySufficiencyStatus =
  | 'SUPERVISORY_FINDINGS_PRESENT'
  | 'NO_FINDINGS_EVALUATED'
  | 'INSUFFICIENT_EVIDENCE';

export type EvidenceClassificationType = 'DIRECT' | 'INDIRECT';

export interface FindingCapabilitySummary {
  finding_id: string;
  finding_code: string;
  canonical_rule_code: string;
  title: string;
  category: string;
  severity: string;
  status: string;
  evidence_classification: EvidenceClassificationType;
  detected_at: string;
}

export interface Explainability {
  what: string;
  why: string;
  how: string;
  evidence: string;
  baseline: string;
  impact: string;
}

export interface CapabilityAssessmentItem {
  capability: string;
  status_indicator: CapabilitySufficiencyStatus;
  status_description: string;
  direct_rules_evaluated: string[];
  indirect_signals_evaluated: string[];
  direct_findings: FindingCapabilitySummary[];
  indirect_findings: FindingCapabilitySummary[];
  active_findings_count: number;
  max_severity: string;
  evidence_count: number;
  evidence_strength_distribution: Record<string, number>;
  explainability: Explainability;
}

export interface ObservationPeriod {
  start?: string | null;
  end?: string | null;
  is_bounded: boolean;
}

export interface AssessmentContext {
  assessment_id?: string;
  dataset_version_id?: string;
  analysis_run_id?: string;
}

export interface EntityCapabilityAssessmentResponse {
  cse_id: string;
  cse_code: string;
  cse_name: string;
  sector: string;
  criticality_tier: string;
  assessment_context?: AssessmentContext;
  observation_period: ObservationPeriod;
  capabilities: CapabilityAssessmentItem[];
  total_active_findings: number;
  evaluated_capabilities_count: number;
  insufficient_evidence_capabilities_count: number;
}
