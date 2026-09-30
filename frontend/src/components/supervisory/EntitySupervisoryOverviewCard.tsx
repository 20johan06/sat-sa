import React from 'react';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../ui/Card';
import Skeleton from '../ui/Skeleton';
import ErrorState from '../ui/ErrorState';
import {
  ShieldAlert,
  HelpCircle,
  BarChart3,
  Layers,
  AlertCircle
} from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { getEntitySupervisoryOverview } from '../../api/supervisory';

interface EntitySupervisoryOverviewCardProps {
  cseId: string;
}

export const EntitySupervisoryOverviewCard: React.FC<EntitySupervisoryOverviewCardProps> = ({ cseId }) => {
  const { data, isLoading, isError, error, refetch } = useQuery({
    queryKey: ['entity-supervisory-overview', cseId],
    queryFn: () => getEntitySupervisoryOverview(cseId),
    enabled: !!cseId,
  });

  if (isLoading) {
    return <Skeleton className="h-64 w-full" />;
  }

  if (isError) {
    return (
      <ErrorState
        title="Failed to Load Entity Supervisory Overview"
        message={error instanceof Error ? error.message : 'Unable to connect to supervisory service.'}
        onRetry={refetch}
      />
    );
  }

  if (!data) return null;

  return (
    <Card className="w-full border-blue-200 bg-white font-sans">
      <CardHeader className="border-b border-slate-100 bg-slate-50/60 p-5">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-3">
          <div>
            <div className="flex items-center gap-2">
              <ShieldAlert className="w-5 h-5 text-blue-700" />
              <CardTitle className="text-base font-bold text-slate-900">
                Supervisory Attention Overview
              </CardTitle>
            </div>
            <CardDescription className="text-xs text-slate-500 mt-0.5 font-mono">
              GET /api/v1/supervisory/cse/{cseId}/attention-overview
            </CardDescription>
          </div>
          <div>
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-mono font-bold bg-slate-100 text-slate-800 border border-slate-200">
              {data.indicators.active_findings_count} Active Finding(s)
              {data.indicators.active_critical_findings_count > 0 && (
                <span className="text-red-700">({data.indicators.active_critical_findings_count} Critical)</span>
              )}
            </span>
          </div>
        </div>
      </CardHeader>

      <CardContent className="p-5 space-y-6">
        {/* Core Question & Rationale Banner */}
        <div className="p-4 bg-slate-50 border border-slate-200 rounded-md space-y-3">
          <div className="flex items-center gap-2 text-xs font-mono font-bold text-slate-700 uppercase tracking-wide border-b border-slate-200 pb-2">
            <HelpCircle className="w-4 h-4 text-blue-600" />
            WHY IS THIS CSE SHOWING SUPERVISORY ATTENTION?
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-xs">
            <div className="bg-white p-3 rounded border border-slate-200">
              <span className="font-mono text-[10px] text-blue-700 font-bold uppercase block">WHAT WAS DETECTED</span>
              <p className="text-slate-900 font-bold mt-0.5">{data.why_attention.what}</p>
            </div>
            <div className="bg-white p-3 rounded border border-slate-200">
              <span className="font-mono text-[10px] text-amber-700 font-bold uppercase block">WHY IT MATTERS</span>
              <p className="text-slate-800 mt-0.5">{data.why_attention.why}</p>
            </div>
            <div className="bg-white p-3 rounded border border-slate-200">
              <span className="font-mono text-[10px] text-slate-500 font-bold uppercase block">EVIDENCE & RECORDS</span>
              <p className="text-slate-800 mt-0.5">{data.why_attention.evidence}</p>
            </div>
            <div className="bg-white p-3 rounded border border-slate-200">
              <span className="font-mono text-[10px] text-indigo-700 font-bold uppercase block">BASELINE & IMPACT</span>
              <p className="text-slate-800 font-mono text-[11px] mt-0.5">{data.why_attention.baseline}</p>
              <p className="text-slate-600 text-[11px] mt-1 italic">{data.why_attention.impact}</p>
            </div>
          </div>
        </div>

        {/* Data Quality Limitations Warning (If present) */}
        {data.data_quality_limitations && data.data_quality_limitations.length > 0 && (
          <div className="p-3 bg-amber-50 border border-amber-200 rounded-md text-xs text-amber-900 flex items-start gap-2">
            <AlertCircle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
            <div>
              <span className="font-mono font-bold block mb-0.5">DATA SUFFICIENCY LIMITATIONS:</span>
              <ul className="list-disc list-inside space-y-0.5 font-mono text-[11px]">
                {data.data_quality_limitations.map((lim, idx) => (
                  <li key={idx}>{lim}</li>
                ))}
              </ul>
            </div>
          </div>
        )}

        {/* Indicators & Capability Breakdown */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Key Indicators Summary */}
          <div className="space-y-3">
            <h4 className="text-xs font-mono font-bold text-slate-700 uppercase flex items-center gap-1.5">
              <Layers className="w-4 h-4 text-slate-500" />
              Supervisory Indicator Metrics
            </h4>
            <div className="grid grid-cols-2 gap-2 text-xs">
              <div className="p-2.5 bg-slate-50 border border-slate-200 rounded font-mono">
                <span className="text-[10px] text-slate-500 block">ACTIVE FINDINGS</span>
                <span className="text-base font-bold text-slate-900">{data.indicators.active_findings_count}</span>
              </div>
              <div className="p-2.5 bg-slate-50 border border-slate-200 rounded font-mono">
                <span className="text-[10px] text-slate-500 block">CRITICAL / HIGH FINDINGS</span>
                <span className="text-base font-bold text-red-700">{data.indicators.high_attention_findings_count}</span>
              </div>
              <div className="p-2.5 bg-slate-50 border border-slate-200 rounded font-mono">
                <span className="text-[10px] text-slate-500 block">EXECUTION GAPS</span>
                <span className="text-base font-bold text-slate-800">{data.indicators.execution_gap_findings_count}</span>
              </div>
              <div className="p-2.5 bg-slate-50 border border-slate-200 rounded font-mono">
                <span className="text-[10px] text-slate-500 block">PEER DEVIATIONS</span>
                <span className="text-base font-bold text-indigo-700">{data.indicators.peer_deviations_count}</span>
              </div>
            </div>

            {/* Evidence Strength Breakdown */}
            <div className="p-3 bg-slate-50 border border-slate-200 rounded text-xs space-y-2 font-mono">
              <span className="font-bold text-slate-700 text-[11px] block">EVIDENCE STRENGTH DISTRIBUTION</span>
              <div className="grid grid-cols-4 gap-1 text-center text-[10px]">
                <div className="p-1 bg-emerald-100 text-emerald-800 rounded font-semibold">
                  STRONG: <span className="font-bold">{data.evidence_strength_distribution.STRONG || 0}</span>
                </div>
                <div className="p-1 bg-blue-100 text-blue-800 rounded font-semibold">
                  MODERATE: <span className="font-bold">{data.evidence_strength_distribution.MODERATE || 0}</span>
                </div>
                <div className="p-1 bg-amber-100 text-amber-800 rounded font-semibold">
                  LIMITED: <span className="font-bold">{data.evidence_strength_distribution.LIMITED || 0}</span>
                </div>
                <div className="p-1 bg-slate-200 text-slate-700 rounded font-semibold">
                  NONE: <span className="font-bold">{data.evidence_strength_distribution.NONE || 0}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Capabilities Breakdown */}
          <div className="space-y-3">
            <h4 className="text-xs font-mono font-bold text-slate-700 uppercase flex items-center gap-1.5">
              <BarChart3 className="w-4 h-4 text-slate-500" />
              Affected Capability Dimensions
            </h4>
            <div className="border border-slate-200 rounded overflow-hidden">
              <table className="w-full text-left text-xs font-mono">
                <thead>
                  <tr className="bg-slate-100 text-slate-600 text-[10px] uppercase border-b border-slate-200">
                    <th className="py-2 px-3">Capability</th>
                    <th className="py-2 px-2 text-center">Findings</th>
                    <th className="py-2 px-2 text-center">Max Severity</th>
                    <th className="py-2 px-2 text-center">Evidence</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 font-sans">
                  {data.capabilities_breakdown.length === 0 ? (
                    <tr>
                      <td colSpan={4} className="py-3 px-3 text-center text-slate-400 font-mono text-[11px]">
                        No capability gaps detected.
                      </td>
                    </tr>
                  ) : (
                    data.capabilities_breakdown.map((cap, idx) => (
                      <tr key={idx} className="hover:bg-slate-50 font-xs">
                        <td className="py-2 px-3 font-semibold text-slate-800">{cap.capability}</td>
                        <td className="py-2 px-2 text-center font-mono font-bold">{cap.findings_count}</td>
                        <td className="py-2 px-2 text-center font-mono">
                          <span
                            className={`px-1.5 py-0.5 rounded text-[10px] font-bold ${
                              cap.max_severity === 'CRITICAL'
                                ? 'bg-red-100 text-red-800'
                                : cap.max_severity === 'HIGH'
                                ? 'bg-amber-100 text-amber-800'
                                : 'bg-blue-100 text-blue-800'
                            }`}
                          >
                            {cap.max_severity}
                          </span>
                        </td>
                        <td className="py-2 px-2 text-center font-mono">{cap.evidence_count}</td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default EntitySupervisoryOverviewCard;
