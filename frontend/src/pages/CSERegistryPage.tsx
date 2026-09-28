import React from 'react';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import Button from '../components/ui/Button';
import Input from '../components/ui/Input';
import Select from '../components/ui/Select';
import { Building2, Search, Plus, Filter } from 'lucide-react';

export const CSERegistryPage: React.FC = () => {
  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[{ label: 'Directory' }, { label: 'CSE Registry' }]}
        title="Critical Sector Entity Directory"
        description="National registry of supervised critical sector entities under SOC operational effectiveness monitoring."
        actions={
          <Button icon={<Plus className="w-4 h-4" />}>
            Register Entity
          </Button>
        }
      />

      {/* Filter Shell */}
      <Card className="mb-6">
        <CardContent className="p-4 flex flex-col sm:flex-row gap-3">
          <Input
            placeholder="Search by entity code or name..."
            startIcon={<Search className="w-4 h-4 text-slate-400" />}
          />
          <div className="flex gap-3 sm:w-72">
            <Select
              options={[
                { value: '', label: 'All Sectors' },
                { value: 'FINANCIAL', label: 'Financial Services' },
                { value: 'ENERGY', label: 'Energy Sector' },
                { value: 'TELECOM', label: 'Telecommunications' },
              ]}
            />
            <Button variant="outline" icon={<Filter className="w-4 h-4" />}>
              Filters
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Placeholder Data Container (No Mock Data) */}
      <Card>
        <CardHeader>
          <CardTitle>Supervised Entities</CardTitle>
          <CardDescription>
            Entities registered in backend PostgreSQL database via GET /api/v1/cses/.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <EmptyState
            icon={<Building2 className="w-8 h-8 text-blue-600" />}
            title="CSE Directory Ready for API Integration"
            description="Phase 2 Application Shell initialized. In Phase 4, real entity records will be populated from GET /api/v1/cses/ without mock data."
          />
        </CardContent>
      </Card>
    </PageContainer>
  );
};

export default CSERegistryPage;
