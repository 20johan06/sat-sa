import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import { useCapabilityAssessment } from '../hooks/api/useCapability';
import type {
  CapabilitySufficiencyStatus,
  CapabilityAssessmentItem,
  FindingCapabilitySummary
} from '../types/api/capability';

export const CSECapabilityAssessmentPage: React.FC = () => {
  const { cseId } = useParams<{ cseId: string }>();
  const { data: assessment, isLoading, error } = useCapabilityAssessment(cseId || '');
  const [selectedExplainability, setSelectedExplainability] = useState<CapabilityAssessmentItem | null>(null);

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-10 w-10 border-t-2 border-b-2 border-indigo-500"></div>
      </div>
    );
  }

  if (error || !assessment) {
    return (
      <div className="p-6 text-red-400 bg-red-900/20 rounded-lg border border-red-800">
        <h3 className="text-lg font-semibold">Capability Assessment Unavailable</h3>
        <p className="mt-1 text-sm text-red-300">
          Unable to load capability assessment data for the requested Critical Sector Entity.
        </p>
      </div>
    );
  }

  const getStatusBadge = (status: CapabilitySufficiencyStatus) => {
    switch (status) {
      case 'SUPERVISORY_FINDINGS_PRESENT':
        return (
          <span className="px-3 py-1 rounded-full text-xs font-semibold bg-amber-500/20 text-amber-300 border border-amber-500/40">
            SUPERVISORY FINDINGS PRESENT
          </span>
        );
      case 'NO_FINDINGS_EVALUATED':
        return (
          <span className="px-3 py-1 rounded-full text-xs font-semibold bg-cyan-500/20 text-cyan-300 border border-cyan-500/40">
            NO FINDINGS EVALUATED
          </span>
        );
      case 'INSUFFICIENT_EVIDENCE':
        return (
          <span className="px-3 py-1 rounded-full text-xs font-semibold bg-slate-500/20 text-slate-300 border border-slate-500/40">
            INSUFFICIENT EVIDENCE
          </span>
        );
      default:
        return null;
    }
  };

  const getSeverityBadge = (sev: string) => {
    switch (sev.toUpperCase()) {
      case 'CRITICAL':
        return <span className="px-2 py-0.5 text-xs rounded bg-red-950 text-red-400 border border-red-800">CRITICAL</span>;
      case 'HIGH':
        return <span className="px-2 py-0.5 text-xs rounded bg-orange-950 text-orange-400 border border-orange-800">HIGH</span>;
      case 'MEDIUM':
        return <span className="px-2 py-0.5 text-xs rounded bg-amber-950 text-amber-400 border border-amber-800">MEDIUM</span>;
      case 'LOW':
        return <span className="px-2 py-0.5 text-xs rounded bg-blue-950 text-blue-400 border border-blue-800">LOW</span>;
      default:
        return <span className="px-2 py-0.5 text-xs rounded bg-slate-800 text-slate-400 border border-slate-700">NONE</span>;
    }
  };

  return (
    <div className="space-y-6 max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
      {/* Header */}
      <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-2xl font-bold text-slate-100">{assessment.cse_name}</h1>
              <span className="text-sm font-mono text-indigo-400 bg-indigo-950/60 px-2.5 py-1 rounded border border-indigo-800/50">
                {assessment.cse_code}
              </span>
            </div>
            <p className="text-slate-400 text-sm mt-1">
              Sector: <span className="text-slate-200">{assessment.sector}</span> | Criticality Tier:{' '}
              <span className="text-slate-200">{assessment.criticality_tier}</span>
            </p>
          </div>
          <div className="flex flex-wrap items-center gap-3">
            <div className="bg-slate-800/80 px-4 py-2 rounded-lg border border-slate-700 text-right">
              <span className="text-xs text-slate-400 block">Evaluated Dimensions</span>
              <span className="text-lg font-bold text-slate-100">{assessment.evaluated_capabilities_count} / 8</span>
            </div>
            <div className="bg-slate-800/80 px-4 py-2 rounded-lg border border-slate-700 text-right">
              <span className="text-xs text-slate-400 block">Active Supervisory Findings</span>
              <span className="text-lg font-bold text-amber-400">{assessment.total_active_findings}</span>
            </div>
          </div>
        </div>
      </div>

      {/* Capability Grid */}
      <div className="grid grid-cols-1 gap-6">
        {assessment.capabilities.map((cap) => (
          <div
            key={cap.capability}
            className="bg-slate-900 border border-slate-800 rounded-xl p-6 hover:border-slate-700 transition-all shadow-lg"
          >
            {/* Top Bar */}
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-3 pb-4 border-b border-slate-800">
              <div>
                <h2 className="text-xl font-bold text-slate-100">{cap.capability}</h2>
                <p className="text-xs text-slate-400 mt-1">{cap.status_description}</p>
              </div>
              <div className="flex items-center gap-3">
                {getStatusBadge(cap.status_indicator)}
                <button
                  onClick={() => setSelectedExplainability(cap)}
                  className="px-3 py-1 text-xs rounded bg-indigo-900/40 text-indigo-300 border border-indigo-700/50 hover:bg-indigo-900/60 transition-colors"
                >
                  View Explainability
                </button>
              </div>
            </div>

            {/* Evaluated Rules Metadata */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 my-4 py-3 bg-slate-950/40 px-4 rounded-lg border border-slate-800/60">
              <div>
                <span className="text-xs font-semibold text-slate-400 block uppercase tracking-wider">
                  Direct Rules Evaluated
                </span>
                <div className="flex flex-wrap gap-1.5 mt-1.5">
                  {cap.direct_rules_evaluated.length > 0 ? (
                    cap.direct_rules_evaluated.map((r) => (
                      <span
                        key={r}
                        className="text-xs font-mono bg-emerald-950/60 text-emerald-300 px-2 py-0.5 rounded border border-emerald-800/40"
                      >
                        {r}
                      </span>
                    ))
                  ) : (
                    <span className="text-xs text-slate-500 italic">None (No direct canonical rules)</span>
                  )}
                </div>
              </div>
              <div>
                <span className="text-xs font-semibold text-slate-400 block uppercase tracking-wider">
                  Indirect Signals Evaluated
                </span>
                <div className="flex flex-wrap gap-1.5 mt-1.5">
                  {cap.indirect_signals_evaluated.length > 0 ? (
                    cap.indirect_signals_evaluated.map((r) => (
                      <span
                        key={r}
                        className="text-xs font-mono bg-purple-950/60 text-purple-300 px-2 py-0.5 rounded border border-purple-800/40"
                      >
                        {r}
                      </span>
                    ))
                  ) : (
                    <span className="text-xs text-slate-500 italic">None</span>
                  )}
                </div>
              </div>
            </div>

            {/* Direct Findings Section */}
            {cap.direct_findings.length > 0 && (
              <div className="mt-4">
                <h3 className="text-xs font-bold text-emerald-400 uppercase tracking-wider mb-2">
                  Direct Capability Findings ({cap.direct_findings.length})
                </h3>
                <div className="space-y-2">
                  {cap.direct_findings.map((f: FindingCapabilitySummary) => (
                    <div
                      key={f.finding_id}
                      className="flex flex-col sm:flex-row sm:items-center justify-between p-3 bg-slate-950/60 rounded border border-slate-800 gap-2"
                    >
                      <div className="flex items-center gap-3">
                        <span className="text-xs font-mono text-indigo-300 bg-indigo-950 px-2 py-0.5 rounded border border-indigo-800">
                          {f.canonical_rule_code}
                        </span>
                        <span className="text-sm text-slate-200 font-medium">{f.title}</span>
                      </div>
                      <div className="flex items-center gap-3 text-xs">
                        {getSeverityBadge(f.severity)}
                        <span className="text-slate-400">{new Date(f.detected_at).toLocaleDateString()}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Indirect Signals Section */}
            {cap.indirect_findings.length > 0 && (
              <div className="mt-4">
                <h3 className="text-xs font-bold text-purple-400 uppercase tracking-wider mb-2">
                  Indirect Associated Signals ({cap.indirect_findings.length})
                </h3>
                <div className="space-y-2">
                  {cap.indirect_findings.map((f: FindingCapabilitySummary) => (
                    <div
                      key={f.finding_id}
                      className="flex flex-col sm:flex-row sm:items-center justify-between p-3 bg-purple-950/20 rounded border border-purple-900/30 gap-2"
                    >
                      <div className="flex items-center gap-3">
                        <span className="text-xs font-mono text-purple-300 bg-purple-950 px-2 py-0.5 rounded border border-purple-800">
                          {f.canonical_rule_code}
                        </span>
                        <span className="text-xs font-semibold text-purple-400 bg-purple-900/40 px-2 py-0.5 rounded uppercase">
                          Associated Signal
                        </span>
                        <span className="text-sm text-slate-200 font-medium">{f.title}</span>
                      </div>
                      <div className="flex items-center gap-3 text-xs">
                        {getSeverityBadge(f.severity)}
                        <span className="text-slate-400">{new Date(f.detected_at).toLocaleDateString()}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Empty State message */}
            {cap.direct_findings.length === 0 && cap.indirect_findings.length === 0 && (
              <div className="mt-3 p-3 bg-slate-950/30 rounded border border-slate-800/40 text-xs text-slate-400 italic">
                No active direct findings or indirect associated signals detected for this capability dimension.
              </div>
            )}

            {/* Bottom Summary Bar */}
            <div className="mt-4 pt-3 border-t border-slate-800/80 flex flex-wrap items-center justify-between gap-3 text-xs text-slate-400">
              <div className="flex items-center gap-4">
                <span>Linked Operational Evidence: <strong className="text-slate-200">{cap.evidence_count}</strong></span>
                <span>Max Severity: <strong className="text-slate-200">{cap.max_severity}</strong></span>
              </div>
              <div className="flex items-center gap-2">
                <span>Evidence Quality:</span>
                <span className="text-emerald-400">STRONG ({cap.evidence_strength_distribution.STRONG || 0})</span>
                <span className="text-amber-400">MODERATE ({cap.evidence_strength_distribution.MODERATE || 0})</span>
                <span className="text-slate-400">LIMITED ({cap.evidence_strength_distribution.LIMITED || 0})</span>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Factual Explainability Modal */}
      {selectedExplainability && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-xl max-w-2xl w-full p-6 space-y-4 shadow-2xl">
            <div className="flex items-center justify-between border-b border-slate-800 pb-3">
              <h3 className="text-lg font-bold text-slate-100">
                Capability Explainability — {selectedExplainability.capability}
              </h3>
              <button
                onClick={() => setSelectedExplainability(null)}
                className="text-slate-400 hover:text-slate-200 text-lg font-bold"
              >
                ✕
              </button>
            </div>
            <div className="space-y-3 text-sm text-slate-300 max-h-[60vh] overflow-y-auto pr-2">
              <div>
                <strong className="text-indigo-400 block text-xs uppercase tracking-wider">WHAT</strong>
                <p className="mt-0.5">{selectedExplainability.explainability.what}</p>
              </div>
              <div>
                <strong className="text-indigo-400 block text-xs uppercase tracking-wider">WHY</strong>
                <p className="mt-0.5">{selectedExplainability.explainability.why}</p>
              </div>
              <div>
                <strong className="text-indigo-400 block text-xs uppercase tracking-wider">HOW</strong>
                <p className="mt-0.5">{selectedExplainability.explainability.how}</p>
              </div>
              <div>
                <strong className="text-indigo-400 block text-xs uppercase tracking-wider">EVIDENCE</strong>
                <p className="mt-0.5">{selectedExplainability.explainability.evidence}</p>
              </div>
              <div>
                <strong className="text-indigo-400 block text-xs uppercase tracking-wider">BASELINE</strong>
                <p className="mt-0.5">{selectedExplainability.explainability.baseline}</p>
              </div>
              <div>
                <strong className="text-indigo-400 block text-xs uppercase tracking-wider">IMPACT</strong>
                <p className="mt-0.5">{selectedExplainability.explainability.impact}</p>
              </div>
            </div>
            <div className="pt-3 border-t border-slate-800 flex justify-end">
              <button
                onClick={() => setSelectedExplainability(null)}
                className="px-4 py-2 bg-slate-800 text-slate-200 text-xs font-semibold rounded hover:bg-slate-700 transition-colors"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
