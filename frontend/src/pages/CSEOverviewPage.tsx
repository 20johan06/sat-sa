import React from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import { LayoutDashboard } from 'lucide-react';

export const CSEOverviewPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${cse_id || ''}` },
          { label: 'Overview' },
        ]}
        title="Entity Telemetry & Supervisory Summary"
        description="Aggregated operational telemetry counts and active findings summary for the target entity."
      />

      <Card>
        <CardHeader>
          <CardTitle>Telemetry & Active Findings Panel</CardTitle>
          <CardDescription>
            Target Endpoint: GET /api/v1/cses/{cse_id}/summary
          </CardDescription>
        </CardHeader>
        <CardContent>
          <EmptyState
            icon={<LayoutDashboard className="w-8 h-8 text-blue-600" />}
            title="CSE Overview Shell Active"
            description={`Route bound to CSE ID: ${cse_id}. Telemetry counts and findings summary will be connected to GET /api/v1/cses/${cse_id}/summary in Phase 4.`}
          />
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default CSEOverviewPage;
