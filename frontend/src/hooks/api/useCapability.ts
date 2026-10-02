import { useQuery } from '@tanstack/react-query';
import { getEntityCapabilityAssessment, getCapabilityDetail } from '../../api/capability';
import queryKeys from '../../utils/queryKeys';

export function useCapabilityAssessment(cseId: string) {
  return useQuery({
    queryKey: queryKeys.capability.assessment(cseId),
    queryFn: () => getEntityCapabilityAssessment(cseId),
    enabled: Boolean(cseId),
  });
}

export function useCapabilityDetailQuery(cseId: string, capabilityName: string) {
  return useQuery({
    queryKey: queryKeys.capability.detail(cseId, capabilityName),
    queryFn: () => getCapabilityDetail(cseId, capabilityName),
    enabled: Boolean(cseId && capabilityName),
  });
}
