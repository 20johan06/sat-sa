export interface CSEBase {
  cse_code: string;
  name: string;
  sector: string;
  criticality_tier: string;
  contact_email?: string | null;
  is_active: boolean;
}

export type CSECreate = CSEBase;

export interface CSEUpdate {
  name?: string;
  sector?: string;
  criticality_tier?: string;
  contact_email?: string;
  is_active?: boolean;
}

export interface CSEResponse extends CSEBase {
  id: string;
  created_at: string;
  updated_at: string;
}

export interface TelemetryCounts {
  assets: number;
  alerts_total: number;
  alerts_by_severity: Record<string, number>;
  cases: number;
  investigations: number;
  escalations: number;
  monitoring_coverages: number;
}

export interface AnalyticsSummary {
  active_findings_count: number;
  findings_by_category: Record<string, number>;
  latest_finding_detected_at?: string | null;
  last_ingestion_batch_at?: string | null;
}

export interface CSESummarySchema {
  cse_id: string;
  code: string;
  name: string;
  sector: string;
  criticality_tier: string;
  telemetry_counts: TelemetryCounts;
  analytics_summary: AnalyticsSummary;
}

export interface CSEListQueryParams {
  skip?: number;
  limit?: number;
  search?: string;
  sector?: string;
  is_active?: boolean;
}
