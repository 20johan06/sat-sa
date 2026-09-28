import { useQuery } from '@tanstack/react-query';
import { getHealth } from '../../api/health';
import queryKeys from '../../utils/queryKeys';

export function useHealthQuery() {
  return useQuery({
    queryKey: queryKeys.health.all,
    queryFn: getHealth,
    staleTime: 1000 * 30, // 30 seconds for health check
  });
}
