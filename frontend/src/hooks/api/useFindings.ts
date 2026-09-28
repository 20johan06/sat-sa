import { useQuery } from '@tanstack/react-query';
import { listFindings, getFindingDetail } from '../../api/findings';
import type { FindingQueryParams } from '../../types/api/findings';
import queryKeys from '../../utils/queryKeys';

export function useFindingsQuery(params?: FindingQueryParams) {
  return useQuery({
    queryKey: queryKeys.findings.list(params),
    queryFn: () => listFindings(params),
  });
}

export function useFindingQuery(findingId: string) {
  return useQuery({
    queryKey: queryKeys.findings.detail(findingId),
    queryFn: () => getFindingDetail(findingId),
    enabled: Boolean(findingId),
  });
}
