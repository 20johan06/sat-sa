from fastapi import APIRouter
from app.api.v1.endpoints import (
    health,
    cses,
    analytics,
    findings,
    benchmarks,
    reports
)
from app.api.v1 import ingestion

api_router = APIRouter()

api_router.include_router(health.router)
api_router.include_router(cses.router)
api_router.include_router(ingestion.router)
api_router.include_router(analytics.router)
api_router.include_router(findings.router)
api_router.include_router(benchmarks.router)
api_router.include_router(reports.router)
