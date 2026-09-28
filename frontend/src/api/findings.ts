import apiClient from './client';
import type {
  PaginatedFindingsResponse,
  FindingDetailSchema,
  FindingQueryParams
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
