from fastapi import APIRouter
from app.api.v1.endpoints import health, cses
from app.api.v1 import ingestion

api_router = APIRouter()

api_router.include_router(health.router)
api_router.include_router(cses.router)
api_router.include_router(ingestion.router)

