import os
import pytest
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# 1. Force environment variables to test database before app imports
TEST_DB_NAME = os.environ.get("POSTGRES_DB_TEST", "satsa_test_db")
TEST_DB_URL = os.environ.get(
    "DATABASE_URL_TEST",
    f"postgresql+psycopg://satsa_user:satsa_password@localhost:5432/{TEST_DB_NAME}"
)

os.environ["POSTGRES_DB"] = TEST_DB_NAME
os.environ["DATABASE_URL"] = TEST_DB_URL

# Import settings and db modules after environment override
from app.config.settings import settings
settings.POSTGRES_DB = TEST_DB_NAME
settings.DATABASE_URL = TEST_DB_URL

import app.db.session as db_session_module
from app.db.base import Base
import app.models  # Register all models with Base metadata
from app.services.auth_service import AuthService

# Create dedicated test engine and sessionmaker bound to satsa_test_db
test_engine = create_engine(
    TEST_DB_URL,
    pool_pre_ping=True,
    echo=False
)
TestSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=test_engine)

# Rebind engine and SessionLocal in app.db.session module so all services, endpoints, and tests use satsa_test_db
db_session_module.engine = test_engine
db_session_module.SessionLocal = TestSessionLocal

@pytest.fixture(scope="session", autouse=True)
def init_test_database():
    """Initializes the satsa_test_db schema and seeds initial admin before tests run."""
    Base.metadata.create_all(bind=test_engine)
    
    # Ensure alembic_version table exists for schema validation tests
    with test_engine.begin() as conn:
        conn.execute(text(
            "CREATE TABLE IF NOT EXISTS alembic_version (version_num VARCHAR(32) NOT NULL, CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num))"
        ))
        conn.execute(text(
            "INSERT INTO alembic_version (version_num) SELECT '47b585f55760' WHERE NOT EXISTS (SELECT 1 FROM alembic_version)"
        ))

    db = TestSessionLocal()
    try:
        AuthService.ensure_initial_admin(db)
    except Exception:
        db.rollback()
    finally:
        db.close()

@pytest.fixture
def db_session():
    """Provides a database session bound to satsa_test_db for tests."""
    session = TestSessionLocal()
    try:
        yield session
    finally:
        session.rollback()
        session.close()
