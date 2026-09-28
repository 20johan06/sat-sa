export type DatasetType =
  | 'alerts'
  | 'cases'
  | 'investigations'
  | 'escalations'
  | 'monitoring_coverages';

export interface JSONIngestionPayload {
  cse_id: string;
  dataset_type: DatasetType;
  records: Record<string, unknown>[];
}

export interface IngestionBatchResponse {
  id: string;
  cse_id: string;
  batch_reference: string;
  source_type: string;
  source_filename: string;
  total_records: number;
  valid_records: number;
  rejected_records: number;
  status: string;
  error_summary?: string | null;
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
