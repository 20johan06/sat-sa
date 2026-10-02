#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${1:-docker-compose.prod.yml}"

echo "=========================================="
echo "SAT-SA Database Migration Procedure"
echo "=========================================="

echo "Verifying PostgreSQL container readiness..."
docker compose -f "$COMPOSE_FILE" exec postgres pg_isready -U "${POSTGRES_USER}" -d "${POSTGRES_DB}"

echo "Executing explicit Alembic schema migration (head)..."
docker compose -f "$COMPOSE_FILE" run --rm backend alembic upgrade head

echo "SUCCESS: Database schema migrated cleanly to head."
