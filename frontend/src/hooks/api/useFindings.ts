import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { listFindings, getFindingDetail, updateFindingStatus } from '../../api/findings';
import type { FindingQueryParams, FindingStatusUpdatePayload } from '../../types/api/findings';
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

export function useUpdateFindingStatusMutation(findingId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: FindingStatusUpdatePayload) => updateFindingStatus(findingId, payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.findings.detail(findingId) });
      queryClient.invalidateQueries({ queryKey: queryKeys.findings.all });
    },
  });
}

