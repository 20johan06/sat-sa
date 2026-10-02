import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import Badge from '../components/ui/Badge';
import SeverityBadge from '../components/ui/SeverityBadge';
import StatusBadge from '../components/ui/StatusBadge';
import ErrorState from '../components/ui/ErrorState';
import Skeleton from '../components/ui/Skeleton';
import Button from '../components/ui/Button';
import EmptyState from '../components/ui/EmptyState';
import {
  FileSearch,
  ArrowLeft,
  Building2,
  Clock,
  Database,
  Layers,
  FileText,
  HelpCircle,
  ExternalLink,
  ShieldCheck,
  AlertTriangle,
  Activity,
  Compass,
  CheckCircle2,
  MessageSquare,
  History,
  FileQuestion,
  UserCheck,
  PlusCircle,
} from 'lucide-react';
import {
  useFindingQuery,
  useUpdateFindingStatusMutation,
  useFindingHistoryQuery,
  useAddExaminerNoteMutation,
  useRequestEvidenceMutation,
} from '../hooks/api/useFindings';
import { useCseQuery } from '../hooks/api/useCses';

export const FindingDetailPage: React.FC = () => {
  const { finding_id } = useParams<{ finding_id: string }>();
  const activeFindingId = finding_id || '';
  const navigate = useNavigate();

  const { data: finding, isLoading, isError, error, refetch } = useFindingQuery(activeFindingId);
  const { data: cse } = useCseQuery(finding?.cse_id || '');
  const { data: historyList, isLoading: isHistoryLoading } = useFindingHistoryQuery(activeFindingId);

  const updateStatusMutation = useUpdateFindingStatusMutation(activeFindingId);
  const addNoteMutation = useAddExaminerNoteMutation(activeFindingId);
  const requestEvidenceMutation = useRequestEvidenceMutation(activeFindingId);

  const [newStatus, setNewStatus] = useState<string>('');
  const [reviewNotes, setReviewNotes] = useState<string>('');
  const [standaloneNote, setStandaloneNote] = useState<string>('');
  const [statusError, setStatusError] = useState<string>('');

  // Evidence request form state
  const [showEvidenceRequestForm, setShowEvidenceRequestForm] = useState<boolean>(false);
  const [evidenceNote, setEvidenceNote] = useState<string>('');
  const [dataTypesInput, setDataTypesInput] = useState<string>('syslog, auth_log');
  const [timeWindowInput, setTimeWindowInput] = useState<string>('');
  const [evidenceDescription, setEvidenceDescription] = useState<string>('');

  const handleUpdateStatus = (e: React.FormEvent) => {
    e.preventDefault();
    setStatusError('');
    const targetStatus = newStatus || finding?.status || 'UNDER_REVIEW';

    // Client validation for disposition transitions requiring notes
    const mandatoryNoteTargets = ['CONFIRMED', 'DISMISSED', 'NOT_SUBSTANTIATED', 'NEEDS_MORE_EVIDENCE'];
    if (mandatoryNoteTargets.includes(targetStatus) && (!reviewNotes || !reviewNotes.trim())) {
      setStatusError(`An examiner note/rationale is required when transitioning status to ${targetStatus}.`);
      return;
    }

    updateStatusMutation.mutate(
      { status: targetStatus, notes: reviewNotes },
      {
        onSuccess: () => {
          setReviewNotes('');
          setStatusError('');
        },
        onError: (err: any) => {
          setStatusError(err?.response?.data?.detail || err?.message || 'Failed to update status');
        },
      }
    );
  };

  const handleAddStandaloneNote = (e: React.FormEvent) => {
    e.preventDefault();
    if (!standaloneNote.trim()) return;

    addNoteMutation.mutate(
      { note_text: standaloneNote },
      {
        onSuccess: () => {
          setStandaloneNote('');
        },
      }
    );
  };

  const handleRequestEvidenceSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!evidenceNote.trim()) return;

    const dataTypes = dataTypesInput
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);

    requestEvidenceMutation.mutate(
      {
        note_text: evidenceNote,
        required_data_types: dataTypes.length > 0 ? dataTypes : ['syslog'],
        requested_time_window: timeWindowInput || undefined,
        description: evidenceDescription || undefined,
      },
      {
        onSuccess: () => {
          setEvidenceNote('');
          setTimeWindowInput('');
          setEvidenceDescription('');
          setShowEvidenceRequestForm(false);
        },
      }
    );
  };

  const exp = finding?.explainability;
  const isTerminalState = ['CONFIRMED', 'DISMISSED', 'NOT_SUBSTANTIATED'].includes(finding?.status || '');

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'National Findings', href: '/findings' },
          { label: finding ? finding.finding_code : `Finding ${activeFindingId.slice(0, 8)}...` },
          { label: 'Evidence & Examiner Review' },
        ]}
        title={finding ? finding.title : 'Supervisory Finding & Operational Evidence Detail'}
        description="Detailed breakdown of finding code, detection method, supervisory rationale, rule metrics, 6-part explainability, traceable evidence links, and immutable review history."
        actions={
          <Button
            variant="outline"
            icon={<ArrowLeft className="w-4 h-4" />}
            onClick={() => navigate(-1)}
          >
            Back to Registry
          </Button>
        }
      />

      {isLoading ? (
        <div className="space-y-6">
          <Skeleton className="h-32 w-full" />
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div className="lg:col-span-2 space-y-6">
              <Skeleton className="h-48 w-full" />
              <Skeleton className="h-40 w-full" />
            </div>
            <div>
              <Skeleton className="h-96 w-full" />
            </div>
          </div>
        </div>
      ) : isError ? (
        <ErrorState
          title="Failed to Load Finding Detail"
          message={error instanceof Error ? error.message : 'Unable to connect to backend findings API.'}
          onRetry={refetch}
        />
      ) : !finding ? (
        <EmptyState
          icon={<FileSearch className="w-8 h-8 text-slate-400" />}
          title="Finding Not Found"
          description="The requested supervisory finding record does not exist in the database."
          action={
            <Button variant="outline" onClick={() => navigate('/findings')}>
              Return to Findings Registry
            </Button>
          }
        />
      ) : (
        <div className="space-y-6">
          {/* Top Overview Banner Card */}
          <Card>
            <CardHeader className="border-b border-slate-100 bg-slate-50/50">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div className="flex items-start gap-3">
                  <div className="p-2.5 rounded-md bg-blue-50 border border-blue-200 text-blue-700 shrink-0">
                    <FileSearch className="w-5 h-5" />
                  </div>
                  <div>
                    <div className="flex flex-wrap items-center gap-2 mb-1">
                      <span className="font-mono text-xs font-bold text-blue-700 bg-blue-50 px-2 py-0.5 rounded border border-blue-200">
                        {finding.finding_code}
                      </span>
                      <Badge variant="outline" size="sm" className="font-mono">
                        {finding.category}
                      </Badge>
                      <SeverityBadge severity={finding.severity} size="sm" />
                      <StatusBadge status={finding.status} />
                    </div>
                    <h2 className="text-lg font-bold text-slate-900 tracking-tight">
                      {finding.title}
                    </h2>
                  </div>
                </div>

                <div className="flex flex-col gap-1 text-xs font-mono text-slate-500 self-start md:self-auto">
                  <div className="flex items-center gap-1.5">
                    <Clock className="w-3.5 h-3.5" />
                    <span>Detected: {new Date(finding.detected_at).toLocaleString()}</span>
                  </div>
                  {finding.batch_id && (
                    <div className="flex items-center gap-1.5">
                      <Database className="w-3.5 h-3.5" />
                      <span>Batch ID: {finding.batch_id.slice(0, 8)}...</span>
                    </div>
                  )}
                </div>
              </div>
            </CardHeader>
            <CardContent className="p-5 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4 text-xs">
              <div>
                <span className="text-slate-400 block font-mono">SUPERVISED ENTITY</span>
                <Button
                  variant="ghost"
                  size="sm"
                  className="p-0 h-auto font-mono text-xs font-semibold text-blue-700 hover:text-blue-900 flex items-center gap-1 mt-0.5"
                  onClick={() => navigate(`/cses/${finding.cse_id}`)}
                >
                  <Building2 className="w-3.5 h-3.5 text-blue-600" />
                  <span>{cse ? cse.name : finding.cse_id}</span>
                  <ExternalLink className="w-3 h-3 text-slate-400" />
                </Button>
              </div>

              <div>
                <span className="text-slate-400 block font-mono">DETECTION METHOD</span>
                <span className="font-mono font-medium text-slate-800 mt-0.5 block">
                  {finding.detection_method}
                </span>
              </div>

              <div>
                <span className="text-slate-400 block font-mono">EVIDENCE RECORDS</span>
                <span className="font-mono font-bold text-slate-900 mt-0.5 block flex items-center gap-1">
                  <Layers className="w-3.5 h-3.5 text-slate-500" />
                  {finding.evidence_count} record(s)
                </span>
              </div>

              <div>
                <span className="text-slate-400 block font-mono">FINDING UUID</span>
                <span className="font-mono text-slate-700 select-all break-all sm:break-normal mt-0.5 block" title={finding.id}>
                  {finding.id}
                </span>
              </div>
            </CardContent>
          </Card>

          {/* Main 2-Column Content Layout */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Left Column: 6-Part Explainability Card & Rule Metrics */}
            <div className="lg:col-span-2 space-y-6">
              {/* Canonical 6-Part Supervisory Explainability Card */}
              <Card>
                <CardHeader className="border-b border-slate-100 bg-slate-50/30">
                  <div className="flex items-center gap-2">
                    <ShieldCheck className="w-5 h-5 text-blue-600" />
                    <div>
                      <CardTitle className="text-sm font-bold">Canonical 6-Part Supervisory Explainability</CardTitle>
                      <CardDescription>
                        Structured explainability decomposition (WHAT, WHY, HOW, EVIDENCE, BASELINE, IMPACT)
                      </CardDescription>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="p-5 space-y-4 text-xs">
                  {/* WHAT */}
                  <div className="p-3.5 rounded-md bg-white border border-slate-200 space-y-1">
                    <div className="flex items-center gap-2 text-slate-700 font-mono font-bold uppercase text-[11px]">
                      <FileText className="w-3.5 h-3.5 text-blue-600" />
                      <span>1. WHAT — Detected Phenomenon</span>
                    </div>
                    <p className="text-slate-800 leading-relaxed font-sans">{exp?.what || finding.description}</p>
                  </div>

                  {/* WHY */}
                  <div className="p-3.5 rounded-md bg-white border border-slate-200 space-y-1">
                    <div className="flex items-center gap-2 text-slate-700 font-mono font-bold uppercase text-[11px]">
                      <HelpCircle className="w-3.5 h-3.5 text-amber-600" />
                      <span>2. WHY — Supervisory Rationale & Cause</span>
                    </div>
                    <p className="text-slate-800 leading-relaxed font-sans">{exp?.why || finding.rationale}</p>
                  </div>

                  {/* HOW */}
                  <div className="p-3.5 rounded-md bg-white border border-slate-200 space-y-1">
                    <div className="flex items-center gap-2 text-slate-700 font-mono font-bold uppercase text-[11px]">
                      <Activity className="w-3.5 h-3.5 text-indigo-600" />
                      <span>3. HOW — Detection Method & Threshold</span>
                    </div>
                    <p className="text-slate-800 leading-relaxed font-sans font-mono">{exp?.how || finding.detection_method}</p>
                  </div>

                  {/* EVIDENCE */}
                  <div className="p-3.5 rounded-md bg-white border border-slate-200 space-y-1">
                    <div className="flex items-center gap-2 text-slate-700 font-mono font-bold uppercase text-[11px]">
                      <Layers className="w-3.5 h-3.5 text-emerald-600" />
                      <span>4. EVIDENCE — Primary Database Pointers</span>
                    </div>
                    <p className="text-slate-800 leading-relaxed font-sans">{exp?.evidence || `${finding.evidence_count} evidence link(s)`}</p>
                  </div>

                  {/* BASELINE */}
                  <div className="p-3.5 rounded-md bg-white border border-slate-200 space-y-1">
                    <div className="flex items-center gap-2 text-slate-700 font-mono font-bold uppercase text-[11px]">
                      <Compass className="w-3.5 h-3.5 text-purple-600" />
                      <span>5. BASELINE — Operational or Peer Baseline</span>
                    </div>
                    <p className="text-slate-800 leading-relaxed font-sans font-mono">{exp?.baseline || 'Standard operational baseline expectation.'}</p>
                  </div>

                  {/* IMPACT */}
                  <div className="p-3.5 rounded-md bg-white border border-slate-200 space-y-1">
                    <div className="flex items-center gap-2 text-slate-700 font-mono font-bold uppercase text-[11px]">
                      <AlertTriangle className="w-3.5 h-3.5 text-rose-600" />
                      <span>6. IMPACT — Evaluated Supervisory Impact</span>
                    </div>
                    <p className="text-slate-800 leading-relaxed font-sans">{exp?.impact || `Severity: ${finding.severity}`}</p>
                  </div>
                </CardContent>
              </Card>

              {/* Rule Metrics JSON Card */}
              {finding.metrics_json && Object.keys(finding.metrics_json).length > 0 && (
                <Card>
                  <CardHeader className="border-b border-slate-100">
                    <div className="flex items-center gap-2">
                      <HelpCircle className="w-4 h-4 text-slate-600" />
                      <CardTitle className="text-sm font-bold">Rule Metrics & Calculated Parameters</CardTitle>
                    </div>
                    <CardDescription>
                      Quantitative telemetry attributes evaluated during detection
                    </CardDescription>
                  </CardHeader>
                  <CardContent className="p-5">
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 font-mono text-xs">
                      {Object.entries(finding.metrics_json).map(([key, val]) => (
                        <div key={key} className="p-2.5 rounded bg-slate-50 border border-slate-200 flex items-center justify-between gap-2 overflow-hidden">
                          <span className="font-semibold text-slate-700 shrink-0">{key}:</span>
                          <span className="text-blue-800 font-bold truncate">
                            {typeof val === 'object' ? JSON.stringify(val) : String(val)}
                          </span>
                        </div>
                      ))}
                    </div>
                  </CardContent>
                </Card>
              )}

              {/* Phase 11 Supervisory Review & Audit Timeline */}
              <Card>
                <CardHeader className="border-b border-slate-100 flex flex-row items-center justify-between">
                  <div className="flex items-center gap-2">
                    <History className="w-4 h-4 text-blue-700" />
                    <div>
                      <CardTitle className="text-sm font-bold">Supervisory Review & Audit History</CardTitle>
                      <CardDescription>Immutable chronological trail of examiner decisions, notes, and status changes</CardDescription>
                    </div>
                  </div>
                  <Badge variant="outline" size="sm" className="font-mono">
                    {historyList ? historyList.length : 0} Entry(s)
                  </Badge>
                </CardHeader>
                <CardContent className="p-5">
                  {isHistoryLoading ? (
                    <Skeleton className="h-24 w-full" />
                  ) : !historyList || historyList.length === 0 ? (
                    <EmptyState
                      icon={<History className="w-6 h-6 text-slate-400" />}
                      title="No Review History Records"
                      description="No supervisory review actions or notes have been logged for this finding yet."
                    />
                  ) : (
                    <div className="relative border-l-2 border-slate-200 ml-3 space-y-4">
                      {historyList.map((hist) => (
                        <div key={hist.id} className="ml-5 relative">
                          <div className="absolute -left-[27px] top-1.5 w-3 h-3 rounded-full bg-blue-600 border-2 border-white" />
                          <div className="bg-slate-50 p-3.5 rounded-md border border-slate-200 text-xs space-y-1.5">
                            <div className="flex flex-wrap items-center justify-between gap-2">
                              <div className="flex items-center gap-2 font-mono">
                                <span className="font-bold text-slate-900">{hist.action_type}</span>
                                {hist.previous_status && hist.new_status && (
                                  <span className="text-[11px] text-slate-600 bg-white px-1.5 py-0.5 rounded border border-slate-200">
                                    {hist.previous_status} → <span className="font-bold text-blue-700">{hist.new_status}</span>
                                  </span>
                                )}
                              </div>
                              <span className="text-[10px] font-mono text-slate-500">
                                {new Date(hist.created_at).toLocaleString()}
                              </span>
                            </div>

                            <div className="flex items-center gap-2 text-[11px] text-slate-600 font-mono">
                              <UserCheck className="w-3.5 h-3.5 text-slate-500" />
                              <span>Actor: <strong className="text-slate-800">{hist.username || hist.user_id || 'System'}</strong></span>
                              {hist.user_role && (
                                <Badge variant="outline" size="sm" className="text-[10px] py-0 px-1 font-mono">
                                  {hist.user_role}
                                </Badge>
                              )}
                            </div>

                            {hist.note_text && (
                              <p className="text-xs text-slate-800 bg-white p-2.5 rounded border border-slate-200 font-sans leading-relaxed">
                                "{hist.note_text}"
                              </p>
                            )}

                            {hist.evidence_request_details && (
                              <div className="bg-amber-50/70 p-2.5 rounded border border-amber-200 font-mono text-[11px] space-y-1">
                                <div className="text-amber-800 font-bold flex items-center gap-1">
                                  <FileQuestion className="w-3.5 h-3.5" />
                                  <span>Evidence Request Details:</span>
                                </div>
                                <div>
                                  <span className="text-amber-700 font-semibold">Required Data Types: </span>
                                  <span className="text-slate-900">
                                    {Array.isArray(hist.evidence_request_details.required_data_types)
                                      ? hist.evidence_request_details.required_data_types.join(', ')
                                      : String(hist.evidence_request_details.required_data_types)}
                                  </span>
                                </div>
                                {Boolean(hist.evidence_request_details.requested_time_window) && (
                                  <div>
                                    <span className="text-amber-700 font-semibold">Time Window: </span>
                                    <span className="text-slate-900">{String(hist.evidence_request_details.requested_time_window)}</span>
                                  </div>
                                )}
                              </div>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </CardContent>
              </Card>
            </div>

            {/* Right Column: Supervisory Review Action & Traceable Evidence Links */}
            <div className="space-y-6">
              {/* Interactive Supervisory Review & Status Update Panel */}
              <Card>
                <CardHeader className="border-b border-slate-100 bg-slate-50/50">
                  <div className="flex items-center gap-2">
                    <MessageSquare className="w-4 h-4 text-blue-700" />
                    <CardTitle className="text-sm font-bold">Supervisory Review Action</CardTitle>
                  </div>
                  <CardDescription>Execute formal finding status transition</CardDescription>
                </CardHeader>
                <CardContent className="p-4 space-y-4">
                  {isTerminalState ? (
                    <div className="p-3 bg-slate-100 border border-slate-200 rounded text-xs text-slate-700 font-mono">
                      🔒 Finding is in terminal disposition status (<strong>{finding.status}</strong>). Status reopening is forbidden.
                    </div>
                  ) : (
                    <form onSubmit={handleUpdateStatus} className="space-y-3">
                      <div>
                        <label className="block text-xs font-mono text-slate-600 mb-1">
                          SUPERVISORY STATUS TRANSITION
                        </label>
                        <select
                          value={newStatus || finding.status}
                          onChange={(e) => setNewStatus(e.target.value)}
                          className="w-full text-xs font-mono p-2 rounded border border-slate-300 bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none"
                        >
                          {finding.status === 'NEW' && (
                            <>
                              <option value="NEW">New (Current)</option>
                              <option value="UNDER_REVIEW">Under Review</option>
                              <option value="CONFIRMED">Confirmed</option>
                              <option value="DISMISSED">Dismissed</option>
                            </>
                          )}
                          {finding.status === 'UNDER_REVIEW' && (
                            <>
                              <option value="UNDER_REVIEW">Under Review (Current)</option>
                              <option value="CONFIRMED">Confirmed</option>
                              <option value="NOT_SUBSTANTIATED">Not Substantiated</option>
                              <option value="DISMISSED">Dismissed</option>
                              <option value="NEEDS_MORE_EVIDENCE">Needs More Evidence</option>
                            </>
                          )}
                          {finding.status === 'NEEDS_MORE_EVIDENCE' && (
                            <>
                              <option value="NEEDS_MORE_EVIDENCE">Needs More Evidence (Current)</option>
                              <option value="UNDER_REVIEW">Under Review</option>
                              <option value="CONFIRMED">Confirmed</option>
                            </>
                          )}
                        </select>
                      </div>

                      <div>
                        <label className="block text-xs font-mono text-slate-600 mb-1">
                          EXAMINER RATIONALE / AUDIT NOTE
                        </label>
                        <textarea
                          value={reviewNotes}
                          onChange={(e) => setReviewNotes(e.target.value)}
                          placeholder="Attach examiner rationale or review note (Required for Confirmed, Dismissed, Not Substantiated, Needs More Evidence)..."
                          rows={3}
                          className="w-full text-xs p-2 rounded border border-slate-300 bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none font-sans"
                        />
                      </div>

                      {statusError && (
                        <p className="text-xs font-mono text-rose-600 bg-rose-50 p-2 rounded border border-rose-200">
                          ⚠ {statusError}
                        </p>
                      )}

                      <Button
                        type="submit"
                        variant="primary"
                        size="sm"
                        className="w-full"
                        isLoading={updateStatusMutation.isPending}
                        icon={<CheckCircle2 className="w-4 h-4" />}
                      >
                        Execute Status Transition
                      </Button>
                    </form>
                  )}

                  {/* Evidence Request Quick Trigger Button for UNDER_REVIEW findings */}
                  {finding.status === 'UNDER_REVIEW' && !showEvidenceRequestForm && (
                    <div className="pt-2 border-t border-slate-100">
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        className="w-full text-xs"
                        icon={<FileQuestion className="w-4 h-4 text-amber-600" />}
                        onClick={() => setShowEvidenceRequestForm(true)}
                      >
                        Request More Evidence
                      </Button>
                    </div>
                  )}

                  {/* Structured Evidence Request Form */}
                  {showEvidenceRequestForm && (
                    <form onSubmit={handleRequestEvidenceSubmit} className="p-3 bg-amber-50/80 rounded border border-amber-200 space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-mono font-bold text-amber-900 flex items-center gap-1">
                          <FileQuestion className="w-3.5 h-3.5 text-amber-600" />
                          Structured Evidence Request
                        </span>
                        <Button
                          variant="ghost"
                          size="sm"
                          className="h-6 text-[11px] p-1 text-slate-500"
                          onClick={() => setShowEvidenceRequestForm(false)}
                        >
                          Cancel
                        </Button>
                      </div>

                      <div>
                        <label className="block text-[11px] font-mono text-amber-900 mb-1">
                          REQUIRED DATA TYPES (Comma-separated)
                        </label>
                        <input
                          type="text"
                          value={dataTypesInput}
                          onChange={(e) => setDataTypesInput(e.target.value)}
                          placeholder="e.g. syslog, auth_log, firewall_pcap"
                          className="w-full text-xs font-mono p-1.5 rounded border border-amber-300 bg-white"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-mono text-amber-900 mb-1">
                          TIME WINDOW (Optional)
                        </label>
                        <input
                          type="text"
                          value={timeWindowInput}
                          onChange={(e) => setTimeWindowInput(e.target.value)}
                          placeholder="e.g. 2026-10-01T00:00 to 2026-10-02T12:00"
                          className="w-full text-xs font-mono p-1.5 rounded border border-amber-300 bg-white"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-mono text-amber-900 mb-1">
                          EXAMINER REQUEST RATIONALE (Required)
                        </label>
                        <textarea
                          value={evidenceNote}
                          onChange={(e) => setEvidenceNote(e.target.value)}
                          placeholder="Explain why current evidence is insufficient..."
                          rows={2}
                          className="w-full text-xs p-1.5 rounded border border-amber-300 bg-white"
                          required
                        />
                      </div>

                      <Button
                        type="submit"
                        variant="primary"
                        size="sm"
                        className="w-full bg-amber-700 hover:bg-amber-800 text-white"
                        isLoading={requestEvidenceMutation.isPending}
                      >
                        Submit Evidence Request
                      </Button>
                    </form>
                  )}
                </CardContent>
              </Card>

              {/* Add Standalone Examiner Note */}
              <Card>
                <CardHeader className="border-b border-slate-100 bg-slate-50/50">
                  <div className="flex items-center gap-2">
                    <PlusCircle className="w-4 h-4 text-slate-700" />
                    <CardTitle className="text-sm font-bold">Add Examiner Note</CardTitle>
                  </div>
                  <CardDescription>Append standalone review commentary to history</CardDescription>
                </CardHeader>
                <CardContent className="p-4">
                  <form onSubmit={handleAddStandaloneNote} className="space-y-3">
                    <textarea
                      value={standaloneNote}
                      onChange={(e) => setStandaloneNote(e.target.value)}
                      placeholder="Add examiner observation note..."
                      rows={2}
                      className="w-full text-xs p-2 rounded border border-slate-300 bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none"
                    />
                    <Button
                      type="submit"
                      variant="outline"
                      size="sm"
                      className="w-full"
                      isLoading={addNoteMutation.isPending}
                      disabled={!standaloneNote.trim()}
                    >
                      Append Note to History
                    </Button>
                  </form>
                </CardContent>
              </Card>

              {/* Traceable Evidence Links */}
              <Card>
                <CardHeader className="border-b border-slate-100 flex flex-row items-center justify-between">
                  <div>
                    <CardTitle className="text-sm font-bold">Traceable Evidence Links</CardTitle>
                    <CardDescription>FindingEvidence records</CardDescription>
                  </div>
                  <Badge variant="outline" size="sm">
                    {finding.evidence.length} Record(s)
                  </Badge>
                </CardHeader>
                <CardContent className="p-4">
                  {finding.evidence.length === 0 ? (
                    <EmptyState
                      icon={<Layers className="w-6 h-6 text-slate-400" />}
                      title="No Linked Evidence Records"
                      description="This finding does not currently have linked individual evidence pointers."
                    />
                  ) : (
                    <div className="space-y-3">
                      {finding.evidence.map((ev) => (
                        <div
                          key={ev.id}
                          className="p-3.5 rounded-md bg-slate-50 border border-slate-200 space-y-2 text-xs"
                        >
                          <div className="flex items-center justify-between">
                            <Badge variant="info" size="sm" className="font-mono">
                              {ev.evidence_type}
                            </Badge>
                            <span className="text-[10px] font-mono text-slate-400">
                              {new Date(ev.created_at).toLocaleDateString()}
                            </span>
                          </div>

                          <div className="space-y-1 font-mono text-[11px] text-slate-700">
                            {ev.alert_id && (
                              <div className="flex flex-col sm:flex-row sm:justify-between gap-0.5">
                                <span className="text-slate-400 shrink-0">ALERT ID:</span>
                                <span className="font-semibold text-slate-900 select-all break-all sm:break-normal">{ev.alert_id}</span>
                              </div>
                            )}
                            {ev.case_id && (
                              <div className="flex flex-col sm:flex-row sm:justify-between gap-0.5">
                                <span className="text-slate-400 shrink-0">CASE ID:</span>
                                <span className="font-semibold text-slate-900 select-all break-all sm:break-normal">{ev.case_id}</span>
                              </div>
                            )}
                            {ev.investigation_id && (
                              <div className="flex flex-col sm:flex-row sm:justify-between gap-0.5">
                                <span className="text-slate-400 shrink-0">INVESTIGATION ID:</span>
                                <span className="font-semibold text-slate-900 select-all break-all sm:break-normal">{ev.investigation_id}</span>
                              </div>
                            )}
                            {ev.escalation_id && (
                              <div className="flex flex-col sm:flex-row sm:justify-between gap-0.5">
                                <span className="text-slate-400 shrink-0">ESCALATION ID:</span>
                                <span className="font-semibold text-slate-900 select-all break-all sm:break-normal">{ev.escalation_id}</span>
                              </div>
                            )}
                            {ev.coverage_id && (
                              <div className="flex flex-col sm:flex-row sm:justify-between gap-0.5">
                                <span className="text-slate-400 shrink-0">COVERAGE ID:</span>
                                <span className="font-semibold text-slate-900 select-all break-all sm:break-normal">{ev.coverage_id}</span>
                              </div>
                            )}
                          </div>

                          {ev.notes && (
                            <p className="text-[11px] text-slate-600 bg-white p-2 rounded border border-slate-100 font-sans italic">
                              "{ev.notes}"
                            </p>
                          )}
                        </div>
                      ))}
                    </div>
                  )}
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      )}
    </PageContainer>
  );
};

export default FindingDetailPage;

