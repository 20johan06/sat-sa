import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import { useCSETrendsQuery } from '../hooks/api/useTrends';
import type { TrendMetricItem } from '../types/api/trends';

export const CSETrendsPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const [windowDays, setWindowDays] = useState<number>(30);

  const { data: trends, isLoading, error } = useCSETrendsQuery(cse_id || '', {
    window_days: windowDays,
  });

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-10 w-10 border-t-2 border-b-2 border-indigo-500"></div>
      </div>
    );
  }

  if (error || !trends) {
    return (
      <div className="p-6 text-red-400 bg-red-900/20 rounded-lg border border-red-800">
        <h3 className="text-lg font-semibold">Trends & Historical Analytics Unavailable</h3>
        <p className="mt-1 text-sm text-red-300">
          Unable to load historical trend analytics for the requested Critical Sector Entity.
        </p>
      </div>
    );
  }

  const formatPeriodDate = (dStr?: string | null) => {
    if (!dStr) return 'N/A';
    return new Date(dStr).toLocaleDateString(undefined, {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  };

  const getStrengthBadge = (strength: string) => {
    switch (strength) {
      case 'STRONG':
        return <span className="px-2 py-0.5 text-xs font-semibold rounded bg-emerald-950 text-emerald-300 border border-emerald-800">STRONG</span>;
      case 'MODERATE':
        return <span className="px-2 py-0.5 text-xs font-semibold rounded bg-amber-950 text-amber-300 border border-amber-800">MODERATE</span>;
      default:
        return <span className="px-2 py-0.5 text-xs font-semibold rounded bg-slate-800 text-slate-400 border border-slate-700">LIMITED</span>;
    }
  };

  return (
    <div className="space-y-6 max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
      {/* Header Bar */}
      <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-2xl font-bold text-slate-100">{trends.cse_name}</h1>
            <span className="text-sm font-mono text-indigo-400 bg-indigo-950/60 px-2.5 py-1 rounded border border-indigo-800/50">
              {trends.cse_code}
            </span>
          </div>
          <p className="text-slate-400 text-sm mt-1">
            Historical Trends & Period Comparisons | Sector: <span className="text-slate-200">{trends.sector}</span>
          </p>
        </div>

        <div className="flex items-center gap-3">
          <label className="text-xs text-slate-400 font-semibold uppercase tracking-wider">Window:</label>
          <select
            value={windowDays}
            onChange={(e) => setWindowDays(Number(e.target.value))}
            className="bg-slate-800 text-slate-200 border border-slate-700 rounded px-3 py-1.5 text-xs font-semibold focus:outline-none focus:border-indigo-500"
          >
            <option value={14}>14 Days</option>
            <option value={30}>30 Days</option>
            <option value={60}>60 Days</option>
            <option value={90}>90 Days</option>
          </select>
        </div>
      </div>

      {/* Observation Period Details */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div className="bg-slate-900/80 border border-slate-800 p-4 rounded-lg">
          <span className="text-xs font-semibold text-indigo-400 uppercase tracking-wider block">Current Period (P₀)</span>
          <p className="text-sm text-slate-200 font-mono mt-1">
            {formatPeriodDate(trends.current_period.start)} — {formatPeriodDate(trends.current_period.end)}
          </p>
        </div>
        <div className="bg-slate-900/80 border border-slate-800 p-4 rounded-lg">
          <span className="text-xs font-semibold text-purple-400 uppercase tracking-wider block">Previous Period (P₋₁)</span>
          <p className="text-sm text-slate-200 font-mono mt-1">
            {formatPeriodDate(trends.previous_period?.start)} — {formatPeriodDate(trends.previous_period?.end)}
          </p>
        </div>
      </div>

      {/* Telemetry & Canonical Rule Metrics Table */}
      <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-lg">
        <h2 className="text-lg font-bold text-slate-100 mb-4">Operational Telemetry & Canonical Rule Metric Trends</h2>
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm text-slate-300">
            <thead className="bg-slate-950 text-xs font-semibold uppercase tracking-wider text-slate-400 border-b border-slate-800">
              <tr>
                <th className="py-3 px-4">Metric Dimension</th>
                <th className="py-3 px-4">Rule Code</th>
                <th className="py-3 px-4 text-right">Current (P₀)</th>
                <th className="py-3 px-4 text-right">Previous (P₋₁)</th>
                <th className="py-3 px-4 text-right">Abs Change</th>
                <th className="py-3 px-4 text-right">Pct Change</th>
                <th className="py-3 px-4">Evidence Quality</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800/60">
              {trends.metrics.map((m: TrendMetricItem, idx: number) => (
                <tr key={idx} className="hover:bg-slate-800/40 transition-colors">
                  <td className="py-3 px-4 font-medium text-slate-200">{m.metric_name}</td>
                  <td className="py-3 px-4">
                    {m.rule_code ? (
                      <span className="font-mono text-xs text-indigo-300 bg-indigo-950 px-2 py-0.5 rounded border border-indigo-800">
                        {m.rule_code}
                      </span>
                    ) : (
                      <span className="text-slate-500 text-xs italic">N/A</span>
                    )}
                  </td>
                  <td className="py-3 px-4 text-right font-mono font-semibold text-slate-100">
                    {m.current_value !== null && m.current_value !== undefined ? m.current_value : '—'}
                  </td>
                  <td className="py-3 px-4 text-right font-mono text-slate-400">
                    {m.previous_value !== null && m.previous_value !== undefined ? m.previous_value : '—'}
                  </td>
                  <td className="py-3 px-4 text-right font-mono">
                    {m.absolute_change !== null && m.absolute_change !== undefined ? (
                      <span className={m.absolute_change > 0 ? 'text-amber-400' : m.absolute_change < 0 ? 'text-cyan-400' : 'text-slate-400'}>
                        {m.absolute_change > 0 ? `+${m.absolute_change}` : m.absolute_change}
                      </span>
                    ) : (
                      '—'
                    )}
                  </td>
                  <td className="py-3 px-4 text-right font-mono">
                    {m.percentage_change !== null && m.percentage_change !== undefined ? (
                      <span>{m.percentage_change > 0 ? `+${m.percentage_change.toFixed(1)}%` : `${m.percentage_change.toFixed(1)}%`}</span>
                    ) : (
                      <span className="text-slate-500 text-xs italic" title={m.limitation || undefined}>
                        N/A
                      </span>
                    )}
                  </td>
                  <td className="py-3 px-4">{getStrengthBadge(m.evidence_strength)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Capability Trends Grid */}
      <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-lg">
        <h2 className="text-lg font-bold text-slate-100 mb-4">Eight Capability Dimension Signal Trends</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          {trends.capability_trends.map((cap) => (
            <div key={cap.capability} className="bg-slate-950/60 border border-slate-800 p-4 rounded-lg">
              <h3 className="text-sm font-bold text-slate-200">{cap.capability}</h3>
              <div className="mt-3 space-y-2 text-xs">
                <div className="flex justify-between border-b border-slate-800 pb-1">
                  <span className="text-slate-400">Direct Findings (P₀):</span>
                  <span className="font-mono text-emerald-400 font-bold">{cap.direct_findings_current}</span>
                </div>
                <div className="flex justify-between border-b border-slate-800 pb-1">
                  <span className="text-slate-400">Direct Findings (P₋₁):</span>
                  <span className="font-mono text-slate-400">{cap.direct_findings_previous}</span>
                </div>
                <div className="flex justify-between border-b border-slate-800 pb-1">
                  <span className="text-slate-400">Indirect Signals (P₀):</span>
                  <span className="font-mono text-purple-400 font-bold">{cap.indirect_signals_current}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Indirect Signals (P₋₁):</span>
                  <span className="font-mono text-slate-400">{cap.indirect_signals_previous}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
