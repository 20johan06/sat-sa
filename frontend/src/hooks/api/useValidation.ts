import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { validationApi } from '../../api/validation';
import type { ValidationGenerateRequest, ValidationRunRequest } from '../../types/api/validation';

export const VALIDATION_QUERY_KEYS = {
  all: ['validation'] as const,
  results: (kValue: number) => ['validation', 'results', kValue] as const,
};

export const useValidationResults = (kValue: number = 5) => {
  return useQuery({
    queryKey: VALIDATION_QUERY_KEYS.results(kValue),
    queryFn: () => validationApi.getValidationResults(kValue),
  });
};

export const useGenerateSyntheticData = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: ValidationGenerateRequest) => validationApi.generateSyntheticData(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: VALIDATION_QUERY_KEYS.all });
    },
  });
};

export const useRunValidation = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: ValidationRunRequest) => validationApi.runValidation(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: VALIDATION_QUERY_KEYS.all });
    },
  });
};
