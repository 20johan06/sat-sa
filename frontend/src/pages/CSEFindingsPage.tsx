import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import ErrorState from '../components/ui/ErrorState';
import Skeleton from '../components/ui/Skeleton';
import Select from '../components/ui/Select';
import Input from '../components/ui/Input';
import Button from '../components/ui/Button';
import Badge from '../components/ui/Badge';
import SeverityBadge from '../components/ui/SeverityBadge';
import StatusBadge from '../components/ui/StatusBadge';
import Alert from '../components/ui/Alert';
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '../components/ui/Table';
import {
  Search,
  RotateCcw,
  ChevronLeft,
  ChevronRight,
  ArrowRight,
  Layers,
  Calendar,
} from 'lucide-react';
import { useFindingsQuery } from '../hooks/api/useFindings';
import type { FindingQueryParams } from '../types/api/findings';

const CATEGORY_OPTIONS = [
  { value: '', label: 'All Categories' },
  { value: 'EXECUTION_GAP', label: 'Execution Gap' },
  { value: 'NEGATIVE_SPACE', label: 'Negative Space' },
  { value: 'ANOMALY', label: 'Statistical Anomaly' },
  { value: 'BENCHMARK', label: 'Benchmark Deviation' },
];

const SEVERITY_OPTIONS = [
  { value: '', label: 'All Severities' },
  { value: 'CRITICAL', label: 'CRITICAL' },
  { value: 'HIGH', label: 'HIGH' },
  { value: 'MEDIUM', label: 'MEDIUM' },
  { value: 'LOW', label: 'LOW' },
];

const STATUS_OPTIONS = [
  { value: '', label: 'All Statuses' },
  { value: 'NEW', label: 'NEW' },
  { value: 'ACKNOWLEDGED', label: 'ACKNOWLEDGED' },
  { value: 'RESOLVED', label: 'RESOLVED' },
];

export const CSEFindingsPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const activeCseId = cse_id || '';
  const navigate = useNavigate();

  // Filter States
  const [selectedCategory, setSelectedCategory] = useState<string>('');
  const [selectedSeverity, setSelectedSeverity] = useState<string>('');
  const [selectedStatus, setSelectedStatus] = useState<string>('');
  const [ruleCodeInput, setRuleCodeInput] = useState<string>('');
  const [obsStart, setObsStart] = useState<string>('');
  const [obsEnd, setObsEnd] = useState<string>('');
  const [page, setPage] = useState<number>(1);
  const pageSize = 20;

  const [dateError, setDateError] = useState<string | null>(null);

  const isoObsStart = obsStart ? new Date(obsStart).toISOString() : undefined;
  const isoObsEnd = obsEnd ? new Date(obsEnd).toISOString() : undefined;

  const queryParams: FindingQueryParams = {
    cse_id: activeCseId,
    category: selectedCategory || undefined,
    severity: selectedSeverity || undefined,
    status: selectedStatus || undefined,
    rule_code: ruleCodeInput.trim() || undefined,
    obs_start: isoObsStart,
    obs_end: isoObsEnd,
    page,
    page_size: pageSize,
  };

  const { data, isLoading, isError, error, refetch } = useFindingsQuery(queryParams);

  const handleFilterSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setDateError(null);

    if (obsStart && obsEnd && new Date(obsStart) >= new Date(obsEnd)) {
      setDateError('Observation start date must be strictly before observation end date.');
      return;
    }

    setPage(1);
  };

  const handleResetFilters = () => {
    setSelectedCategory('');
    setSelectedSeverity('');
    setSelectedStatus('');
    setRuleCodeInput('');
    setObsStart('');
    setObsEnd('');
    setDateError(null);
    setPage(1);
  };

  const isFiltered = Boolean(
    selectedCategory ||
      selectedSeverity ||
      selectedStatus ||
      ruleCodeInput ||
      obsStart ||
      obsEnd
  );

  const findingsList = data?.items || [];
  const pagination = data?.pagination;
  const totalPages = pagination?.total_pages || 1;
  const totalItems = pagination?.total || 0;

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${activeCseId.slice(0, 8)}...`, href: `/cses/${activeCseId}` },
          { label: 'Findings Registry' },
        ]}
        title="Entity Supervisory Findings Registry"
        description={`Persisted telemetry gaps, anomalies, and benchmark findings registered specifically for CSE ID: ${activeCseId}`}
      />

      {dateError && (
        <div className="mb-4">
          <Alert type="error" title="Filter Validation Error">
            {dateError}
          </Alert>
        </div>
      )}

      {/* Entity Filter Shell */}
      <Card className="mb-6">
        <CardContent className="p-4">
          <form onSubmit={handleFilterSubmit} className="space-y-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-3">
              <Select
                label="Category"
                value={selectedCategory}
                onChange={(e) => {
                  setSelectedCategory(e.target.value);
                  setPage(1);
                }}
                options={CATEGORY_OPTIONS}
              />
              <Select
                label="Severity"
                value={selectedSeverity}
                onChange={(e) => {
                  setSelectedSeverity(e.target.value);
                  setPage(1);
                }}
                options={SEVERITY_OPTIONS}
              />
              <Select
                label="Status"
                value={selectedStatus}
                onChange={(e) => {
                  setSelectedStatus(e.target.value);
                  setPage(1);
                }}
                options={STATUS_OPTIONS}
              />
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">Rule Code</label>
                <Input
                  value={ruleCodeInput}
                  onChange={(e) => setRuleCodeInput(e.target.value)}
                  placeholder="e.g. EG-01, NS-02"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 items-end">
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">
                  Obs Start
                </label>
                <Input
                  type="datetime-local"
                  value={obsStart}
                  onChange={(e) => setObsStart(e.target.value)}
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
                  onChange={(e) => setObsEnd(e.target.value)}
                  startIcon={<Calendar className="w-4 h-4 text-slate-400" />}
                />
              </div>
            </div>

            <div className="flex justify-end gap-2 pt-2 border-t border-slate-100">
              {isFiltered && (
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  icon={<RotateCcw className="w-3.5 h-3.5" />}
                  onClick={handleResetFilters}
                >
                  Reset Filters
                </Button>
              )}
              <Button type="submit" variant="primary" size="sm" icon={<Search className="w-3.5 h-3.5" />}>
                Apply Filters
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>

      {/* Main Entity Data Table */}
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-3">
          <div>
            <CardTitle>Entity Findings Grid</CardTitle>
            <CardDescription>
              Persisted findings retrieved from GET /api/v1/findings/?cse_id={activeCseId}
            </CardDescription>
          </div>
          <Badge variant="outline" size="sm">
            Total Findings: {totalItems}
          </Badge>
        </CardHeader>
        <CardContent className="p-0">
          {isLoading ? (
            <div className="p-6 space-y-3">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-12 w-full" />
            </div>
          ) : isError ? (
            <div className="p-6">
              <ErrorState
                title="Failed to fetch Entity Findings"
                message={error instanceof Error ? error.message : 'Backend API connection failed.'}
                onRetry={refetch}
              />
            </div>
          ) : findingsList.length === 0 ? (
            <div className="p-8">
              <EmptyState
                icon={<Search className="w-8 h-8 text-slate-400" />}
                title={isFiltered ? 'No Matching Entity Findings' : 'No Supervisory Findings Persisted'}
                description={
                  isFiltered
                    ? 'No findings match the applied filter criteria for this entity.'
                    : 'No supervisory findings have been persisted for this Critical Sector Entity yet.'
                }
                action={
                  isFiltered ? (
                    <Button variant="outline" onClick={handleResetFilters}>
                      Clear Filters
                    </Button>
                  ) : undefined
                }
              />
            </div>
          ) : (
            <>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Finding Code</TableHead>
                    <TableHead>Category</TableHead>
                    <TableHead>Severity</TableHead>
                    <TableHead>Title & Summary</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead>Evidence</TableHead>
                    <TableHead>Detected At</TableHead>
                    <TableHead className="text-right">Action</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {findingsList.map((finding) => (
                    <TableRow
                      key={finding.id}
                      className="cursor-pointer hover:bg-slate-50/90 transition-colors"
                      onClick={() => navigate(`/findings/${finding.id}`)}
                    >
                      <TableCell className="font-mono text-xs font-bold text-blue-700">
                        {finding.finding_code}
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline" size="sm" className="font-mono text-[11px]">
                          {finding.category}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <SeverityBadge severity={finding.severity} size="sm" />
                      </TableCell>
                      <TableCell className="font-medium text-slate-900 max-w-xs truncate">
                        {finding.title}
                      </TableCell>
                      <TableCell>
                        <StatusBadge status={finding.status} />
                      </TableCell>
                      <TableCell className="font-mono text-xs text-slate-600">
                        <span className="flex items-center gap-1">
                          <Layers className="w-3 h-3 text-slate-400" />
                          {finding.evidence_count} records
                        </span>
                      </TableCell>
                      <TableCell className="font-mono text-xs text-slate-500 whitespace-nowrap">
                        {new Date(finding.detected_at).toLocaleString()}
                      </TableCell>
                      <TableCell className="text-right">
                        <Button
                          variant="ghost"
                          size="sm"
                          icon={<ArrowRight className="w-3.5 h-3.5" />}
                          onClick={(e) => {
                            e.stopPropagation();
                            navigate(`/findings/${finding.id}`);
                          }}
                        >
                          Detail
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>

              {/* Pagination Controls */}
              <div className="px-5 py-3 border-t border-slate-200 flex items-center justify-between bg-slate-50/50">
                <span className="text-xs text-slate-500 font-mono">
                  Page {page} of {totalPages} • Total {totalItems} findings for this entity
                </span>
                <div className="flex gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={page === 1}
                    icon={<ChevronLeft className="w-4 h-4" />}
                    onClick={() => setPage((p) => Math.max(1, p - 1))}
                  >
                    Previous
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={page >= totalPages}
                    icon={<ChevronRight className="w-4 h-4" />}
                    onClick={() => setPage((p) => p + 1)}
                  >
                    Next
                  </Button>
                </div>
              </div>
            </>
          )}
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default CSEFindingsPage;
