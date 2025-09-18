#!/bin/bash
# Usage: ./capture_chrony.sh
# Captures chrony tracking and sources for clock sync status

DATE=$(date +"%Y%m%d_%H%M%S")
HOST=$(hostname)

OUTDIR="../latency-jitter-ztn/data/baseline"
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
