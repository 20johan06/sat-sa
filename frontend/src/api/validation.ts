import { apiClient } from './client';
import type {
  ValidationRunResult,
  ValidationGenerateRequest,
  ValidationRunRequest
} from '../types/api/validation';

export const validationApi = {
  generateSyntheticData: async (data: ValidationGenerateRequest = {}): Promise<any> => {
    const res = await apiClient.post<any>('/api/v1/validation/generate', data, { timeout: 60000 });
    return res.data;
  },

  runValidation: async (data: ValidationRunRequest = {}): Promise<ValidationRunResult> => {
    const res = await apiClient.post<ValidationRunResult>('/api/v1/validation/run', data, { timeout: 60000 });
    return res.data;
  },

  getValidationResults: async (kValue: number = 5): Promise<ValidationRunResult> => {
    const res = await apiClient.get<ValidationRunResult>(`/api/v1/validation/results?k_value=${kValue}`, { timeout: 60000 });
    return res.data;
  }
};
