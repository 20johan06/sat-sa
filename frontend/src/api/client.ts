import axios from 'axios';
import type { AxiosInstance } from 'axios';
import { normalizeApiError } from './errors';

const BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';
export const TOKEN_STORAGE_KEY = 'sat_sa_auth_token';

export const apiClient: AxiosInstance = axios.create({
  baseURL: BASE_URL,
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Request interceptor injecting Bearer JWT token
apiClient.interceptors.request.use((config) => {
  const token = sessionStorage.getItem(TOKEN_STORAGE_KEY) || localStorage.getItem(TOKEN_STORAGE_KEY);
  if (token && config.headers) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor handling errors and 401 unauthenticated redirect
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      sessionStorage.removeItem(TOKEN_STORAGE_KEY);
      localStorage.removeItem(TOKEN_STORAGE_KEY);
    }
    return Promise.reject(normalizeApiError(error));
  }
);

export default apiClient;
