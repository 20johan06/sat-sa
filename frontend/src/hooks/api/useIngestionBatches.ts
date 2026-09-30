import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  listIngestionBatches,
  getIngestionBatch,
  uploadIngestionFile,
  ingestJSONPayload
} from '../../api/ingestion';
import type {
  IngestionBatchQueryParams,
  DatasetType,
  JSONIngestionPayload
} from '../../types/api/ingestion';
import queryKeys from '../../utils/queryKeys';

export function useIngestionBatchesQuery(params?: IngestionBatchQueryParams) {
  return useQuery({
    queryKey: queryKeys.ingestion.batches(params),
    queryFn: () => listIngestionBatches(params),
  });
}

export function useIngestionBatchDetailQuery(batchId: string) {
  return useQuery({
    queryKey: queryKeys.ingestion.batchDetail(batchId),
    queryFn: () => getIngestionBatch(batchId),
    enabled: Boolean(batchId),
  });
}

export function useUploadIngestionMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ cseId, datasetType, file, assessmentId }: { cseId: string; datasetType: DatasetType; file: File; assessmentId?: string }) =>
      uploadIngestionFile(cseId, datasetType, file, assessmentId),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.ingestion.all });
      queryClient.invalidateQueries({ queryKey: queryKeys.cses.summary(variables.cseId) });
      if (variables.assessmentId) {
        queryClient.invalidateQueries({ queryKey: queryKeys.assessments.all });
      }
    },
  });
}

export function useJsonIngestionMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: JSONIngestionPayload) => ingestJSONPayload(payload),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.ingestion.all });
      queryClient.invalidateQueries({ queryKey: queryKeys.cses.summary(variables.cse_id) });
    },
  });
}
