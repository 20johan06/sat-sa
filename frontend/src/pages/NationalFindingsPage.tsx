import React from 'react';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import Select from '../components/ui/Select';
import { Search, Filter } from 'lucide-react';
import Button from '../components/ui/Button';

export const NationalFindingsPage: React.FC = () => {
  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[{ label: 'Supervision' }, { label: 'National Findings' }]}
        title="National Supervisory Findings Registry"
        description="Search, query, filter, and paginate supervisory findings across all monitored Critical Sector Entities."
      />

      <Card className="mb-6">
        <CardContent className="p-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-3">
          <Select
            label="Category"
            options={[
              { value: '', label: 'All Categories' },
              { value: 'EXECUTION_GAP', label: 'Execution Gap' },
              { value: 'NEGATIVE_SPACE', label: 'Negative Space' },
              { value: 'ANOMALY', label: 'Statistical Anomaly' },
              { value: 'BENCHMARK', label: 'Benchmark Deviation' },
            ]}
          />
          <Select
            label="Severity"
            options={[
              { value: '', label: 'All Severities' },
              { value: 'CRITICAL', label: 'CRITICAL' },
              { value: 'HIGH', label: 'HIGH' },
              { value: 'MEDIUM', label: 'MEDIUM' },
              { value: 'LOW', label: 'LOW' },
            ]}
          />
          <Select
            label="Status"
            options={[
              { value: '', label: 'All Statuses' },
              { value: 'NEW', label: 'NEW' },
              { value: 'ACKNOWLEDGED', label: 'ACKNOWLEDGED' },
              { value: 'RESOLVED', label: 'RESOLVED' },
            ]}
          />
          <div className="flex items-end">
            <Button variant="secondary" className="w-full" icon={<Filter className="w-4 h-4" />}>
              Apply Filters
            </Button>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>National Findings Master Grid</CardTitle>
          <CardDescription>
            Target Endpoint: GET /api/v1/findings/
          </CardDescription>
        </CardHeader>
        <CardContent>
          <EmptyState
            icon={<Search className="w-8 h-8 text-blue-600" />}
            title="National Findings Registry Shell Active"
            description="In Phase 6, paginated findings across all entities will be populated from GET /api/v1/findings/ without mock data."
          />
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default NationalFindingsPage;
