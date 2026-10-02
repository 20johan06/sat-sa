import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useCsesQuery } from '../hooks/api/useCses';
import { useReportsList, useReportDetail, useGenerateReport } from '../hooks/api/useReports';
import { reportsApi } from '../api/reports';
import type { CSEResponse } from '../types/api/cse';
import type { ReportItem } from '../types/api/reports';

export const ReportsPage: React.FC = () => {
  const { cse_id: routeCseId } = useParams<{ cse_id?: string }>();
  const { user } = useAuth();
  const { data: csesData } = useCsesQuery();

  const cses: CSEResponse[] = Array.isArray(csesData) ? csesData : [];
  const [selectedCSEId, setSelectedCSEId] = useState<string>(routeCseId || cses[0]?.id || '');
  const [selectedReportId, setSelectedReportId] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<'history' | 'preview'>('history');

  const activeCseId = routeCseId || selectedCSEId;

  const isSupervisorOrAdmin = user?.role === 'ADMIN' || user?.role === 'SUPERVISOR';

  const { data: reportsData, isLoading: isListLoading } = useReportsList(activeCseId);
  const { data: reportDetail, isLoading: isDetailLoading } = useReportDetail(selectedReportId);
  const generateReportMutation = useGenerateReport();

  const handleGenerate = async () => {
    if (!activeCseId) return;
    try {
      const res = await generateReportMutation.mutateAsync({ cse_id: activeCseId });
      if (res && res.report_metadata && res.report_metadata.report_id) {
        setSelectedReportId(res.report_metadata.report_id);
        setActiveTab('preview');
      }
    } catch (err) {
      console.error('Failed to generate report:', err);
    }
  };

  const handleExportPDF = (reportId: string, code: string) => {
    reportsApi.exportPDF(reportId, `${code}.pdf`);
  };

  const handleExportCSV = (reportId: string, code: string) => {
    reportsApi.exportCSV(reportId, `${code}_evidence.csv`);
  };

  const handleExportJSON = (reportId: string, code: string) => {
    reportsApi.exportJSON(reportId, `${code}.json`);
  };

  return (
    <div className="space-y-6 p-6 max-w-7xl mx-auto">
      {/* Top Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-2xl font-bold text-white tracking-tight">Supervisory Assessment Reports</h1>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-blue-500/10 text-blue-400 border border-blue-500/20">
              Phase 12 Presentation & Export
            </span>
          </div>
          <p className="text-sm text-slate-400 mt-1">
            Generate and export auditable supervisory reports with immutable dataset provenance.
          </p>
        </div>

        <div className="flex items-center gap-3">
          {!routeCseId && cses.length > 0 && (
            <select
              value={activeCseId}
              onChange={(e) => setSelectedCSEId(e.target.value)}
              className="bg-slate-800 border border-slate-700 text-slate-200 text-xs rounded-lg px-3 py-2"
            >
              {cses.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name} ({c.cse_code})
                </option>
              ))}
            </select>
          )}

          {isSupervisorOrAdmin && (
            <button
              onClick={handleGenerate}
              disabled={!activeCseId || generateReportMutation.isPending}
              className="px-5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white font-medium text-sm rounded-lg transition-all shadow-lg hover:shadow-blue-500/20 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              {generateReportMutation.isPending ? (
                <span>Generating Report...</span>
              ) : (
                <>
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
                  </svg>
                  <span>Generate Report Snapshot</span>
                </>
              )}
            </button>
          )}
        </div>
      </div>

      {/* Main Tabs */}
      <div className="flex border-b border-slate-800">
        <button
          onClick={() => setActiveTab('history')}
          className={`px-4 py-3 text-sm font-medium border-b-2 transition-colors ${
            activeTab === 'history'
              ? 'border-blue-500 text-blue-400 font-semibold'
              : 'border-transparent text-slate-400 hover:text-slate-200'
          }`}
        >
          Report History List ({reportsData?.total || 0})
        </button>
        {selectedReportId && (
          <button
            onClick={() => setActiveTab('preview')}
            className={`px-4 py-3 text-sm font-medium border-b-2 transition-colors ${
              activeTab === 'preview'
                ? 'border-blue-500 text-blue-400 font-semibold'
                : 'border-transparent text-slate-400 hover:text-slate-200'
            }`}
          >
            Report Preview & Export
          </button>
        )}
      </div>

      {/* History Tab */}
      {activeTab === 'history' && (
        <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl space-y-4">
          <h2 className="text-lg font-semibold text-white">Generated Historical Snapshots</h2>
          {isListLoading ? (
            <div className="text-slate-400 text-sm py-8 text-center">Loading reports history...</div>
          ) : !reportsData?.items || reportsData.items.length === 0 ? (
            <div className="text-slate-400 text-sm py-8 text-center border border-dashed border-slate-800 rounded-lg">
              No supervisory reports generated for this CSE yet. Click "Generate Report Snapshot" above.
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-left text-sm text-slate-300">
                <thead className="bg-slate-800/60 text-slate-400 uppercase text-xs">
                  <tr>
                    <th className="px-4 py-3">Report Code</th>
                    <th className="px-4 py-3">Created At</th>
                    <th className="px-4 py-3">Generated By</th>
                    <th className="px-4 py-3">Observation Period</th>
                    <th className="px-4 py-3 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/50">
                  {reportsData.items.map((r: ReportItem) => (
                    <tr key={r.id} className="hover:bg-slate-800/30 transition-colors">
                      <td className="px-4 py-3.5 font-mono text-blue-400 font-medium">{r.report_code}</td>
                      <td className="px-4 py-3.5 text-slate-300">{new Date(r.created_at).toLocaleString()}</td>
                      <td className="px-4 py-3.5 text-slate-300">{r.generated_by_username}</td>
                      <td className="px-4 py-3.5 text-slate-400 text-xs">
                        {r.obs_start ? new Date(r.obs_start).toLocaleDateString() : 'Unbounded'} to{' '}
                        {r.obs_end ? new Date(r.obs_end).toLocaleDateString() : 'Unbounded'}
                      </td>
                      <td className="px-4 py-3.5 text-right space-x-2">
                        <button
                          onClick={() => {
                            setSelectedReportId(r.id);
                            setActiveTab('preview');
                          }}
                          className="px-3 py-1.5 bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-medium rounded transition"
                        >
                          View Preview
                        </button>
                        {isSupervisorOrAdmin && (
                          <>
                            <button
                              onClick={() => handleExportPDF(r.id, r.report_code)}
                              className="px-3 py-1.5 bg-blue-600/20 hover:bg-blue-600/30 text-blue-300 border border-blue-500/30 text-xs font-medium rounded transition"
                            >
                              PDF
                            </button>
                            <button
                              onClick={() => handleExportCSV(r.id, r.report_code)}
                              className="px-3 py-1.5 bg-emerald-600/20 hover:bg-emerald-600/30 text-emerald-300 border border-emerald-500/30 text-xs font-medium rounded transition"
                            >
                              CSV
                            </button>
                          </>
                        )}
                        <button
                          onClick={() => handleExportJSON(r.id, r.report_code)}
                          className="px-3 py-1.5 bg-purple-600/20 hover:bg-purple-600/30 text-purple-300 border border-purple-500/30 text-xs font-medium rounded transition"
                        >
                          JSON
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}

      {/* Preview & Export Tab */}
      {activeTab === 'preview' && selectedReportId && (
        <div className="space-y-6">
          {isDetailLoading || !reportDetail ? (
            <div className="text-slate-400 text-sm py-12 text-center bg-slate-900 rounded-xl border border-slate-800">
              Loading report preview...
            </div>
          ) : (
            <>
              {/* Provenance & Export Action Bar */}
              <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white font-mono">{reportDetail.report_metadata.report_code}</h2>
                  <p className="text-xs text-slate-400 mt-1">
                    Generated: {new Date(reportDetail.report_metadata.generated_at).toLocaleString()} by{' '}
                    <span className="text-slate-200 font-semibold">{reportDetail.report_metadata.generated_by_user}</span>
                  </p>
                </div>
                <div className="flex items-center gap-3">
                  {isSupervisorOrAdmin && (
                    <>
                      <button
                        onClick={() => handleExportPDF(selectedReportId, reportDetail.report_metadata.report_code)}
                        className="px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white font-medium text-xs rounded-lg transition shadow-md"
                      >
                        Export PDF
                      </button>
                      <button
                        onClick={() => handleExportCSV(selectedReportId, reportDetail.report_metadata.report_code)}
                        className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-medium text-xs rounded-lg transition shadow-md"
                      >
                        Export CSV
                      </button>
                    </>
                  )}
                  <button
                    onClick={() => handleExportJSON(selectedReportId, reportDetail.report_metadata.report_code)}
                    className="px-4 py-2 bg-purple-600 hover:bg-purple-500 text-white font-medium text-xs rounded-lg transition shadow-md"
                  >
                    Export JSON
                  </button>
                </div>
              </div>

              {/* Signals Overview Cards */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {Object.entries(reportDetail.supervisory_signals_summary || {}).map(([cat, count]: [string, number]) => (
                  <div key={cat} className="bg-slate-900 border border-slate-800 p-4 rounded-xl shadow-lg">
                    <div className="text-xs font-semibold text-slate-400 uppercase tracking-wider">{cat}</div>
                    <div className="text-2xl font-bold text-white mt-1">{count}</div>
                    <div className="text-xs text-slate-500 mt-1">{count > 0 ? 'Actionable Triggers' : 'Clear'}</div>
                  </div>
                ))}
              </div>

              {/* Detailed Findings & Explainability */}
              <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl space-y-4">
                <h3 className="text-lg font-semibold text-white">Supervisory Findings & 6-Part Explainability</h3>
                {reportDetail.active_findings && reportDetail.active_findings.length > 0 ? (
                  <div className="space-y-4">
                    {reportDetail.active_findings.map((f: any) => (
                      <div key={f.id} className="bg-slate-800/40 border border-slate-700/50 p-5 rounded-lg space-y-3">
                        <div className="flex items-center justify-between">
                          <span className="font-mono text-xs font-bold text-blue-400">{f.finding_code}</span>
                          <span className="px-2.5 py-0.5 rounded text-xs font-bold bg-slate-800 text-slate-300">
                            {f.status}
                          </span>
                        </div>
                        <h4 className="font-semibold text-white">{f.title}</h4>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-xs bg-slate-950/40 p-3 rounded border border-slate-800/60">
                          <div><span className="font-bold text-slate-400">WHAT:</span> <span className="text-slate-300">{f.explainability?.what || f.description}</span></div>
                          <div><span className="font-bold text-slate-400">WHY:</span> <span className="text-slate-300">{f.explainability?.why || f.rationale}</span></div>
                          <div><span className="font-bold text-slate-400">HOW:</span> <span className="text-slate-300">{f.explainability?.how || f.detection_method}</span></div>
                          <div><span className="font-bold text-slate-400">EVIDENCE:</span> <span className="text-slate-300">{f.explainability?.evidence || `${f.evidence?.length || 0} records`}</span></div>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <p className="text-slate-400 text-sm italic">No active supervisory findings present in this snapshot.</p>
                )}
              </div>

              {/* Data Quality Limitation Audit */}
              <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 shadow-xl space-y-3">
                <h3 className="text-lg font-semibold text-white">Data Quality & Limitations Audit</h3>
                <p className="text-xs text-slate-300 leading-relaxed">
                  {reportDetail.data_quality_and_limitations?.evidence_distinction_notice}
                </p>
                <p className="text-xs text-slate-400">
                  {reportDetail.data_quality_and_limitations?.coverage_limitations}
                </p>
              </div>
            </>
          )}
        </div>
      )}
    </div>
  );
};
