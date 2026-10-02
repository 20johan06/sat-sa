import apiClient from './client';
import type { CSETrendAnalysisResponse } from '../types/api/trends';

export async function getCSETrends(
  cseId: string,
  params?: { obs_start?: string; obs_end?: string; window_days?: number }
): Promise<CSETrendAnalysisResponse> {
  const response = await apiClient.get<CSETrendAnalysisResponse>(
    `/api/v1/supervisory/cse/${cseId}/trends`,
    { params }
  );
  return response.data;
}
