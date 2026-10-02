#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "SAT-SA Air-Gapped Image Loading Procedure"
echo "=========================================="

IMAGES_DIR="${1:-images}"

if [ ! -d "$IMAGES_DIR" ]; then
    echo "ERROR: Image directory '$IMAGES_DIR' not found."
    exit 1
fi

echo "Loading PostgreSQL 16 Alpine base image..."
docker load < "$IMAGES_DIR/postgres-16-alpine.tar"

echo "Loading SAT-SA Backend production image..."
docker load < "$IMAGES_DIR/sat-sa-backend-v1.0.0-c59d5fa.tar"

echo "Loading SAT-SA Frontend production image..."
docker load < "$IMAGES_DIR/sat-sa-frontend-v1.0.0-c59d5fa.tar"

echo "SUCCESS: All 3 air-gapped deployment images loaded into local Docker daemon."
docker images | grep -E "sat-sa|postgres"
