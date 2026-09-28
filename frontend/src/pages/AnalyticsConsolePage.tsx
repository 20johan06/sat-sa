import React from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import Button from '../components/ui/Button';
import { Activity, Play } from 'lucide-react';

export const AnalyticsConsolePage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${cse_id || ''}`, href: `/cses/${cse_id}` },
          { label: 'Analytics Console' },
        ]}
        title="Supervisory Analytics Engine Console"
        description="Configure observation periods, execute Phase 5 deterministic rules (EG-01 to BM-01), and inspect the 4-signal matrix."
        actions={
          <Button icon={<Play className="w-4 h-4" />}>
            Run Analytics Engine
          </Button>
        }
      />

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Analytics Engine Execution</CardTitle>
            <CardDescription>Target Endpoint: POST /api/v1/analytics/{cse_id}/run</CardDescription>
          </CardHeader>
          <CardContent>
            <EmptyState
              icon={<Play className="w-8 h-8 text-blue-600" />}
              title="Execution Panel Shell"
              description="In Phase 5, triggering this panel will evaluate the 8 deterministic rules against telemetry."
            />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Supervisory Signal Matrix</CardTitle>
            <CardDescription>Target Endpoint: GET /api/v1/analytics/{cse_id}/signals</CardDescription>
          </CardHeader>
          <CardContent>
            <EmptyState
              icon={<Activity className="w-8 h-8 text-blue-600" />}
              title="Signal Matrix Shell"
              description="Will render the 4 supervisory signals (Execution Gap, Negative Space, Anomaly, Benchmark) from API responses."
            />
          </CardContent>
        </Card>
      </div>
    </PageContainer>
  );
};

export default AnalyticsConsolePage;
