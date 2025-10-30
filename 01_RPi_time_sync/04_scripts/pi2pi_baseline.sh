#!/bin/bash
# Auto-log metadata before starting test
SCRIPT_DIR="$(dirname "$0")"
"$SCRIPT_DIR/log_metadata.sh" "/home/Research/latency-jitter-ztn/01_RPi_time_sync/02_data"
RUN_ID=$(date +"%Y%m%d_%H%M%S")
META_FILE="/home/Research/latency-jitter-ztn/01_RPi_time_sync/02_data_${RUN_ID}.txt"
iperf3 -c 192.168.10.11 -u -t 60 | tee "iperf_pi1_to_pi2_${RUN_ID}.log"
echo "Metadata: $META_FILE" >> "iperf_pi1_to_pi2_${RUN_ID}.log"

# pi2pi_baseline.sh – 24h Pi↔Pi baseline latency + jitter

PI2=192.168.50.12         # IP of Pi-Jitter-2
LOGDIR="$HOME/pi2pi_baseline_logs"
DURATION=86400            # 24 hours

mkdir -p "$LOGDIR"

timestamp=$(date +%Y%m%d_%H%M%S)

echo "[INFO] Starting Pi↔Pi baseline at $timestamp for $DURATION seconds"
echo "[INFO] Logs will be saved in $LOGDIR"

# --- Start continuous ping ---
ping -i 1 -D $PI2 > "$LOGDIR/ping_pi1_to_pi2_${timestamp}.log" &
PING_PID=$!

# --- Start iperf3 UDP jitter test ---
iperf3 -c $PI2 -u -b 1M -t $DURATION -i 10 > "$LOGDIR/iperf_pi1_to_pi2_${timestamp}.log" &
IPERF_PID=$!

# --- Wait ---
sleep $DURATION

# --- Cleanup ---
kill $PING_PID 2>/dev/null

echo "[INFO] Baseline complete at $(date +%Y%m%d_%H%M%S)"

# Build manifest linking data logs and metadata
python3 /home/Research/latency-jitter-ztn/01_RPi_time_sync/04_scripts/build_manifest.py \
	/home/Research/latency-jitter-ztn/01_RPi_time_sync/02_data /home/Research/latency-jitter-ztn/01_RPi_time_sync/02_data/baseline

