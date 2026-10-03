import React from 'react';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import Button from '../components/ui/Button';
import Skeleton from '../components/ui/Skeleton';
import ErrorState from '../components/ui/ErrorState';
import StatusBadge from '../components/ui/StatusBadge';
import { HeartPulse, Database, Server, RefreshCw, CheckCircle2, AlertTriangle } from 'lucide-react';
import { useHealthQuery } from '../hooks/api/useHealth';

export const SystemHealthPage: React.FC = () => {
  const { data: health, isLoading, isError, error, refetch, dataUpdatedAt } = useHealthQuery();

  const formattedLastChecked = dataUpdatedAt
    ? new Date(dataUpdatedAt).toLocaleTimeString()
    : 'Not fetched yet';

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[{ label: 'System' }, { label: 'Operational Health' }]}
        title="Application & Database Health Monitor"
        description="Real-time operational health telemetry retrieved from GET /api/v1/health."
        actions={
          <Button
            variant="outline"
            size="sm"
            icon={<RefreshCw className="w-3.5 h-3.5" />}
            onClick={() => refetch()}
            disabled={isLoading}
          >
            Refresh Health
          </Button>
        }
      />

      <div className="space-y-6">
        {/* Overall Health Status Summary Card */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-3 border-b border-slate-100">
            <div className="flex items-center gap-2">
              <HeartPulse className="w-5 h-5 text-blue-700" />
              <div>
                <CardTitle>System Connectivity & Engine Status</CardTitle>
                <CardDescription className="font-mono text-xs">
                  Target Endpoint: GET /api/v1/health • Last checked at {formattedLastChecked}
                </CardDescription>
              </div>
            </div>
            {health && (
              <div className="flex items-center gap-2 font-mono text-xs">
                {health.status === 'ok' ? (
                  <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-500/10 text-emerald-700 border border-emerald-500/30 font-bold">
                    <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
                    SYSTEM OPERATIONAL
                  </span>
                ) : (
                  <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-500/10 text-amber-700 border border-amber-500/30 font-bold">
                    <AlertTriangle className="w-3.5 h-3.5 text-amber-600" />
                    SYSTEM DEGRADED
                  </span>
                )}
              </div>
            )}
          </CardHeader>
          <CardContent className="p-6">
            {isLoading ? (
              <div className="space-y-3">
                <Skeleton className="h-12 w-full" />
                <Skeleton className="h-24 w-full" />
              </div>
            ) : isError ? (
              <ErrorState
                title="System Health Probe Failed"
                message={error instanceof Error ? error.message : 'Unable to connect to backend FastAPI service.'}
                onRetry={refetch}
              />
            ) : health ? (
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {/* FastAPI Application Subsystem */}
                <div className="bg-slate-50 border border-slate-200 rounded-xl p-4 space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold uppercase tracking-wider text-slate-500 font-mono flex items-center gap-1.5">
                      <Server className="w-4 h-4 text-blue-600" />
                      FastAPI Application
                    </span>
                    <StatusBadge status={health.app === 'healthy' ? 'ACTIVE' : 'INACTIVE'} />
                  </div>
                  <div className="text-lg font-bold text-slate-900 font-mono capitalize">{health.app}</div>
                  <p className="text-[11px] text-slate-500 font-mono">Uvicorn ASGI engine responding</p>
                </div>

                {/* PostgreSQL Database Subsystem */}
                <div className="bg-slate-50 border border-slate-200 rounded-xl p-4 space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold uppercase tracking-wider text-slate-500 font-mono flex items-center gap-1.5">
                      <Database className="w-4 h-4 text-emerald-600" />
                      PostgreSQL Database
                    </span>
                    <StatusBadge status={health.database === 'connected' ? 'ACTIVE' : 'INACTIVE'} />
                  </div>
                  <div className="text-lg font-bold text-slate-900 font-mono capitalize">{health.database}</div>
                  <p className="text-[11px] text-slate-500 font-mono">Live SQL connection pool active</p>
                </div>

                {/* Deployment Environment */}
                <div className="bg-slate-50 border border-slate-200 rounded-xl p-4 space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold uppercase tracking-wider text-slate-500 font-mono">
                      Environment Mode
                    </span>
                    <span className="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-slate-200 text-slate-800">
                      {health.environment}
                    </span>
                  </div>
                  <div className="text-lg font-bold text-slate-900 font-mono capitalize">{health.environment}</div>
                  <p className="text-[11px] text-slate-500 font-mono">Air-gapped supervisory environment</p>
                </div>
              </div>
            ) : null}
          </CardContent>
        </Card>
      </div>
    </PageContainer>
  );
};

export default SystemHealthPage;

