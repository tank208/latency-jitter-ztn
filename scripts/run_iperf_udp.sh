#!/bin/bash
# Usage: ./run_iperf_udp.sh <server_ip> <bandwidth> <duration>
# Example: ./run_iperf_udp.sh 192.168.1.102 10M 30

SERVER=$1
BANDWIDTH=${2:-10M}  # default 10 Mbps
DURATION=${3:-30}    # default 30s
DATE=$(date +"%Y%m%d_%H%M%S")
HOST=$(hostname)

OUTDIR="$(pwd)/data/baseline"
mkdir -p $OUTDIR

OUTFILE="$OUTDIR/iperf_udp_${HOST}_to_${SERVER}_$DATE.txt"

echo "Running iperf3 UDP test from $HOST to $SERVER at $BANDWIDTH for $DURATION seconds..."
iperf3 -c $SERVER -u -b $BANDWIDTH -t $DURATION -i 1 | tee $OUTFILE

echo "Results saved to $OUTFILE"
