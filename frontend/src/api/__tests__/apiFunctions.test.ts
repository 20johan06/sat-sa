import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { apiClient } from '../client';
import { getHealth } from '../health';
import { listCSEs, getCSE } from '../cses';
import { listFindings } from '../findings';
import { getAnalyticsSignals } from '../analytics';
import { listIngestionBatches } from '../ingestion';

describe('Representative API Functions Infrastructure', () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it('invokes getHealth and returns health response', async () => {
    const mockHealth = { status: 'healthy', timestamp: '2026-09-29T00:00:00Z', version: '1.0.0' };
    const getSpy = vi.spyOn(apiClient, 'get').mockResolvedValueOnce({ data: mockHealth });

    const result = await getHealth();
    expect(getSpy).toHaveBeenCalledWith('/api/v1/health');
    expect(result).toEqual(mockHealth);
  });

  it('invokes listCSEs with search and filter parameters', async () => {
    const mockList = [
      {
        id: '11111111-1111-1111-1111-111111111111',
        cse_code: 'CSE_001',
        name: 'Test Energy Grid',
        sector: 'ENERGY',
        criticality_tier: 'TIER_1',
        contact_email: 'admin@energy.test',
        is_active: true,
        created_at: '2026-01-01T00:00:00Z',
        updated_at: '2026-01-01T00:00:00Z',
      },
    ];
    const getSpy = vi.spyOn(apiClient, 'get').mockResolvedValueOnce({ data: mockList });

    const params = { sector: 'ENERGY', search: 'Grid', skip: 0, limit: 10 };
    const result = await listCSEs(params);

    expect(getSpy).toHaveBeenCalledWith('/api/v1/cses/', { params });
    expect(result).toEqual(mockList);
  });

  it('invokes getCSE with ID', async () => {
    const mockCSE = {
      id: '11111111-1111-1111-1111-111111111111',
      cse_code: 'CSE_001',
      name: 'Test Energy Grid',
      sector: 'ENERGY',
      criticality_tier: 'TIER_1',
      contact_email: 'admin@energy.test',
      is_active: true,
      created_at: '2026-01-01T00:00:00Z',
      updated_at: '2026-01-01T00:00:00Z',
    };
    const getSpy = vi.spyOn(apiClient, 'get').mockResolvedValueOnce({ data: mockCSE });

    const result = await getCSE(mockCSE.id);
    expect(getSpy).toHaveBeenCalledWith(`/api/v1/cses/${mockCSE.id}`);
    expect(result).toEqual(mockCSE);
  });

  it('invokes listFindings with parameters', async () => {
    const mockFindings = [
      {
        id: '22222222-2222-2222-2222-222222222222',
        cse_id: '11111111-1111-1111-1111-111111111111',
        title: 'Unpatched Outdated Kernel',
        severity: 'HIGH',
        category: 'VULNERABILITY',
        status: 'OPEN',
        first_observed_at: '2026-01-01T00:00:00Z',
        last_observed_at: '2026-01-01T00:00:00Z',
      },
    ];
    const getSpy = vi.spyOn(apiClient, 'get').mockResolvedValueOnce({ data: mockFindings });

    const params = { severity: 'HIGH', status: 'OPEN' };
    const result = await listFindings(params);

    expect(getSpy).toHaveBeenCalledWith('/api/v1/findings/', { params });
    expect(result).toEqual(mockFindings);
  });

  it('invokes getAnalyticsSignals with cseId and parameters', async () => {
    const mockSignals = {
      cse_id: '11111111-1111-1111-1111-111111111111',
      signals: [],
      total_count: 0,
    };
    const getSpy = vi.spyOn(apiClient, 'get').mockResolvedValueOnce({ data: mockSignals });

    const cseId = '11111111-1111-1111-1111-111111111111';
    const params = { obs_start: '2026-01-01T00:00:00Z' };
    const result = await getAnalyticsSignals(cseId, params);

    expect(getSpy).toHaveBeenCalledWith(`/api/v1/analytics/${cseId}/signals`, { params });
    expect(result).toEqual(mockSignals);
  });

  it('invokes listIngestionBatches', async () => {
    const mockBatches = [
      {
        id: 'b-01',
        cse_id: '11111111-1111-1111-1111-111111111111',
        source: 'SIEM_LOGS',
        status: 'COMPLETED',
        record_count: 500,
        ingested_at: '2026-01-01T00:00:00Z',
      },
    ];
    const getSpy = vi.spyOn(apiClient, 'get').mockResolvedValueOnce({ data: mockBatches });

    const result = await listIngestionBatches();
    expect(getSpy).toHaveBeenCalledWith('/api/v1/ingestion/batches', { params: undefined });
    expect(result).toEqual(mockBatches);
  });
});
