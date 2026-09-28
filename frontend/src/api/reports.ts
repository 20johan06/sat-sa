import apiClient from './client';
import type { ReportJSONResponse, ReportQueryParams } from '../types/api/reports';

export async function getCSEReportJSON(
  cseId: string,
  params?: Omit<ReportQueryParams, 'format'>
): Promise<ReportJSONResponse> {
  const response = await apiClient.get<ReportJSONResponse>(
    `/api/v1/reports/cse/${cseId}`,
    {
      params: {
        ...params,
        format: 'json',
      },
    }
  );
  return response.data;
}

export async function getCSEReportMarkdown(
  cseId: string,
  params?: Omit<ReportQueryParams, 'format'>
): Promise<string> {
  const response = await apiClient.get<string>(
    `/api/v1/reports/cse/${cseId}`,
    {
      params: {
        ...params,
        format: 'markdown',
      },
      responseType: 'text',
    }
  );
  return response.data;
}
