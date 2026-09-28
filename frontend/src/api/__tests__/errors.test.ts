import { describe, it, expect } from 'vitest';
import type { AxiosError } from 'axios';
import { ApiError, normalizeApiError } from '../errors';
import type { HTTPErrorResponse } from '../../types/api/common';

describe('API Error Handling Infrastructure', () => {
  it('instantiates ApiError correctly', () => {
    const customError = new ApiError('Custom error message', 404, 'ENTITY_NOT_FOUND', { id: '123' });
    expect(customError.message).toBe('Custom error message');
    expect(customError.status).toBe(404);
    expect(customError.code).toBe('ENTITY_NOT_FOUND');
    expect(customError.details).toEqual({ id: '123' });
  });

  it('passes through existing ApiError instances without modification', () => {
    const customError = new ApiError('Custom error', 400, 'BAD_REQUEST');
    const normalized = normalizeApiError(customError);
    expect(normalized).toBe(customError);
  });

  it('normalizes network failures without response objects into 503 NETWORK_ERROR', () => {
    const networkError = {
      message: 'Network Error',
      isAxiosError: true,
    } as AxiosError<HTTPErrorResponse>;
    const norm = normalizeApiError(networkError);
    expect(norm.isNetworkError).toBe(true);
    expect(norm.status).toBe(503);
    expect(norm.code).toBe('NETWORK_ERROR');
    expect(norm.message).toBe('Unable to connect to SAT-SA backend API. Ensure the FastAPI server is running.');
  });

  it('normalizes ECONNABORTED timeout errors into 408 TIMEOUT_ERROR', () => {
    const timeoutError = {
      code: 'ECONNABORTED',
      message: 'timeout of 15000ms exceeded',
      isAxiosError: true,
    } as AxiosError<HTTPErrorResponse>;
    const norm = normalizeApiError(timeoutError);
    expect(norm.isTimeout).toBe(true);
    expect(norm.status).toBe(408);
    expect(norm.code).toBe('TIMEOUT_ERROR');
  });

  it('normalizes HTTP 400 Bad Request responses', () => {
    const err400 = {
      isAxiosError: true,
      response: {
        status: 400,
        data: {
          error: {
            code: 'BAD_REQUEST',
            message: 'Invalid request parameter',
            details: null,
          },
        },
      },
    } as AxiosError<HTTPErrorResponse>;
    const norm = normalizeApiError(err400);
    expect(norm.status).toBe(400);
    expect(norm.code).toBe('BAD_REQUEST');
    expect(norm.message).toBe('Invalid request parameter');
  });

  it('normalizes HTTP 404 Not Found responses', () => {
    const err404 = {
      isAxiosError: true,
      response: {
        status: 404,
        data: {
          error: {
            code: 'CSE_NOT_FOUND',
            message: 'CSE not found',
            details: null,
          },
        },
      },
    } as AxiosError<HTTPErrorResponse>;
    const norm = normalizeApiError(err404);
    expect(norm.status).toBe(404);
    expect(norm.code).toBe('CSE_NOT_FOUND');
    expect(norm.message).toBe('CSE not found');
  });

  it('normalizes HTTP 422 FastAPI validation errors', () => {
    const err422 = {
      isAxiosError: true,
      response: {
        status: 422,
        data: {
          detail: [{ loc: ['body', 'obs_start'], msg: 'obs_start must be before obs_end', type: 'value_error' }],
        },
      },
    } as AxiosError<unknown>;
    const norm = normalizeApiError(err422);
    expect(norm.status).toBe(422);
    expect(norm.code).toBe('VALIDATION_ERROR');
    expect(norm.message).toContain('validation error');
  });

  it('normalizes HTTP 500 Internal Server Error responses', () => {
    const err500 = {
      isAxiosError: true,
      response: {
        status: 500,
        data: {
          error: {
            code: 'INTERNAL_SERVER_ERROR',
            message: 'An internal server error occurred.',
            details: null,
          },
        },
      },
    } as AxiosError<HTTPErrorResponse>;
    const norm = normalizeApiError(err500);
    expect(norm.status).toBe(500);
    expect(norm.code).toBe('INTERNAL_SERVER_ERROR');
  });
});

