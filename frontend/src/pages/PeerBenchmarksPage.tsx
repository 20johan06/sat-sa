import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import Badge from '../components/ui/Badge';
import Input from '../components/ui/Input';
import Button from '../components/ui/Button';
import Alert from '../components/ui/Alert';
import EmptyState from '../components/ui/EmptyState';
import ErrorState from '../components/ui/ErrorState';
import Skeleton from '../components/ui/Skeleton';
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '../components/ui/Table';
import {
  BarChart3,
  Calendar,
  Search,
  RotateCcw,
  Users,
} from 'lucide-react';
import { useBenchmarksQuery } from '../hooks/api/useBenchmarks';
import type { PeerGroupStatus } from '../types/api/benchmarks';

export const PeerBenchmarksPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const activeCseId = cse_id || '';

  // Observation Window State
  const [obsStart, setObsStart] = useState<string>('');
  const [obsEnd, setObsEnd] = useState<string>('');
  const [dateError, setDateError] = useState<string | null>(null);

  const isoObsStart = obsStart ? new Date(obsStart).toISOString() : undefined;
  const isoObsEnd = obsEnd ? new Date(obsEnd).toISOString() : undefined;

  const queryParams = {
    obs_start: isoObsStart,
    obs_end: isoObsEnd,
  };

  const { data, isLoading, isError, error, refetch } = useBenchmarksQuery(
    activeCseId,
    queryParams
  );

  const handleFilterSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setDateError(null);

    if (obsStart && obsEnd && new Date(obsStart) >= new Date(obsEnd)) {
      setDateError('Observation start date must be strictly before observation end date.');
      return;
    }

    refetch();
  };

  const handleReset = () => {
    setObsStart('');
    setObsEnd('');
    setDateError(null);
  };

  const renderStatusBadge = (status?: PeerGroupStatus | string) => {
    switch (status) {
      case 'SECTOR_PEER_GROUP':
        return <Badge variant="success">SUFFICIENT SECTOR DATA (N ≥ 3)</Badge>;
      case 'POPULATION_FALLBACK':
        return <Badge variant="warning" className="font-mono">POPULATION FALLBACK ACTIVE</Badge>;
      case 'NO_APPLICABLE_BASELINE':
        return <Badge variant="outline">INSUFFICIENT DATA</Badge>;
      default:
        return <Badge variant="outline">{status || 'UNKNOWN'}</Badge>;
    }
  };

  const baselines = data?.baselines || [];

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${activeCseId.slice(0, 8)}...`, href: `/cses/${activeCseId}` },
          { label: 'Peer Benchmarks' },
        ]}
        title="Peer Group & Sector Benchmarking Inspector"
        description="Inspect persisted sector baseline distributions, sample sizes, and population fallbacks for the target Critical Sector Entity."
      />

      {/* Supervisory Guidance & Explainability Callout */}
      <div className="mb-6 p-4 bg-blue-50/70 border border-blue-200 rounded-md text-xs text-blue-900 space-y-1 font-sans">
        <div className="font-bold flex items-center gap-1.5 text-blue-900 font-mono uppercase">
          <BarChart3 className="w-4 h-4 text-blue-700" />
          Canonical BM-01 Benchmark Guidance
        </div>
        <p className="text-slate-700">
          Peer benchmarking evaluates target CSE alert investigation and critical escalation rates against sector baselines.
          Deviations (|Z| &gt; 2.0) are presented for explainable oversight.
        </p>
        <p className="font-semibold text-blue-800 font-mono text-[11px] pt-1">
          Supervisory Interpretation: &quot;Peer deviation detected — supervisory review may be warranted.&quot;
        </p>
      </div>

      {/* Observation Period Selector Card */}
      <Card className="mb-6">
        <CardHeader className="border-b border-slate-100 bg-slate-50/50 py-3">
          <div className="flex items-center gap-2">
            <Calendar className="w-4 h-4 text-blue-700" />
            <CardTitle className="text-sm font-bold text-slate-900">
              Observation Window Filter
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

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3 items-end">
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">
                  Observation Start (obs_start)
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
                  Observation End (obs_end)
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
                  Apply Window
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

      {/* Main Content Area */}
      {isLoading ? (
        <div className="space-y-6">
          <Skeleton className="h-32 w-full" />
          <Skeleton className="h-64 w-full" />
        </div>
      ) : isError ? (
        <ErrorState
          title="Failed to Load Peer Benchmarks"
          message={error instanceof Error ? error.message : 'Unable to connect to backend benchmarks API.'}
          onRetry={refetch}
        />
      ) : (
        <div className="space-y-6">
          {/* Peer Group Metadata Summary Card */}
          {data && (
            <Card>
              <CardHeader className="border-b border-slate-100 bg-slate-50/50">
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                  <div className="flex items-center gap-3">
                    <div className="p-2 rounded bg-blue-100 text-blue-800">
                      <Users className="w-5 h-5" />
                    </div>
                    <div>
                      <CardTitle className="text-base font-bold text-slate-900">
                        Peer Group Context: {data.peer_group_name}
                      </CardTitle>
                      <CardDescription className="font-mono text-xs text-slate-500">
                        Target Endpoint: GET /api/v1/benchmarks/{activeCseId}
                      </CardDescription>
                    </div>
                  </div>
                  <div>{renderStatusBadge(data.peer_group_status)}</div>
                </div>
              </CardHeader>
              <CardContent className="p-4 grid grid-cols-1 sm:grid-cols-3 gap-4 text-xs font-mono">
                <div className="bg-slate-50 p-3 rounded border border-slate-200">
                  <span className="text-slate-500 block text-[10px]">SECTOR</span>
                  <span className="font-bold text-slate-900 text-sm">{data.sector}</span>
                </div>
                <div className="bg-slate-50 p-3 rounded border border-slate-200">
                  <span className="text-slate-500 block text-[10px]">SECTOR OBSERVATIONS</span>
                  <span className="font-bold text-slate-900 text-sm">
                    {data.n_sector_observations} sample(s)
                  </span>
                </div>
                <div className="bg-slate-50 p-3 rounded border border-slate-200">
                  <span className="text-slate-500 block text-[10px]">OBSERVATION BOUNDED</span>
                  <span className="font-bold text-slate-900 text-sm">
                    {data.observation_period?.is_bounded ? 'Bounded Window' : 'Unbounded'}
                  </span>
                </div>
              </CardContent>
            </Card>
          )}

          {/* Baselines Table Card */}
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-3">
              <div>
                <CardTitle className="text-sm font-bold">Sector & Population Baselines</CardTitle>
                <CardDescription>
                  Persisted metric baseline values, standard deviations, and sample bounds
                </CardDescription>
              </div>
              <Badge variant="outline" size="sm">
                {baselines.length} Metric Baseline(s)
              </Badge>
            </CardHeader>
            <CardContent className="p-0">
              {baselines.length === 0 ? (
                <div className="p-8">
                  <EmptyState
                    icon={<BarChart3 className="w-8 h-8 text-slate-400" />}
                    title="No Applicable Benchmark Baseline"
                    description="No applicable benchmark baselines are currently persisted for this entity or observation window."
                  />
                </div>
              ) : (
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Metric Name</TableHead>
                      <TableHead>Peer Group</TableHead>
                      <TableHead className="text-right">Baseline Mean</TableHead>
                      <TableHead className="text-right">Min</TableHead>
                      <TableHead className="text-right">Max</TableHead>
                      <TableHead className="text-right">Std Dev</TableHead>
                      <TableHead className="text-right">Sample Size (N)</TableHead>
                      <TableHead>Period Window</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {baselines.map((item) => (
                      <TableRow key={item.id}>
                        <TableCell className="font-mono text-xs font-bold text-slate-900">
                          {item.metric_name}
                        </TableCell>
                        <TableCell className="font-mono text-xs text-slate-600">
                          <Badge variant="outline" size="sm" className="font-mono">
                            {item.peer_group}
                          </Badge>
                        </TableCell>
                        <TableCell className="font-mono text-xs font-bold text-blue-800 text-right">
                          {item.baseline_value.toFixed(4)}
                        </TableCell>
                        <TableCell className="font-mono text-xs text-slate-600 text-right">
                          {item.min_value !== undefined && item.min_value !== null
                            ? item.min_value.toFixed(4)
                            : '—'}
                        </TableCell>
                        <TableCell className="font-mono text-xs text-slate-600 text-right">
                          {item.max_value !== undefined && item.max_value !== null
                            ? item.max_value.toFixed(4)
                            : '—'}
                        </TableCell>
                        <TableCell className="font-mono text-xs text-slate-600 text-right">
                          {item.std_dev.toFixed(4)}
                        </TableCell>
                        <TableCell className="font-mono text-xs font-semibold text-slate-900 text-right">
                          {item.sample_size}
                        </TableCell>
                        <TableCell className="font-mono text-[11px] text-slate-500 whitespace-nowrap">
                          {new Date(item.period_start).toLocaleDateString()} –{' '}
                          {new Date(item.period_end).toLocaleDateString()}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              )}
            </CardContent>
          </Card>
        </div>
      )}
    </PageContainer>
  );
};

export default PeerBenchmarksPage;
