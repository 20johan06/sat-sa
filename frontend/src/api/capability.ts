import apiClient from './client';
import type {
  EntityCapabilityAssessmentResponse,
  CapabilityAssessmentItem
} from '../types/api/capability';

export async function getEntityCapabilityAssessment(
  cseId: string
): Promise<EntityCapabilityAssessmentResponse> {
  const response = await apiClient.get<EntityCapabilityAssessmentResponse>(
    `/api/v1/supervisory/cse/${cseId}/capability-assessment`
  );
  return response.data;
}

export async function getCapabilityDetail(
  cseId: string,
  capabilityName: string
): Promise<CapabilityAssessmentItem> {
  const response = await apiClient.get<CapabilityAssessmentItem>(
    `/api/v1/supervisory/cse/${cseId}/capability/${capabilityName}/detail`
  );
  return response.data;
}
