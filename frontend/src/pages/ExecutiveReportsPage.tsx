import React from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import Button from '../components/ui/Button';
import { FileText, Download, Copy } from 'lucide-react';

export const ExecutiveReportsPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${cse_id || ''}`, href: `/cses/${cse_id}` },
          { label: 'Executive Reports' },
        ]}
        title="Supervisory Executive Assessment Reports"
        description="Generate and export deterministic supervisory assessment reports in Markdown or JSON format."
        actions={
          <div className="flex gap-2">
            <Button variant="outline" icon={<Copy className="w-4 h-4" />}>
              Copy Markdown
            </Button>
            <Button icon={<Download className="w-4 h-4" />}>
              Download JSON
            </Button>
          </div>
        }
      />

      <Card>
        <CardHeader>
          <CardTitle>Supervisory Report Preview Console</CardTitle>
          <CardDescription>
            Target Endpoint: GET /api/v1/reports/cse/{cse_id}?format=markdown
          </CardDescription>
        </CardHeader>
        <CardContent>
          <EmptyState
            icon={<FileText className="w-8 h-8 text-blue-600" />}
            title="Executive Report Console Shell"
            description={`Route bound to CSE ID: ${cse_id}. In Phase 7, deterministic Markdown and JSON supervisory reports will be rendered from GET /api/v1/reports/cse/${cse_id}.`}
          />
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default ExecutiveReportsPage;
