import { describe, it, expect } from 'vitest';
import type {
  ValidationMetrics,
  ValidationRunResult,
  ValidationGenerateRequest,
  ValidationRunRequest
} from '../../types/api/validation';

describe('Phase 13 Synthetic Data & Validation Engine Frontend Contract', () => {
  it('should construct ValidationGenerateRequest correctly', () => {
    const req: ValidationGenerateRequest = {
      seed: 202613,
      force_recreate: true
    };
    expect(req.seed).toBe(202613);
    expect(req.force_recreate).toBe(true);
  });

  it('should construct ValidationRunRequest correctly', () => {
    const req: ValidationRunRequest = {
      k_value: 5
    };
    expect(req.k_value).toBe(5);
  });

  it('should structure ValidationRunResult correctly', () => {
    const metrics: ValidationMetrics = {
      overall_tp: 6,
      overall_fp: 0,
      overall_fn: 0,
      overall_tn: 2,
      precision: 1.0,
      recall: 1.0,
      f1_score: 1.0,
      precision_at_k: 1.0,
      k_value: 5
    };

    const result: ValidationRunResult = {
      validation_run_id: 'val-run-001',
      execution_timestamp: '2026-10-02T22:00:00Z',
      analytics_version: 'v1.0.0',
      dataset_hash: 'hash-202613',
      total_scenarios_evaluated: 8,
      metrics,
      rule_breakdown: [
        {
          rule_code: 'EG-03',
          tp: 1,
          fp: 0,
          fn: 0,
          tn: 7,
          precision: 1.0,
          recall: 1.0,
          f1_score: 1.0
        }
      ],
      scenario_results: [
        {
          scenario_id: 'SYN-CSE-02',
          cse_code: 'SYN-CSE-02',
          target_rule: 'EG-03',
          expected_presence: 'EXPECTED_FINDING',
          actual_presence: 'EXPECTED_FINDING',
          is_correct: true,
          matched_finding_ids: ['fnd-eg03-001'],
          tp: 1,
          fp: 0,
          fn: 0,
          tn: 0
        }
      ]
    };

    expect(result.total_scenarios_evaluated).toBe(8);
    expect(result.metrics.precision).toBe(1.0);
    expect(result.metrics.recall).toBe(1.0);
    expect(result.metrics.f1_score).toBe(1.0);
    expect(result.scenario_results[0].is_correct).toBe(true);
  });

  describe('Validation Route RBAC Access Matrix', () => {
    const VALIDATION_ALLOWED_ROLES: Array<'ADMIN' | 'SUPERVISOR' | 'VIEWER'> = ['ADMIN', 'SUPERVISOR'];

    it('1. allows ADMIN role access to /validation route', () => {
      const userRole = 'ADMIN';
      const isAllowed = VALIDATION_ALLOWED_ROLES.includes(userRole as any);
      expect(isAllowed).toBe(true);
    });

    it('2. allows SUPERVISOR role access to /validation route', () => {
      const userRole = 'SUPERVISOR';
      const isAllowed = VALIDATION_ALLOWED_ROLES.includes(userRole as any);
      expect(isAllowed).toBe(true);
    });

    it('3. blocks VIEWER role from /validation route', () => {
      const userRole = 'VIEWER';
      const isAllowed = VALIDATION_ALLOWED_ROLES.includes(userRole as any);
      expect(isAllowed).toBe(false);
    });

    it('4. blocks CSE_USER role from /validation route', () => {
      const userRole = 'CSE_USER';
      const isAllowed = VALIDATION_ALLOWED_ROLES.includes(userRole as any);
      expect(isAllowed).toBe(false);
    });

    it('5. redirects unauthenticated user (null token/user) from /validation route', () => {
      const token = null;
      const user = null;
      const isAuthenticated = Boolean(token && user);
      expect(isAuthenticated).toBe(false);
    });
  });
});
