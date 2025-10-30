#!/bin/bash
# log_metadata.sh
# Generates a metadata file for each test run to ensure reproducibility

LOG_DIR="${1:-/home/pi/test_metadata}"
mkdir -p "$LOG_DIR"

RUN_ID=$(date +"%Y%m%d_%H%M%S")
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "no-git")
HOSTNAME=$(hostname)
USER=$(whoami)

# Optional: include repo name if executed inside cloned repo
REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo "$(pwd)")")

METADATA_FILE="$LOG_DIR/metadata_${RUN_ID}.txt"

{
    echo "========================================"
    echo " Experiment Metadata"
    echo "========================================"
    echo "Run ID:        $RUN_ID"
    echo "Timestamp:     $(date -u)"
    echo "User:          $USER"
    echo "Host:          $HOSTNAME"
    echo "Repository:    $REPO_NAME"
    echo "Git Commit:    $GIT_COMMIT"
    echo "Working Dir:   $(pwd)"
    echo "----------------------------------------"
    echo "System Info:"
    uname -a
    echo "----------------------------------------"
    echo "Active Network Interfaces:"
    ip -br addr | grep -E "eth|enp"
    echo "----------------------------------------"
    echo "Chrony Version:"
    chronyd -v 2>/dev/null | head -n 1
    echo "----------------------------------------"
    echo "Python Version:"
    python3 --version 2>/dev/null
    echo "========================================"
} > "$METADATA_FILE"

echo "[INFO] Metadata recorded in: $METADATA_FILE"

