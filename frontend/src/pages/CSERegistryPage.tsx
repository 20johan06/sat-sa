import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import EmptyState from '../components/ui/EmptyState';
import ErrorState from '../components/ui/ErrorState';
import Button from '../components/ui/Button';
import Input from '../components/ui/Input';
import Select from '../components/ui/Select';
import Badge from '../components/ui/Badge';
import StatusBadge from '../components/ui/StatusBadge';
import Modal from '../components/ui/Modal';
import Skeleton from '../components/ui/Skeleton';
import Alert from '../components/ui/Alert';
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '../components/ui/Table';
import {
  Building2,
  Search,
  Plus,
  ArrowRight,
  ChevronLeft,
  ChevronRight,
  RotateCcw,
} from 'lucide-react';
import { useCsesQuery, useCreateCseMutation } from '../hooks/api/useCses';
import type { CSECreate, CSEListQueryParams } from '../types/api/cse';

const SECTOR_OPTIONS = [
  { value: '', label: 'All Sectors' },
  { value: 'ENERGY', label: 'Energy Sector' },
  { value: 'FINANCIAL', label: 'Financial Services' },
  { value: 'TELECOM', label: 'Telecommunications' },
  { value: 'DEFENSE', label: 'Defense & Security' },
  { value: 'GOVERNMENT', label: 'Government Services' },
  { value: 'HEALTHCARE', label: 'Healthcare & Public Health' },
];

const STATUS_OPTIONS = [
  { value: '', label: 'All Statuses' },
  { value: 'true', label: 'Active Only' },
  { value: 'false', label: 'Inactive Only' },
];

const TIER_OPTIONS = [
  { value: 'TIER_1', label: 'TIER 1 — National Critical' },
  { value: 'TIER_2', label: 'TIER 2 — High Priority' },
  { value: 'TIER_3', label: 'TIER 3 — Standard Priority' },
];

export const CSERegistryPage: React.FC = () => {
  const navigate = useNavigate();

  // Search, Filter & Pagination State
  const [searchInput, setSearchInput] = useState<string>('');
  const [activeSearch, setActiveSearch] = useState<string>('');
  const [selectedSector, setSelectedSector] = useState<string>('');
  const [selectedStatus, setSelectedStatus] = useState<string>('');
  const [page, setPage] = useState<number>(1);
  const pageSize = 10;

  // Registration Modal State
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [formError, setFormError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const [formData, setFormData] = useState<CSECreate>({
    cse_code: '',
    name: '',
    sector: 'ENERGY',
    criticality_tier: 'TIER_1',
    contact_email: '',
    is_active: true,
  });

  // API Query Parameters
  const queryParams: CSEListQueryParams = {
    skip: (page - 1) * pageSize,
    limit: pageSize,
    search: activeSearch || undefined,
    sector: selectedSector || undefined,
    is_active: selectedStatus === 'true' ? true : selectedStatus === 'false' ? false : undefined,
  };

  const { data: cses, isLoading, isError, error, refetch } = useCsesQuery(queryParams);
  const createMutation = useCreateCseMutation();

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setActiveSearch(searchInput.trim());
    setPage(1);
  };

  const handleClearFilters = () => {
    setSearchInput('');
    setActiveSearch('');
    setSelectedSector('');
    setSelectedStatus('');
    setPage(1);
  };

  const handleOpenModal = () => {
    setFormError(null);
    setFormData({
      cse_code: '',
      name: '',
      sector: 'ENERGY',
      criticality_tier: 'TIER_1',
      contact_email: '',
      is_active: true,
    });
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setFormError(null);
  };

  const handleFormSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setFormError(null);

    if (!formData.cse_code.trim()) {
      setFormError('Entity Code (cse_code) is required.');
      return;
    }
    if (!formData.name.trim()) {
      setFormError('Entity Name is required.');
      return;
    }
    if (!formData.sector.trim()) {
      setFormError('Sector is required.');
      return;
    }

    try {
      await createMutation.mutateAsync({
        cse_code: formData.cse_code.trim().toUpperCase(),
        name: formData.name.trim(),
        sector: formData.sector.trim().toUpperCase(),
        criticality_tier: formData.criticality_tier,
        contact_email: formData.contact_email?.trim() || null,
        is_active: formData.is_active,
      });

      setSuccessMessage(`Entity "${formData.name.trim()}" registered successfully.`);
      setIsModalOpen(false);
      setTimeout(() => setSuccessMessage(null), 5000);
    } catch (err: unknown) {
      const apiErr = err as { message?: string; details?: unknown };
      setFormError(apiErr.message || 'Failed to register Critical Sector Entity.');
    }
  };

  const isFiltered = Boolean(activeSearch || selectedSector || selectedStatus);
  const cseList = cses || [];

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[{ label: 'Directory' }, { label: 'CSE Registry' }]}
        title="Critical Sector Entity Directory"
        description="National registry of supervised critical sector entities under SOC operational effectiveness monitoring."
        actions={
          <Button icon={<Plus className="w-4 h-4" />} onClick={handleOpenModal}>
            Register Entity
          </Button>
        }
      />

      {successMessage && (
        <div className="mb-4">
          <Alert type="success" title="Registration Complete">
            {successMessage}
          </Alert>
        </div>
      )}

      {/* Filter & Search Bar */}
      <Card className="mb-6">
        <CardContent className="p-4">
          <form onSubmit={handleSearchSubmit} className="flex flex-col md:flex-row gap-3">
            <div className="flex-1">
              <Input
                value={searchInput}
                onChange={(e) => setSearchInput(e.target.value)}
                placeholder="Search by entity code or name..."
                startIcon={<Search className="w-4 h-4 text-slate-400" />}
              />
            </div>
            <div className="flex flex-col sm:flex-row gap-3 sm:w-auto">
              <div className="w-full sm:w-48">
                <Select
                  value={selectedSector}
                  onChange={(e) => {
                    setSelectedSector(e.target.value);
                    setPage(1);
                  }}
                  options={SECTOR_OPTIONS}
                />
              </div>
              <div className="w-full sm:w-40">
                <Select
                  value={selectedStatus}
                  onChange={(e) => {
                    setSelectedStatus(e.target.value);
                    setPage(1);
                  }}
                  options={STATUS_OPTIONS}
                />
              </div>
              <div className="flex gap-2">
                <Button type="submit" variant="primary">
                  Search
                </Button>
                {isFiltered && (
                  <Button
                    type="button"
                    variant="outline"
                    icon={<RotateCcw className="w-3.5 h-3.5" />}
                    onClick={handleClearFilters}
                  >
                    Reset
                  </Button>
                )}
              </div>
            </div>
          </form>
        </CardContent>
      </Card>

      {/* Main Registry Table / State Display */}
      <Card>
        <CardHeader className="flex flex-row items-center justify-between pb-3">
          <div>
            <CardTitle>Supervised Entities</CardTitle>
            <CardDescription>
              Real-time directory fetched from GET /api/v1/cses/.
            </CardDescription>
          </div>
          {cseList.length > 0 && (
            <Badge variant="outline" size="sm">
              Showing Page {page}
            </Badge>
          )}
        </CardHeader>
        <CardContent className="p-0">
          {isLoading ? (
            <div className="p-6 space-y-3">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-12 w-full" />
            </div>
          ) : isError ? (
            <div className="p-6">
              <ErrorState
                title="Failed to fetch CSE Registry"
                message={error instanceof Error ? error.message : 'Backend API connection failed.'}
                onRetry={refetch}
              />
            </div>
          ) : cseList.length === 0 ? (
            <div className="p-8">
              {isFiltered ? (
                <EmptyState
                  icon={<Search className="w-8 h-8 text-slate-400" />}
                  title="No Matching Entities Found"
                  description="No Critical Sector Entities match the current search or filter criteria."
                  action={
                    <Button variant="outline" onClick={handleClearFilters}>
                      Clear Filters
                    </Button>
                  }
                />
              ) : (
                <EmptyState
                  icon={<Building2 className="w-8 h-8 text-blue-600" />}
                  title="No Critical Sector Entities Registered"
                  description="The supervisory database currently has no registered entities. Click 'Register Entity' to add the first CSE."
                  action={
                    <Button icon={<Plus className="w-4 h-4" />} onClick={handleOpenModal}>
                      Register First Entity
                    </Button>
                  }
                />
              )}
            </div>
          ) : (
            <>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Code</TableHead>
                    <TableHead>Entity Name</TableHead>
                    <TableHead>Sector</TableHead>
                    <TableHead>Criticality</TableHead>
                    <TableHead>Contact Email</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="text-right">Action</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {cseList.map((cse) => (
                    <TableRow
                      key={cse.id}
                      className="cursor-pointer hover:bg-slate-50/90 transition-colors"
                      onClick={() => navigate(`/cses/${cse.id}`)}
                    >
                      <TableCell className="font-mono text-xs font-semibold text-slate-900">
                        {cse.cse_code}
                      </TableCell>
                      <TableCell className="font-medium text-slate-900">
                        {cse.name}
                      </TableCell>
                      <TableCell className="text-slate-600 text-xs font-mono">
                        {cse.sector}
                      </TableCell>
                      <TableCell>
                        <Badge
                          variant={cse.criticality_tier === 'TIER_1' ? 'warning' : 'info'}
                          size="sm"
                        >
                          {cse.criticality_tier}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-slate-600 text-xs font-mono">
                        {cse.contact_email || '—'}
                      </TableCell>
                      <TableCell>
                        <StatusBadge status={cse.is_active ? 'ACTIVE' : 'INACTIVE'} />
                      </TableCell>
                      <TableCell className="text-right">
                        <Button
                          variant="ghost"
                          size="sm"
                          icon={<ArrowRight className="w-3.5 h-3.5" />}
                          onClick={(e) => {
                            e.stopPropagation();
                            navigate(`/cses/${cse.id}`);
                          }}
                        >
                          Overview
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>

              {/* Pagination Bar */}
              <div className="px-5 py-3 border-t border-slate-200 flex items-center justify-between bg-slate-50/50">
                <span className="text-xs text-slate-500 font-mono">
                  Page {page} • {cseList.length} entity record(s) on page
                </span>
                <div className="flex gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={page === 1}
                    icon={<ChevronLeft className="w-4 h-4" />}
                    onClick={() => setPage((p) => Math.max(1, p - 1))}
                  >
                    Previous
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={cseList.length < pageSize}
                    icon={<ChevronRight className="w-4 h-4" />}
                    onClick={() => setPage((p) => p + 1)}
                  >
                    Next
                  </Button>
                </div>
              </div>
            </>
          )}
        </CardContent>
      </Card>

      {/* Registration Modal */}
      <Modal
        isOpen={isModalOpen}
        onClose={handleCloseModal}
        title="Register Critical Sector Entity"
        description="Add a new entity to the national supervisory database (POST /api/v1/cses/)."
        maxWidth="lg"
      >
        <form onSubmit={handleFormSubmit} className="space-y-4">
          {formError && (
            <Alert type="error" title="Registration Error">
              {formError}
            </Alert>
          )}

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                CSE Code <span className="text-red-500">*</span>
              </label>
              <Input
                value={formData.cse_code}
                onChange={(e) => setFormData({ ...formData, cse_code: e.target.value })}
                placeholder="e.g. CSE-POWER-001"
                maxLength={50}
                required
              />
              <span className="text-[10px] text-slate-500">Unique uppercase identifier (2–50 chars)</span>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Entity Name <span className="text-red-500">*</span>
              </label>
              <Input
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                placeholder="e.g. National Thermal Power Grid"
                maxLength={255}
                required
              />
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Sector <span className="text-red-500">*</span>
              </label>
              <Input
                value={formData.sector}
                onChange={(e) => setFormData({ ...formData, sector: e.target.value.toUpperCase() })}
                placeholder="e.g. ENERGY, FINANCIAL, TELECOM"
                maxLength={100}
                required
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Criticality Tier
              </label>
              <Select
                value={formData.criticality_tier}
                onChange={(e) => setFormData({ ...formData, criticality_tier: e.target.value })}
                options={TIER_OPTIONS}
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 mb-1">
              Contact Email
            </label>
            <Input
              type="email"
              value={formData.contact_email || ''}
              onChange={(e) => setFormData({ ...formData, contact_email: e.target.value })}
              placeholder="e.g. soc-lead@powergrid.gov"
              maxLength={255}
            />
          </div>

          <div className="flex items-center gap-2 pt-2">
            <input
              type="checkbox"
              id="is_active_checkbox"
              checked={formData.is_active}
              onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
              className="rounded border-slate-300 text-blue-600 focus:ring-blue-500 h-4 w-4"
            />
            <label htmlFor="is_active_checkbox" className="text-xs font-medium text-slate-700">
              Entity is Active for Supervisory Monitoring
            </label>
          </div>

          <div className="flex justify-end gap-3 pt-4 border-t border-slate-100">
            <Button type="button" variant="outline" onClick={handleCloseModal}>
              Cancel
            </Button>
            <Button
              type="submit"
              variant="primary"
              disabled={createMutation.isPending}
            >
              {createMutation.isPending ? 'Registering...' : 'Submit Registration'}
            </Button>
          </div>
        </form>
      </Modal>
    </PageContainer>
  );
};

export default CSERegistryPage;
