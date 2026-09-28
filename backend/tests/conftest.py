import pytest
from app.db.session import SessionLocal

@pytest.fixture
def db_session():
    """Provides a transactional database session for tests with automatic cleanup."""
    session = SessionLocal()
    try:
        yield session
    finally:
        session.rollback()
        session.close()
