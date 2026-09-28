import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import Badge from '../components/ui/Badge';
import SeverityBadge from '../components/ui/SeverityBadge';
import Button from '../components/ui/Button';
import Input from '../components/ui/Input';
import Alert from '../components/ui/Alert';
import EmptyState from '../components/ui/EmptyState';
import ErrorState from '../components/ui/ErrorState';
import Skeleton from '../components/ui/Skeleton';
import {
  Activity,
  Play,
  Calendar,
  ArrowRight,
  RotateCw,
  CheckCircle2,
  Clock,
  Info,
} from 'lucide-react';
import {
  useAnalyticsSignalsQuery,
  useRunAnalyticsMutation,
} from '../hooks/api/useAnalyticsSignals';
import type { AnalyticsRunResultSchema } from '../types/api/analytics';

const CANONICAL_CATEGORIES = [
  { key: 'EXECUTION_GAP', label: 'Execution Gap', code: 'EG' },
  { key: 'NEGATIVE_SPACE', label: 'Negative Space', code: 'NS' },
  { key: 'ANOMALY', label: 'Statistical Anomaly', code: 'AN' },
  { key: 'BENCHMARK', label: 'Benchmark Deviation', code: 'BM' },
];

export const AnalyticsConsolePage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const activeCseId = cse_id || '';
  const navigate = useNavigate();

  // Observation Period State
  const [obsStart, setObsStart] = useState<string>('');
  const [obsEnd, setObsEnd] = useState<string>('');
  const [validationError, setValidationError] = useState<string | null>(null);

  // Execution Result State
  const [lastRunResult, setLastRunResult] = useState<AnalyticsRunResultSchema | null>(null);
  const [runError, setRunError] = useState<string | null>(null);

  // Convert local datetime input values to ISO strings for API parameters
  const isoObsStart = obsStart ? new Date(obsStart).toISOString() : undefined;
  const isoObsEnd = obsEnd ? new Date(obsEnd).toISOString() : undefined;

  const signalQueryParams = {
    obs_start: isoObsStart,
    obs_end: isoObsEnd,
  };

  const {
    data: signalData,
    isLoading: isSignalsLoading,
    isError: isSignalsError,
    error: signalsError,
    refetch: refetchSignals,
  } = useAnalyticsSignalsQuery(activeCseId, signalQueryParams);

  const runMutation = useRunAnalyticsMutation(activeCseId);

  const validateDates = (): boolean => {
    setValidationError(null);
    if (obsStart && obsEnd) {
      const startDate = new Date(obsStart);
      const endDate = new Date(obsEnd);
      if (startDate >= endDate) {
        setValidationError('Observation start date must be strictly before observation end date.');
        return false;
      }
    }
    return true;
  };

  const handleRunAnalytics = async (e: React.FormEvent) => {
    e.preventDefault();
    setRunError(null);

    if (!validateDates()) return;

    try {
      const result = await runMutation.mutateAsync({
        obs_start: isoObsStart || null,
        obs_end: isoObsEnd || null,
      });
      setLastRunResult(result);
    } catch (err: unknown) {
      const apiErr = err as { message?: string };
      setRunError(apiErr.message || 'Failed to execute supervisory analytics engine.');
    }
  };

  const handleResetPeriod = () => {
    setObsStart('');
    setObsEnd('');
    setValidationError(null);
  };

  const signals = signalData?.signals || {};
  const dataSufficiencyStatus = signalData?.data_sufficiency_status || 'NO_FINDINGS';

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${activeCseId.slice(0, 8)}...`, href: `/cses/${activeCseId}` },
          { label: 'Analytics Console' },
        ]}
        title="Supervisory Analytics Engine Console"
        description="Configure observation periods, execute deterministic supervisory rules, and inspect persisted signal matrices."
      />

      {/* Observation Period & Execution Panel */}
      <Card className="mb-6">
        <CardHeader className="border-b border-slate-100 bg-slate-50/50">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
            <div className="flex items-center gap-2">
              <Calendar className="w-5 h-5 text-blue-700" />
              <div>
                <CardTitle className="text-base font-bold text-slate-900">
                  Observation Period & Engine Trigger
                </CardTitle>
                <CardDescription>
                  Define observation window and trigger rule evaluation (POST /api/v1/analytics/{activeCseId}/run)
                </CardDescription>
              </div>
            </div>
            {lastRunResult && (
              <Badge variant="success" size="sm">
                Last Run: {new Date(lastRunResult.executed_at).toLocaleTimeString()}
              </Badge>
            )}
          </div>
        </CardHeader>
        <CardContent className="p-5">
          <form onSubmit={handleRunAnalytics} className="space-y-4">
            {validationError && (
              <Alert type="error" title="Validation Error">
                {validationError}
              </Alert>
            )}

            {runError && (
              <Alert type="error" title="Analytics Execution Error">
                {runError}
              </Alert>
            )}

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 items-end">
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">
                  Observation Start (obs_start)
                </label>
                <Input
                  type="datetime-local"
                  value={obsStart}
                  onChange={(e) => {
                    setObsStart(e.target.value);
                    setValidationError(null);
                  }}
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">
                  Observation End (obs_end)
                </label>
                <Input
                  type="datetime-local"
                  value={obsEnd}
                  onChange={(e) => {
                    setObsEnd(e.target.value);
                    setValidationError(null);
                  }}
                />
              </div>

              <div className="flex gap-2">
                <Button
                  type="submit"
                  variant="primary"
                  className="flex-1"
                  disabled={runMutation.isPending}
                  icon={runMutation.isPending ? <RotateCw className="w-4 h-4 animate-spin" /> : <Play className="w-4 h-4" />}
                >
                  {runMutation.isPending ? 'Executing Engine...' : 'Run Analytics Engine'}
                </Button>

                {(obsStart || obsEnd) && (
                  <Button
                    type="button"
                    variant="outline"
                    onClick={handleResetPeriod}
                    icon={<RotateCw className="w-3.5 h-3.5" />}
                  >
                    Reset
                  </Button>
                )}
              </div>
            </div>
          </form>
        </CardContent>
      </Card>

      {/* Execution Result Fact Panel */}
      {lastRunResult && (
        <Card className="mb-6 border-blue-200 bg-blue-50/20">
          <CardHeader className="border-b border-blue-100 py-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2 text-blue-900">
                <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                <CardTitle className="text-sm font-bold">Analytics Execution Result</CardTitle>
              </div>
              <span className="text-xs font-mono text-slate-500">
                Executed At: {new Date(lastRunResult.executed_at).toLocaleString()}
              </span>
            </div>
          </CardHeader>
          <CardContent className="p-4 space-y-4">
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
              <div className="bg-white p-3 rounded border border-slate-200">
                <span className="text-[10px] font-mono text-slate-500 block">FINDINGS CREATED</span>
                <span className="text-lg font-bold font-mono text-blue-700">
                  {lastRunResult.findings_created}
                </span>
              </div>
              <div className="bg-white p-3 rounded border border-slate-200">
                <span className="text-[10px] font-mono text-slate-500 block">DEDUPLICATED</span>
                <span className="text-lg font-bold font-mono text-slate-700">
                  {lastRunResult.findings_deduplicated}
                </span>
              </div>
              <div className="bg-white p-3 rounded border border-slate-200">
                <span className="text-[10px] font-mono text-slate-500 block">BASELINES PERSISTED</span>
                <span className="text-lg font-bold font-mono text-slate-700">
                  {lastRunResult.baselines_persisted}
                </span>
              </div>
              <div className="bg-white p-3 rounded border border-slate-200">
                <span className="text-[10px] font-mono text-slate-500 block">RULES EVALUATED</span>
                <span className="text-lg font-bold font-mono text-slate-700">
                  {lastRunResult.rules_evaluated.length}
                </span>
              </div>
            </div>

            {/* Evaluated Rules list */}
            <div>
              <span className="text-xs font-semibold text-slate-700 block mb-1.5">
                Evaluated Rule Identifiers:
              </span>
              <div className="flex flex-wrap gap-1.5">
                {lastRunResult.rules_evaluated.map((rule) => (
                  <Badge key={rule} variant="outline" size="sm" className="font-mono">
                    {rule}
                  </Badge>
                ))}
              </div>
            </div>

            {/* Data Sufficiency per Rule */}
            {lastRunResult.data_sufficiency_by_rule && (
              <div>
                <span className="text-xs font-semibold text-slate-700 block mb-1.5">
                  Data Sufficiency by Rule:
                </span>
                <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 text-[11px] font-mono">
                  {Object.entries(lastRunResult.data_sufficiency_by_rule).map(([rule, status]) => (
                    <div
                      key={rule}
                      className="p-2 rounded bg-white border border-slate-200 flex items-center justify-between"
                    >
                      <span className="font-bold text-slate-800">{rule}:</span>
                      <span
                        className={
                          status === 'SUFFICIENT'
                            ? 'text-emerald-700 font-semibold'
                            : 'text-amber-700 font-medium'
                        }
                      >
                        {status}
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      )}

      {/* Supervisory Signals Matrix Section */}
      <Card>
        <CardHeader className="border-b border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <Activity className="w-5 h-5 text-blue-700" />
            <div>
              <CardTitle className="text-base font-bold text-slate-900">
                Supervisory Signals Matrix
              </CardTitle>
              <CardDescription>
                GET /api/v1/analytics/{activeCseId}/signals
              </CardDescription>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <Badge
              variant={dataSufficiencyStatus === 'SUFFICIENT' ? 'info' : 'outline'}
              size="sm"
            >
              Status: {dataSufficiencyStatus}
            </Badge>
            <Button
              variant="outline"
              size="sm"
              icon={<ArrowRight className="w-3.5 h-3.5" />}
              onClick={() => navigate(`/cses/${activeCseId}/findings`)}
            >
              View Findings Registry
            </Button>
          </div>
        </CardHeader>
        <CardContent className="p-6">
          {isSignalsLoading ? (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <Skeleton className="h-44 w-full" />
              <Skeleton className="h-44 w-full" />
              <Skeleton className="h-44 w-full" />
              <Skeleton className="h-44 w-full" />
            </div>
          ) : isSignalsError ? (
            <ErrorState
              title="Failed to fetch Supervisory Signals"
              message={signalsError instanceof Error ? signalsError.message : 'Unable to connect to signals API.'}
              onRetry={refetchSignals}
            />
          ) : dataSufficiencyStatus === 'NO_FINDINGS' && Object.keys(signals).length === 0 ? (
            <EmptyState
              icon={<Info className="w-8 h-8 text-slate-400" />}
              title="No Supervisory Findings Persisted"
              description="No supervisory findings are currently persisted for this observation period. Click 'Run Analytics Engine' above to evaluate telemetry rules."
              action={
                <Button
                  icon={<Play className="w-4 h-4" />}
                  onClick={handleRunAnalytics}
                  disabled={runMutation.isPending}
                >
                  Execute Analytics Engine
                </Button>
              }
            />
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {CANONICAL_CATEGORIES.map((cat) => {
                const group = signals[cat.key];
                const count = group?.count || 0;
                const maxSeverity = group?.max_severity;
                const findingsList = group?.findings || [];

                return (
                  <Card
                    key={cat.key}
                    className="border border-slate-200 hover:border-slate-300 transition-colors"
                  >
                    <CardHeader className="pb-3 border-b border-slate-100 bg-slate-50/40">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <Badge variant="outline" size="sm" className="font-mono font-bold">
                            {cat.code}
                          </Badge>
                          <CardTitle className="text-sm font-bold text-slate-900">
                            {group?.display_name || cat.label}
                          </CardTitle>
                        </div>
                        <div className="flex items-center gap-2">
                          {maxSeverity && <SeverityBadge severity={maxSeverity} size="sm" />}
                          <Badge variant={count > 0 ? 'warning' : 'outline'} size="sm">
                            {count} {count === 1 ? 'Finding' : 'Findings'}
                          </Badge>
                        </div>
                      </div>
                    </CardHeader>
                    <CardContent className="p-4">
                      {findingsList.length === 0 ? (
                        <p className="text-xs text-slate-500 font-mono italic">
                          No {cat.label.toLowerCase()} findings persisted for this period.
                        </p>
                      ) : (
                        <div className="space-y-2.5">
                          {findingsList.map((item) => (
                            <div
                              key={item.finding_id}
                              className="p-3 rounded-md bg-slate-50 border border-slate-100 hover:bg-slate-100/80 transition-colors flex flex-col gap-1 cursor-pointer"
                              onClick={() => navigate(`/cses/${activeCseId}/findings`)}
                            >
                              <div className="flex items-center justify-between gap-2">
                                <span className="font-mono text-xs font-bold text-blue-700">
                                  {item.finding_code}
                                </span>
                                <SeverityBadge severity={item.severity} size="sm" />
                              </div>
                              <span className="text-xs font-medium text-slate-900 leading-snug">
                                {item.title}
                              </span>
                              <div className="flex items-center gap-1 text-[10px] font-mono text-slate-500 mt-1">
                                <Clock className="w-3 h-3" />
                                <span>Detected: {new Date(item.detected_at).toLocaleString()}</span>
                              </div>
                            </div>
                          ))}
                        </div>
                      )}
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          )}
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default AnalyticsConsolePage;
