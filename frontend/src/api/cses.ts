import apiClient from './client';
import type {
  CSEResponse,
  CSECreate,
  CSESummarySchema,
  CSEListQueryParams
} from '../types/api/cse';

export async function createCSE(data: CSECreate): Promise<CSEResponse> {
  const response = await apiClient.post<CSEResponse>('/api/v1/cses/', data);
  return response.data;
}

export async function listCSEs(params?: CSEListQueryParams): Promise<CSEResponse[]> {
  const response = await apiClient.get<CSEResponse[]>('/api/v1/cses/', {
    params,
  });
  return response.data;
}

export async function getCSE(cseId: string): Promise<CSEResponse> {
  const response = await apiClient.get<CSEResponse>(`/api/v1/cses/${cseId}`);
  return response.data;
}

export async function getCSESummary(cseId: string): Promise<CSESummarySchema> {
  const response = await apiClient.get<CSESummarySchema>(`/api/v1/cses/${cseId}/summary`);
  return response.data;
}
