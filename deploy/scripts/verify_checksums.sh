#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "SAT-SA Offline Image Checksum Verification"
echo "=========================================="

if [ ! -f "SHA256SUMS" ]; then
    echo "ERROR: SHA256SUMS file not found in current directory."
    exit 1
fi

echo "Verifying SHA-256 checksums of offline deployment image archives..."
sha256sum -c SHA256SUMS

echo "SUCCESS: All offline deployment image archives verified successfully."
