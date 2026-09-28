import React from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import { BarChart3 } from 'lucide-react';

export const PeerBenchmarksPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${cse_id || ''}`, href: `/cses/${cse_id}` },
          { label: 'Peer Benchmarks' },
        ]}
        title="Peer Group & Sector Benchmarking Inspector"
        description="Compare entity operational performance against sector baseline distributions and population averages."
      />

      <Card>
        <CardHeader>
          <CardTitle>Sector Peer Group Baselines</CardTitle>
          <CardDescription>
            Target Endpoint: GET /api/v1/benchmarks/{cse_id}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <EmptyState
            icon={<BarChart3 className="w-8 h-8 text-blue-600" />}
            title="Peer Benchmarks Shell Active"
            description={`Route bound to CSE ID: ${cse_id}. In Phase 7, sector baseline metrics (Mean, StdDev, Sample Size) will be populated from GET /api/v1/benchmarks/${cse_id}.`}
          />
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default PeerBenchmarksPage;
