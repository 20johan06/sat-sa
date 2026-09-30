import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../ui/Card';
import Button from '../ui/Button';
import Skeleton from '../ui/Skeleton';
import ErrorState from '../ui/ErrorState';
import {
  ShieldAlert,
  Filter,
  HelpCircle,
  ChevronRight,
  CheckCircle2
} from 'lucide-react';
import { useQuery } from '@tanstack/react-query';
import { getAttentionQueue } from '../../api/supervisory';
import type { SupervisoryAttentionItem } from '../../types/api/supervisory';

export const SupervisoryAttentionQueue: React.FC = () => {
  const navigate = useNavigate();
  const [selectedSector, setSelectedSector] = useState<string>('');
  const [activeRationaleItem, setActiveRationaleItem] = useState<SupervisoryAttentionItem | null>(null);

  const { data, isLoading, isError, error, refetch } = useQuery({
    queryKey: ['supervisory-attention-queue', selectedSector],
    queryFn: () =>
      getAttentionQueue({
        sector: selectedSector || undefined,
        page: 1,
        page_size: 50,
      }),
  });

  return (
    <Card className="w-full font-sans">
      <CardHeader className="border-b border-slate-100 bg-slate-50/50 p-5">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <div className="flex items-center gap-2">
              <ShieldAlert className="w-5 h-5 text-blue-700" />
              <CardTitle className="text-base font-bold text-slate-900">
                Supervisory Attention Queue
              </CardTitle>
            </div>
            <CardDescription className="text-xs text-slate-500 mt-0.5 font-mono">
              Transparent, database-derived supervisory indicators aggregated from validated Phase 5 findings.
            </CardDescription>
          </div>

          {/* Sector Filter */}
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-1.5 text-xs text-slate-500 font-mono">
              <Filter className="w-3.5 h-3.5" />
              <span>SECTOR:</span>
              <select
                value={selectedSector}
                onChange={(e) => setSelectedSector(e.target.value)}
                className="bg-white border border-slate-200 rounded px-2.5 py-1 text-xs font-mono text-slate-800 focus:outline-none focus:ring-1 focus:ring-blue-500"
              >
                <option value="">ALL SECTORS</option>
                <option value="DEFENSE">DEFENSE</option>
                <option value="FINANCE">FINANCE</option>
                <option value="ENERGY">ENERGY</option>
                <option value="TELECOM">TELECOM</option>
                <option value="GOVERNMENT">GOVERNMENT</option>
              </select>
            </div>
          </div>
        </div>
      </CardHeader>

      <CardContent className="p-5">
        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-16 w-full" />
            <Skeleton className="h-16 w-full" />
          </div>
        ) : isError ? (
          <ErrorState
            title="Failed to Load Supervisory Attention Queue"
            message={error instanceof Error ? error.message : 'Unable to connect to supervisory service.'}
            onRetry={refetch}
          />
        ) : !data || data.items.length === 0 ? (
          <div className="text-center py-10 border border-dashed border-slate-200 rounded-md bg-slate-50/50">
            <CheckCircle2 className="w-8 h-8 text-emerald-500 mx-auto mb-2" />
            <p className="text-xs font-mono font-semibold text-slate-700">No Monitored Entities Found</p>
            <p className="text-[11px] text-slate-500 mt-1">No entity records match the selected sector criteria.</p>
          </div>
        ) : (
          <div className="space-y-5">
            {/* Transparent Summary Bar */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 font-mono">
              <div className="p-3 bg-slate-50 border border-slate-200 rounded-md">
                <span className="text-[11px] text-slate-500 block">TOTAL ENTITIES</span>
                <span className="text-xl font-bold text-slate-900">{data.total_cses}</span>
                <span className="text-[10px] text-slate-500 block mt-0.5">Monitored CSEs</span>
              </div>
              <div className="p-3 bg-blue-50/60 border border-blue-200/80 rounded-md">
                <span className="text-[11px] text-blue-700 font-semibold block">ENTITIES WITH FINDINGS</span>
                <span className="text-xl font-bold text-blue-900">{data.total_cses_with_active_findings}</span>
                <span className="text-[10px] text-blue-600 block mt-0.5">Require Inspection</span>
              </div>
              <div className="p-3 bg-red-50/60 border border-red-200/80 rounded-md">
                <span className="text-[11px] text-red-700 font-semibold block">CRITICAL FINDINGS</span>
                <span className="text-xl font-bold text-red-900">{data.total_critical_findings}</span>
                <span className="text-[10px] text-red-600 block mt-0.5">Active Critical Severity</span>
              </div>
              <div className="p-3 bg-amber-50/60 border border-amber-200/80 rounded-md">
                <span className="text-[11px] text-amber-700 font-semibold block">HIGH FINDINGS</span>
                <span className="text-xl font-bold text-amber-900">{data.total_high_findings}</span>
                <span className="text-[10px] text-amber-600 block mt-0.5">Active High Severity</span>
              </div>
            </div>

            {/* Queue Table */}
            <div className="overflow-x-auto border border-slate-200 rounded-md">
              <table className="w-full text-left border-collapse text-xs font-sans">
                <thead>
                  <tr className="bg-slate-100 text-slate-600 font-mono text-[11px] uppercase border-b border-slate-200">
                    <th className="py-2.5 px-3">CSE / Entity</th>
                    <th className="py-2.5 px-3">Sector</th>
                    <th className="py-2.5 px-3 text-center">Active Findings</th>
                    <th className="py-2.5 px-3 text-center">Severity Breakdown</th>
                    <th className="py-2.5 px-3 text-center">Affected Records</th>
                    <th className="py-2.5 px-3">Primary Category</th>
                    <th className="py-2.5 px-3">Rationale & Explainability</th>
                    <th className="py-2.5 px-3 text-right">Action</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 text-slate-800">
                  {data.items.map((item) => (
                    <tr key={item.cse_id} className="hover:bg-slate-50/80 transition-colors">
                      <td className="py-3 px-3">
                        <div className="font-bold text-slate-900">{item.cse_name}</div>
                        <div className="font-mono text-[11px] text-slate-500">{item.cse_code}</div>
                      </td>
                      <td className="py-3 px-3 font-mono font-medium text-slate-700">{item.sector}</td>
                      <td className="py-3 px-3 text-center">
                        <span className="font-mono font-bold text-slate-900 bg-slate-100 px-2 py-0.5 rounded">
                          {item.indicators.active_findings_count} Active
                        </span>
                      </td>
                      <td className="py-3 px-3 text-center font-mono text-[11px]">
                        <div className="flex items-center justify-center gap-1.5">
                          {item.indicators.active_critical_findings_count > 0 && (
                            <span className="px-1.5 py-0.5 bg-red-100 text-red-800 font-bold rounded">
                              {item.indicators.active_critical_findings_count} Crit
                            </span>
                          )}
                          {item.indicators.active_high_findings_count > 0 && (
                            <span className="px-1.5 py-0.5 bg-amber-100 text-amber-800 font-bold rounded">
                              {item.indicators.active_high_findings_count} High
                            </span>
                          )}
                          {item.indicators.active_critical_findings_count === 0 &&
                            item.indicators.active_high_findings_count === 0 && (
                              <span className="text-slate-500">
                                {item.indicators.active_findings_count > 0 ? 'Med/Low' : 'None'}
                              </span>
                            )}
                        </div>
                      </td>
                      <td className="py-3 px-3 text-center font-mono font-semibold text-slate-800">
                        {item.indicators.affected_record_count}
                      </td>
                      <td className="py-3 px-3 font-mono text-[11px]">
                        {item.dominant_categories.length > 0 ? (
                          <span className="px-2 py-0.5 bg-slate-100 text-slate-800 font-semibold rounded">
                            {item.dominant_categories[0]}
                          </span>
                        ) : (
                          <span className="text-slate-400">None</span>
                        )}
                      </td>
                      <td className="py-3 px-3">
                        <div className="text-xs text-slate-700 font-medium max-w-xs truncate">
                          {item.concise_rationale.what}
                        </div>
                        <button
                          onClick={() => setActiveRationaleItem(item)}
                          className="text-[11px] font-mono text-blue-600 hover:text-blue-800 font-semibold flex items-center gap-0.5 mt-0.5"
                        >
                          <HelpCircle className="w-3 h-3" /> View Rationale
                        </button>
                      </td>
                      <td className="py-3 px-3 text-right">
                        <Button
                          variant="secondary"
                          size="sm"
                          className="font-mono text-xs inline-flex items-center gap-1"
                          onClick={() => navigate(`/cses/${item.cse_id}`)}
                        >
                          Inspect <ChevronRight className="w-3 h-3" />
                        </Button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* Explainability Drawer Modal */}
        {activeRationaleItem && (
          <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-xs flex items-center justify-center p-4">
            <div className="bg-white border border-slate-200 rounded-lg shadow-xl max-w-xl w-full p-6 space-y-4 font-sans">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                <div className="flex items-center gap-2">
                  <ShieldAlert className="w-5 h-5 text-blue-600" />
                  <h3 className="text-base font-bold text-slate-900">
                    Explainable Supervisory Rationale
                  </h3>
                </div>
                <button
                  onClick={() => setActiveRationaleItem(null)}
                  className="text-slate-400 hover:text-slate-600 font-bold text-sm"
                >
                  ✕
                </button>
              </div>

              <div className="space-y-3 text-xs">
                <div className="bg-slate-50 p-3 rounded-md border border-slate-100">
                  <span className="font-mono text-slate-400 font-bold uppercase text-[10px] block">ENTITY</span>
                  <span className="font-bold text-slate-900 text-sm">{activeRationaleItem.cse_name} ({activeRationaleItem.cse_code})</span>
                </div>

                <div className="space-y-2">
                  <div className="p-2.5 bg-blue-50/50 border border-blue-100 rounded-md">
                    <span className="font-mono font-bold text-blue-900 block uppercase text-[10px]">WHAT (SIGNAL DETECTED)</span>
                    <p className="text-slate-800 font-semibold mt-0.5">{activeRationaleItem.concise_rationale.what}</p>
                  </div>

                  <div className="p-2.5 bg-amber-50/50 border border-amber-100 rounded-md">
                    <span className="font-mono font-bold text-amber-900 block uppercase text-[10px]">WHY (SUPERVISORY RELEVANCE)</span>
                    <p className="text-slate-800 mt-0.5">{activeRationaleItem.concise_rationale.why}</p>
                  </div>

                  <div className="p-2.5 bg-slate-50 border border-slate-200 rounded-md">
                    <span className="font-mono font-bold text-slate-700 block uppercase text-[10px]">HOW (ANALYTIC RULE)</span>
                    <p className="text-slate-800 font-mono text-[11px] mt-0.5">{activeRationaleItem.concise_rationale.how}</p>
                  </div>

                  <div className="p-2.5 bg-slate-50 border border-slate-200 rounded-md">
                    <span className="font-mono font-bold text-slate-700 block uppercase text-[10px]">EVIDENCE & RECORD COUNT</span>
                    <p className="text-slate-800 mt-0.5">{activeRationaleItem.concise_rationale.evidence}</p>
                  </div>

                  <div className="p-2.5 bg-slate-50 border border-slate-200 rounded-md">
                    <span className="font-mono font-bold text-slate-700 block uppercase text-[10px]">BASELINE & COMPARISON</span>
                    <p className="text-slate-800 font-mono text-[11px] mt-0.5">{activeRationaleItem.concise_rationale.baseline}</p>
                  </div>

                  <div className="p-2.5 bg-indigo-50/50 border border-indigo-100 rounded-md">
                    <span className="font-mono font-bold text-indigo-900 block uppercase text-[10px]">IMPACT / ACTION</span>
                    <p className="text-slate-800 font-medium mt-0.5">{activeRationaleItem.concise_rationale.impact}</p>
                  </div>
                </div>
              </div>

              <div className="flex justify-end pt-2 border-t border-slate-100">
                <Button variant="secondary" size="sm" onClick={() => setActiveRationaleItem(null)}>
                  Close
                </Button>
              </div>
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
};

export default SupervisoryAttentionQueue;
