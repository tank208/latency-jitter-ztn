#!/bin/bash
# sync_pi_logs.sh – Pull logs from Pi-Jitter-1 into local baseline folder

PI_USER="hall4024"
PI_HOST="192.168.50.11"
PI_LOGDIR="/home/${PI_USER}/pi2pi_baseline_logs"
LOCAL_BASE="$HOME/01_ZTN/latency-jitter-ztn/scripts/data/baseline"

# Create dated subdir for this sync
DATESTAMP=$(date +%Y-%m-%d_%H%M)
DEST="${LOCAL_BASE}/${DATESTAMP}"
mkdir -p "$DEST"

echo "[INFO] Syncing logs from ${PI_USER}@${PI_HOST}:${PI_LOGDIR} to $DEST"

# rsync with progress
rsync -avz --progress "${PI_USER}@${PI_HOST}:${PI_LOGDIR}/" "$DEST/"

echo "[INFO] Sync complete. Logs are in $DEST"
