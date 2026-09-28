import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getAnalyticsSignals, runAnalytics } from '../../api/analytics';
import type { AnalyticsRunRequest } from '../../types/api/analytics';
import queryKeys from '../../utils/queryKeys';

export function useAnalyticsSignalsQuery(
  cseId: string,
  params?: { obs_start?: string; obs_end?: string }
) {
  return useQuery({
    queryKey: queryKeys.analytics.signals(cseId, params),
    queryFn: () => getAnalyticsSignals(cseId, params),
    enabled: Boolean(cseId),
  });
}

export function useRunAnalyticsMutation(cseId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload?: AnalyticsRunRequest) => runAnalytics(cseId, payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.analytics.all });
      queryClient.invalidateQueries({ queryKey: queryKeys.findings.all });
      queryClient.invalidateQueries({ queryKey: queryKeys.cses.summary(cseId) });
    },
  });
}
