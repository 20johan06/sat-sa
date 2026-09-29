import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import Badge from '../components/ui/Badge';
import Input from '../components/ui/Input';
import Select from '../components/ui/Select';
import Button from '../components/ui/Button';
import Alert from '../components/ui/Alert';
import EmptyState from '../components/ui/EmptyState';
import ErrorState from '../components/ui/ErrorState';
import Skeleton from '../components/ui/Skeleton';
import {
  FileText,
  Calendar,
  Search,
  RotateCcw,
  Copy,
  Download,
  Check,
  Code,
  FileCode,
} from 'lucide-react';
import {
  useCSEReportJSONQuery,
  useCSEReportMarkdownQuery,
} from '../hooks/api/useReport';
import type { ReportFormat } from '../types/api/reports';

export const ExecutiveReportsPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const activeCseId = cse_id || '';

  // Controls State
  const [obsStart, setObsStart] = useState<string>('');
  const [obsEnd, setObsEnd] = useState<string>('');
  const [format, setFormat] = useState<ReportFormat>('markdown');
  const [dateError, setDateError] = useState<string | null>(null);
  const [copySuccess, setCopySuccess] = useState<boolean>(false);

  const isoObsStart = obsStart ? new Date(obsStart).toISOString() : undefined;
  const isoObsEnd = obsEnd ? new Date(obsEnd).toISOString() : undefined;

  const queryParams = {
    obs_start: isoObsStart,
    obs_end: isoObsEnd,
  };

  // Queries
  const jsonQuery = useCSEReportJSONQuery(activeCseId, queryParams);
  const markdownQuery = useCSEReportMarkdownQuery(activeCseId, queryParams);

  const activeQuery = format === 'markdown' ? markdownQuery : jsonQuery;
  const isLoading = activeQuery.isLoading;
  const isError = activeQuery.isError;
  const error = activeQuery.error;
  const refetch = activeQuery.refetch;

  const handleFilterSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setDateError(null);

    if (obsStart && obsEnd && new Date(obsStart) >= new Date(obsEnd)) {
      setDateError('Observation start date must be strictly before observation end date.');
      return;
    }

    jsonQuery.refetch();
    markdownQuery.refetch();
  };

  const handleReset = () => {
    setObsStart('');
    setObsEnd('');
    setDateError(null);
  };

  const handleCopyMarkdown = async () => {
    const mdContent = markdownQuery.data;
    if (mdContent) {
      try {
        await navigator.clipboard.writeText(mdContent);
        setCopySuccess(true);
        setTimeout(() => setCopySuccess(false), 3000);
      } catch {
        // Fallback copy
        const textArea = document.createElement('textarea');
        textArea.value = mdContent;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
        setCopySuccess(true);
        setTimeout(() => setCopySuccess(false), 3000);
      }
    }
  };

  const handleDownloadJSON = () => {
    const jsonContent = jsonQuery.data;
    if (jsonContent) {
      const dataStr = 'data:text/json;charset=utf-8,' + encodeURIComponent(JSON.stringify(jsonContent, null, 2));
      const downloadAnchor = document.createElement('a');
      downloadAnchor.setAttribute('href', dataStr);
      downloadAnchor.setAttribute('download', `REP-CSE-${activeCseId.slice(0, 8)}.json`);
      document.body.appendChild(downloadAnchor);
      downloadAnchor.click();
      downloadAnchor.remove();
    }
  };

  const jsonReport = jsonQuery.data;
  const markdownReport = markdownQuery.data;

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${activeCseId.slice(0, 8)}...`, href: `/cses/${activeCseId}` },
          { label: 'Executive Reports' },
        ]}
        title="Supervisory Executive Assessment Reports"
        description="Generate, inspect, and export deterministic supervisory assessment reports in structured JSON or Markdown format."
        actions={
          <div className="flex items-center gap-2">
            {copySuccess && (
              <Badge variant="success" size="sm">
                Copied to Clipboard!
              </Badge>
            )}
            <Button
              variant="outline"
              size="sm"
              icon={copySuccess ? <Check className="w-4 h-4 text-emerald-600" /> : <Copy className="w-4 h-4" />}
              disabled={!markdownReport}
              onClick={handleCopyMarkdown}
            >
              Copy Markdown
            </Button>
            <Button
              size="sm"
              icon={<Download className="w-4 h-4" />}
              disabled={!jsonReport}
              onClick={handleDownloadJSON}
            >
              Download JSON
            </Button>
          </div>
        }
      />

      {/* Report Controls & Format Selector Card */}
      <Card className="mb-6">
        <CardHeader className="border-b border-slate-100 bg-slate-50/50 py-3">
          <div className="flex items-center gap-2">
            <FileText className="w-4 h-4 text-blue-700" />
            <CardTitle className="text-sm font-bold text-slate-900">
              Report Generation & Format Controls
            </CardTitle>
          </div>
        </CardHeader>
        <CardContent className="p-4">
          <form onSubmit={handleFilterSubmit} className="space-y-3">
            {dateError && (
              <Alert type="error" title="Validation Error">
                {dateError}
              </Alert>
            )}

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 items-end">
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">
                  Format Type
                </label>
                <Select
                  value={format}
                  aria-label="Report format type"
                  onChange={(e) => setFormat(e.target.value as ReportFormat)}
                  options={[
                    { value: 'markdown', label: 'Markdown Format (.md)' },
                    { value: 'json', label: 'Structured JSON Format (.json)' },
                  ]}
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">
                  Obs Start
                </label>
                <Input
                  type="datetime-local"
                  value={obsStart}
                  aria-label="Observation Start Date"
                  onChange={(e) => {
                    setObsStart(e.target.value);
                    setDateError(null);
                  }}
                  startIcon={<Calendar className="w-4 h-4 text-slate-400" />}
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">
                  Obs End
                </label>
                <Input
                  type="datetime-local"
                  value={obsEnd}
                  aria-label="Observation End Date"
                  onChange={(e) => {
                    setObsEnd(e.target.value);
                    setDateError(null);
                  }}
                  startIcon={<Calendar className="w-4 h-4 text-slate-400" />}
                />
              </div>

              <div className="flex gap-2">
                <Button type="submit" variant="primary" size="sm" icon={<Search className="w-3.5 h-3.5" />}>
                  Generate Report
                </Button>
                {(obsStart || obsEnd) && (
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    icon={<RotateCcw className="w-3.5 h-3.5" />}
                    onClick={handleReset}
                  >
                    Reset
                  </Button>
                )}
              </div>
            </div>
          </form>
        </CardContent>
      </Card>

      {/* Main Report Display Area */}
      {isLoading ? (
        <div className="space-y-4">
          <Skeleton className="h-28 w-full" />
          <Skeleton className="h-96 w-full" />
        </div>
      ) : isError ? (
        <ErrorState
          title="Failed to Generate Executive Report"
          message={error instanceof Error ? error.message : 'Unable to connect to backend reporting API.'}
          onRetry={refetch}
        />
      ) : (
        <div className="space-y-6">
          {/* Format: Markdown View */}
          {format === 'markdown' && (
            <Card>
              <CardHeader className="border-b border-slate-100 bg-slate-50/50 flex flex-row items-center justify-between">
                <div className="flex items-center gap-2">
                  <FileCode className="w-4 h-4 text-blue-700" />
                  <div>
                    <CardTitle className="text-sm font-bold">Markdown Supervisory Report</CardTitle>
                    <CardDescription>
                      GET /api/v1/reports/cse/{activeCseId}?format=markdown
                    </CardDescription>
                  </div>
                </div>
                <Badge variant="info" size="sm" className="font-mono">
                  FORMAT: MARKDOWN
                </Badge>
              </CardHeader>
              <CardContent className="p-6">
                {!markdownReport ? (
                  <EmptyState
                    icon={<FileText className="w-8 h-8 text-slate-400" />}
                    title="No Supervisory Report Data Available"
                    description="No supervisory report data is available for the selected observation period."
                  />
                ) : (
                  <div className="p-5 rounded-md bg-slate-900 text-slate-100 font-mono text-xs overflow-x-auto leading-relaxed border border-slate-800 shadow-inner whitespace-pre-wrap select-text">
                    {markdownReport}
                  </div>
                )}
              </CardContent>
            </Card>
          )}

          {/* Format: JSON View */}
          {format === 'json' && (
            <Card>
              <CardHeader className="border-b border-slate-100 bg-slate-50/50 flex flex-row items-center justify-between">
                <div className="flex items-center gap-2">
                  <Code className="w-4 h-4 text-blue-700" />
                  <div>
                    <CardTitle className="text-sm font-bold">Structured JSON Supervisory Report</CardTitle>
                    <CardDescription>
                      GET /api/v1/reports/cse/{activeCseId}?format=json
                    </CardDescription>
                  </div>
                </div>
                <Badge variant="info" size="sm" className="font-mono">
                  FORMAT: JSON
                </Badge>
              </CardHeader>
              <CardContent className="p-6 space-y-6">
                {!jsonReport ? (
                  <EmptyState
                    icon={<FileText className="w-8 h-8 text-slate-400" />}
                    title="No Supervisory Report Data Available"
                    description="No supervisory report data is available for the selected observation period."
                  />
                ) : (
                  <>
                    {/* Summary Fact Panels */}
                    {jsonReport.report_metadata && typeof jsonReport.report_metadata === 'object' && (
                      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-3 text-xs font-mono">
                        <div className="p-3 bg-slate-50 rounded border border-slate-200">
                          <span className="text-[10px] text-slate-500 block">REPORT ID</span>
                          <span className="font-bold text-blue-800 text-xs">
                            {String((jsonReport.report_metadata as Record<string, unknown>).report_id || 'N/A')}
                          </span>
                        </div>
                        <div className="p-3 bg-slate-50 rounded border border-slate-200">
                          <span className="text-[10px] text-slate-500 block">GENERATED AT</span>
                          <span className="font-bold text-slate-900 text-xs">
                            {new Date(String((jsonReport.report_metadata as Record<string, unknown>).generated_at || '')).toLocaleString()}
                          </span>
                        </div>
                        <div className="p-3 bg-slate-50 rounded border border-slate-200">
                          <span className="text-[10px] text-slate-500 block">ACTIVE FINDINGS</span>
                          <span className="font-bold text-slate-900 text-xs">
                            {jsonReport.active_findings?.length || 0} findings
                          </span>
                        </div>
                        <div className="p-3 bg-slate-50 rounded border border-slate-200">
                          <span className="text-[10px] text-slate-500 block">PEER BASELINES</span>
                          <span className="font-bold text-slate-900 text-xs">
                            {jsonReport.peer_baselines?.length || 0} baselines
                          </span>
                        </div>
                      </div>
                    )}

                    {/* Preformatted JSON Payload */}
                    <div>
                      <h4 className="text-xs font-mono font-bold text-slate-700 mb-2">
                        Complete Response Payload (JSON):
                      </h4>
                      <pre className="p-5 rounded-md bg-slate-900 text-emerald-400 font-mono text-xs overflow-x-auto border border-slate-800 shadow-inner max-h-[500px]">
                        {JSON.stringify(jsonReport, null, 2)}
                      </pre>
                    </div>
                  </>
                )}
              </CardContent>
            </Card>
          )}
        </div>
      )}
    </PageContainer>
  );
};

export default ExecutiveReportsPage;
