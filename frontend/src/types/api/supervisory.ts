import type { ObservationPeriodSchema } from './common';

export interface SupervisoryAttentionIndicators {
  active_findings_count: number;
  active_critical_findings_count: number;
  active_high_findings_count: number;
  high_attention_findings_count: number;
  execution_gap_findings_count: number;
  negative_space_findings_count: number;
  anomaly_findings_count: number;
  benchmark_deviations_count: number;
  evidence_strength_distribution: Record<string, number>;
  affected_record_count: number;
  affected_critical_high_records: number;
  peer_deviations_count: number;
  repeated_signals_count: number;
}

export interface ExplainableRationale {
  what: string;
  why: string;
  how: string;
  evidence: string;
  baseline: string;
  impact: string;
}

export interface SupervisoryAttentionItem {
  cse_id: string;
  cse_code: string;
  cse_name: string;
  sector: string;
  criticality_tier: string;
  indicators: SupervisoryAttentionIndicators;
  dominant_categories: string[];
  latest_analysis_run_at: string | null;
  observation_period: ObservationPeriodSchema;
  concise_rationale: ExplainableRationale;
  drilldown_context: Record<string, any>;
}

export interface SupervisoryAttentionQueueResponse {
  items: SupervisoryAttentionItem[];
  total_cses: number;
  total_cses_with_active_findings: number;
  total_active_findings: number;
  total_critical_findings: number;
  total_high_findings: number;
  observation_period: ObservationPeriodSchema;
}

export interface CapabilityBreakdown {
  capability: string;
  findings_count: number;
  max_severity: string;
  evidence_count: number;
}

export interface EntitySupervisoryOverviewResponse {
  cse_id: string;
  code: string;
  name: string;
  sector: string;
  criticality_tier: string;
  indicators: SupervisoryAttentionIndicators;
  findings_by_category: Record<string, number>;
  findings_by_severity: Record<string, number>;
  evidence_strength_distribution: Record<string, number>;
  capabilities_breakdown: CapabilityBreakdown[];
  peer_benchmarks_summary: Record<string, any>;
  observation_period: ObservationPeriodSchema;
  latest_analysis_run: Record<string, any> | null;
  data_quality_limitations: string[];
  why_attention: ExplainableRationale;
}
