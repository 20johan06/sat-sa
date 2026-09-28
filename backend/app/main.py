from contextlib import asynccontextmanager
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from app.config.settings import settings
from app.utils.logger import logger
from app.api.health import router as health_router

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

# CORS Middleware Configuration - Explicit Local Development Origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global Exception Handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception on path {request.url.path}: {exc}", exc_info=True)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": "An internal server error occurred."}
    )

# Include API routes
app.include_router(health_router)

@app.get("/")
def root():
    return {
        "project": settings.PROJECT_NAME,
        "subtitle": "Supervisory Analytics Tool for SOC Assessment",
        "version": "0.1.0",
        "docs": "/docs"
    }
