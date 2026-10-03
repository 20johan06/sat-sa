import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useValidationResults, useGenerateSyntheticData, useRunValidation } from '../hooks/api/useValidation';
import { SyntheticNoticeBanner } from '../components/supervisory/SyntheticNoticeBanner';
import type { ScenarioResultItem, RuleConfusionMatrix } from '../types/api/validation';

export const ValidationPage: React.FC = () => {
  const { user } = useAuth();
  const [kValue, setKValue] = useState<number>(5);

  const isSupervisorOrAdmin = user?.role === 'ADMIN' || user?.role === 'SUPERVISOR';

  const { data: valData, isLoading } = useValidationResults(kValue);
  const generateMutation = useGenerateSyntheticData();
  const runMutation = useRunValidation();

  const handleGenerate = async () => {
    try {
      await generateMutation.mutateAsync({ force_recreate: true });
    } catch (err) {
      console.error('Failed to generate synthetic dataset:', err);
    }
  };

  const handleRunValidation = async () => {
    try {
      await runMutation.mutateAsync({ k_value: kValue });
    } catch (err) {
      console.error('Failed to run validation pipeline:', err);
    }
  };

  return (
    <div className="space-y-6 p-6 max-w-7xl mx-auto">
      {/* Header Bar */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-2xl font-bold text-white tracking-tight">Synthetic Data & Validation Engine</h1>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
              Phase 13 Validation Framework
            </span>
          </div>
          <p className="text-sm text-slate-400 mt-1">
            Evaluate detection metrics (TP, FP, FN, TN, Precision, Recall, F1, Precision@K) across 8 canonical rules on isolated synthetic datasets.
          </p>
        </div>

        {isSupervisorOrAdmin && (
          <div className="flex items-center gap-3">
            <button
              onClick={handleGenerate}
              disabled={generateMutation.isPending}
              className="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-medium rounded-lg transition border border-slate-700 disabled:opacity-50"
            >
              {generateMutation.isPending ? 'Seeding Data...' : 'Seed Synthetic Scenarios'}
            </button>
            <button
              onClick={handleRunValidation}
              disabled={runMutation.isPending}
              className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-medium rounded-lg transition shadow-lg disabled:opacity-50"
            >
              {runMutation.isPending ? 'Executing Analytics...' : 'Run Validation Pipeline'}
            </button>
          </div>
        )}
      </div>

      {isLoading || !valData ? (
        <div className="text-slate-300 text-sm py-16 text-center bg-slate-900 rounded-xl border border-slate-800 space-y-4 shadow-xl">
          <div className="w-10 h-10 border-4 border-emerald-500 border-t-transparent rounded-full animate-spin mx-auto"></div>
          <div>
            <p className="font-bold text-base text-white font-mono">Running controlled synthetic validation...</p>
            <p className="text-xs text-slate-400 mt-1">Evaluating canonical supervisory rules across synthetic scenarios...</p>
            <p className="text-[11px] text-slate-500 font-mono mt-0.5">Results will appear when validation engine completes calculation.</p>
          </div>
        </div>
      ) : (
        <>
          {/* Synthetic Validation Environment Disclaimer Banner */}
          <SyntheticNoticeBanner className="mb-2" />

          {/* Executive Metrics Overview Cards */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-slate-900 border border-slate-800 p-5 rounded-xl shadow-lg">
              <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Precision</div>
              <div className="text-3xl font-bold text-emerald-400 mt-2">
                {(valData.metrics.precision * 100).toFixed(1)}%
              </div>
              <div className="text-xs text-slate-500 mt-1">TP / (TP + FP)</div>
            </div>

            <div className="bg-slate-900 border border-slate-800 p-5 rounded-xl shadow-lg">
              <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Recall</div>
              <div className="text-3xl font-bold text-blue-400 mt-2">
                {(valData.metrics.recall * 100).toFixed(1)}%
              </div>
              <div className="text-xs text-slate-500 mt-1">TP / (TP + FN)</div>
            </div>

            <div className="bg-slate-900 border border-slate-800 p-5 rounded-xl shadow-lg">
              <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">F1 Score</div>
              <div className="text-3xl font-bold text-purple-400 mt-2">
                {(valData.metrics.f1_score * 100).toFixed(1)}%
              </div>
              <div className="text-xs text-slate-500 mt-1">Harmonic Mean</div>
            </div>

            <div className="bg-slate-900 border border-slate-800 p-5 rounded-xl shadow-lg">
              <div className="flex items-center justify-between">
                <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Precision@{kValue}</div>
                <select
                  value={kValue}
                  onChange={(e) => setKValue(Number(e.target.value))}
                  className="bg-slate-800 text-xs text-slate-200 rounded px-1.5 py-0.5 border border-slate-700"
                >
                  <option value={3}>K=3</option>
                  <option value={5}>K=5</option>
                  <option value={10}>K=10</option>
                </select>
              </div>
              <div className="text-3xl font-bold text-amber-400 mt-2">
                {(valData.metrics.precision_at_k * 100).toFixed(1)}%
              </div>
              <div className="text-xs text-slate-500 mt-1">Phase 8 Manual Review Rank</div>
            </div>
          </div>

          {/* Aggregated Confusion Matrix Banner */}
          <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl">
            <h2 className="text-lg font-semibold text-white mb-4">Aggregated Confusion Matrix</h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
              <div className="bg-emerald-950/30 border border-emerald-800/40 p-4 rounded-lg">
                <div className="text-xs font-semibold text-emerald-400 uppercase">True Positives (TP)</div>
                <div className="text-2xl font-bold text-white mt-1">{valData.confusion_matrix.true_positives}</div>
              </div>
              <div className="bg-rose-950/30 border border-rose-800/40 p-4 rounded-lg">
                <div className="text-xs font-semibold text-rose-400 uppercase">False Positives (FP)</div>
                <div className="text-2xl font-bold text-white mt-1">{valData.confusion_matrix.false_positives}</div>
              </div>
              <div className="bg-amber-950/30 border border-amber-800/40 p-4 rounded-lg">
                <div className="text-xs font-semibold text-amber-400 uppercase">False Negatives (FN)</div>
                <div className="text-2xl font-bold text-white mt-1">{valData.confusion_matrix.false_negatives}</div>
              </div>
              <div className="bg-slate-800/50 border border-slate-700/50 p-4 rounded-lg">
                <div className="text-xs font-semibold text-slate-300 uppercase">True Negatives (TN)</div>
                <div className="text-2xl font-bold text-white mt-1">{valData.confusion_matrix.true_negatives}</div>
              </div>
            </div>
          </div>

          {/* Canonical Rule Breakdown Table */}
          <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl space-y-4">
            <h2 className="text-lg font-semibold text-white">Canonical Rule Precision Breakdown</h2>
            <div className="overflow-x-auto">
              <table className="w-full text-left text-sm text-slate-300">
                <thead className="bg-slate-800/60 text-slate-400 uppercase text-xs">
                  <tr>
                    <th className="px-4 py-3">Rule Code</th>
                    <th className="px-4 py-3">TP</th>
                    <th className="px-4 py-3">FP</th>
                    <th className="px-4 py-3">FN</th>
                    <th className="px-4 py-3">TN</th>
                    <th className="px-4 py-3">Precision</th>
                    <th className="px-4 py-3">Recall</th>
                    <th className="px-4 py-3">F1 Score</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/50 font-mono text-xs">
                  {Object.values(valData.rule_breakdown || {}).map((m: RuleConfusionMatrix) => (
                    <tr key={m.rule_code} className="hover:bg-slate-800/30">
                      <td className="px-4 py-3 text-blue-400 font-bold">{m.rule_code}</td>
                      <td className="px-4 py-3 text-emerald-400">{m.tp}</td>
                      <td className="px-4 py-3 text-rose-400">{m.fp}</td>
                      <td className="px-4 py-3 text-amber-400">{m.fn}</td>
                      <td className="px-4 py-3 text-slate-400">{m.tn}</td>
                      <td className="px-4 py-3 text-slate-200">{(m.precision * 100).toFixed(0)}%</td>
                      <td className="px-4 py-3 text-slate-200">{(m.recall * 100).toFixed(0)}%</td>
                      <td className="px-4 py-3 text-purple-300">{(m.f1_score * 100).toFixed(0)}%</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Synthetic Scenario Ground Truth Table */}
          <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl space-y-4">
            <h2 className="text-lg font-semibold text-white">Scenario Detection Results</h2>
            <div className="space-y-3">
              {valData.scenario_results.map((scen: ScenarioResultItem) => (
                <div key={scen.scenario_id} className="bg-slate-800/40 border border-slate-700/50 p-4 rounded-lg flex flex-col md:flex-row md:items-center justify-between gap-3 text-xs">
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-mono font-bold text-slate-200">{scen.scenario_id}</span>
                      <span className="font-mono text-slate-400">({scen.cse_code})</span>
                    </div>
                    <p className="text-slate-400 mt-1">{scen.notes}</p>
                  </div>

                  <div className="flex items-center gap-3">
                    <span className="px-2.5 py-1 rounded bg-slate-800 text-slate-300 font-mono">
                      Expected: {scen.expected_presence}
                    </span>
                    <span className={`px-2.5 py-1 rounded font-bold font-mono ${
                      scen.actual_presence === 'FINDING_GENERATED' ? 'bg-blue-500/20 text-blue-300 border border-blue-500/30' : 'bg-slate-800 text-slate-400'
                    }`}>
                      Actual: {scen.actual_presence}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default ValidationPage;
