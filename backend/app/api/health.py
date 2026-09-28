from fastapi import APIRouter, Depends, Response, status
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.db.session import get_db
from app.schemas.health import HealthCheckResponse
from app.config.settings import settings
from app.utils.logger import logger

router = APIRouter()

@router.get(
    "/health",
    response_model=HealthCheckResponse,
    summary="Application and Database Health Check"
)
def health_check(response: Response, db: Session = Depends(get_db)):
    """
    Checks operational health of the FastAPI application and real database connectivity.
    """
    db_status = "unavailable"
    app_status = "healthy"
    overall_status = "ok"

    try:
        db.execute(text("SELECT 1"))
        db_status = "connected"
    except Exception as exc:
        logger.warning(f"Database health check failed: {exc}")
        db_status = "unavailable"
        overall_status = "degraded"
        response.status_code = status.HTTP_503_SERVICE_UNAVAILABLE

    return HealthCheckResponse(
        status=overall_status,
        app=app_status,
        database=db_status,
        environment=settings.ENVIRONMENT
    )
