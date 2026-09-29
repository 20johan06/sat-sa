import React, { useState } from 'react';
import { useParams } from 'react-router-dom';
import PageContainer from '../components/layout/PageContainer';
import PageHeader from '../components/layout/PageHeader';
import Card, { CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/Card';
import Button from '../components/ui/Button';
import Select from '../components/ui/Select';
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from '../components/ui/Table';
import EmptyState from '../components/ui/EmptyState';
import ErrorState from '../components/ui/ErrorState';
import Skeleton from '../components/ui/Skeleton';
import Modal from '../components/ui/Modal';
import Badge from '../components/ui/Badge';
import Alert from '../components/ui/Alert';
import {
  useIngestionBatchesQuery,
  useIngestionBatchDetailQuery,
  useUploadIngestionMutation,
  useJsonIngestionMutation,
} from '../hooks/api/useIngestionBatches';
import type { DatasetType, IngestionBatchResponse } from '../types/api/ingestion';
import {
  UploadCloud,
  FileSpreadsheet,
  FileCode,
  CheckCircle2,
  AlertCircle,
  Clock,
  RefreshCw,
  Eye,
  FileText,
  Database,
  ArrowLeft,
  ArrowRight,
} from 'lucide-react';

const DATASET_TYPE_OPTIONS: { value: DatasetType; label: string; description: string }[] = [
  {
    value: 'alerts',
    label: 'Security Alerts (alerts)',
    description: 'Operational security event alerts and triage metadata',
  },
  {
    value: 'cases',
    label: 'Incident Cases (cases)',
    description: 'Security incident case tracking and severity records',
  },
  {
    value: 'investigations',
    label: 'Investigative Actions (investigations)',
    description: 'Analyst investigation logs, evidence counts, and notes',
  },
  {
    value: 'escalations',
    label: 'Critical Escalations (escalations)',
    description: 'Case escalation records and supervisory response levels',
  },
  {
    value: 'monitoring_coverages',
    label: 'Monitoring Coverages (monitoring_coverages)',
    description: 'Log source category coverage indicators and timestamps',
  },
];

const MAX_FILE_SIZE_BYTES = 52_428_800; // 50 MB

export const IngestionAuditPage: React.FC = () => {
  const { cse_id } = useParams<{ cse_id: string }>();
  const activeCseId = cse_id || '';

  // Ingestion Workspace State
  const [datasetType, setDatasetType] = useState<DatasetType>('alerts');
  const [ingestionMode, setIngestionMode] = useState<'file' | 'json'>('file');
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [jsonText, setJsonText] = useState<string>('');
  const [clientValidationError, setClientValidationError] = useState<string | null>(null);
  const [lastSubmittedBatch, setLastSubmittedBatch] = useState<IngestionBatchResponse | null>(null);

  // Pagination & Batch Detail Modal State
  const [page, setPage] = useState<number>(1);
  const limit = 10;
  const skip = (page - 1) * limit;

  const [selectedBatchId, setSelectedBatchId] = useState<string | null>(null);

  // API Hooks
  const {
    data: batchListData,
    isLoading: isBatchesLoading,
    isError: isBatchesError,
    error: batchesError,
    refetch: refetchBatches,
  } = useIngestionBatchesQuery({ cse_id: activeCseId, skip, limit });

  const {
    data: batchDetailData,
    isLoading: isDetailLoading,
    isError: isDetailError,
    error: detailError,
  } = useIngestionBatchDetailQuery(selectedBatchId || '');

  const uploadMutation = useUploadIngestionMutation();
  const jsonMutation = useJsonIngestionMutation();

  const isSubmitting = uploadMutation.isPending || jsonMutation.isPending;

  // File Selector Handler
  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setClientValidationError(null);
    setLastSubmittedBatch(null);

    const file = e.target.files?.[0];
    if (!file) {
      setSelectedFile(null);
      return;
    }

    const ext = file.name.split('.').pop()?.toLowerCase();
    if (ext !== 'csv' && ext !== 'json') {
      setClientValidationError(`Unsupported file extension '.${ext}'. Allowed file formats: .csv, .json.`);
      setSelectedFile(null);
      return;
    }

    if (file.size > MAX_FILE_SIZE_BYTES) {
      setClientValidationError(
        `File size (${(file.size / (1024 * 1024)).toFixed(2)} MB) exceeds maximum allowed size limit of 50 MB.`
      );
      setSelectedFile(null);
      return;
    }

    setSelectedFile(file);
  };

  // Submission Handlers
  const handleFileUploadSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setClientValidationError(null);
    setLastSubmittedBatch(null);

    if (!activeCseId) {
      setClientValidationError('Target CSE ID is missing from active context.');
      return;
    }

    if (!selectedFile) {
      setClientValidationError('Please select a valid CSV or JSON file to upload.');
      return;
    }

    try {
      const result = await uploadMutation.mutateAsync({
        cseId: activeCseId,
        datasetType,
        file: selectedFile,
      });
      setLastSubmittedBatch(result);
      setSelectedFile(null);
    } catch {
      // Error handled by mutation hook state
    }
  };

  const handleJsonSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setClientValidationError(null);
    setLastSubmittedBatch(null);

    if (!activeCseId) {
      setClientValidationError('Target CSE ID is missing from active context.');
      return;
    }

    if (!jsonText.trim()) {
      setClientValidationError('Please enter a structured JSON records array payload.');
      return;
    }

    let parsedRecords: unknown;
    try {
      parsedRecords = JSON.parse(jsonText);
    } catch {
      setClientValidationError('Invalid JSON format. Please ensure the payload is valid JSON.');
      return;
    }

    if (!Array.isArray(parsedRecords)) {
      setClientValidationError('JSON payload must be a JSON array of record objects.');
      return;
    }

    if (parsedRecords.length === 0) {
      setClientValidationError('JSON payload array must contain at least one record object.');
      return;
    }

    try {
      const result = await jsonMutation.mutateAsync({
        cse_id: activeCseId,
        dataset_type: datasetType,
        records: parsedRecords as Record<string, unknown>[],
      });
      setLastSubmittedBatch(result);
      setJsonText('');
    } catch {
      // Error handled by mutation hook state
    }
  };

  const activeSubmissionError =
    uploadMutation.error || jsonMutation.error
      ? (uploadMutation.error as Error)?.message || (jsonMutation.error as Error)?.message || 'Ingestion request failed.'
      : null;

  const totalBatches = batchListData?.total || 0;
  const totalPages = Math.ceil(totalBatches / limit) || 1;

  const renderStatusBadge = (status: string) => {
    const norm = (status || '').toUpperCase();
    if (norm === 'COMPLETED') {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-mono font-medium bg-emerald-50 text-emerald-800 border border-emerald-200">
          <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
          COMPLETED
        </span>
      );
    } else if (norm === 'FAILED') {
      return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-mono font-medium bg-rose-50 text-rose-800 border border-rose-200">
          <AlertCircle className="w-3.5 h-3.5 text-rose-600" />
          FAILED
        </span>
      );
    }
    return (
      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-mono font-medium bg-amber-50 text-amber-800 border border-amber-200">
        <Clock className="w-3.5 h-3.5 text-amber-600" />
        {status}
      </span>
    );
  };

  return (
    <PageContainer>
      <PageHeader
        breadcrumbs={[
          { label: 'CSE Directory', href: '/' },
          { label: `Entity ${activeCseId}`, href: `/cses/${activeCseId}` },
          { label: 'Data Ingestion' },
        ]}
        title="Telemetry Ingestion & Batch Provenance Audit"
        description="Upload CSV/JSON operational datasets and audit persisted ingestion batch provenance records."
        actions={
          <Button
            variant="outline"
            icon={<RefreshCw className="w-4 h-4" />}
            onClick={() => refetchBatches()}
            disabled={isBatchesLoading}
          >
            Refresh Provenance Log
          </Button>
        }
      />

      {/* Main Grid: Dataset Ingestion Workspace & Schema Info */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        {/* Ingestion Workspace Card */}
        <Card className="lg:col-span-2">
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle className="flex items-center gap-2">
                  <UploadCloud className="w-5 h-5 text-blue-600" />
                  Operational Dataset Ingestion Workspace
                </CardTitle>
                <CardDescription>
                  Target Endpoint: POST /api/v1/ingestion/upload or /api/v1/ingestion/json
                </CardDescription>
              </div>

              {/* Mode Selector Tabs */}
              <div className="flex bg-slate-100 p-1 rounded-md border border-slate-200">
                <button
                  type="button"
                  onClick={() => {
                    setIngestionMode('file');
                    setClientValidationError(null);
                  }}
                  className={`px-3 py-1 text-xs font-medium rounded transition-colors ${
                    ingestionMode === 'file' ? 'bg-white text-blue-700 shadow-xs' : 'text-slate-600 hover:text-slate-900'
                  }`}
                >
                  File Upload (CSV/JSON)
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setIngestionMode('json');
                    setClientValidationError(null);
                  }}
                  className={`px-3 py-1 text-xs font-medium rounded transition-colors ${
                    ingestionMode === 'json' ? 'bg-white text-blue-700 shadow-xs' : 'text-slate-600 hover:text-slate-900'
                  }`}
                >
                  Structured JSON Payload
                </button>
              </div>
            </div>
          </CardHeader>

          <CardContent className="space-y-5">
            {/* Target Dataset Type Selector */}
            <div>
              <Select
                id="dataset-type-select"
                label="Target Dataset Type"
                value={datasetType}
                onChange={(e) => setDatasetType(e.target.value as DatasetType)}
                options={DATASET_TYPE_OPTIONS.map((opt) => ({
                  value: opt.value,
                  label: opt.label,
                }))}
                helperText={DATASET_TYPE_OPTIONS.find((opt) => opt.value === datasetType)?.description}
              />
            </div>

            {/* Client-Side Validation Error Alert */}
            {clientValidationError && (
              <Alert type="warning" title="Validation Warning">
                {clientValidationError}
              </Alert>
            )}

            {/* Backend API Submission Error Alert */}
            {activeSubmissionError && (
              <Alert type="error" title="Ingestion Failed">
                {activeSubmissionError}
              </Alert>
            )}

            {/* Last Successful Ingestion Result Banner */}
            {lastSubmittedBatch && (
              <Alert type="success" title="Ingestion Completed Successfully">
                <div className="space-y-1 text-xs">
                  <div className="flex flex-wrap gap-x-4 gap-y-1 font-mono">
                    <span>
                      Batch Ref: <strong>{lastSubmittedBatch.batch_reference}</strong>
                    </span>
                    <span>
                      Source: <strong>{lastSubmittedBatch.source_type}</strong> ({lastSubmittedBatch.source_filename})
                    </span>
                  </div>
                  <div className="flex flex-wrap gap-x-4 gap-y-1">
                    <span>Total Records: <strong>{lastSubmittedBatch.total_records}</strong></span>
                    <span>Valid Records: <strong>{lastSubmittedBatch.valid_records}</strong></span>
                    <span>Rejected Records: <strong>{lastSubmittedBatch.rejected_records}</strong></span>
                    <span>Status: <strong>{lastSubmittedBatch.status}</strong></span>
                  </div>
                </div>
              </Alert>
            )}

            {/* Ingestion Mode Form 1: File Upload */}
            {ingestionMode === 'file' && (
              <form onSubmit={handleFileUploadSubmit} className="space-y-4">
                <div className="border-2 border-dashed border-slate-300 rounded-lg p-6 text-center hover:border-blue-400 transition-colors bg-slate-50/50">
                  <FileSpreadsheet className="w-10 h-10 text-slate-400 mx-auto mb-2" />
                  <p className="text-sm font-medium text-slate-800">
                    Select an operational dataset file (.csv or .json)
                  </p>
                  <p className="text-xs text-slate-500 mb-4">
                    Maximum supported file size: 50 MB (52,428,800 bytes)
                  </p>
                  <input
                    id="file-upload-input"
                    type="file"
                    accept=".csv,.json"
                    onChange={handleFileChange}
                    className="block w-full text-xs text-slate-600 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-xs file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100 cursor-pointer"
                  />
                </div>

                {selectedFile && (
                  <div className="flex items-center justify-between p-3 bg-blue-50/70 border border-blue-200 rounded-md text-xs">
                    <div className="flex items-center gap-2">
                      <FileText className="w-4 h-4 text-blue-600" />
                      <div>
                        <span className="font-semibold text-slate-900">{selectedFile.name}</span>
                        <span className="text-slate-500 ml-2">
                          ({(selectedFile.size / 1024).toFixed(1)} KB)
                        </span>
                      </div>
                    </div>
                    <Badge variant="info">{selectedFile.name.split('.').pop()?.toUpperCase()}</Badge>
                  </div>
                )}

                <div className="flex justify-end">
                  <Button
                    type="submit"
                    disabled={!selectedFile || isSubmitting}
                    icon={<UploadCloud className="w-4 h-4" />}
                  >
                    {isSubmitting ? 'Processing Ingestion...' : 'Upload & Ingest Dataset'}
                  </Button>
                </div>
              </form>
            )}

            {/* Ingestion Mode Form 2: Structured JSON Payload */}
            {ingestionMode === 'json' && (
              <form onSubmit={handleJsonSubmit} className="space-y-4">
                <div>
                  <label htmlFor="json-payload-textarea" className="block text-xs font-semibold text-slate-700 mb-1.5">
                    Structured JSON Records Array
                  </label>
                  <textarea
                    id="json-payload-textarea"
                    rows={6}
                    value={jsonText}
                    onChange={(e) => setJsonText(e.target.value)}
                    placeholder={`[\n  {\n    "external_alert_id": "ALT-1001",\n    "title": "Unusual Admin Escalation",\n    "category": "IDENTITY",\n    "severity": "HIGH",\n    "status": "OPEN",\n    "detected_at": "2026-09-28T12:00:00Z"\n  }\n]`}
                    className="w-full p-3 font-mono text-xs border border-slate-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-slate-800 bg-slate-900/5"
                  />
                  <p className="text-[11px] text-slate-500 mt-1">
                    Provide a valid JSON array of record objects matching the target dataset schema.
                  </p>
                </div>

                <div className="flex justify-end">
                  <Button
                    type="submit"
                    disabled={!jsonText.trim() || isSubmitting}
                    icon={<FileCode className="w-4 h-4" />}
                  >
                    {isSubmitting ? 'Ingesting Payload...' : 'Ingest JSON Payload'}
                  </Button>
                </div>
              </form>
            )}
          </CardContent>
        </Card>

        {/* Ingestion Guidelines & Info Card */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Database className="w-5 h-5 text-slate-600" />
              Ingestion Specifications
            </CardTitle>
            <CardDescription>Backend validation & schema contracts</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4 text-xs text-slate-700">
            <div className="p-3 bg-slate-50 rounded-md border border-slate-200 space-y-2">
              <h4 className="font-bold text-slate-900">Supported Format Rules</h4>
              <ul className="list-disc list-inside space-y-1 text-slate-600">
                <li>CSV file with header row matching dataset fields</li>
                <li>Structured JSON array file or API payload</li>
                <li>Maximum file size: 50 MB</li>
              </ul>
            </div>

            <div className="p-3 bg-slate-50 rounded-md border border-slate-200 space-y-2">
              <h4 className="font-bold text-slate-900">Validation & Provenance</h4>
              <ul className="list-disc list-inside space-y-1 text-slate-600">
                <li>Generates traceable BATCH-YYYYMMDDHHMMSS reference</li>
                <li>Validates Pydantic schema per dataset type</li>
                <li>Transactional database persistence & rollback on error</li>
                <li>Persists total, valid, and rejected record counts</li>
              </ul>
            </div>

            <div className="text-[11px] text-slate-500 font-mono bg-slate-100 p-2 rounded border border-slate-200">
              Active Entity UUID: <span className="font-bold text-slate-800 select-all">{activeCseId}</span>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Batch Provenance Audit Log Card */}
      <Card>
        <CardHeader>
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <CardTitle className="flex items-center gap-2">
                <FileText className="w-5 h-5 text-slate-700" />
                Batch Provenance Audit Registry
              </CardTitle>
              <CardDescription>
                Persisted ingestion history for target CSE ID: {activeCseId}
              </CardDescription>
            </div>
            <Badge variant="outline" size="md">
              Total Batches: {totalBatches}
            </Badge>
          </div>
        </CardHeader>

        <CardContent>
          {isBatchesLoading ? (
            <div className="space-y-3 py-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-12 w-full" />
            </div>
          ) : isBatchesError ? (
            <ErrorState
              title="Failed to Load Ingestion Batches"
              message={(batchesError as Error)?.message || 'An error occurred while fetching the batch audit log.'}
              onRetry={() => refetchBatches()}
            />
          ) : !batchListData || batchListData.items.length === 0 ? (
            <EmptyState
              icon={<FileSpreadsheet className="w-8 h-8 text-slate-400" />}
              title="No Ingestion Batches Found"
              description="No operational dataset ingestion batches have been recorded for this entity."
            />
          ) : (
            <div className="space-y-4">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Batch Reference</TableHead>
                    <TableHead>Source Type</TableHead>
                    <TableHead>Filename</TableHead>
                    <TableHead>Total Records</TableHead>
                    <TableHead>Valid Records</TableHead>
                    <TableHead>Rejected Records</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead>Imported At</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {batchListData.items.map((batch) => (
                    <TableRow key={batch.id}>
                      <TableCell className="font-mono text-xs font-semibold text-slate-900">
                        {batch.batch_reference}
                      </TableCell>
                      <TableCell>
                        <Badge variant={batch.source_type === 'CSV' ? 'info' : 'default'}>
                          {batch.source_type}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-xs text-slate-700 font-mono">
                        {batch.source_filename}
                      </TableCell>
                      <TableCell className="text-xs font-mono font-medium text-slate-900">
                        {batch.total_records}
                      </TableCell>
                      <TableCell className="text-xs font-mono text-emerald-700 font-semibold">
                        {batch.valid_records}
                      </TableCell>
                      <TableCell className="text-xs font-mono text-rose-700 font-semibold">
                        {batch.rejected_records}
                      </TableCell>
                      <TableCell>{renderStatusBadge(batch.status)}</TableCell>
                      <TableCell className="text-xs text-slate-600 font-mono whitespace-nowrap">
                        {new Date(batch.imported_at).toLocaleString()}
                      </TableCell>
                      <TableCell className="text-right">
                        <Button
                          size="sm"
                          variant="outline"
                          icon={<Eye className="w-3.5 h-3.5" />}
                          onClick={() => setSelectedBatchId(batch.id)}
                        >
                          View Provenance
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>

              {/* Server-Side Pagination Bar */}
              <div className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-4 border-t border-slate-200 text-xs text-slate-600">
                <div>
                  Showing <span className="font-semibold text-slate-900">{batchListData.items.length > 0 ? skip + 1 : 0}</span> to{' '}
                  <span className="font-semibold text-slate-900">{Math.min(skip + limit, totalBatches)}</span> of{' '}
                  <span className="font-semibold text-slate-900">{totalBatches}</span> batch provenance records
                </div>

                <div className="flex items-center gap-2">
                  <Button
                    size="sm"
                    variant="outline"
                    icon={<ArrowLeft className="w-3.5 h-3.5" />}
                    onClick={() => setPage((p) => Math.max(p - 1, 1))}
                    disabled={page <= 1}
                  >
                    Previous
                  </Button>

                  <span className="font-mono text-xs px-2 font-medium">
                    Page {page} of {totalPages}
                  </span>

                  <Button
                    size="sm"
                    variant="outline"
                    icon={<ArrowRight className="w-3.5 h-3.5" />}
                    onClick={() => setPage((p) => Math.min(p + 1, totalPages))}
                    disabled={page >= totalPages}
                  >
                    Next
                  </Button>
                </div>
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Batch Provenance Detail Modal */}
      <Modal
        isOpen={Boolean(selectedBatchId)}
        onClose={() => setSelectedBatchId(null)}
        title="Ingestion Batch Provenance Detail"
        maxWidth="lg"
      >
        {isDetailLoading ? (
          <div className="space-y-4 py-6">
            <Skeleton className="h-6 w-3/4" />
            <Skeleton className="h-20 w-full" />
            <Skeleton className="h-16 w-full" />
          </div>
        ) : isDetailError ? (
          <ErrorState
            title="Failed to Load Batch Details"
            message={(detailError as Error)?.message || 'Could not fetch batch detail.'}
          />
        ) : batchDetailData ? (
          <div className="space-y-6 text-xs">
            {/* Batch Status Header */}
            <div className="flex items-center justify-between p-4 rounded-lg bg-slate-50 border border-slate-200">
              <div>
                <span className="text-[11px] font-mono text-slate-500 uppercase tracking-wider block">Batch Reference</span>
                <span className="text-base font-bold font-mono text-slate-900">{batchDetailData.batch_reference}</span>
              </div>
              <div>{renderStatusBadge(batchDetailData.status)}</div>
            </div>

            {/* Batch Metadata Grid */}
            <div className="grid grid-cols-2 gap-4">
              <div className="p-3 bg-slate-50/50 rounded border border-slate-200 space-y-1">
                <span className="text-slate-500 font-mono block text-[10px]">BATCH ID</span>
                <span className="font-mono font-semibold text-slate-900 select-all">{batchDetailData.id}</span>
              </div>

              <div className="p-3 bg-slate-50/50 rounded border border-slate-200 space-y-1">
                <span className="text-slate-500 font-mono block text-[10px]">TARGET CSE ID</span>
                <span className="font-mono font-semibold text-slate-900 select-all">{batchDetailData.cse_id}</span>
              </div>

              <div className="p-3 bg-slate-50/50 rounded border border-slate-200 space-y-1">
                <span className="text-slate-500 font-mono block text-[10px]">SOURCE TYPE & FILENAME</span>
                <span className="font-mono font-semibold text-slate-900">
                  {batchDetailData.source_type} — {batchDetailData.source_filename}
                </span>
              </div>

              <div className="p-3 bg-slate-50/50 rounded border border-slate-200 space-y-1">
                <span className="text-slate-500 font-mono block text-[10px]">IMPORTED TIMESTAMP</span>
                <span className="font-mono font-semibold text-slate-900">
                  {new Date(batchDetailData.imported_at).toLocaleString()}
                </span>
              </div>
            </div>

            {/* Persisted Record Counts Summary */}
            <div className="p-4 rounded-lg border border-slate-200 bg-white space-y-3">
              <h4 className="font-bold text-slate-900 text-sm">Persisted Record Counts</h4>
              <div className="grid grid-cols-3 gap-4 text-center">
                <div className="p-3 rounded bg-slate-50 border border-slate-200">
                  <span className="text-[10px] text-slate-500 uppercase tracking-wider block font-mono">Total Records</span>
                  <span className="text-lg font-bold font-mono text-slate-900">{batchDetailData.total_records}</span>
                </div>

                <div className="p-3 rounded bg-emerald-50/60 border border-emerald-200">
                  <span className="text-[10px] text-emerald-700 uppercase tracking-wider block font-mono">Valid Records</span>
                  <span className="text-lg font-bold font-mono text-emerald-800">{batchDetailData.valid_records}</span>
                </div>

                <div className="p-3 rounded bg-rose-50/60 border border-rose-200">
                  <span className="text-[10px] text-rose-700 uppercase tracking-wider block font-mono">Rejected Records</span>
                  <span className="text-lg font-bold font-mono text-rose-800">{batchDetailData.rejected_records}</span>
                </div>
              </div>
            </div>

            {/* Error Diagnostics Summary (If Present) */}
            {batchDetailData.error_summary && (
              <div className="space-y-2">
                <h4 className="font-bold text-rose-900 text-xs flex items-center gap-1.5">
                  <AlertCircle className="w-4 h-4 text-rose-600" />
                  Validation / Ingestion Diagnostic Summary
                </h4>
                <div className="p-3 rounded bg-rose-50 border border-rose-200 font-mono text-xs text-rose-900 whitespace-pre-wrap overflow-x-auto max-h-48">
                  {batchDetailData.error_summary}
                </div>
              </div>
            )}
          </div>
        ) : null}
      </Modal>
    </PageContainer>
  );
};

export default IngestionAuditPage;
