import { useQuery } from '@tanstack/react-query';
import { getCSEReportJSON, getCSEReportMarkdown } from '../../api/reports';
import type { ReportQueryParams } from '../../types/api/reports';
import queryKeys from '../../utils/queryKeys';

export function useCSEReportJSONQuery(
  cseId: string,
  params?: Omit<ReportQueryParams, 'format'>
) {
  return useQuery({
    queryKey: queryKeys.reports.json(cseId, params),
    queryFn: () => getCSEReportJSON(cseId, params),
    enabled: Boolean(cseId),
  });
}

export function useCSEReportMarkdownQuery(
  cseId: string,
  params?: Omit<ReportQueryParams, 'format'>
) {
  return useQuery({
    queryKey: queryKeys.reports.markdown(cseId, params),
    queryFn: () => getCSEReportMarkdown(cseId, params),
    enabled: Boolean(cseId),
  });
}
