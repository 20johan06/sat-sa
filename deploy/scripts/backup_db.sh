#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${1:-docker-compose.prod.yml}"
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/sat_sa_backup_$TIMESTAMP.sql"

echo "=========================================="
echo "SAT-SA PostgreSQL Backup Procedure"
echo "=========================================="

mkdir -p "$BACKUP_DIR"

echo "Creating PostgreSQL backup: $BACKUP_FILE ..."
docker compose -f "$COMPOSE_FILE" exec -T postgres pg_dump -U "${POSTGRES_USER}" "${POSTGRES_DB}" > "$BACKUP_FILE"

if [ -s "$BACKUP_FILE" ]; then
    echo "SUCCESS: Database backup created successfully ($BACKUP_FILE, $(du -h "$BACKUP_FILE" | cut -f1))."
else
    echo "ERROR: Backup file $BACKUP_FILE is empty or was not created!"
    exit 1
fi
