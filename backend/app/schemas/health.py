from pydantic import BaseModel

class HealthCheckResponse(BaseModel):
    status: str
    app: str
    database: str
    environment: str
