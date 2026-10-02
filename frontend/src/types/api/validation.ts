export interface RuleConfusionMatrix {
  rule_code: string;
  tp: number;
  fp: number;
  fn: number;
  tn: number;
  precision: number;
  recall: number;
  f1_score: number;
}

export interface ConfusionMatrixAggregate {
  true_positives: number;
  false_positives: number;
  false_negatives: number;
  true_negatives: number;
}

export interface ValidationMetrics {
  precision: number;
  recall: number;
  f1_score: number;
  precision_at_k: number;
  k_value: number;
}

export interface ScenarioResultItem {
  scenario_id: string;
  cse_code: string;
  target_rule: string;
  expected_presence: string;
  actual_presence: string;
  matched_finding_ids: string[];
  tp: number;
  fp: number;
  fn: number;
  tn: number;
  notes?: string;
}

export interface ValidationRunResult {
  validation_run_id: string;
  executed_at: string;
  analytics_version: string;
  total_scenarios_evaluated: number;
  confusion_matrix: ConfusionMatrixAggregate;
  metrics: ValidationMetrics;
  rule_breakdown: Record<string, RuleConfusionMatrix>;
  scenario_results: ScenarioResultItem[];
  dataset_hash?: string;
  summary_text: string;
}

export interface ValidationGenerateRequest {
  seed?: number;
  force_recreate?: boolean;
}

export interface ValidationRunRequest {
  k_value?: number;
}
