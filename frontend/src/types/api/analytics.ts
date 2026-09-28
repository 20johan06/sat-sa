import type { ObservationPeriodSchema } from './common';

export interface AnalyticsRunRequest {
  obs_start?: string | null;
  obs_end?: string | null;
  batch_id?: string | null;
}

export interface AnalyticsRunResultSchema {
  cse_id: string;
  observation_period: ObservationPeriodSchema;
  rules_evaluated: string[];
  findings_created: number;
  findings_deduplicated: number;
  baselines_persisted: number;
  data_sufficiency_by_rule: Record<string, string>;
  executed_at: string;
}

export interface SignalFindingItem {
  finding_id: string;
  finding_code: string;
  title: string;
  severity: string;
  detected_at: string;
}

export interface SignalGroupSchema {
  display_name: string;
  count: number;
  max_severity?: string | null;
  findings: SignalFindingItem[];
}

export interface SignalMatrixResponse {
  cse_id: string;
  observation_period: ObservationPeriodSchema;
  data_sufficiency_status: string; // "SUFFICIENT" | "NO_FINDINGS"
  signals: Record<string, SignalGroupSchema>;
}
