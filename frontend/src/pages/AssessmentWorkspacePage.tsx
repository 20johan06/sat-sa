import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  fetchAssessments,
  createAssessment,
  updateAssessmentStatus,
  fetchDatasetVersions,
  fetchAnalysisRuns,
  createAnalysisRun,
} from '../api/assessments';
import { useAuth } from '../context/AuthContext';

export const AssessmentWorkspacePage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const queryClient = useQueryClient();
  const { user } = useAuth();
  const canManage = user?.role === 'ADMIN' || user?.role === 'SUPERVISOR';

  const [selectedAssessmentId, setSelectedAssessmentId] = useState<string | null>(null);
  const [showCreateModal, setShowCreateModal] = useState(false);

  // Form states
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [periodStart, setPeriodStart] = useState('2026-08-01T00:00');
  const [periodEnd, setPeriodEnd] = useState('2026-09-01T00:00');
  const [formError, setFormError] = useState<string | null>(null);

  // Queries
  const {
    data: assessmentsData,
    isLoading: loadingAssessments,
    error: assessmentsError,
    refetch: refetchAssessments
  } = useQuery({
    queryKey: ['assessments', cse_id],
    queryFn: () => fetchAssessments(cse_id!),
    enabled: !!cse_id,
  });

  const {
    data: datasetsData,
    isLoading: loadingDatasets
  } = useQuery({
    queryKey: ['dataset-versions', cse_id, selectedAssessmentId],
    queryFn: () => fetchDatasetVersions(cse_id!, selectedAssessmentId || undefined),
    enabled: !!cse_id,
  });

  const {
    data: analysisRunsData,
    isLoading: loadingRuns
  } = useQuery({
    queryKey: ['analysis-runs', cse_id, selectedAssessmentId],
    queryFn: () => fetchAnalysisRuns(cse_id!, selectedAssessmentId || undefined),
    enabled: !!cse_id,
  });

  // Mutations
  const createAssessmentMutation = useMutation({
    mutationFn: createAssessment,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['assessments', cse_id] });
      setShowCreateModal(false);
      setName('');
      setDescription('');
      setFormError(null);
    },
    onError: (err: any) => {
      setFormError(err.response?.data?.detail || err.message || 'Failed to create assessment.');
    }
  });

  const updateStatusMutation = useMutation({
    mutationFn: ({ id, status }: { id: string; status: string }) => updateAssessmentStatus(id, status),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['assessments', cse_id] });
    }
  });

  const triggerRunMutation = useMutation({
    mutationFn: createAnalysisRun,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['analysis-runs', cse_id] });
      queryClient.invalidateQueries({ queryKey: ['assessments', cse_id] });
    }
  });

  const handleCreateSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setFormError(null);

    if (!name.trim()) {
      setFormError('Assessment name is required.');
      return;
    }

    if (new Date(periodStart) >= new Date(periodEnd)) {
      setFormError('Assessment period start date must be strictly before end date.');
      return;
    }

    createAssessmentMutation.mutate({
      cse_id: cse_id!,
      name: name.trim(),
      description: description.trim() || undefined,
      period_start: new Date(periodStart).toISOString(),
      period_end: new Date(periodEnd).toISOString()
    });
  };

  const getStatusBadgeClass = (status: string) => {
    switch (status) {
      case 'DRAFT': return 'bg-slate-700 text-slate-300';
      case 'DATASET_ATTACHED': return 'bg-blue-900/60 text-blue-300 border border-blue-700/50';
      case 'IN_ANALYSIS': return 'bg-amber-900/60 text-amber-300 border border-amber-700/50 animate-pulse';
      case 'UNDER_REVIEW': return 'bg-purple-900/60 text-purple-300 border border-purple-700/50';
      case 'COMPLETED': return 'bg-emerald-900/60 text-emerald-300 border border-emerald-700/50';
      default: return 'bg-slate-800 text-slate-400';
    }
  };

  if (loadingAssessments) {
    return (
      <div className="p-6 bg-slate-950 min-h-screen text-slate-100 flex items-center justify-center">
        <div className="flex items-center space-x-3 text-slate-400">
          <div className="w-5 h-5 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin"></div>
          <span>Loading supervisory assessments...</span>
        </div>
      </div>
    );
  }

  if (assessmentsError) {
    return (
      <div className="p-6 bg-slate-950 min-h-screen text-slate-100">
        <div className="max-w-7xl mx-auto bg-red-950/40 border border-red-800/60 rounded-lg p-6">
          <h2 className="text-lg font-bold text-red-400 mb-2">Error Loading Assessments</h2>
          <p className="text-slate-300 text-sm mb-4">{(assessmentsError as any)?.message || 'Failed to fetch assessment records.'}</p>
          <button
            onClick={() => refetchAssessments()}
            className="px-4 py-2 bg-red-900 hover:bg-red-800 text-red-100 rounded text-sm font-medium transition"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  const assessments = assessmentsData?.items || [];
  const datasets = datasetsData?.items || [];
  const analysisRuns = analysisRunsData?.items || [];

  return (
    <div className="p-6 bg-slate-950 min-h-screen text-slate-100">
      <div className="max-w-7xl mx-auto space-y-8">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center justify-between border-b border-slate-800 pb-5 gap-4">
          <div>
            <div className="flex items-center space-x-2 text-xs font-mono text-emerald-400 uppercase tracking-wider">
              <span>SAT-SA V2</span>
              <span>•</span>
              <span>Supervisory Assessment Workspace</span>
            </div>
            <h1 className="text-2xl font-bold text-slate-50 mt-1">Supervisory Assessment Campaigns</h1>
            <p className="text-sm text-slate-400">
              Manage supervisory assessment periods, attach immutable dataset versions, and track analysis execution runs.
            </p>
          </div>

          {canManage && (
            <button
              onClick={() => setShowCreateModal(true)}
              className="px-4 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-slate-950 font-semibold rounded-md shadow transition flex items-center justify-center space-x-2 text-sm"
            >
              <span>+ New Assessment</span>
            </button>
          )}
        </div>

        {/* Assessments List */}
        <div className="bg-slate-900/70 border border-slate-800 rounded-lg p-6">
          <h2 className="text-lg font-semibold text-slate-100 mb-4 flex items-center justify-between">
            <span>Assessment Campaigns ({assessments.length})</span>
            {selectedAssessmentId && (
              <button
                onClick={() => setSelectedAssessmentId(null)}
                className="text-xs text-emerald-400 hover:underline"
              >
                Clear Selected Filter
              </button>
            )}
          </h2>

          {assessments.length === 0 ? (
            <div className="p-8 text-center border border-dashed border-slate-800 rounded-lg bg-slate-950/40">
              <p className="text-slate-400 text-sm">No supervisory assessments created for this CSE yet.</p>
              {canManage && (
                <button
                  onClick={() => setShowCreateModal(true)}
                  className="mt-3 px-3 py-1.5 bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-medium rounded transition"
                >
                  Create First Assessment
                </button>
              )}
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {assessments.map((a) => {
                const isSelected = selectedAssessmentId === a.id;
                return (
                  <div
                    key={a.id}
                    onClick={() => setSelectedAssessmentId(isSelected ? null : a.id)}
                    className={`p-5 rounded-lg border cursor-pointer transition ${
                      isSelected
                        ? 'bg-slate-800/90 border-emerald-500/80 shadow-lg ring-1 ring-emerald-500/50'
                        : 'bg-slate-950/60 border-slate-800 hover:border-slate-700 hover:bg-slate-900/50'
                    }`}
                  >
                    <div className="flex items-center justify-between mb-3">
                      <span className={`px-2.5 py-0.5 rounded text-xs font-mono font-semibold ${getStatusBadgeClass(a.status)}`}>
                        {a.status}
                      </span>
                      <span className="text-xs font-mono text-slate-500">
                        {new Date(a.created_at).toLocaleDateString()}
                      </span>
                    </div>

                    <h3 className="font-bold text-slate-100 text-base mb-1">{a.name}</h3>
                    {a.description && <p className="text-xs text-slate-400 mb-4 line-clamp-2">{a.description}</p>}

                    <div className="space-y-1.5 text-xs font-mono border-t border-slate-800/80 pt-3">
                      <div className="flex justify-between text-slate-400">
                        <span>Period Start:</span>
                        <span className="text-slate-200">{new Date(a.period_start).toLocaleDateString()}</span>
                      </div>
                      <div className="flex justify-between text-slate-400">
                        <span>Period End:</span>
                        <span className="text-slate-200">{new Date(a.period_end).toLocaleDateString()}</span>
                      </div>
                    </div>

                    {canManage && (
                      <div className="mt-4 pt-3 border-t border-slate-800/80 flex items-center justify-between" onClick={(e) => e.stopPropagation()}>
                        <span className="text-xs text-slate-500">Update Lifecycle:</span>
                        <select
                          value={a.status}
                          onChange={(e) => updateStatusMutation.mutate({ id: a.id, status: e.target.value })}
                          className="bg-slate-900 border border-slate-700 text-slate-200 text-xs rounded px-2 py-1 focus:outline-none focus:border-emerald-500"
                        >
                          <option value="DRAFT">DRAFT</option>
                          <option value="DATASET_ATTACHED">DATASET_ATTACHED</option>
                          <option value="IN_ANALYSIS">IN_ANALYSIS</option>
                          <option value="UNDER_REVIEW">UNDER_REVIEW</option>
                          <option value="COMPLETED">COMPLETED</option>
                        </select>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Linked Immutable Dataset Versions & Analysis Runs */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Dataset Versions */}
          <div className="bg-slate-900/70 border border-slate-800 rounded-lg p-6">
            <h2 className="text-base font-semibold text-slate-100 mb-4 flex items-center justify-between">
              <span>Immutable Dataset Versions</span>
              <span className="text-xs font-mono text-slate-400">{datasets.length} recorded</span>
            </h2>

            {loadingDatasets ? (
              <div className="p-4 text-slate-400 text-xs font-mono">Loading dataset versions...</div>
            ) : datasets.length === 0 ? (
              <div className="p-6 text-center border border-dashed border-slate-800 rounded-lg text-slate-500 text-xs">
                No immutable dataset versions linked. Ingest telemetry or create a dataset version to attach to an assessment.
              </div>
            ) : (
              <div className="space-y-3 max-h-96 overflow-y-auto pr-1">
                {datasets.map((d) => (
                  <div key={d.id} className="p-3.5 bg-slate-950/70 border border-slate-800/80 rounded font-mono text-xs space-y-1.5">
                    <div className="flex items-center justify-between">
                      <span className="font-bold text-emerald-400">{d.version_tag}</span>
                      <span className="px-1.5 py-0.5 bg-slate-800 text-slate-300 text-[10px] rounded uppercase">{d.dataset_type}</span>
                    </div>
                    <div className="text-slate-300 truncate">Source: {d.source_filename}</div>
                    <div className="flex items-center justify-between text-slate-500 text-[11px]">
                      <span>Records: {d.record_count}</span>
                      <span className="text-slate-400">SHA-256: {d.content_hash.substring(0, 12)}...</span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Analysis Execution Traceability */}
          <div className="bg-slate-900/70 border border-slate-800 rounded-lg p-6">
            <h2 className="text-base font-semibold text-slate-100 mb-4 flex items-center justify-between">
              <span>Analysis Execution Runs</span>
              {canManage && (
                <button
                  onClick={() => triggerRunMutation.mutate({ cse_id: cse_id!, assessment_id: selectedAssessmentId || undefined })}
                  disabled={triggerRunMutation.isPending}
                  className="px-2.5 py-1 bg-blue-600 hover:bg-blue-500 disabled:bg-slate-800 text-white text-xs font-medium rounded transition"
                >
                  {triggerRunMutation.isPending ? 'Running Engine...' : 'Run Analytics Engine'}
                </button>
              )}
            </h2>

            {loadingRuns ? (
              <div className="p-4 text-slate-400 text-xs font-mono">Loading analysis execution runs...</div>
            ) : analysisRuns.length === 0 ? (
              <div className="p-6 text-center border border-dashed border-slate-800 rounded-lg text-slate-500 text-xs">
                No analysis runs executed for this context. Trigger the analytics engine to record execution provenance.
              </div>
            ) : (
              <div className="space-y-3 max-h-96 overflow-y-auto pr-1">
                {analysisRuns.map((r) => (
                  <div key={r.id} className="p-3.5 bg-slate-950/70 border border-slate-800/80 rounded font-mono text-xs space-y-1.5">
                    <div className="flex items-center justify-between">
                      <span className="font-bold text-blue-400">{r.engine_version}</span>
                      <span className={`px-2 py-0.5 rounded text-[10px] font-bold ${r.status === 'COMPLETED' ? 'bg-emerald-950 text-emerald-400 border border-emerald-800' : 'bg-amber-950 text-amber-400'}`}>
                        {r.status}
                      </span>
                    </div>
                    <div className="text-slate-400 text-[11px]">
                      Rules Evaluated: {r.rules_evaluated.join(', ')}
                    </div>
                    <div className="flex items-center justify-between text-slate-500 text-[11px] border-t border-slate-900 pt-1.5">
                      <span>Findings Generated: <strong className="text-slate-200">{r.findings_created}</strong></span>
                      <span>{new Date(r.started_at).toLocaleString()}</span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Create Assessment Modal */}
      {showCreateModal && (
        <div className="fixed inset-0 bg-black/70 backdrop-blur-xs flex items-center justify-center p-4 z-50">
          <div className="bg-slate-900 border border-slate-800 rounded-lg max-w-md w-full p-6 space-y-4 shadow-2xl">
            <h3 className="text-lg font-bold text-slate-100">Create Supervisory Assessment</h3>

            {formError && (
              <div className="p-3 bg-red-950/60 border border-red-800 text-red-300 text-xs rounded">
                {formError}
              </div>
            )}

            <form onSubmit={handleCreateSubmit} className="space-y-4 text-xs font-mono">
              <div>
                <label className="block text-slate-300 mb-1">Assessment Name *</label>
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="e.g. Q3 2026 Supervisory Campaign"
                  className="w-full bg-slate-950 border border-slate-700 rounded p-2 text-slate-100 focus:outline-none focus:border-emerald-500"
                />
              </div>

              <div>
                <label className="block text-slate-300 mb-1">Description</label>
                <textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Scope or regulatory objective..."
                  rows={3}
                  className="w-full bg-slate-950 border border-slate-700 rounded p-2 text-slate-100 focus:outline-none focus:border-emerald-500"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-slate-300 mb-1">Period Start *</label>
                  <input
                    type="datetime-local"
                    value={periodStart}
                    onChange={(e) => setPeriodStart(e.target.value)}
                    className="w-full bg-slate-950 border border-slate-700 rounded p-2 text-slate-100 focus:outline-none focus:border-emerald-500"
                  />
                </div>
                <div>
                  <label className="block text-slate-300 mb-1">Period End *</label>
                  <input
                    type="datetime-local"
                    value={periodEnd}
                    onChange={(e) => setPeriodEnd(e.target.value)}
                    className="w-full bg-slate-950 border border-slate-700 rounded p-2 text-slate-100 focus:outline-none focus:border-emerald-500"
                  />
                </div>
              </div>

              <div className="flex items-center justify-end space-x-3 pt-4 border-t border-slate-800">
                <button
                  type="button"
                  onClick={() => setShowCreateModal(false)}
                  className="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded font-medium transition"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={createAssessmentMutation.isPending}
                  className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 disabled:bg-slate-800 text-slate-950 font-bold rounded transition"
                >
                  {createAssessmentMutation.isPending ? 'Creating...' : 'Create Assessment'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default AssessmentWorkspacePage;
