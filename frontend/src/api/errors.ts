import type { AxiosError } from 'axios';
import type { HTTPErrorResponse } from '../types/api/common';

export class ApiError extends Error {
  public readonly status: number;
  public readonly code: string;
  public readonly details?: unknown;
  public readonly isNetworkError: boolean;
  public readonly isTimeout: boolean;

  constructor(
    message: string,
    status: number = 500,
    code: string = 'UNKNOWN_ERROR',
    details?: unknown,
    isNetworkError: boolean = false,
    isTimeout: boolean = false
  ) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code;
    this.details = details;
    this.isNetworkError = isNetworkError;
    this.isTimeout = isTimeout;

    Object.setPrototypeOf(this, ApiError.prototype);
  }
}

export function normalizeApiError(error: unknown): ApiError {
  if (error instanceof ApiError) {
    return error;
  }

  const axiosError = error as AxiosError<HTTPErrorResponse>;

  if (axiosError.code === 'ECONNABORTED' || (axiosError.message && axiosError.message.includes('timeout'))) {
    return new ApiError(
      'Request timed out. Please check backend server responsiveness.',
      408,
      'TIMEOUT_ERROR',
      null,
      false,
      true
    );
  }

  if (!axiosError.response) {
    return new ApiError(
      'Unable to connect to SAT-SA backend API. Ensure the FastAPI server is running.',
      503,
      'NETWORK_ERROR',
      null,
      true,
      false
    );
  }

  const status = axiosError.response.status;
  const data = axiosError.response.data;

  if (data && typeof data === 'object' && 'error' in data && data.error) {
    return new ApiError(
      data.error.message || 'An API error occurred.',
      status,
      data.error.code || 'API_ERROR',
      data.error.details || null
    );
  }

  if (status === 422 && data && typeof data === 'object' && 'detail' in data) {
    return new ApiError(
      'Request validation error.',
      422,
      'VALIDATION_ERROR',
      data.detail
    );
  }

  return new ApiError(
    axiosError.message || 'HTTP request failed.',
    status,
    `HTTP_${status}`,
    null
  );
}
