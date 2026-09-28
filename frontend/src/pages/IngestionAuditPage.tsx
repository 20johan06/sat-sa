import React from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import Button from '../components/ui/Button';
import { UploadCloud, FileSpreadsheet } from 'lucide-react';

export const IngestionAuditPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${cse_id || ''}`, href: `/cses/${cse_id}` },
          { label: 'Data Ingestion' },
        ]}
        title="Telemetry Ingestion & Batch Provenance Audit"
        description="Upload CSV/JSON operational datasets and audit data batch ingestion provenance records."
        actions={
          <Button icon={<UploadCloud className="w-4 h-4" />}>
            Upload Dataset File
          </Button>
        }
      />

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Dataset Uploader</CardTitle>
            <CardDescription>Target Endpoints: POST /api/v1/ingestion/upload and /json</CardDescription>
          </CardHeader>
          <CardContent>
            <EmptyState
              icon={<FileSpreadsheet className="w-8 h-8 text-blue-600" />}
              title="Dataset Dropzone Shell"
              description="In Phase 8, operational CSV/JSON datasets (alerts, cases, investigations, escalations, coverages) will be uploaded here."
            />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Batch Provenance Audit Log</CardTitle>
            <CardDescription>Target Endpoint: GET /api/v1/ingestion/batches</CardDescription>
          </CardHeader>
          <CardContent>
            <EmptyState
              icon={<UploadCloud className="w-8 h-8 text-blue-600" />}
              title="Batch Provenance Log Shell"
              description="Will render ingestion batch history, record validation stats, and imported timestamps."
            />
          </CardContent>
        </Card>
      </div>
    </PageContainer>
  );
};

export default IngestionAuditPage;
