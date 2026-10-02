export type ReportFormat = 'json' | 'markdown';

export interface ReportQueryParams {
  obs_start?: string;
  obs_end?: string;
  format?: ReportFormat;
}

export interface ReportGenerateRequest {
  cse_id: string;
  assessment_id?: string;
  dataset_version_id?: string;
  analysis_run_id?: string;
  obs_start?: string;
  obs_end?: string;
}

export interface ReportItem {
  id: string;
  report_code: string;
  cse_id: string;
  assessment_id?: string;
  dataset_version_id?: string;
  analysis_run_id?: string;
  obs_start?: string;
  obs_end?: string;
  generated_by_user_id: string;
  generated_by_username: string;
  created_at: string;
}

export interface PaginatedReportsResponse {
  items: ReportItem[];
  total: number;
  page: number;
  page_size: number;
  total_pages: number;
}

export interface ReportDetailResponse {
  report_metadata: {
    report_id: string;
    report_code: string;
    generated_at: string;
    generated_by_user: string;
    generated_by_user_id: string;
    cse_id: string;
    cse_code: string;
    cse_name: string;
    sector: string;
    criticality_tier: string;
    observation_period: {
      start?: string;
      end?: string;
      is_bounded: boolean;
    };
    provenance: {
      assessment?: any;
      dataset_version?: any;
      analysis_run?: any;
      rule_manifests: string[];
    };
  };
  cse_profile: {
    code: string;
    name: string;
    sector: string;
    criticality_tier: string;
  };
  telemetry_summary: Record<string, any>;
  supervisory_signals_summary: Record<string, number>;
  active_findings: any[];
  peer_baselines: any[];
  capability_assessment: any;
  trends_summary: any;
  data_quality_and_limitations: Record<string, any>;
}
