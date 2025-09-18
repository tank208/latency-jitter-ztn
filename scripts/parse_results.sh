#!/bin/bash
# Parse ping and iperf3 results into a CSV for analysis
# Usage: ./scripts/parse_results.sh

OUTDIR="$(pwd)/data/baseline"
CSV="$(pwd)/analysis/baseline_metrics.csv"

mkdir -p "$(pwd)/analysis"

# Write CSV header if file does not exist
if [ ! -f "$CSV" ]; then
  echo "date,host,target,type,avg_rtt_ms,jitter_ms,loss_percent" > "$CSV"
fi

# Parse ping logs
for f in $OUTDIR/ping_*.txt; do
  [ -e "$f" ] || continue
  DATE=$(echo $f | grep -oE '[0-9]{8}_[0-9]{6}')
  HOST=$(echo $f | cut -d'_' -f2)
  TARGET=$(echo $f | cut -d'_' -f4)

  # Extract avg RTT and loss
  AVG_RTT=$(grep "rtt" $f | awk -F'/' '{print $5}')
  LOSS=$(grep "packet loss" $f | awk '{print $6}' | tr -d '%')

  echo "$DATE,$HOST,$TARGET,ping,$AVG_RTT,,${LOSS}" >> "$CSV"
done

# Parse iperf UDP logs
for f in $OUTDIR/iperf_udp_*.txt; do
  [ -e "$f" ] || continue
  DATE=$(echo $f | grep -oE '[0-9]{8}_[0-9]{6}')
  HOST=$(echo $f | cut -d'_' -f3)
  TARGET=$(echo $f | cut -d'_' -f5)

  # Extract jitter and loss
  JITTER=$(grep "receiver" $f | awk '{print $(NF-3)}')
  LOSS=$(grep "receiver" $f | awk '{print $NF}' | tr -d '()%')

  echo "$DATE,$HOST,$TARGET,iperf,,${JITTER},${LOSS}" >> "$CSV"
done

echo "Parsed results saved to $CSV"
