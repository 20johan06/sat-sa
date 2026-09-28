# SAT-SA — Supervisory Analytics Tool for SOC Assessment

**SIH 2026 | Problem Statement 26157**

## Overview
SAT-SA (Supervisory Analytics Tool for SOC Assessment) is a supervisory analytics platform designed to provide automated, evidence-based oversight for Security Operations Center (SOC) performance and operational risk assessment.

## Stack
- **Frontend**: React, TypeScript, Vite, Tailwind CSS
- **Backend**: Python 3.14, FastAPI, Uvicorn, Pydantic, SQLAlchemy, Alembic
- **Database**: PostgreSQL 16 (via Docker Compose)
- **Data & Analytics**: Pandas, NumPy, SciPy, scikit-learn
- **Testing**: Pytest, Playwright
- **Deployment**: Docker, Docker Compose

## Development Setup

### 1. Database Setup
Start the PostgreSQL container via Docker Compose:
```bash
docker compose up -d
```

### 2. Backend Setup
Activate virtual environment and start FastAPI dev server:
```bash
cd backend
# Windows:
.venv\Scripts\python -m uvicorn app.main:app --reload --port 8000
```
Health Check Endpoint: `http://localhost:8000/health`

### 3. Frontend Setup
Install dependencies and start Vite dev server:
```bash
cd frontend
npm install
npm run dev
```
