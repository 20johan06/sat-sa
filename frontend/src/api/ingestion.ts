import apiClient from './client';
import type {
  DatasetType,
  JSONIngestionPayload,
  IngestionBatchResponse,
  IngestionBatchListResponse,
  IngestionBatchQueryParams
} from '../types/api/ingestion';

export async function uploadIngestionFile(
  cseId: string,
  datasetType: DatasetType,
  file: File,
  assessmentId?: string
): Promise<IngestionBatchResponse> {
  const formData = new FormData();
  formData.append('cse_id', cseId);
  formData.append('dataset_type', datasetType);
  formData.append('file', file);
  if (assessmentId) {
    formData.append('assessment_id', assessmentId);
  }

  const response = await apiClient.post<IngestionBatchResponse>(
    '/api/v1/ingestion/upload',
    formData,
    {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    }
  );
  return response.data;
}

export async function ingestJSONPayload(
  payload: JSONIngestionPayload
): Promise<IngestionBatchResponse> {
  const response = await apiClient.post<IngestionBatchResponse>(
    '/api/v1/ingestion/json',
    payload
  );
  return response.data;
}

export async function listIngestionBatches(
  params?: IngestionBatchQueryParams
): Promise<IngestionBatchListResponse> {
  const response = await apiClient.get<IngestionBatchListResponse>(
    '/api/v1/ingestion/batches',
    { params }
  );
  return response.data;
}

export async function getIngestionBatch(
  batchId: string
): Promise<IngestionBatchResponse> {
  const response = await apiClient.get<IngestionBatchResponse>(
    `/api/v1/ingestion/batches/${batchId}`
  );
  return response.data;
}
