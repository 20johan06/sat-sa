import uuid
from datetime import datetime
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, ConfigDict, Field

class RuleConfusionMatrix(BaseModel):
    rule_code: str
    tp: int = 0
    fp: int = 0
    fn: int = 0
    tn: int = 0
    precision: float = 0.0
    recall: float = 0.0
    f1_score: float = 0.0

class ConfusionMatrixAggregate(BaseModel):
    true_positives: int = 0
    false_positives: int = 0
    false_negatives: int = 0
    true_negatives: int = 0

class ValidationMetrics(BaseModel):
    precision: float = 0.0
    recall: float = 0.0
    f1_score: float = 0.0
    precision_at_k: float = 0.0
    k_value: int = 5

class ScenarioResultItem(BaseModel):
    scenario_id: str
    cse_code: str
    target_rule: str
    expected_presence: str
    actual_presence: str
    matched_finding_ids: List[str] = Field(default_factory=list)
    tp: int = 0
    fp: int = 0
    fn: int = 0
    tn: int = 0
    notes: Optional[str] = None

class ValidationRunResult(BaseModel):
    validation_run_id: str
    executed_at: datetime
    analytics_version: str = "v2.0.0-phase5-canonical"
    total_scenarios_evaluated: int
    confusion_matrix: ConfusionMatrixAggregate
    metrics: ValidationMetrics
    rule_breakdown: Dict[str, RuleConfusionMatrix]
    scenario_results: List[ScenarioResultItem]
    dataset_hash: Optional[str] = None
    summary_text: str

    model_config = ConfigDict(from_attributes=True)

class ValidationGenerateRequest(BaseModel):
    seed: int = 202613
    force_recreate: bool = False

class ValidationRunRequest(BaseModel):
    k_value: int = 5
