import { apiClient } from './client';

export interface AssessmentItem {
  id: string;
  cse_id: string;
  name: string;
  description?: string;
  period_start: string;
  period_end: string;
  status: 'DRAFT' | 'DATASET_ATTACHED' | 'IN_ANALYSIS' | 'UNDER_REVIEW' | 'COMPLETED' | 'ARCHIVED';
  created_at: string;
  updated_at: string;
  created_by_user_id?: string;
}

export interface AssessmentListResponse {
  total: number;
  items: AssessmentItem[];
}

export interface DatasetVersionItem {
  id: string;
  cse_id: string;
  assessment_id?: string;
  batch_id?: string;
  version_tag: string;
  dataset_type: string;
  source_filename: string;
  content_hash: string;
  record_count: number;
  is_immutable: boolean;
  created_at: string;
}

export interface DatasetVersionListResponse {
  total: number;
  items: DatasetVersionItem[];
}

export interface AnalysisRunItem {
  id: string;
  cse_id: string;
  assessment_id?: string;
  dataset_version_id?: string;
  obs_start?: string;
  obs_end?: string;
  engine_version: string;
  rules_evaluated: string[];
  status: string;
  findings_created: number;
  baselines_persisted: number;
  started_at: string;
  completed_at?: string;
}

export interface AnalysisRunListResponse {
  total: number;
  items: AnalysisRunItem[];
}

export const fetchAssessments = async (cse_id: string): Promise<AssessmentListResponse> => {
  const response = await apiClient.get<AssessmentListResponse>(`/api/v1/assessments?cse_id=${cse_id}`);
  return response.data;
};

export const createAssessment = async (payload: {
  cse_id: string;
  name: string;
  description?: string;
  period_start: string;
  period_end: string;
}): Promise<AssessmentItem> => {
  const response = await apiClient.post<AssessmentItem>('/api/v1/assessments', payload);
  return response.data;
};

export const updateAssessmentStatus = async (
  assessment_id: string,
  status: string
): Promise<AssessmentItem> => {
  const response = await apiClient.patch<AssessmentItem>(`/api/v1/assessments/${assessment_id}/status`, { status });
  return response.data;
};

export const fetchDatasetVersions = async (cse_id: string, assessment_id?: string): Promise<DatasetVersionListResponse> => {
  let url = `/api/v1/dataset-versions?cse_id=${cse_id}`;
  if (assessment_id) {
    url += `&assessment_id=${assessment_id}`;
  }
  const response = await apiClient.get<DatasetVersionListResponse>(url);
  return response.data;
};

export const createDatasetVersion = async (payload: {
  cse_id: string;
  assessment_id?: string;
  batch_id?: string;
  dataset_type: string;
  source_filename: string;
  version_tag?: string;
}): Promise<DatasetVersionItem> => {
  const response = await apiClient.post<DatasetVersionItem>('/api/v1/dataset-versions', payload);
  return response.data;
};

export const fetchAnalysisRuns = async (cse_id: string, assessment_id?: string): Promise<AnalysisRunListResponse> => {
  let url = `/api/v1/analysis-runs?cse_id=${cse_id}`;
  if (assessment_id) {
    url += `&assessment_id=${assessment_id}`;
  }
  const response = await apiClient.get<AnalysisRunListResponse>(url);
  return response.data;
};

export const createAnalysisRun = async (payload: {
  cse_id: string;
  assessment_id?: string;
  dataset_version_id?: string;
  obs_start?: string;
  obs_end?: string;
}): Promise<AnalysisRunItem> => {
  const response = await apiClient.post<AnalysisRunItem>('/api/v1/analysis-runs', payload);
  return response.data;
};
