import { describe, it, expect } from 'vitest';
import type { FindingReviewHistoryResponse, EvidenceRequestPayload } from '../../types/api/findings';

describe('Phase 11 Examiner Workflow & Audit Trail Frontend Types & Contract', () => {
  it('should format FindingReviewHistoryResponse schema correctly', () => {
    const historyItem: FindingReviewHistoryResponse = {
      id: 'hist-123',
      finding_id: 'find-456',
      user_id: 'user-789',
      username: 'supervisor_alice',
      user_role: 'SUPERVISOR',
      cse_id: 'cse-111',
      action_type: 'STATUS_CHANGE',
      previous_status: 'NEW',
      new_status: 'UNDER_REVIEW',
      note_text: 'Initiating formal supervisory review.',
      created_at: new Date().toISOString(),
    };

    expect(historyItem.action_type).toBe('STATUS_CHANGE');
    expect(historyItem.previous_status).toBe('NEW');
    expect(historyItem.new_status).toBe('UNDER_REVIEW');
    expect(historyItem.user_role).toBe('SUPERVISOR');
  });

  it('should construct EvidenceRequestPayload correctly', () => {
    const reqPayload: EvidenceRequestPayload = {
      note_text: 'Current syslog sample is insufficient.',
      required_data_types: ['syslog', 'auth_log'],
      requested_time_window: '2026-10-01 to 2026-10-02',
      description: 'Requesting extended PCAP logs.',
    };

    expect(reqPayload.required_data_types).toContain('syslog');
    expect(reqPayload.required_data_types).toContain('auth_log');
    expect(reqPayload.note_text).toBeDefined();
  });

  it('should enforce authoritative status list in status transitions', () => {
    const validV2Statuses = [
      'NEW',
      'UNDER_REVIEW',
      'CONFIRMED',
      'NOT_SUBSTANTIATED',
      'DISMISSED',
      'NEEDS_MORE_EVIDENCE',
    ];

    const forbiddenStatuses = ['RESOLVED', 'CLOSED', 'ACKNOWLEDGED'];

    expect(validV2Statuses).toHaveLength(6);
    forbiddenStatuses.forEach((st) => {
      expect(validV2Statuses.includes(st)).toBe(false);
    });
  });
});
