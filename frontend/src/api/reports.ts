import { apiClient } from './client';
import type {
  ReportGenerateRequest,
  PaginatedReportsResponse,
  ReportDetailResponse,
  ReportQueryParams
} from '../types/api/reports';

export const reportsApi = {
  generateReport: async (req: ReportGenerateRequest): Promise<ReportDetailResponse> => {
    const response = await apiClient.post('/reports/generate', req);
    return response.data;
  },

  listReports: async (cseId: string, page = 1, pageSize = 20): Promise<PaginatedReportsResponse> => {
    const response = await apiClient.get(`/reports/cse/${cseId}`, {
      params: { page, page_size: pageSize }
    });
    return response.data;
  },

  getReportDetail: async (reportId: string): Promise<ReportDetailResponse> => {
    const response = await apiClient.get(`/reports/${reportId}`);
    return response.data;
  },

  getCSEReportJSON: async (cseId: string, params?: ReportQueryParams): Promise<ReportDetailResponse> => {
    const response = await apiClient.get(`/reports/cse/${cseId}`, {
      params: { ...params, format: 'json' }
    });
    return response.data;
  },

  getCSEReportMarkdown: async (cseId: string, params?: ReportQueryParams): Promise<string> => {
    const response = await apiClient.get(`/reports/cse/${cseId}`, {
      params: { ...params, format: 'markdown' },
      responseType: 'text'
    });
    return response.data;
  },

  exportPDF: async (reportId: string, filename: string): Promise<void> => {
    const response = await apiClient.get(`/reports/${reportId}/export/pdf`, {
      responseType: 'blob'
    });
    const url = window.URL.createObjectURL(new Blob([response.data], { type: 'application/pdf' }));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', filename.endsWith('.pdf') ? filename : `${filename}.pdf`);
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.URL.revokeObjectURL(url);
  },

  exportCSV: async (reportId: string, filename: string): Promise<void> => {
    const response = await apiClient.get(`/reports/${reportId}/export/csv`, {
      responseType: 'blob'
    });
    const url = window.URL.createObjectURL(new Blob([response.data], { type: 'text/csv' }));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', filename.endsWith('.csv') ? filename : `${filename}.csv`);
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.URL.revokeObjectURL(url);
  },

  exportJSON: async (reportId: string, filename: string): Promise<void> => {
    const response = await apiClient.get(`/reports/${reportId}/export/json`, {
      responseType: 'blob'
    });
    const url = window.URL.createObjectURL(new Blob([response.data], { type: 'application/json' }));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', filename.endsWith('.json') ? filename : `${filename}.json`);
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.URL.revokeObjectURL(url);
  }
};

export const getCSEReportJSON = reportsApi.getCSEReportJSON;
export const getCSEReportMarkdown = reportsApi.getCSEReportMarkdown;
