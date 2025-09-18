#!/bin/bash
# Usage: ./run_ping.sh <target_ip> <count>
# Example: ./run_ping.sh 192.168.1.102 200

TARGET=$1
COUNT=${2:-200}   # default 200 if not provided
DATE=$(date +"%Y%m%d_%H%M%S")
HOST=$(hostname)

OUTDIR="$(pwd)/data/baseline"
mkdir -p $OUTDIR

OUTFILE="$OUTDIR/ping_${HOST}_to_${TARGET}_$DATE.txt"

echo "Running ping from $HOST to $TARGET for $COUNT packets..."
ping -c $COUNT $TARGET | tee $OUTFILE

echo "Results saved to $OUTFILE"
