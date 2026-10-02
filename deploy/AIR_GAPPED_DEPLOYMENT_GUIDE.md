# SAT-SA — AIR-GAPPED DEPLOYMENT GUIDE
**PROJECT:** SAT-SA — Supervisory Analytics Tool for SOC Assessment  
**SIH 2026 PS 26157 | NTRO / NCIIPC**  
**RELEASE VERSION:** `v1.0.0-c59d5fa`  
**ARCHITECTURE:** Air-Gapped Offline Containerized Architecture

---

## 1. ARCHITECTURE & ISOLATION OVERVIEW

SAT-SA is engineered to operate inside isolated, high-security National Cybersecurity Operations Centers (SOCs) under NTRO/NCIIPC oversight.

```
                      AIR-GAPPED SOC OPERATOR
                                 │
                                 ▼
                     NGINX REVERSE PROXY (Port 80)
                                 │
                 ┌───────────────┴───────────────┐
                 │                               │
                 ▼                               ▼
       React Static Bundle               FastAPI Backend (/api/)
         (Local Assets)                          │
                                                 ▼
                                        PostgreSQL Database
                                      (Persistent Storage)
```

- **Zero Outbound Sockets:** The internal Docker network (`sat-sa-internal`) has `internal: true`. Application containers cannot establish external outbound network connections.
- **Local Static Assets:** System font stack (`Inter`, `system-ui`) and bundled SVG icons (`lucide-react`). Zero CDN resources, zero external tracking scripts.

---

## 2. STAGING PRE-BUILD & EXPORT PROCEDURE (CONNECTED WORKSTATION)

Before transferring to an air-gapped environment, build and export container images on a connected staging workstation:

```bash
# 1. Build Backend Production Image
docker build -t sat-sa-backend:v1.0.0-c59d5fa ./backend

# 2. Build Frontend Production Image
docker build -t sat-sa-frontend:v1.0.0-c59d5fa ./frontend

# 3. Pull Base Database Image
docker pull postgres:16-alpine

# 4. Export Image Tarballs
mkdir -p sat-sa-offline-v1.0.0/images
docker save sat-sa-backend:v1.0.0-c59d5fa > sat-sa-offline-v1.0.0/images/sat-sa-backend-v1.0.0-c59d5fa.tar
docker save sat-sa-frontend:v1.0.0-c59d5fa > sat-sa-offline-v1.0.0/images/sat-sa-frontend-v1.0.0-c59d5fa.tar
docker save postgres:16-alpine > sat-sa-offline-v1.0.0/images/postgres-16-alpine.tar

# 5. Generate Cryptographic Checksums
cd sat-sa-offline-v1.0.0/images
sha256sum *.tar > ../SHA256SUMS
```

---

## 3. CHECKSUM VERIFICATION & IMAGE LOADING (AIR-GAPPED TARGET HOST)

Upon transferring `sat-sa-offline-v1.0.0.tar.gz` to the air-gapped target host via approved physical media:

### Step 1: Verify Image Integrity
```bash
./scripts/verify_checksums.sh
```

### Step 2: Load All 3 Container Images
```bash
./scripts/load_images.sh
```
*Verification:* Confirm loaded images via `docker images | grep -E "sat-sa|postgres"`.

---

## 4. ENVIRONMENT & MANDATORY SECRETS CONFIGURATION

Copy `.env.production.example` to `.env.production`:

```bash
cp .env.production.example .env.production
```

Edit `.env.production` and supply explicit non-default secret values:
- `POSTGRES_USER`: Database username
- `POSTGRES_PASSWORD`: Cryptographically random database password
- `POSTGRES_DB`: Production database name
- `SECRET_KEY`: 64-character hex cryptographic key for JWT signing

---

## 5. DATABASE DEPLOYMENT & MIGRATION PROCEDURES

### 5.1 Fresh Database Deployment
```bash
# 1. Start PostgreSQL container
docker compose -f docker-compose.prod.yml up -d postgres

# 2. Verify PostgreSQL health
docker compose -f docker-compose.prod.yml exec postgres pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}

# 3. Run explicit Alembic migration to head
./scripts/migrate_db.sh

# 4. Start remaining application services
docker compose -f docker-compose.prod.yml up -d

# 5. Verify application health
curl -f http://localhost/health
```

### 5.2 Existing Database Upgrade Procedure
```bash
# 1. Start PostgreSQL container
docker compose -f docker-compose.prod.yml up -d postgres

# 2. Verify PostgreSQL health
docker compose -f docker-compose.prod.yml exec postgres pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}

# 3. Create verified pre-migration backup (MANDATORY BEFORE MIGRATION)
./scripts/backup_db.sh

# 4. Run explicit Alembic migration to head
./scripts/migrate_db.sh

# 5. Start remaining application services & verify
docker compose -f docker-compose.prod.yml up -d
curl -f http://localhost/health
```

---

## 6. HEALTH & READINESS PROBES

- **PostgreSQL Database:** `pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}`
- **FastAPI Backend:** `GET /health` (returns `{"status": "ok", "app": "healthy", "database": "connected"}` with HTTP 200).
- **Frontend / Nginx:** `GET http://localhost/` (returns `index.html` with HTTP 200).

---

## 7. REPORT EXPORT WORKFLOW

To export supervisory reports in an air-gapped deployment:
1. Log in to the supervisory portal as `ADMIN` or `SUPERVISOR`.
2. Generate report record via `POST /api/v1/reports/generate`.
3. Download PDF report via `GET /api/v1/reports/{report_id}/export/pdf`.
4. Download CSV evidence matrix via `GET /api/v1/reports/{report_id}/export/csv`.

---

## 8. SYNTHETIC VALIDATION BOUNDARY

Synthetic data generation occurs only through an explicitly triggered validation operation and is tagged `SYNTHETIC_VALIDATION`. It must never occur automatically during normal production startup, ingestion, analysis, or deployment.

All operational telemetry and supervisory assessment records remain cleanly isolated from synthetic validation scenarios.
