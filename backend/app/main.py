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
    logger.info(
        f"Starting {settings.PROJECT_NAME} backend "
        f"in '{settings.ENVIRONMENT}' environment..."
    )
    yield
    logger.info(
        f"Shutting down {settings.PROJECT_NAME} backend gracefully."
    )


app = FastAPI(
    title=settings.PROJECT_NAME,
    description="SAT-SA — Supervisory Analytics Tool for SOC Assessment Backend API",
    version="0.1.0",
    lifespan=lifespan,
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.exception_handler(SATSAException)
async def satsa_exception_handler(
    request: Request,
    exc: SATSAException,
):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": exc.error_code,
            "message": exc.message,
            "details": exc.details,
        },
    )


@app.exception_handler(Exception)
async def global_exception_handler(
    request: Request,
    exc: Exception,
):
    logger.exception(
        "Unhandled exception while processing request: %s",
        request.url.path,
    )

    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "error": "INTERNAL_SERVER_ERROR",
            "message": "An unexpected error occurred.",
        },
    )


# Health routes
app.include_router(health_router)

# Versioned API routes
app.include_router(
    api_router,
    prefix=settings.API_V1_STR,
)


@app.get("/")
def root():
    return {
        "project": settings.PROJECT_NAME,
        "subtitle": "Supervisory Analytics Tool for SOC Assessment",
        "version": "0.1.0",
        "docs": "/docs",
        "api_v1": settings.API_V1_STR,
    }