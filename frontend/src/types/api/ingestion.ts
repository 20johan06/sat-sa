export type DatasetType =
  | 'alerts'
  | 'cases'
  | 'investigations'
  | 'escalations'
  | 'monitoring_coverages';

export interface RejectionDetail {
  record_index: number;
  field: string;
  value?: string | null;
  reason: string;
  code: string;
}

export interface DataQualityReport {
  total_records: number;
  valid_records: number;
  rejected_records: number;
  duplicate_records_count: number;
  invalid_timestamps_count: number;
  impossible_timestamps_count: number;
  invalid_severity_count: number;
  missing_cse_count: number;
  broken_references_count: number;
  missing_fields_count: number;
  rejections: RejectionDetail[];
  coverage_limitations: string[];
}

export interface JSONIngestionPayload {
  cse_id: string;
  dataset_type: DatasetType;
  records: Record<string, unknown>[];
  assessment_id?: string | null;
}

export interface IngestionBatchResponse {
  id: string;
  cse_id: string;
  assessment_id?: string | null;
  batch_reference: string;
  source_type: string;
  source_filename: string;
  total_records: number;
  valid_records: number;
  rejected_records: number;
  status: string;
  error_summary?: string | null;
  quality_report?: DataQualityReport | null;
  imported_at: string;
}

export interface IngestionBatchListResponse {
  total: number;
  items: IngestionBatchResponse[];
}

export interface IngestionBatchQueryParams {
  cse_id?: string;
  skip?: number;
  limit?: number;
}

