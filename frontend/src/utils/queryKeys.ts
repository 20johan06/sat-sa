import type { CSEListQueryParams } from '../types/api/cse';
import type { FindingQueryParams } from '../types/api/findings';
import type { BenchmarkQueryParams } from '../types/api/benchmarks';
import type { ReportQueryParams } from '../types/api/reports';
import type { IngestionBatchQueryParams } from '../types/api/ingestion';

export const queryKeys = {
  health: {
    all: ['health'] as const,
  },
  cses: {
    all: ['cses'] as const,
    list: (params?: CSEListQueryParams) => ['cses', 'list', params || {}] as const,
    detail: (id: string) => ['cses', 'detail', id] as const,
    summary: (id: string) => ['cses', 'summary', id] as const,
  },
  analytics: {
    all: ['analytics'] as const,
    signals: (cseId: string, params?: { obs_start?: string; obs_end?: string }) =>
      ['analytics', 'signals', cseId, params || {}] as const,
  },
  findings: {
    all: ['findings'] as const,
    list: (params?: FindingQueryParams) => ['findings', 'list', params || {}] as const,
    detail: (id: string) => ['findings', 'detail', id] as const,
  },
  benchmarks: {
    all: ['benchmarks'] as const,
    detail: (cseId: string, params?: BenchmarkQueryParams) =>
      ['benchmarks', 'detail', cseId, params || {}] as const,
  },
  reports: {
    all: ['reports'] as const,
    json: (cseId: string, params?: Omit<ReportQueryParams, 'format'>) =>
      ['reports', 'json', cseId, params || {}] as const,
    markdown: (cseId: string, params?: Omit<ReportQueryParams, 'format'>) =>
      ['reports', 'markdown', cseId, params || {}] as const,
  },
  ingestion: {
    all: ['ingestion'] as const,
    batches: (params?: IngestionBatchQueryParams) =>
      ['ingestion', 'batches', params || {}] as const,
    batchDetail: (id: string) => ['ingestion', 'batch', id] as const,
  },
  assessments: {
    all: ['assessments'] as const,
    list: (cseId: string) => ['assessments', 'list', cseId] as const,
    detail: (id: string) => ['assessments', 'detail', id] as const,
  },
  capability: {
    all: ['capability'] as const,
    assessment: (cseId: string) => ['capability', 'assessment', cseId] as const,
    detail: (cseId: string, capName: string) => ['capability', 'detail', cseId, capName] as const,
  },
};

export default queryKeys;
