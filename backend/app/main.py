from contextlib import asynccontextmanager
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from app.config.settings import settings
from app.utils.logger import logger
from app.utils.exceptions import SATSAException
from app.api.health import router as health_router
from app.api.v1.api import api_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifecycle events for FastAPI startup and shutdown logging."""
    logger.info(f"Starting {settings.PROJECT_NAME} backend in '{settings.ENVIRONMENT}' environment...")
    yield
    logger.info(f"Shutting down {settings.PROJECT_NAME} backend gracefully.")

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="SAT-SA — Supervisory Analytics Tool for SOC Assessment Backend API",
    version="0.1.0",
    lifespan=lifespan
)

# CORS Middleware Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Custom SAT-SA Application Exception Handler
@app.exception_handler(SATSAException)
async def satsa_exception_handler(request: Request, exc: SATSAException):
    logger.warning(f"Domain exception on path {request.url.path} [{exc.code}]: {exc.message}")
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "code": exc.code,
                "message": exc.message,
                "details": exc.details
            }
        }
    )

# Global Unhandled Exception Handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception on path {request.url.path}: {exc}", exc_info=True)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "error": {
                "code": "INTERNAL_SERVER_ERROR",
                "message": "An internal server error occurred."
            }
        }
    )

# Mount Health Endpoint at root /health for backward compatibility
app.include_router(health_router)

# Mount API v1 Router under /api/v1
app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/")
def root():
    return {
        "project": settings.PROJECT_NAME,
        "registered_routes": [
            getattr(route, "path", None)
            for route in app.routes
            if getattr(route, "path", None)
        ],
        "health_router_routes": [
            getattr(route, "path", None)
            for route in health_router.routes
            if getattr(route, "path", None)
        ],
        "api_router_routes": [
            getattr(route, "path", None)
            for route in api_router.routes
            if getattr(route, "path", None)
        ],
        "health_router_count": len(health_router.routes),
        "api_router_count": len(api_router.routes),
    }
