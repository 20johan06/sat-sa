import { describe, it, expect } from 'vitest';
import type {
  ReportGenerateRequest,
  ReportItem,
  PaginatedReportsResponse,
  ReportDetailResponse
} from '../../types/api/reports';

describe('Phase 12 Reports & Export Frontend Types & Contract', () => {
  it('should format ReportGenerateRequest correctly', () => {
    const req: ReportGenerateRequest = {
      cse_id: 'cse-123',
      assessment_id: 'ass-456',
      obs_start: '2026-10-01T00:00:00Z',
      obs_end: '2026-10-02T00:00:00Z',
    };

    expect(req.cse_id).toBe('cse-123');
    expect(req.assessment_id).toBe('ass-456');
  });

  it('should format PaginatedReportsResponse correctly', () => {
    const item: ReportItem = {
      id: 'rep-111',
      report_code: 'REP-CSE-SBI-20261002-001',
      cse_id: 'cse-123',
      generated_by_user_id: 'user-789',
      generated_by_username: 'supervisor_john',
      created_at: new Date().toISOString(),
    };

    const resp: PaginatedReportsResponse = {
      items: [item],
      total: 1,
      page: 1,
      page_size: 20,
      total_pages: 1,
    };

    expect(resp.items).toHaveLength(1);
    expect(resp.items[0].report_code).toContain('REP-CSE');
  });

  it('should format ReportDetailResponse containing 8 capabilities and canonical rules', () => {
    const detail: Partial<ReportDetailResponse> = {
      report_metadata: {
        report_id: 'REP-1',
        report_code: 'REP-CSE-SBI-20261002-001',
        generated_at: new Date().toISOString(),
        generated_by_user: 'supervisor_john',
        generated_by_user_id: 'usr-1',
        cse_id: 'cse-1',
        cse_code: 'SBI-01',
        cse_name: 'SBI SOC',
        sector: 'BANKING',
        criticality_tier: 'TIER_1',
        observation_period: { is_bounded: true },
        provenance: {
          rule_manifests: ['EG-01', 'EG-02', 'EG-03', 'EG-04', 'NS-01', 'NS-02', 'AN-01', 'BM-01'],
        },
      },
      supervisory_signals_summary: {
        EXECUTION_GAP: 2,
        NEGATIVE_SPACE: 1,
        ANOMALY: 0,
        BENCHMARK: 1,
      },
    };

    expect(detail.report_metadata?.provenance.rule_manifests).toHaveLength(8);
    expect(detail.report_metadata?.provenance.rule_manifests).not.toContain('AN-02');
    expect(detail.supervisory_signals_summary?.EXECUTION_GAP).toBe(2);
  });
});
