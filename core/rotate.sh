#!/usr/bin/env bash
# core/rotate.sh - Rotation logic

set -e

# Load utils and config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/core/utils.sh"

log_message "INFO" "Checking for rotation..."

if [[ -z "$BACKUP_DIR" ]]; then
    log_message "ERROR" "BACKUP_DIR not set."
    exit 1
fi

MAX_BACKUPS="${MAX_BACKUPS:-5}"

# Find backups (ignoring checksums, just archives)
# Supports .tar.gz and .tar.gz.enc
# We list them by modification time (ls -t), oldest last.
# We skip the first MAX_BACKUPS lines.

# Note: Handles filenames with spaces poorly if not careful, but our format `backup_TIMESTAMP` is safe.
BACKUPS=($(ls -t "$BACKUP_DIR"/backup_*.tar.gz* 2>/dev/null | grep -v ".sha256" || true))

COUNT=${#BACKUPS[@]}

if [[ "$COUNT" -le "$MAX_BACKUPS" ]]; then
    log_message "INFO" "Backup count ($COUNT) within limit ($MAX_BACKUPS). No action."
    exit 0
fi

TO_DELETE=$(($COUNT - $MAX_BACKUPS))
log_message "INFO" "Rotating $TO_DELETE old backup(s)."

# Get the last TO_DELETE items
# logic: iterate from MAX_BACKUPS to END
for ((i=MAX_BACKUPS; i<COUNT; i++)); do
    FILE="${BACKUPS[$i]}"
    log_message "INFO" "Deleting old backup: $FILE"
    rm "$FILE"
    # Also delete checksum
    if [[ -f "${FILE}.sha256" ]]; then
        rm "${FILE}.sha256"
    fi
done

log_message "SUCCESS" "Rotation complete."
