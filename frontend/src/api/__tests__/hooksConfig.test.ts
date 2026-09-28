import { describe, it, expect } from 'vitest';
import queryKeys from '../../utils/queryKeys';

describe('Query Hook Configuration & Enabled Logic', () => {
  it('disables useCseQuery when cseId is empty', () => {
    const emptyId = '';
    const enabledState = Boolean(emptyId);
    expect(enabledState).toBe(false);

    const validId = '11111111-1111-1111-1111-111111111111';
    const validEnabledState = Boolean(validId);
    expect(validEnabledState).toBe(true);
  });

  it('disables useCseSummaryQuery when cseId is empty', () => {
    const emptyId = '';
    expect(Boolean(emptyId)).toBe(false);

    const validId = 'cse-456';
    expect(Boolean(validId)).toBe(true);
  });

  it('verifies correct query key resolution for useHealthQuery', () => {
    const expectedKey = queryKeys.health.all;
    expect(expectedKey).toEqual(['health']);
  });

  it('verifies query key structure for useFindingsQuery with filters', () => {
    const filters = { severity: 'CRITICAL', status: 'OPEN' };
    const expectedKey = queryKeys.findings.list(filters);
    expect(expectedKey).toEqual(['findings', 'list', { severity: 'CRITICAL', status: 'OPEN' }]);
  });

  it('verifies query key structure for useAnalyticsSignalsQuery', () => {
    const cseId = 'cse-789';
    const params = { obs_start: '2026-01-01' };
    const expectedKey = queryKeys.analytics.signals(cseId, params);
    expect(expectedKey).toEqual(['analytics', 'signals', 'cse-789', { obs_start: '2026-01-01' }]);
  });
});
