from fastapi import APIRouter
from app.api.v1.endpoints import (
    health,
    auth,
    users,
    audit,
    cses,
    analytics,
    findings,
    benchmarks,
    reports,
    assessments,
    dataset_versions,
    analysis_runs,
    supervisory,
    manual_review,
    capability
)
from app.api.v1 import ingestion

api_router = APIRouter()

# Health endpoints (Public)
api_router.include_router(health.router)

# Authentication & RBAC endpoints
api_router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(users.router, prefix="/users", tags=["Users"])
api_router.include_router(audit.router, prefix="/audit", tags=["Audit Logs"])

# Core domain endpoints
api_router.include_router(cses.router)
api_router.include_router(ingestion.router)
api_router.include_router(analytics.router)
api_router.include_router(findings.router)
api_router.include_router(benchmarks.router)
api_router.include_router(reports.router)
api_router.include_router(supervisory.router)
api_router.include_router(manual_review.router)
api_router.include_router(capability.router)

# Phase 3 V2 Assessment & Dataset Foundation endpoints
api_router.include_router(assessments.router)
api_router.include_router(dataset_versions.router)
api_router.include_router(analysis_runs.router)

