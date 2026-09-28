import React from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import { Search } from 'lucide-react';

export const CSEFindingsPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${cse_id || ''}`, href: `/cses/${cse_id}` },
          { label: 'Findings Registry' },
        ]}
        title="Entity Supervisory Findings"
        description="Filterable findings detected for the target critical sector entity."
      />

      <Card>
        <CardHeader>
          <CardTitle>Entity Findings Data Grid</CardTitle>
          <CardDescription>
            Target Endpoint: GET /api/v1/findings/?cse_id={cse_id}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <EmptyState
            icon={<Search className="w-8 h-8 text-blue-600" />}
            title="Entity Findings Registry Shell"
            description="In Phase 6, paginated supervisory findings for this entity will be retrieved from GET /api/v1/findings/."
          />
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default CSEFindingsPage;
