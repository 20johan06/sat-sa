import apiClient from './client';
import type { PeerBenchmarkResponse, BenchmarkQueryParams } from '../types/api/benchmarks';

export async function getBenchmarks(
  cseId: string,
  params?: BenchmarkQueryParams
): Promise<PeerBenchmarkResponse> {
  const response = await apiClient.get<PeerBenchmarkResponse>(
    `/api/v1/benchmarks/${cseId}`,
    { params }
  );
  return response.data;
}
