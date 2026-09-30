import client from './client';
import type {
  SupervisoryAttentionQueueResponse,
  EntitySupervisoryOverviewResponse
} from '../types/api/supervisory';

export interface AttentionQueueParams {
  sector?: string;
  obs_start?: string;
  obs_end?: string;
  page?: number;
  page_size?: number;
}

export interface SupervisoryOverviewParams {
  obs_start?: string;
  obs_end?: string;
}

export const getAttentionQueue = async (
  params?: AttentionQueueParams
): Promise<SupervisoryAttentionQueueResponse> => {
  const response = await client.get<SupervisoryAttentionQueueResponse>(
    '/supervisory/attention-queue',
    { params }
  );
  return response.data;
};

export const getEntitySupervisoryOverview = async (
  cseId: string,
  params?: SupervisoryOverviewParams
): Promise<EntitySupervisoryOverviewResponse> => {
  const response = await client.get<EntitySupervisoryOverviewResponse>(
    `/supervisory/cse/${cseId}/attention-overview`,
    { params }
  );
  return response.data;
};
