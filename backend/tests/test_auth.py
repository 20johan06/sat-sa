import uuid
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.config.settings import settings
from app.services.auth_service import AuthService
from app.models.user import User

client = TestClient(app)

def test_initial_admin_bootstrap(db_session):
    """Verify initial admin account is bootstrapped securely."""
    admin = AuthService.ensure_initial_admin(db_session)
    assert admin.username == settings.INITIAL_ADMIN_USERNAME
    assert admin.role == "ADMIN"
    assert admin.is_active is True

def test_successful_login(db_session):
    """Verify POST /api/v1/auth/login succeeds with valid admin credentials."""
    AuthService.ensure_initial_admin(db_session)
    response = client.post(
        "/api/v1/auth/login",
        json={
            "username": settings.INITIAL_ADMIN_USERNAME,
            "password": settings.INITIAL_ADMIN_PASSWORD
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"
    assert data["user"]["username"] == settings.INITIAL_ADMIN_USERNAME
    assert data["user"]["role"] == "ADMIN"

def test_login_invalid_password(db_session):
    """Verify POST /api/v1/auth/login fails with HTTP 401 for wrong password."""
    AuthService.ensure_initial_admin(db_session)
    response = client.post(
        "/api/v1/auth/login",
        json={
            "username": settings.INITIAL_ADMIN_USERNAME,
            "password": "WrongPassword123!"
        }
    )
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "INVALID_CREDENTIALS"

def test_login_unknown_user(db_session):
    """Verify POST /api/v1/auth/login fails with HTTP 401 for non-existent user."""
    response = client.post(
        "/api/v1/auth/login",
        json={
            "username": f"unknown_user_{uuid.uuid4().hex[:6]}",
            "password": "SomePassword123!"
        }
    )
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "INVALID_CREDENTIALS"

def test_get_current_user_me(db_session):
    """Verify GET /api/v1/auth/me returns authenticated profile when Bearer token is sent."""
    AuthService.ensure_initial_admin(db_session)
    login_res = client.post(
        "/api/v1/auth/login",
        json={
            "username": settings.INITIAL_ADMIN_USERNAME,
            "password": settings.INITIAL_ADMIN_PASSWORD
        }
    )
    token = login_res.json()["access_token"]

    me_res = client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {token}"}
    )
    assert me_res.status_code == 200
    profile = me_res.json()
    assert profile["username"] == settings.INITIAL_ADMIN_USERNAME
    assert profile["role"] == "ADMIN"

def test_invalid_token_signature(db_session):
    """Verify GET /api/v1/auth/me returns HTTP 401 for tampered JWT token."""
    invalid_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.invalidpayload.invalidsignature"
    res = client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {invalid_token}"}
    )
    assert res.status_code == 401
    assert res.json()["error"]["code"] == "INVALID_TOKEN"

def test_logout(db_session):
    """Verify POST /api/v1/auth/logout records audit event and returns success."""
    AuthService.ensure_initial_admin(db_session)
    login_res = client.post(
        "/api/v1/auth/login",
        json={
            "username": settings.INITIAL_ADMIN_USERNAME,
            "password": settings.INITIAL_ADMIN_PASSWORD
        }
    )
    token = login_res.json()["access_token"]

    logout_res = client.post(
        "/api/v1/auth/logout",
        headers={"Authorization": f"Bearer {token}"}
    )
    assert logout_res.status_code == 200
    assert logout_res.json()["message"] == "Successfully logged out."
