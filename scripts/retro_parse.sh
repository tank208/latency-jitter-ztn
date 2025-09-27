#!/bin/bash
# Retroactively parse ping + iperf3 logs into human-readable summaries

OUTCSV="analysis/baseline_retro_summary.csv"
mkdir -p analysis

echo "file,type,start,end,avg_latency_ms,min_latency_ms,max_latency_ms,avg_jitter_ms,avg_bw_kbps" > "$OUTCSV"

for log in "$@"; do
    if [[ $log == *ping*.log ]]; then
        # --- If logs have epoch timestamps (ping -D), extract them ---
        if grep -q '^\[' "$log"; then
            start_epoch=$(head -n 1 "$log" | awk -F'[][]' '{print $2}')
            end_epoch=$(tail -n 1 "$log" | awk -F'[][]' '{print $2}')
            start_human=$(date -d @"$start_epoch" +"%Y-%m-%d %H:%M:%S")
            end_human=$(date -d @"$end_epoch" +"%Y-%m-%d %H:%M:%S")
        else
            start_human="UNKNOWN"
            end_human="UNKNOWN"
        fi

        # --- Extract latency values (ms) ---
        awk -F'time=' '/time=/{print $2}' "$log" | sed 's/ ms//' | \
        awk '{sum+=$1; if(min==""||$1<min)min=$1; if($1>max)max=$1; n++}
             END {if(n>0) printf "%.3f,%.3f,%.3f", sum/n, min, max}' > /tmp/pingstats.txt

        stats=$(cat /tmp/pingstats.txt)
        echo "$log,ping,$start_human,$end_human,$stats,,,," >> "$OUTCSV"

    elif [[ $log == *iperf*.log ]]; then
        # --- Extract first/last time markers for readability ---
        start_time=$(grep 'sec' "$log" | head -n 1 | awk '{print $2}')
        end_time=$(grep 'sec' "$log" | tail -n 1 | awk '{print $2}')

        # --- Jitter + bandwidth averages ---
        awk '/sec/{print $(NF-1), $(NF-3)}' "$log" | \
        awk '{jitter+=$1; bw+=$2; n++} END {if(n>0) printf "%.3f,,%.3f", jitter/n, bw/n}' > /tmp/iperfstats.txt

        stats=$(cat /tmp/iperfstats.txt)
        echo "$log,iperf,$start_time,$end_time,,,,${stats}" >> "$OUTCSV"
    fi
done

echo "[INFO] Retro summaries saved to $OUTCSV"
