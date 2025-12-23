#!/usr/bin/env bash
# core/restore.sh - Restore logic

set -e

# Load utils and config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/core/utils.sh"

ARCHIVE="$1"
DEST="$2"

if [[ -z "$ARCHIVE" ]]; then
    log_message "ERROR" "Usage: vaultbak restore <archive_path> [destination]"
    exit 1
fi

if [[ ! -f "$ARCHIVE" ]]; then
    log_message "ERROR" "Archive not found: $ARCHIVE"
    exit 1
fi

# Default destination
if [[ -z "$DEST" ]]; then
    DEST="$SOURCE_DIR"
    log_message "WARNING" "No destination specified. Restoring to SOURCE_DIR: $DEST"
fi

if [[ ! -d "$DEST" ]]; then
    log_message "INFO" "Creating destination directory: $DEST"
    mkdir -p "$DEST"
fi

log_message "INFO" "Starting restore from $ARCHIVE to $DEST"

# Check if encrypted
IS_ENCRYPTED=false
if [[ "$ARCHIVE" == *.enc ]]; then
    IS_ENCRYPTED=true
fi

TEMP_ARCHIVE="$ARCHIVE"

# Decrypt if needed
if [[ "$IS_ENCRYPTED" == "true" ]]; then
    if [[ -z "$ENCRYPTION_KEY_PATH" ]]; then
        log_message "ERROR" "Cannot decrypt: ENCRYPTION_KEY_PATH not set."
        exit 1
    fi
    log_message "INFO" "Decrypting archive..."
    TEMP_ARCHIVE="${ARCHIVE%.enc}"
    # We decrypt to a temp location to avoid overwriting invalid things or permission issues?
    # Actually, let's keep it simple: decrypt to same folder or /tmp?
    TEMP_ARCHIVE="/tmp/$(basename "$TEMP_ARCHIVE")"
    
    openssl enc -d -aes-256-cbc -in "$ARCHIVE" -out "$TEMP_ARCHIVE" -pass "file:${ENCRYPTION_KEY_PATH}" -pbkdf2
fi

# Extract
log_message "INFO" "Extracting archive..."
tar -xzf "$TEMP_ARCHIVE" -C "$DEST"

# Cleanup temp
if [[ "$IS_ENCRYPTED" == "true" ]]; then
    rm "$TEMP_ARCHIVE"
fi

log_message "SUCCESS" "Restore complete."
