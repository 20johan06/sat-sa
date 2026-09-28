import type { ObservationPeriodSchema } from './common';

export type ReportFormat = 'json' | 'markdown';

export interface ReportMetadata {
  report_id: string;
  generated_at: string;
  cse_id: string;
  cse_name: string;
  sector: string;
  observation_period: ObservationPeriodSchema;
}

export interface ReportJSONResponse {
  report_metadata: ReportMetadata | Record<string, unknown>;
  cse_profile: Record<string, unknown>;
  telemetry_summary: Record<string, unknown>;
  supervisory_signals_summary: Record<string, unknown>;
  active_findings: Record<string, unknown>[];
  peer_baselines: Record<string, unknown>[];
}

export interface ReportQueryParams {
  format?: ReportFormat;
  obs_start?: string;
  obs_end?: string;
}
