from sqlalchemy.orm import DeclarativeBase

class Base(DeclarativeBase):
    """Base class for all SQLAlchemy database models."""
    pass

# Import models to ensure they are registered on Base.metadata for Alembic
import app.models  # noqa: F401, E402
