import React from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import { FileSearch } from 'lucide-react';

export const FindingDetailPage: React.FC = () => {
  const { finding_id } = useParams<{ finding_id: string }>();

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'National Findings', href: '/findings' },
          { label: `Finding ${finding_id || ''}` },
          { label: 'Evidence Drill-Down' },
        ]}
        title="Supervisory Finding & Operational Evidence Detail"
        description="Detailed breakdown of finding code, detection method, rationale, metrics JSON, and traceable telemetry links."
      />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 flex flex-col gap-6">
          <Card>
            <CardHeader>
              <CardTitle>Finding Rationale & Detection Breakdown</CardTitle>
              <CardDescription>Target Endpoint: GET /api/v1/findings/{finding_id}</CardDescription>
            </CardHeader>
            <CardContent>
              <EmptyState
                icon={<FileSearch className="w-8 h-8 text-blue-600" />}
                title="Finding Detail Shell"
                description={`Route bound to Finding ID: ${finding_id}. Full finding detail, rationale, and detection method will be connected in Phase 6.`}
              />
            </CardContent>
          </Card>
        </div>

        <div>
          <Card>
            <CardHeader>
              <CardTitle>Traceable Evidence Links</CardTitle>
              <CardDescription>FindingEvidence records linking to raw telemetry</CardDescription>
            </CardHeader>
            <CardContent>
              <EmptyState
                icon={<FileSearch className="w-6 h-6 text-slate-400" />}
                title="Evidence Table Shell"
                description="Will render linked Alerts, Cases, Investigations, Escalations, and Coverages."
              />
            </CardContent>
          </Card>
        </div>
      </div>
    </PageContainer>
  );
};

export default FindingDetailPage;
