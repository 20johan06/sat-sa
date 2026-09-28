import type { ObservationPeriodSchema } from './common';

export type PeerGroupStatus = 'SECTOR_PEER_GROUP' | 'POPULATION_FALLBACK' | 'NO_APPLICABLE_BASELINE';

export interface PeerBaselineItemSchema {
  id: string;
  metric_name: string;
  peer_group: string;
  baseline_value: number;
  min_value?: number | null;
  max_value?: number | null;
  sample_size: number;
  std_dev: number;
  period_start: string;
  period_end: string;
}

export interface PeerBenchmarkResponse {
  cse_id: string;
  sector: string;
  peer_group_name: string;
  peer_group_status: PeerGroupStatus | string;
  n_sector_observations: number;
  observation_period: ObservationPeriodSchema;
  baselines: PeerBaselineItemSchema[];
}

export interface BenchmarkQueryParams {
  obs_start?: string;
  obs_end?: string;
}
