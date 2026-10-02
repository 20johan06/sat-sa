export interface TrendMetricItem {
  metric_name: string;
  rule_code?: string | null;
  category?: string | null;
  current_value?: number | null;
  previous_value?: number | null;
  historical_baseline?: number | null;
  absolute_change?: number | null;
  percentage_change?: number | null;
  evidence_strength: string;
  limitation?: string | null;
}

export interface FindingStatusTrendItem {
  status: string;
  current_count: number;
  previous_count: number;
  absolute_change: number;
}

export interface CapabilityTrendSummaryItem {
  capability: string;
  direct_findings_current: number;
  direct_findings_previous: number;
  indirect_signals_current: number;
  indirect_signals_previous: number;
}

export interface ObservationPeriod {
  start?: string | null;
  end?: string | null;
  is_bounded: boolean;
}

export interface CSETrendAnalysisResponse {
  cse_id: string;
  cse_code: string;
  cse_name: string;
  sector: string;
  criticality_tier: string;
  current_period: ObservationPeriod;
  previous_period?: ObservationPeriod | null;
  metrics: TrendMetricItem[];
  finding_status_trends: FindingStatusTrendItem[];
  capability_trends: CapabilityTrendSummaryItem[];
}
