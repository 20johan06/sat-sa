import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { listCSEs, getCSE, getCSESummary, createCSE } from '../../api/cses';
import type { CSEListQueryParams, CSECreate } from '../../types/api/cse';
import queryKeys from '../../utils/queryKeys';

export function useCsesQuery(params?: CSEListQueryParams) {
  return useQuery({
    queryKey: queryKeys.cses.list(params),
    queryFn: () => listCSEs(params),
  });
}

export function useCseQuery(cseId: string) {
  return useQuery({
    queryKey: queryKeys.cses.detail(cseId),
    queryFn: () => getCSE(cseId),
    enabled: Boolean(cseId),
  });
}

export function useCseSummaryQuery(cseId: string) {
  return useQuery({
    queryKey: queryKeys.cses.summary(cseId),
    queryFn: () => getCSESummary(cseId),
    enabled: Boolean(cseId),
  });
}

export function useCreateCseMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: CSECreate) => createCSE(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.cses.all });
    },
  });
}
