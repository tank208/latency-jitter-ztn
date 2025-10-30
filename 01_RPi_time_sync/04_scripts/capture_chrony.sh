#!/bin/bash
# Auto-log metadata before starting test
SCRIPT_DIR="$(dirname "$0")"
"$SCRIPT_DIR/log_metadata.sh" "/home/Research/latency-jitter-ztn/01_RPi_time_sync/02_data"

# Usage: ./capture_chrony.sh
# Captures chrony tracking and sources for clock sync status

DATE=$(date +"%Y%m%d_%H%M%S")
HOST=$(hostname)

OUTDIR="$(pwd)/data/baseline"
mkdir -p $OUTDIR

OUTFILE="$OUTDIR/chrony_${HOST}_$DATE.txt"

{
  echo "=== Chrony Tracking ==="
  chronyc tracking
  echo
  echo "=== Chrony Sources ==="
  chronyc sources -v
} | tee $OUTFILE

echo "Results saved to $OUTFILE"

# Build manifest linking data logs and metadata
python3 /home/Research/latency-jitter-ztn/01_RPi_time_sync/04_scripts/build_manifest.py \
        /home/Research/latency-jitter-ztn/01_RPi_time_sync/02_data /home/Research/latency-jitter-ztn/01_RPi_time_sync/02_data/baseline

