export interface HealthCheckResponse {
  status: string;      // "ok" | "degraded"
  app: string;         // "healthy"
  database: string;    // "connected" | "unavailable"
  environment: string; // "development" | "production"
}
