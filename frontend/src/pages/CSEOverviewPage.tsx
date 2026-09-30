import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import Badge from '../components/ui/Badge';
import StatusBadge from '../components/ui/StatusBadge';
import ErrorState from '../components/ui/ErrorState';
import Skeleton from '../components/ui/Skeleton';
import SeverityBadge from '../components/ui/SeverityBadge';
import {
  Building2,
  ShieldAlert,
  Activity,
  Search,
  BarChart3,
  FileText,
  UploadCloud,
  Layers,
  ArrowRight,
  Clock,
  Mail,
  Calendar,
} from 'lucide-react';
import { useCseQuery, useCseSummaryQuery } from '../hooks/api/useCses';
import { EntitySupervisoryOverviewCard } from '../components/supervisory/EntitySupervisoryOverviewCard';

export const CSEOverviewPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const activeCseId = cse_id || '';
  const navigate = useNavigate();

  const cseQuery = useCseQuery(activeCseId);
  const summaryQuery = useCseSummaryQuery(activeCseId);

  const isLoading = cseQuery.isLoading || summaryQuery.isLoading;
  const isError = cseQuery.isError || summaryQuery.isError;
  const error = cseQuery.error || summaryQuery.error;

  const handleRetryAll = () => {
    cseQuery.refetch();
    summaryQuery.refetch();
  };

  const cse = cseQuery.data;
  const summary = summaryQuery.data;

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: cse ? cse.name : `Entity ${activeCseId.slice(0, 8)}...` },
          { label: 'Overview' },
        ]}
        title="Entity Profile & Supervisory Overview"
        description="Aggregated supervisory attention indicators, operational telemetry counts, and active finding rationale."
      />

      {isLoading ? (
        <div className="space-y-6">
          <Skeleton className="h-36 w-full" />
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <Skeleton className="h-28 w-full" />
            <Skeleton className="h-28 w-full" />
            <Skeleton className="h-28 w-full" />
            <Skeleton className="h-28 w-full" />
          </div>
          <Skeleton className="h-48 w-full" />
        </div>
      ) : isError ? (
        <ErrorState
          title="Failed to Load CSE Overview"
          message={error instanceof Error ? error.message : 'Unable to connect to backend summary service.'}
          onRetry={handleRetryAll}
        />
      ) : (
        <div className="space-y-6">
          {/* Entity Profile Card */}
          {cse && (
            <Card>
              <CardHeader className="border-b border-slate-100 bg-slate-50/50">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-3">
                  <div className="flex items-center gap-3">
                    <div className="p-2 rounded-md bg-blue-100 text-blue-800">
                      <Building2 className="w-5 h-5" />
                    </div>
                    <div>
                      <CardTitle className="text-base font-bold text-slate-900">
                        {cse.name}
                      </CardTitle>
                      <CardDescription className="font-mono text-xs text-slate-500">
                        Entity Code: {cse.cse_code} • ID: {cse.id}
                      </CardDescription>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <Badge variant={cse.criticality_tier === 'TIER_1' ? 'warning' : 'info'}>
                      {cse.criticality_tier}
                    </Badge>
                    <StatusBadge status={cse.is_active ? 'ACTIVE' : 'INACTIVE'} />
                  </div>
                </div>
              </CardHeader>
              <CardContent className="p-5 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4 text-xs text-slate-700">
                <div>
                  <span className="text-slate-400 block font-mono">SECTOR</span>
                  <span className="font-semibold text-slate-900 font-mono text-sm">{cse.sector}</span>
                </div>
                <div>
                  <span className="text-slate-400 block font-mono flex items-center gap-1">
                    <Mail className="w-3 h-3" /> CONTACT EMAIL
                  </span>
                  <span className="font-medium text-slate-800 font-mono">{cse.contact_email || 'Not configured'}</span>
                </div>
                <div>
                  <span className="text-slate-400 block font-mono flex items-center gap-1">
                    <Calendar className="w-3 h-3" /> CREATED AT
                  </span>
                  <span className="font-mono">{new Date(cse.created_at).toLocaleDateString()}</span>
                </div>
                <div>
                  <span className="text-slate-400 block font-mono flex items-center gap-1">
                    <Clock className="w-3 h-3" /> LAST UPDATED
                  </span>
                  <span className="font-mono">{new Date(cse.updated_at).toLocaleDateString()}</span>
                </div>
              </CardContent>
            </Card>
          )}

          {/* Phase 6 Entity Supervisory Overview Card */}
          {activeCseId && <EntitySupervisoryOverviewCard cseId={activeCseId} />}

          {/* Telemetry Key Metric Cards */}
          {summary && (
            <div>
              <h3 className="text-xs font-mono uppercase tracking-wider text-slate-500 font-bold mb-3">
                Operational Telemetry Totals (GET /api/v1/cses/{activeCseId}/summary)
              </h3>
              <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
                <Card className="p-4 bg-white border border-slate-200">
                  <span className="text-[11px] font-mono text-slate-500 block">TOTAL ASSETS</span>
                  <span className="text-2xl font-bold text-slate-900 font-mono">
                    {summary.telemetry_counts.assets}
                  </span>
                </Card>
                <Card className="p-4 bg-white border border-slate-200">
                  <span className="text-[11px] font-mono text-slate-500 block">TOTAL ALERTS</span>
                  <span className="text-2xl font-bold text-slate-900 font-mono">
                    {summary.telemetry_counts.alerts_total}
                  </span>
                </Card>
                <Card className="p-4 bg-white border border-slate-200">
                  <span className="text-[11px] font-mono text-slate-500 block">CASES</span>
                  <span className="text-2xl font-bold text-slate-900 font-mono">
                    {summary.telemetry_counts.cases}
                  </span>
                </Card>
                <Card className="p-4 bg-white border border-slate-200">
                  <span className="text-[11px] font-mono text-slate-500 block">INVESTIGATIONS</span>
                  <span className="text-2xl font-bold text-slate-900 font-mono">
                    {summary.telemetry_counts.investigations}
                  </span>
                </Card>
                <Card className="p-4 bg-white border border-slate-200">
                  <span className="text-[11px] font-mono text-slate-500 block">ESCALATIONS</span>
                  <span className="text-2xl font-bold text-slate-900 font-mono">
                    {summary.telemetry_counts.escalations}
                  </span>
                </Card>
                <Card className="p-4 bg-white border border-slate-200">
                  <span className="text-[11px] font-mono text-slate-500 block">COVERAGES</span>
                  <span className="text-2xl font-bold text-slate-900 font-mono">
                    {summary.telemetry_counts.monitoring_coverages}
                  </span>
                </Card>
              </div>
            </div>
          )}

          {/* Alert Severity & Findings Breakdown */}
          {summary && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Alert Severity Breakdown */}
              <Card>
                <CardHeader className="pb-2 border-b border-slate-100">
                  <div className="flex items-center gap-2">
                    <ShieldAlert className="w-4 h-4 text-slate-600" />
                    <CardTitle className="text-sm font-bold">Alert Severity Breakdown</CardTitle>
                  </div>
                  <CardDescription>Distribution of telemetry alerts by severity tier</CardDescription>
                </CardHeader>
                <CardContent className="p-4 space-y-3">
                  {Object.entries(summary.telemetry_counts.alerts_by_severity || {}).map(
                    ([severity, count]) => (
                      <div
                        key={severity}
                        className="flex items-center justify-between p-2.5 rounded-md bg-slate-50 border border-slate-100"
                      >
                        <div className="flex items-center gap-2">
                          <SeverityBadge severity={severity} size="sm" />
                          <span className="text-xs font-mono font-medium text-slate-700">
                            {severity}
                          </span>
                        </div>
                        <span className="text-sm font-bold font-mono text-slate-900">
                          {count}
                        </span>
                      </div>
                    )
                  )}
                </CardContent>
              </Card>

              {/* Active Findings Summary */}
              <Card>
                <CardHeader className="pb-2 border-b border-slate-100">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <Layers className="w-4 h-4 text-slate-600" />
                      <CardTitle className="text-sm font-bold">Supervisory Findings</CardTitle>
                    </div>
                    <Badge variant="warning" size="sm">
                      {summary.analytics_summary.active_findings_count} Active
                    </Badge>
                  </div>
                  <CardDescription>Findings created by supervisory analytics engines</CardDescription>
                </CardHeader>
                <CardContent className="p-4 space-y-3">
                  {Object.entries(summary.analytics_summary.findings_by_category || {}).map(
                    ([category, count]) => (
                      <div
                        key={category}
                        className="flex items-center justify-between p-2.5 rounded-md bg-slate-50 border border-slate-100"
                      >
                        <span className="text-xs font-mono text-slate-700 font-medium">
                          {category}
                        </span>
                        <span className="text-sm font-bold font-mono text-slate-900">
                          {count}
                        </span>
                      </div>
                    )
                  )}

                  <div className="pt-2 border-t border-slate-100 grid grid-cols-2 gap-2 text-[11px] text-slate-500 font-mono">
                    <div>
                      <span>LATEST FINDING:</span>
                      <span className="block text-slate-800 font-semibold truncate">
                        {summary.analytics_summary.latest_finding_detected_at
                          ? new Date(summary.analytics_summary.latest_finding_detected_at).toLocaleString()
                          : 'None'}
                      </span>
                    </div>
                    <div>
                      <span>LAST INGESTION:</span>
                      <span className="block text-slate-800 font-semibold truncate">
                        {summary.analytics_summary.last_ingestion_batch_at
                          ? new Date(summary.analytics_summary.last_ingestion_batch_at).toLocaleString()
                          : 'None'}
                      </span>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          )}

          {/* Quick Supervisory Navigation Cards */}
          <div>
            <h3 className="text-xs font-mono uppercase tracking-wider text-slate-500 font-bold mb-3">
              Supervisory Deep Analysis Modules
            </h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3">
              <Card
                className="p-4 cursor-pointer hover:border-blue-400 hover:shadow-md transition-all group"
                onClick={() => navigate(`/cses/${activeCseId}/analytics`)}
              >
                <div className="flex items-center justify-between mb-2">
                  <Activity className="w-5 h-5 text-blue-600" />
                  <ArrowRight className="w-4 h-4 text-slate-300 group-hover:text-blue-600 transition-colors" />
                </div>
                <h4 className="text-xs font-bold text-slate-900">Analytics Console</h4>
                <p className="text-[11px] text-slate-500 mt-0.5">Evaluate rules & signals</p>
              </Card>

              <Card
                className="p-4 cursor-pointer hover:border-blue-400 hover:shadow-md transition-all group"
                onClick={() => navigate(`/cses/${activeCseId}/findings`)}
              >
                <div className="flex items-center justify-between mb-2">
                  <Search className="w-5 h-5 text-amber-600" />
                  <ArrowRight className="w-4 h-4 text-slate-300 group-hover:text-amber-600 transition-colors" />
                </div>
                <h4 className="text-xs font-bold text-slate-900">Findings Registry</h4>
                <p className="text-[11px] text-slate-500 mt-0.5">Explore detected gaps</p>
              </Card>

              <Card
                className="p-4 cursor-pointer hover:border-blue-400 hover:shadow-md transition-all group"
                onClick={() => navigate(`/cses/${activeCseId}/benchmarks`)}
              >
                <div className="flex items-center justify-between mb-2">
                  <BarChart3 className="w-5 h-5 text-indigo-600" />
                  <ArrowRight className="w-4 h-4 text-slate-300 group-hover:text-indigo-600 transition-colors" />
                </div>
                <h4 className="text-xs font-bold text-slate-900">Peer Benchmarks</h4>
                <p className="text-[11px] text-slate-500 mt-0.5">Compare sector baselines</p>
              </Card>

              <Card
                className="p-4 cursor-pointer hover:border-blue-400 hover:shadow-md transition-all group"
                onClick={() => navigate(`/cses/${activeCseId}/reports`)}
              >
                <div className="flex items-center justify-between mb-2">
                  <FileText className="w-5 h-5 text-emerald-600" />
                  <ArrowRight className="w-4 h-4 text-slate-300 group-hover:text-emerald-600 transition-colors" />
                </div>
                <h4 className="text-xs font-bold text-slate-900">Executive Reports</h4>
                <p className="text-[11px] text-slate-500 mt-0.5">Generate JSON/Markdown</p>
              </Card>

              <Card
                className="p-4 cursor-pointer hover:border-blue-400 hover:shadow-md transition-all group"
                onClick={() => navigate(`/cses/${activeCseId}/ingestion`)}
              >
                <div className="flex items-center justify-between mb-2">
                  <UploadCloud className="w-5 h-5 text-cyan-600" />
                  <ArrowRight className="w-4 h-4 text-slate-300 group-hover:text-cyan-600 transition-colors" />
                </div>
                <h4 className="text-xs font-bold text-slate-900">Data Ingestion</h4>
                <p className="text-[11px] text-slate-500 mt-0.5">Batch import audit logs</p>
              </Card>
            </div>
          </div>
        </div>
      )}
    </PageContainer>
  );
};

export default CSEOverviewPage;
