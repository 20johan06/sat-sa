import React from 'react';
import { useNavigate } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import Badge from '../components/ui/Badge';
import Button from '../components/ui/Button';
import Skeleton from '../components/ui/Skeleton';
import SeverityBadge from '../components/ui/SeverityBadge';
import StatusBadge from '../components/ui/StatusBadge';
import SupervisoryAttentionQueue from '../components/supervisory/SupervisoryAttentionQueue';
import {
  ShieldAlert,
  Building2,
  Layers,
  ArrowRight,
  Activity,
  Eye,
  Shield
} from 'lucide-react';
import { useCsesQuery } from '../hooks/api/useCses';
import { useFindingsQuery } from '../hooks/api/useFindings';

const CAPABILITY_DIMENSIONS = [
  { name: 'Threat Detection', category: 'Operational', evidenceType: 'Direct Signals' },
  { name: 'Investigation', category: 'Operational', evidenceType: 'Direct Signals' },
  { name: 'Escalation', category: 'Governance', evidenceType: 'Direct Signals' },
  { name: 'Incident Response', category: 'Operational', evidenceType: 'Direct Signals' },
  { name: 'Security Operations', category: 'Operational', evidenceType: 'Indirect Signals' },
  { name: 'Governance & Oversight', category: 'Governance', evidenceType: 'Indirect Signals' },
  { name: 'Operational Discipline', category: 'Resilience', evidenceType: 'Indirect Signals' },
  { name: 'Cyber Resilience', category: 'Resilience', evidenceType: 'Indirect Signals' },
];

export const SupervisoryOverviewPage: React.FC = () => {
  const navigate = useNavigate();

  // API Queries for Factual Metrics & Recent Signals
  const { data: cses, isLoading: isCsesLoading } = useCsesQuery({ skip: 0, limit: 100 });
  const { data: findingsData, isLoading: isFindingsLoading } = useFindingsQuery({ page: 1, page_size: 5 });

  const totalCses = cses?.length || 0;
  const activeFindings = findingsData?.pagination.total || 0;
  const findingsList = findingsData?.items || [];

  // Factual count breakdowns from fetched findings
  const underReviewCount = findingsList.filter((f) => f.status === 'UNDER_REVIEW').length;
  const confirmedCount = findingsList.filter((f) => f.status === 'CONFIRMED').length;

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[{ label: 'Platform' }, { label: 'Supervisory Overview' }]}
        title="SAT-SA Supervisory Overview"
        description="National supervisory analytics dashboard surfacing operational evidence, hidden telemetry signals, and explainable supervisory flags for NCIIPC examiners."
      />

      <div className="space-y-6">
        {/* SECTION 1 — FACTUAL OVERVIEW METRICS */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 font-sans">
          <Card className="border-l-4 border-l-blue-600">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 font-mono">
                  Supervised CSEs
                </span>
                <Building2 className="w-4 h-4 text-blue-600" />
              </div>
              {isCsesLoading ? (
                <Skeleton className="h-8 w-16 mt-2" />
              ) : (
                <div className="text-2xl font-bold text-slate-900 mt-1 font-mono">{totalCses}</div>
              )}
              <span className="text-[11px] text-slate-500 font-mono mt-0.5 block">Registered Entities</span>
            </CardContent>
          </Card>

          <Card className="border-l-4 border-l-amber-500">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 font-mono">
                  Active Findings
                </span>
                <ShieldAlert className="w-4 h-4 text-amber-600" />
              </div>
              {isFindingsLoading ? (
                <Skeleton className="h-8 w-16 mt-2" />
              ) : (
                <div className="text-2xl font-bold text-slate-900 mt-1 font-mono">{activeFindings}</div>
              )}
              <span className="text-[11px] text-slate-500 font-mono mt-0.5 block">Persisted Rule Signals</span>
            </CardContent>
          </Card>

          <Card className="border-l-4 border-l-purple-600">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 font-mono">
                  Evidence-Backed
                </span>
                <Layers className="w-4 h-4 text-purple-600" />
              </div>
              {isFindingsLoading ? (
                <Skeleton className="h-8 w-16 mt-2" />
              ) : (
                <div className="text-2xl font-bold text-slate-900 mt-1 font-mono">{findingsList.length}</div>
              )}
              <span className="text-[11px] text-slate-500 font-mono mt-0.5 block">With Telemetry Audit</span>
            </CardContent>
          </Card>

          <Card className="border-l-4 border-l-indigo-600">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 font-mono">
                  Under Review
                </span>
                <Eye className="w-4 h-4 text-indigo-600" />
              </div>
              {isFindingsLoading ? (
                <Skeleton className="h-8 w-16 mt-2" />
              ) : (
                <div className="text-2xl font-bold text-slate-900 mt-1 font-mono">{underReviewCount + confirmedCount}</div>
              )}
              <span className="text-[11px] text-slate-500 font-mono mt-0.5 block">Examiner Workflows</span>
            </CardContent>
          </Card>
        </div>

        {/* SECTION 2 — HIDDEN SUPERVISORY SIGNALS (4 VISUALLY DISTINCT CARDS) */}
        <div>
          <div className="mb-3">
            <h2 className="text-base font-bold text-slate-900 tracking-tight">Hidden Supervisory Signal Categories</h2>
            <p className="text-xs text-slate-500">Canonical rule execution categories converting operational telemetry into explainable supervisory flags.</p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {/* Card 1: Execution Gaps */}
            <div className="bg-amber-500/10 border border-amber-500/30 rounded-xl p-4 flex flex-col justify-between hover:border-amber-500/60 transition shadow-xs">
              <div>
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold uppercase tracking-wider text-amber-900 font-mono">EXECUTION GAPS</span>
                  <span className="px-2 py-0.5 rounded bg-amber-200 text-amber-900 text-[10px] font-mono font-bold">EG-01 to EG-04</span>
                </div>
                <h3 className="text-sm font-bold text-slate-900 mt-2">Procedural & Role Clearances</h3>
                <p className="text-xs text-slate-700 mt-1 leading-relaxed">
                  Identifies uninvestigated alerts (EG-01), unescalated critical alerts (EG-02), rapid case closures (EG-03), and repeated investigation patterns (EG-04).
                </p>
              </div>
              <div className="mt-4 pt-3 border-t border-amber-500/20 flex items-center justify-between">
                <span className="text-xs font-mono font-bold text-amber-900">Canonical Analytics</span>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-xs text-amber-900 hover:text-amber-950 p-0 h-auto font-mono flex items-center gap-1"
                  onClick={() => navigate('/findings')}
                >
                  View Signals <ArrowRight className="w-3 h-3" />
                </Button>
              </div>
            </div>

            {/* Card 2: Negative Space */}
            <div className="bg-purple-500/10 border border-purple-500/30 rounded-xl p-4 flex flex-col justify-between hover:border-purple-500/60 transition shadow-xs">
              <div>
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold uppercase tracking-wider text-purple-900 font-mono">NEGATIVE SPACE</span>
                  <span className="px-2 py-0.5 rounded bg-purple-200 text-purple-900 text-[10px] font-mono font-bold">NS-01, NS-02</span>
                </div>
                <h3 className="text-sm font-bold text-slate-900 mt-2">Coverage & Telemetry Gaps</h3>
                <p className="text-xs text-slate-700 mt-1 leading-relaxed">
                  Identifies critical-asset monitoring gaps (NS-01) and evaluates configured telemetry-coverage expectations (NS-02).
                </p>
              </div>
              <div className="mt-4 pt-3 border-t border-purple-500/20 flex items-center justify-between">
                <span className="text-xs font-mono font-bold text-purple-900">Canonical Analytics</span>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-xs text-purple-900 hover:text-purple-950 p-0 h-auto font-mono flex items-center gap-1"
                  onClick={() => navigate('/findings')}
                >
                  View Signals <ArrowRight className="w-3 h-3" />
                </Button>
              </div>
            </div>

            {/* Card 3: Anomalies */}
            <div className="bg-red-500/10 border border-red-500/30 rounded-xl p-4 flex flex-col justify-between hover:border-red-500/60 transition shadow-xs">
              <div>
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold uppercase tracking-wider text-red-900 font-mono">ANOMALIES</span>
                  <span className="px-2 py-0.5 rounded bg-red-200 text-red-900 text-[10px] font-mono font-bold">AN-01</span>
                </div>
                <h3 className="text-sm font-bold text-slate-900 mt-2">Statistical Deviations</h3>
                <p className="text-xs text-slate-700 mt-1 leading-relaxed">
                  Identifies daily alert-volume anomalies (AN-01) using robust MAD-based statistical analysis.
                </p>
              </div>
              <div className="mt-4 pt-3 border-t border-red-500/20 flex items-center justify-between">
                <span className="text-xs font-mono font-bold text-red-900">Canonical Analytics</span>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-xs text-red-900 hover:text-red-950 p-0 h-auto font-mono flex items-center gap-1"
                  onClick={() => navigate('/findings')}
                >
                  View Signals <ArrowRight className="w-3 h-3" />
                </Button>
              </div>
            </div>

            {/* Card 4: Peer Deviations */}
            <div className="bg-blue-500/10 border border-blue-500/30 rounded-xl p-4 flex flex-col justify-between hover:border-blue-500/60 transition shadow-xs">
              <div>
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold uppercase tracking-wider text-blue-900 font-mono">PEER DEVIATIONS</span>
                  <span className="px-2 py-0.5 rounded bg-blue-200 text-blue-900 text-[10px] font-mono font-bold">BM-01</span>
                </div>
                <h3 className="text-sm font-bold text-slate-900 mt-2">Comparative Baseline Outliers</h3>
                <p className="text-xs text-slate-700 mt-1 leading-relaxed">
                  Evaluates target CSE alert investigation rates against peer groups excluding the target entity to surface comparative outliers.
                </p>
              </div>
              <div className="mt-4 pt-3 border-t border-blue-500/20 flex items-center justify-between">
                <span className="text-xs font-mono font-bold text-blue-900">Canonical Analytics</span>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-xs text-blue-900 hover:text-blue-950 p-0 h-auto font-mono flex items-center gap-1"
                  onClick={() => navigate('/findings')}
                >
                  View Signals <ArrowRight className="w-3 h-3" />
                </Button>
              </div>
            </div>
          </div>
        </div>

        {/* SECTION 4 — FLAG -> EVIDENCE WORKFLOW VISUALIZER */}
        <Card className="bg-slate-900 text-white border-slate-800 shadow-xl">
          <CardContent className="p-5">
            <div className="flex items-center justify-between mb-4 border-b border-slate-800 pb-3">
              <div className="flex items-center gap-2">
                <Activity className="w-5 h-5 text-blue-400" />
                <h3 className="text-base font-bold text-white tracking-tight">Supervisory Signal-to-Review Workflow</h3>
              </div>
              <span className="text-xs font-mono text-slate-400">Canonical Architecture</span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-5 gap-3 text-center">
              <div className="bg-slate-800/80 p-3 rounded-lg border border-slate-700/80">
                <span className="text-[10px] font-mono uppercase text-blue-400 font-bold block">1. SIGNAL FLAG</span>
                <span className="text-xs font-bold text-white block mt-1">Rule Triggered</span>
                <span className="text-[10px] text-slate-400 block mt-0.5">Persisted Finding</span>
              </div>
              <div className="bg-slate-800/80 p-3 rounded-lg border border-slate-700/80">
                <span className="text-[10px] font-mono uppercase text-amber-400 font-bold block">2. WHY (RELEVANCE)</span>
                <span className="text-xs font-bold text-white block mt-1">Supervisory Context</span>
                <span className="text-[10px] text-slate-400 block mt-0.5">Risk & Impact</span>
              </div>
              <div className="bg-slate-800/80 p-3 rounded-lg border border-slate-700/80">
                <span className="text-[10px] font-mono uppercase text-purple-400 font-bold block">3. EVIDENCE MATRIX</span>
                <span className="text-xs font-bold text-white block mt-1">Audit Log Correlation</span>
                <span className="text-[10px] text-slate-400 block mt-0.5">Zero-Evidence Preserved</span>
              </div>
              <div className="bg-slate-800/80 p-3 rounded-lg border border-slate-700/80">
                <span className="text-[10px] font-mono uppercase text-emerald-400 font-bold block">4. RELATED RECORD</span>
                <span className="text-xs font-bold text-white block mt-1">Telemetry Drilldown</span>
                <span className="text-[10px] text-slate-400 block mt-0.5">User/Case Details</span>
              </div>
              <div className="bg-slate-800/80 p-3 rounded-lg border border-slate-700/80">
                <span className="text-[10px] font-mono uppercase text-indigo-400 font-bold block">5. HUMAN REVIEW</span>
                <span className="text-xs font-bold text-white block mt-1">Examiner Decision</span>
                <span className="text-[10px] text-slate-400 block mt-0.5">6 Formal Statuses</span>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* SECTION 3 — SUPERVISORY ATTENTION QUEUE */}
        <div>
          <SupervisoryAttentionQueue />
        </div>

        {/* SECTION 5 — CAPABILITY VIEW (8 DIMENSIONS) */}
        <Card>
          <CardHeader className="border-b border-slate-100 pb-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Shield className="w-5 h-5 text-blue-700" />
                <div>
                  <CardTitle>Eight Canonical Capability Dimensions</CardTitle>
                  <CardDescription className="text-xs">
                    Supervisory framework categorizing direct telemetry signals and indirect organizational evidence.
                  </CardDescription>
                </div>
              </div>
              <Badge variant="outline" size="sm" className="font-mono text-xs">
                8 Dimensions
              </Badge>
            </div>
          </CardHeader>
          <CardContent className="p-4">
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
              {CAPABILITY_DIMENSIONS.map((cap) => (
                <div key={cap.name} className="p-3 bg-slate-50 border border-slate-200 rounded-lg text-xs font-sans">
                  <div className="font-bold text-slate-900">{cap.name}</div>
                  <div className="flex items-center justify-between mt-2 pt-2 border-t border-slate-200">
                    <span className="text-[10px] font-mono font-semibold text-slate-500 uppercase">{cap.category}</span>
                    <span className={`text-[10px] font-mono font-bold px-1.5 py-0.2 rounded ${
                      cap.evidenceType === 'Direct Signals' ? 'bg-blue-100 text-blue-800' : 'bg-slate-200 text-slate-700'
                    }`}>
                      {cap.evidenceType}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* SECTION 6 — RECENT / ACTIVE SIGNALS */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-3">
            <div>
              <CardTitle>Recent Persisted Supervisory Signals</CardTitle>
              <CardDescription>Real-time telemetry findings fetched from GET /api/v1/findings/</CardDescription>
            </div>
            <Button
              variant="outline"
              size="sm"
              icon={<ArrowRight className="w-3.5 h-3.5" />}
              onClick={() => navigate('/findings')}
            >
              View All Findings
            </Button>
          </CardHeader>
          <CardContent className="p-0">
            {isFindingsLoading ? (
              <div className="p-4 space-y-2">
                <Skeleton className="h-10 w-full" />
                <Skeleton className="h-10 w-full" />
              </div>
            ) : findingsList.length === 0 ? (
              <div className="p-6 text-center text-xs text-slate-500 font-mono">
                No active supervisory findings logged in national repository.
              </div>
            ) : (
              <div className="divide-y divide-slate-100">
                {findingsList.map((finding) => {
                  const evidenceStrength =
                    finding.evidence_count > 5
                      ? 'Strong'
                      : finding.evidence_count > 0
                      ? 'Moderate'
                      : 'Limited';

                  return (
                    <div
                      key={finding.id}
                      onClick={() => navigate(`/findings/${finding.id}`)}
                      className="p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3 hover:bg-slate-50 cursor-pointer transition"
                    >
                      <div className="space-y-1">
                        <div className="flex items-center gap-2">
                          <span className="font-mono text-xs font-bold text-blue-700">{finding.finding_code}</span>
                          <Badge variant="outline" size="sm" className="font-mono text-[10px]">
                            {finding.category}
                          </Badge>
                          <SeverityBadge severity={finding.severity} size="sm" />
                        </div>
                        <h4 className="text-xs font-bold text-slate-900">{finding.title}</h4>
                      </div>

                      <div className="flex items-center gap-4 text-xs">
                        <div className="flex items-center gap-1 font-mono">
                          <span className="text-[10px] text-slate-500 uppercase">Evidence:</span>
                          <span className={`px-1.5 py-0.2 rounded font-bold text-[10px] ${
                            evidenceStrength === 'Strong' ? 'bg-emerald-100 text-emerald-800' :
                            evidenceStrength === 'Moderate' ? 'bg-amber-100 text-amber-800' : 'bg-slate-100 text-slate-600'
                          }`}>
                            {evidenceStrength} ({finding.evidence_count})
                          </span>
                        </div>
                        <StatusBadge status={finding.status} />
                        <Button variant="ghost" size="sm" icon={<ArrowRight className="w-3.5 h-3.5" />}>
                          Detail
                        </Button>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </PageContainer>
  );
};

export default SupervisoryOverviewPage;
