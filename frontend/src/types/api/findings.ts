import type { ObservationPeriodSchema, PaginationMeta } from './common';

export type FindingCategory = 'EXECUTION_GAP' | 'NEGATIVE_SPACE' | 'ANOMALY' | 'BENCHMARK';
export type CanonicalSeverity = 'CRITICAL' | 'HIGH' | 'MEDIUM' | 'LOW';

export interface FindingEvidenceResponse {
  id: string;
  finding_id: string;
  evidence_type: string;
  alert_id?: string | null;
  case_id?: string | null;
  investigation_id?: string | null;
  escalation_id?: string | null;
  coverage_id?: string | null;
  notes?: string | null;
  created_at: string;
}

export interface FindingReviewHistoryResponse {
  id: string;
  finding_id: string;
  user_id?: string | null;
  username?: string | null;
  user_role?: string | null;
  cse_id: string;
  action_type: string;
  previous_status?: string | null;
  new_status?: string | null;
  note_text?: string | null;
  evidence_request_details?: Record<string, unknown> | null;
  created_at: string;
}

export interface ExaminerNotePayload {
  note_text: string;
}

export interface EvidenceRequestPayload {
  note_text: string;
  required_data_types: string[];
  requested_time_window?: string;
  description?: string;
}

export interface ExplainabilitySchema {
  what: string;
  why: string;
  how: string;
  evidence: string;
  baseline: string;
  impact: string;
}

export interface FindingStatusUpdatePayload {
  status: string;
  notes?: string;
}

export interface FindingItemSchema {
  id: string;
  finding_code: string;
  cse_id: string;
  batch_id?: string | null;
  category: FindingCategory | string;
  severity: CanonicalSeverity | string;
  title: string;
  description: string;
  rationale: string;
  detection_method: string;
  metrics_json?: Record<string, unknown> | null;
  status: string;
  evidence_count: number;
  detected_at: string;
  explainability?: ExplainabilitySchema;
}

export interface FindingDetailSchema extends FindingItemSchema {
  evidence: FindingEvidenceResponse[];
  review_history?: FindingReviewHistoryResponse[];
}

export interface PaginatedFindingsResponse {
  items: FindingItemSchema[];
  pagination: PaginationMeta;
  observation_period: ObservationPeriodSchema;
}

export interface FindingQueryParams {
  cse_id?: string;
  category?: string;
  severity?: string;
  status?: string;
  rule_code?: string;
  obs_start?: string;
  obs_end?: string;
  page?: number;
  page_size?: number;
}
