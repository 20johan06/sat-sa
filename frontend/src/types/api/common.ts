export interface ErrorDetail {
  code: string;
  message: string;
  details?: unknown;
}

export interface HTTPErrorResponse {
  error: ErrorDetail;
}

export interface ObservationPeriodSchema {
  start?: string | null;
  end?: string | null;
  is_bounded: boolean;
}

export interface PaginationMeta {
  total: number;
  page: number;
  page_size: number;
  total_pages: number;
}
