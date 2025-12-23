#!/usr/bin/env bash
# core/backup.sh - Backup logic

set -e

# Load utils and config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/core/utils.sh"

log_message "INFO" "Starting backup process..."

# Check requirements
check_dependency rsync
check_dependency tar
check_dependency gzip
check_dependency openssl
check_dependency sha256sum

# Validation
if [[ -z "$SOURCE_DIR" || -z "$BACKUP_DIR" ]]; then
    log_message "ERROR" "Configuration missing SOURCE_DIR or BACKUP_DIR."
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    log_message "ERROR" "Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# Variables
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
STAGING_DIR="${BACKUP_DIR}/.cache"
mkdir -p "$STAGING_DIR"

ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

# Step 1: Rsync to Staging (Incremental update of cache)
log_message "INFO" "Syncing source to staging cache..."
rsync -a --delete "$SOURCE_DIR/" "$STAGING_DIR/"

# Step 2: Create Archive
log_message "INFO" "Creating archive: $ARCHIVE_NAME"
# We tar the content of the staging dir
tar -czf "$ARCHIVE_PATH" -C "$STAGING_DIR" .

# Step 3: Encryption (Optional)
FINAL_PATH="$ARCHIVE_PATH"
if [[ "$ENCRYPTION_ENABLED" == "true" ]]; then
    if [[ -z "$ENCRYPTION_KEY_PATH" ]]; then
        log_message "ERROR" "Encryption enabled but ENCRYPTION_KEY_PATH not set."
        exit 1
    fi
    log_message "INFO" "Encrypting archive..."
    ENC_PATH="${ARCHIVE_PATH}.enc"
    openssl enc -aes-256-cbc -salt -in "$ARCHIVE_PATH" -out "$ENC_PATH" -pass "file:${ENCRYPTION_KEY_PATH}" -pbkdf2
    rm "$ARCHIVE_PATH"
    FINAL_PATH="$ENC_PATH"
    log_message "INFO" "Encryption complete."
fi

# Step 4: Checksum
log_message "INFO" "Generating checksum..."
CHECKSUM_FILE="${FINAL_PATH}.sha256"
sha256sum "$FINAL_PATH" > "$CHECKSUM_FILE"

log_message "SUCCESS" "Backup created at $FINAL_PATH"

# Step 5: Rotate
"${SCRIPT_DIR}/core/rotate.sh"
