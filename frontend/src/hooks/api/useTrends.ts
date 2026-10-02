import { useQuery } from '@tanstack/react-query';
import { getCSETrends } from '../../api/trends';
import queryKeys from '../../utils/queryKeys';

export function useCSETrendsQuery(
  cseId: string,
  params?: { obs_start?: string; obs_end?: string; window_days?: number }
) {
  return useQuery({
    queryKey: queryKeys.trends.cse(cseId, params),
    queryFn: () => getCSETrends(cseId, params),
    enabled: Boolean(cseId),
  });
}
