import apiClient from './client';
import type {
  PaginatedFindingsResponse,
  FindingDetailSchema,
  FindingQueryParams,
  FindingStatusUpdatePayload
} from '../types/api/findings';

export async function listFindings(
  params?: FindingQueryParams
): Promise<PaginatedFindingsResponse> {
  const response = await apiClient.get<PaginatedFindingsResponse>('/api/v1/findings/', {
    params: {
      ...params,
      status: params?.status,
    },
  });
  return response.data;
}

export async function getFindingDetail(
  findingId: string
): Promise<FindingDetailSchema> {
  const response = await apiClient.get<FindingDetailSchema>(`/api/v1/findings/${findingId}`);
  return response.data;
}

export async function updateFindingStatus(
  findingId: string,
  payload: FindingStatusUpdatePayload
): Promise<FindingDetailSchema> {
  const response = await apiClient.patch<FindingDetailSchema>(
    `/api/v1/findings/${findingId}/status`,
    payload
  );
  return response.data;
}

