#!/usr/bin/env bash
# core/verify.sh - Verification logic

set -e

# Load utils and config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/core/utils.sh"

ARCHIVE="$1"

if [[ -z "$ARCHIVE" ]]; then
    log_message "ERROR" "Usage: vaultbak verify <archive_path>"
    exit 1
fi

if [[ ! -f "$ARCHIVE" ]]; then
    log_message "ERROR" "Archive not found: $ARCHIVE"
    exit 1
fi

CHECKSUM_FILE="${ARCHIVE}.sha256"

if [[ ! -f "$CHECKSUM_FILE" ]]; then
    log_message "ERROR" "Checksum file not found: $CHECKSUM_FILE"
    exit 1
fi

log_message "INFO" "Verifying checksum for $ARCHIVE"

# sha256sum -c expects the file content to match path. 
# Usually sha256sum output is "HASH  FILENAME"
# If we run it from the dir of the archive it works best along with relative paths.

ARCHIVE_DIR=$(dirname "$ARCHIVE")
ARCHIVE_BASE=$(basename "$ARCHIVE")
CHECKSUM_BASE=$(basename "$CHECKSUM_FILE")

cd "$ARCHIVE_DIR"
if sha256sum -c "$CHECKSUM_BASE" --status; then
    log_message "SUCCESS" "Integrity verified for $ARCHIVE"
else
    log_message "ERROR" "Integrity check FAILED for $ARCHIVE"
    exit 1
fi
