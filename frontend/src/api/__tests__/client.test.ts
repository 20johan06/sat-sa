import { describe, it, expect } from 'vitest';
import { apiClient } from '../client';

describe('Axios API Client Configuration Infrastructure', () => {
  it('configures default timeout to 15000ms', () => {
    expect(apiClient.defaults.timeout).toBe(15000);
  });

  it('configures Content-Type application/json headers', () => {
    expect(apiClient.defaults.headers['Content-Type']).toBe('application/json');
  });

  it('resolves baseURL to http://localhost:8000 or VITE_API_BASE_URL', () => {
    const expectedBase = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';
    expect(apiClient.defaults.baseURL).toBe(expectedBase);
  });
});
