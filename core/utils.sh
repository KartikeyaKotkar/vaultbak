#!/usr/bin/env bash
# core/utils.sh - Common utility functions

# Log file location (can be overridden)
LOG_FILE="${LOG_FILE:-logs/vaultbak.log}"

log_message() {
    local LEVEL="$1"
    local MESSAGE="$2"
    local TIMESTAMP
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "[$TIMESTAMP] [$LEVEL] $MESSAGE" | tee -a "$LOG_FILE"
}

check_dependency() {
    local CMD="$1"
    if ! command -v "$CMD" &> /dev/null; then
        log_message "ERROR" "Missing dependency: $CMD"
        exit 1
    fi
}
