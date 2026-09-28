import { describe, it, expect } from 'vitest';
import { queryKeys } from '../../utils/queryKeys';

describe('Query Key Factories Infrastructure', () => {
  it('generates consistent Health query keys', () => {
    expect(queryKeys.health.all).toEqual(['health']);
  });

  it('generates consistent CSE query keys', () => {
    expect(queryKeys.cses.all).toEqual(['cses']);
    expect(queryKeys.cses.list({ sector: 'ENERGY' })).toEqual(['cses', 'list', { sector: 'ENERGY' }]);
    expect(queryKeys.cses.detail('cse-123')).toEqual(['cses', 'detail', 'cse-123']);
    expect(queryKeys.cses.summary('cse-123')).toEqual(['cses', 'summary', 'cse-123']);
  });

  it('generates consistent Findings query keys', () => {
    expect(queryKeys.findings.all).toEqual(['findings']);
    expect(queryKeys.findings.list({ severity: 'CRITICAL' })).toEqual(['findings', 'list', { severity: 'CRITICAL' }]);
    expect(queryKeys.findings.detail('find-456')).toEqual(['findings', 'detail', 'find-456']);
  });

  it('generates consistent Analytics query keys', () => {
    expect(queryKeys.analytics.all).toEqual(['analytics']);
    expect(queryKeys.analytics.signals('cse-123', { obs_start: '2026-01-01' })).toEqual([
      'analytics',
      'signals',
      'cse-123',
      { obs_start: '2026-01-01' },
    ]);
  });

  it('generates consistent Benchmark query keys', () => {
    expect(queryKeys.benchmarks.all).toEqual(['benchmarks']);
    expect(queryKeys.benchmarks.detail('cse-123', { obs_start: '2026-01-01' })).toEqual([
      'benchmarks',
      'detail',
      'cse-123',
      { obs_start: '2026-01-01' },
    ]);
  });

  it('generates consistent Report query keys', () => {
    expect(queryKeys.reports.all).toEqual(['reports']);
    expect(queryKeys.reports.json('cse-789')).toEqual(['reports', 'json', 'cse-789', {}]);
    expect(queryKeys.reports.markdown('cse-789')).toEqual(['reports', 'markdown', 'cse-789', {}]);
  });

  it('generates consistent Ingestion query keys', () => {
    expect(queryKeys.ingestion.all).toEqual(['ingestion']);
    expect(queryKeys.ingestion.batches()).toEqual(['ingestion', 'batches', {}]);
    expect(queryKeys.ingestion.batchDetail('batch-999')).toEqual(['ingestion', 'batch', 'batch-999']);
  });
});
