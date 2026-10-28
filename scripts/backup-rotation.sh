#!/usr/bin/env bash
set -euo pipefail

BACKUP_SRC="${1:-/var/log}"
BACKUP_DEST="${2:-/tmp/backups}"
RETENTION_DAYS="${3:-7}"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DEST}/backup_${TIMESTAMP}.tar.gz"

mkdir -p "$BACKUP_DEST"

echo "[$(date)] Starting automated backup from $BACKUP_SRC to $BACKUP_FILE..."

# Create compressed archive with error handling
tar -czf "$BACKUP_FILE" -C "$BACKUP_SRC" .

# Generate SHA-256 checksum for audit and integrity
sha256sum "$BACKUP_FILE" > "${BACKUP_FILE}.sha256"
echo "[$(date)] Backup complete. Checksum generated: $(cat "${BACKUP_FILE}.sha256")"

# Enforce retention policy (delete backups older than RETENTION_DAYS)
echo "[$(date)] Enforcing retention policy: deleting backups older than ${RETENTION_DAYS} days..."
find "$BACKUP_DEST" -type f \( -name "backup_*.tar.gz" -o -name "backup_*.sha256" \) -mtime "+$RETENTION_DAYS" -exec rm -v {} \;

echo "[$(date)] Backup and retention cycle finished successfully."
