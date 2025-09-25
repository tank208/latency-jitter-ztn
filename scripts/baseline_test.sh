#!/bin/bash
# baseline_test.sh – 24h latency/jitter baseline
# Run from T14g2

# Config
PI1=192.168.50.11
PI2=192.168.50.12
LOGDIR="$HOME/01_ZTN/latency-jitter-ztn/scripts/data/baseline"
DURATION=86400     # 24 hours in seconds

mkdir -p "$LOGDIR"

timestamp=$(date +%Y%m%d_%H%M%S)

echo "[INFO] Starting baseline test at $timestamp for $DURATION seconds"
echo "[INFO] Logs saved to $LOGDIR"

# --- Start continuous ping ---
ping -i 1 -D $PI1 > "$LOGDIR/ping_pi1_${timestamp}.log" &
PING1_PID=$!
ping -i 1 -D $PI2 > "$LOGDIR/ping_pi2_${timestamp}.log" &
PING2_PID=$!

# --- Start iperf3 UDP jitter test ---
# (assumes iperf3 -s is running on both Pis)
iperf3 -c $PI1 -u -b 1M -t $DURATION -i 10 > "$LOGDIR/iperf_pi1_${timestamp}.log" &
IPERF1_PID=$!
iperf3 -c $PI2 -u -b 1M -t $DURATION -i 10 > "$LOGDIR/iperf_pi2_${timestamp}.log" &
IPERF2_PID=$!

# --- Wait full duration ---
sleep $DURATION

# --- Cleanup ---
kill $PING1_PID $PING2_PID 2>/dev/null

echo "[INFO] Baseline test complete at $(date +%Y%m%d_%H%M%S)"
