import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { reportsApi } from '../../api/reports';
import type { ReportGenerateRequest } from '../../types/api/reports';

export const reportKeys = {
  all: ['reports'] as const,
  lists: (cseId: string, page: number) => [...reportKeys.all, 'list', cseId, page] as const,
  detail: (reportId: string) => [...reportKeys.all, 'detail', reportId] as const,
};

export const useReportsList = (cseId: string | null, page = 1) => {
  return useQuery({
    queryKey: reportKeys.lists(cseId || '', page),
    queryFn: () => reportsApi.listReports(cseId!, page),
    enabled: !!cseId,
  });
};

export const useReportDetail = (reportId: string | null) => {
  return useQuery({
    queryKey: reportKeys.detail(reportId || ''),
    queryFn: () => reportsApi.getReportDetail(reportId!),
    enabled: !!reportId,
  });
};

export const useGenerateReport = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (req: ReportGenerateRequest) => reportsApi.generateReport(req),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: reportKeys.all });
    },
  });
};
