import { useQuery } from '@tanstack/react-query';
import { getBenchmarks } from '../../api/benchmarks';
import type { BenchmarkQueryParams } from '../../types/api/benchmarks';
import queryKeys from '../../utils/queryKeys';

export function useBenchmarksQuery(cseId: string, params?: BenchmarkQueryParams) {
  return useQuery({
    queryKey: queryKeys.benchmarks.detail(cseId, params),
    queryFn: () => getBenchmarks(cseId, params),
    enabled: Boolean(cseId),
  });
}
