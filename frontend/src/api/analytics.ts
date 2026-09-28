import apiClient from './client';
import type {
  AnalyticsRunRequest,
  AnalyticsRunResultSchema,
  SignalMatrixResponse
} from '../types/api/analytics';

export async function runAnalytics(
  cseId: string,
  payload?: AnalyticsRunRequest
): Promise<AnalyticsRunResultSchema> {
  const response = await apiClient.post<AnalyticsRunResultSchema>(
    `/api/v1/analytics/${cseId}/run`,
    payload || {}
  );
  return response.data;
}

export async function getAnalyticsSignals(
  cseId: string,
  params?: { obs_start?: string; obs_end?: string }
): Promise<SignalMatrixResponse> {
  const response = await apiClient.get<SignalMatrixResponse>(
    `/api/v1/analytics/${cseId}/signals`,
    { params }
  );
  return response.data;
}
