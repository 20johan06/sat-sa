import React from 'react';
import { NavLink, Outlet, useParams } from 'react-router-dom';
import {
  LayoutDashboard,
  Activity,
  Search,
  BarChart3,
  FileText,
  UploadCloud,
  Building2,
} from 'lucide-react';
import PageContainer from '../components/layout/PageContainer';
import Badge from '../components/ui/Badge';
import StatusBadge from '../components/ui/StatusBadge';
import { useCseQuery } from '../hooks/api/useCses';

export const CSEContextLayout: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const activeCseId = cse_id || '';

  const { data: cse } = useCseQuery(activeCseId);

  const secondaryNavTabs = [
    { label: 'Overview', path: `/cses/${activeCseId}`, end: true, icon: <LayoutDashboard className="w-4 h-4" /> },
    { label: 'Analytics Console', path: `/cses/${activeCseId}/analytics`, end: false, icon: <Activity className="w-4 h-4" /> },
    { label: 'Findings Registry', path: `/cses/${activeCseId}/findings`, end: false, icon: <Search className="w-4 h-4" /> },
    { label: 'Peer Benchmarks', path: `/cses/${activeCseId}/benchmarks`, end: false, icon: <BarChart3 className="w-4 h-4" /> },
    { label: 'Executive Reports', path: `/cses/${activeCseId}/reports`, end: false, icon: <FileText className="w-4 h-4" /> },
    { label: 'Data Ingestion', path: `/cses/${activeCseId}/ingestion`, end: false, icon: <UploadCloud className="w-4 h-4" /> },
  ];

  return (
    <div className="flex flex-col flex-1">
      {/* Contextual CSE Header Bar */}
      <div className="border-b border-slate-200 bg-white shadow-xs">
        <PageContainer className="py-4">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              <div className="p-2.5 rounded-md bg-blue-50 border border-blue-200 text-blue-700">
                <Building2 className="w-5 h-5" />
              </div>
              <div>
                <div className="flex flex-wrap items-center gap-2 mb-0.5">
                  <span className="text-xs text-slate-500 font-mono">Entity Supervision Context</span>
                  {cse && (
                    <>
                      <Badge variant="outline" size="sm">
                        {cse.sector}
                      </Badge>
                      <Badge variant={cse.criticality_tier === 'TIER_1' ? 'warning' : 'info'} size="sm">
                        {cse.criticality_tier}
                      </Badge>
                      <StatusBadge status={cse.is_active ? 'ACTIVE' : 'INACTIVE'} />
                    </>
                  )}
                </div>
                <h2 className="text-lg font-bold text-slate-900 tracking-tight">
                  {cse ? `${cse.name} (${cse.cse_code})` : 'Critical Sector Entity Supervision'}
                </h2>
              </div>
            </div>

            <div className="text-xs text-slate-600 font-mono bg-slate-50 px-3 py-1.5 rounded-md border border-slate-200 self-start md:self-auto flex items-center gap-2">
              <span>CSE ID:</span>
              <span className="font-semibold text-slate-800 select-all">{activeCseId}</span>
            </div>
          </div>

          {/* Secondary Tabs Navigation */}
          <nav aria-label="Entity Context Navigation" className="flex space-x-1 mt-5 border-b border-slate-200 overflow-x-auto">
            {secondaryNavTabs.map((tab) => (
              <NavLink
                key={tab.path}
                to={tab.path}
                end={tab.end}
                className={({ isActive }) => `
                  flex items-center gap-2 px-3.5 py-2.5 text-xs font-semibold border-b-2 transition-colors whitespace-nowrap
                  ${isActive
                    ? 'border-blue-600 text-blue-600 bg-blue-50/50'
                    : 'border-transparent text-slate-600 hover:text-slate-900 hover:border-slate-300'
                  }
                `}
              >
                {tab.icon}
                <span>{tab.label}</span>
              </NavLink>
            ))}
          </nav>
        </PageContainer>
      </div>

      {/* Child Route Outlet */}
      <div className="flex-1">
        <Outlet />
      </div>
    </div>
  );
};

export default CSEContextLayout;
