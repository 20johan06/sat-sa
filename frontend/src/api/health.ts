import apiClient from './client';
import type { HealthCheckResponse } from '../types/api/health';

export async function getHealth(): Promise<HealthCheckResponse> {
  const response = await apiClient.get<HealthCheckResponse>('/api/v1/health');
  return response.data;
}

export async function getRootHealth(): Promise<HealthCheckResponse> {
  const response = await apiClient.get<HealthCheckResponse>('/health');
  return response.data;
}
