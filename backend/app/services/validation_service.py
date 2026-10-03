import uuid
from datetime import datetime, timezone
from typing import List, Dict, Any, Optional
from sqlalchemy.orm import Session

from app.models.cse import CSE
from app.models.finding import Finding, FindingEvidence, FindingReviewHistory
from app.models.analysis_run import AnalysisRun
from app.services.analytics_runner import AnalyticsRunnerService
from app.services.review_service import review_service
from app.schemas.validation import (
    RuleConfusionMatrix,
    ConfusionMatrixAggregate,
    ValidationMetrics,
    ScenarioResultItem,
    ValidationRunResult
)

CANONICAL_RULES = ["EG-01", "EG-02", "EG-03", "EG-04", "NS-01", "NS-02", "AN-01", "BM-01"]

GROUND_TRUTH_SPEC = {
    "SYN-CSE-01": {"target_rule": "NONE", "expected_presence": "EXPECTED_NO_FINDING", "scenario_id": "CSE-01-NORMAL"},
    "SYN-CSE-02": {"target_rule": "EG-03", "expected_presence": "EXPECTED_FINDING", "scenario_id": "CSE-02-RAPID-CLOSURE"},
    "SYN-CSE-03": {"target_rule": "EG-04", "expected_presence": "EXPECTED_FINDING", "scenario_id": "CSE-03-REPEATED-ALERTS"},
    "SYN-CSE-04": {"target_rule": "EG-02", "expected_presence": "EXPECTED_NO_FINDING", "scenario_id": "CSE-04-MISSING-ESCALATION"},
    "SYN-CSE-05": {"target_rule": "NS-01", "expected_presence": "EXPECTED_FINDING", "scenario_id": "CSE-05-TELEMETRY-GAP"},
    "SYN-CSE-06": {"target_rule": "EG-01", "expected_presence": "EXPECTED_NO_FINDING", "scenario_id": "CSE-06-UNINVESTIGATED-ALERTS"},
    "SYN-CSE-07": {"target_rule": "BM-01", "expected_presence": "EXPECTED_FINDING", "scenario_id": "CSE-07-PEER-DEVIATION"},
    "SYN-CSE-08": {"target_rule": "AN-01", "expected_presence": "EXPECTED_FINDING", "scenario_id": "CSE-08-VOLUME-ANOMALY"},
}

class ValidationService:
    """
    Authoritative Phase 13 Synthetic Validation Engine.
    Executes existing Phase 5 analytics against isolated synthetic datasets,
    evaluates findings against ground truth, and calculates TP/FP/FN/TN, Precision, Recall, F1, and Precision@K.
    Restores pre-validation database state after metric computation to prevent permanent DB mutations.
    """

    @staticmethod
    def run_validation(db: Session, k_value: int = 5) -> ValidationRunResult:
        run_id = f"VAL-RUN-{datetime.now(timezone.utc).strftime('%Y%m%d%H%M%S')}-{uuid.uuid4().hex[:6].upper()}"
        executed_at = datetime.now(timezone.utc)

        # 1. Fetch synthetic CSEs
        syn_cses = db.query(CSE).filter(CSE.cse_code.like("SYN-CSE-%")).all()
        cse_map = {c.cse_code: c for c in syn_cses}
        syn_cse_ids = [c.id for c in syn_cses]

        # Snapshot existing finding and analysis run IDs before validation execution
        existing_finding_ids = set(f.id for f in db.query(Finding.id).filter(Finding.cse_id.in_(syn_cse_ids)).all())
        existing_analysis_run_ids = set(a.id for a in db.query(AnalysisRun.id).filter(AnalysisRun.cse_id.in_(syn_cse_ids)).all())

        scenario_results: List[ScenarioResultItem] = []
        rule_matrix: Dict[str, Dict[str, int]] = {
            r: {"tp": 0, "fp": 0, "fn": 0, "tn": 0} for r in CANONICAL_RULES
        }

        # 2. Execute analytics and evaluate each scenario
        for cse_code, spec in GROUND_TRUTH_SPEC.items():
            target_cse = cse_map.get(cse_code)
            if not target_cse:
                continue

            # Execute real Phase 5 analytics runner pipeline
            run_result = AnalyticsRunnerService.run_analytics(db=db, cse_id=target_cse.id)

            # Query actual findings generated for this CSE
            actual_findings = db.query(Finding).filter(Finding.cse_id == target_cse.id).all()
            actual_rule_codes = set()
            finding_ids = []
            for f in actual_findings:
                finding_ids.append(str(f.id))
                r_code = f.metrics_json.get("rule_code") if f.metrics_json else None
                if r_code:
                    # Map BM-01-INV or BM-01-ESC to canonical BM-01
                    if r_code.startswith("BM-01"):
                        actual_rule_codes.add("BM-01")
                    else:
                        actual_rule_codes.add(r_code)

            target_rule = spec["target_rule"]
            expected_presence = spec["expected_presence"]

            # Evaluate each canonical rule for this scenario
            for r in CANONICAL_RULES:
                is_target = (r == target_rule)
                has_actual = (r in actual_rule_codes)

                if is_target:
                    if expected_presence == "EXPECTED_FINDING":
                        if has_actual:
                            rule_matrix[r]["tp"] += 1
                        else:
                            rule_matrix[r]["fn"] += 1
                    else: # EXPECTED_NO_FINDING
                        if has_actual:
                            rule_matrix[r]["fp"] += 1
                        else:
                            rule_matrix[r]["tn"] += 1
                else:
                    if has_actual:
                        rule_matrix[r]["fp"] += 1
                    else:
                        rule_matrix[r]["tn"] += 1

            actual_pres_str = "FINDING_GENERATED" if len(actual_rule_codes) > 0 else "NO_FINDING"
            
            scen_tp = 1 if (expected_presence == "EXPECTED_FINDING" and target_rule in actual_rule_codes) else 0
            scen_fp = 1 if (expected_presence == "EXPECTED_NO_FINDING" and len(actual_rule_codes) > 0) else 0
            scen_fn = 1 if (expected_presence == "EXPECTED_FINDING" and target_rule not in actual_rule_codes) else 0
            scen_tn = 1 if (expected_presence == "EXPECTED_NO_FINDING" and len(actual_rule_codes) == 0) else 0

            scenario_results.append(ScenarioResultItem(
                scenario_id=spec["scenario_id"],
                cse_code=cse_code,
                target_rule=target_rule,
                expected_presence=expected_presence,
                actual_presence=actual_pres_str,
                matched_finding_ids=finding_ids,
                tp=scen_tp,
                fp=scen_fp,
                fn=scen_fn,
                tn=scen_tn,
                notes=f"Target Rule: {target_rule}, Actual Rules Generated: {list(actual_rule_codes)}"
            ))

        # 3. Calculate Rule Breakdown & Aggregates
        rule_breakdown: Dict[str, RuleConfusionMatrix] = {}
        agg_tp = sum(m["tp"] for m in rule_matrix.values())
        agg_fp = sum(m["fp"] for m in rule_matrix.values())
        agg_fn = sum(m["fn"] for m in rule_matrix.values())
        agg_tn = sum(m["tn"] for m in rule_matrix.values())

        for r_code, m in rule_matrix.items():
            tp, fp, fn, tn = m["tp"], m["fp"], m["fn"], m["tn"]
            prec = tp / (tp + fp) if (tp + fp) > 0 else 1.0 if fp == 0 else 0.0
            rec = tp / (tp + fn) if (tp + fn) > 0 else 1.0 if fn == 0 else 0.0
            f1 = (2 * prec * rec) / (prec + rec) if (prec + rec) > 0 else 0.0

            rule_breakdown[r_code] = RuleConfusionMatrix(
                rule_code=r_code,
                tp=tp,
                fp=fp,
                fn=fn,
                tn=tn,
                precision=round(prec, 4),
                recall=round(rec, 4),
                f1_score=round(f1, 4)
            )

        overall_prec = agg_tp / (agg_tp + agg_fp) if (agg_tp + agg_fp) > 0 else 1.0
        overall_rec = agg_tp / (agg_tp + agg_fn) if (agg_tp + agg_fn) > 0 else 1.0
        overall_f1 = (2 * overall_prec * overall_rec) / (overall_prec + overall_rec) if (overall_prec + overall_rec) > 0 else 0.0

        # 4. Calculate Precision@K using Phase 8 Manual Review Ordering (detected_at DESC, finding_code ASC)
        syn_allowed_ids = [c.id for c in syn_cses]
        queue_resp = review_service.get_manual_review_queue(
            db=db,
            allowed_cse_ids=syn_allowed_ids,
            actionable_only=False,
            page=1,
            page_size=max(k_value, 20)
        )

        top_k_items = queue_resp.items[:k_value]
        relevant_matches = 0
        if top_k_items:
            for item in top_k_items:
                spec = GROUND_TRUTH_SPEC.get(item.cse_code)
                if spec and spec["expected_presence"] == "EXPECTED_FINDING":
                    relevant_matches += 1
            precision_at_k = relevant_matches / len(top_k_items)
        else:
            precision_at_k = 1.0

        # 5. Clean up transient validation findings & analysis runs created during this run to preserve database integrity
        if syn_cse_ids:
            new_findings = db.query(Finding).filter(
                Finding.cse_id.in_(syn_cse_ids),
                ~Finding.id.in_(existing_finding_ids)
            ).all()
            if new_findings:
                new_f_ids = [f.id for f in new_findings]
                db.query(FindingEvidence).filter(FindingEvidence.finding_id.in_(new_f_ids)).delete(synchronize_session=False)
                db.query(FindingReviewHistory).filter(FindingReviewHistory.finding_id.in_(new_f_ids)).delete(synchronize_session=False)
                db.query(Finding).filter(Finding.id.in_(new_f_ids)).delete(synchronize_session=False)
            
            new_analysis_runs = db.query(AnalysisRun).filter(
                AnalysisRun.cse_id.in_(syn_cse_ids),
                ~AnalysisRun.id.in_(existing_analysis_run_ids)
            ).all()
            if new_analysis_runs:
                new_ar_ids = [a.id for a in new_analysis_runs]
                db.query(AnalysisRun).filter(AnalysisRun.id.in_(new_ar_ids)).delete(synchronize_session=False)

            if new_findings or new_analysis_runs:
                db.commit()

        summary = (
            f"Phase 13 Validation Execution Complete. Evaluated {len(scenario_results)} synthetic scenarios across "
            f"8 canonical rules. Aggregated Matrix: TP={agg_tp}, FP={agg_fp}, FN={agg_fn}, TN={agg_tn}. "
            f"Overall Precision: {overall_prec:.1%}, Recall: {overall_rec:.1%}, F1: {overall_f1:.1%}, "
            f"Precision@{k_value}: {precision_at_k:.1%}."
        )

        return ValidationRunResult(
            validation_run_id=run_id,
            executed_at=executed_at,
            analytics_version="v2.0.0-phase5-canonical",
            total_scenarios_evaluated=len(scenario_results),
            confusion_matrix=ConfusionMatrixAggregate(
                true_positives=agg_tp,
                false_positives=agg_fp,
                false_negatives=agg_fn,
                true_negatives=agg_tn
            ),
            metrics=ValidationMetrics(
                precision=round(overall_prec, 4),
                recall=round(overall_rec, 4),
                f1_score=round(overall_f1, 4),
                precision_at_k=round(precision_at_k, 4),
                k_value=k_value
            ),
            rule_breakdown=rule_breakdown,
            scenario_results=scenario_results,
            summary_text=summary
        )

validation_service = ValidationService()
