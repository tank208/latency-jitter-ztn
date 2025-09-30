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
            if [[ "$start_epoch" =~ ^[0-9]+$ && "$end_epoch" =~ ^[0-9]+$ ]]; then
                start_human=$(date -d @"$start_epoch" +"%Y-%m-%d %H:%M:%S")
                end_human=$(date -d @"$end_epoch" +"%Y-%m-%d %H:%M:%S")
            else
                start_human="UNKNOWN"
                end_human="UNKNOWN"
            fi
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
        # --- Extract first/last interval lines for readability ---
        start_line=$(grep 'sec' "$log" | head -n 1)
        end_line=$(grep 'sec' "$log" | tail -n 1)

        start_time=$(echo "$start_line" | awk '{print $3}')
        end_time=$(echo "$end_line" | awk '{print $3}')

        # --- Parse jitter (ms) and bandwidth (normalize to Kbps) ---
        awk '/sec/ && /bits\/sec/ {
            jitter=""; bw="";
            for(i=1;i<=NF;i++) {
                if($i ~ /ms$/) { gsub("ms","",$i); jitter=$i }
                if($(i+1)=="bits/sec") {
                    bw=$(i)
                    if(bw ~ /Kbits/) { sub("Kbits","",bw); bw_kbps=bw+0 }
                    else if(bw ~ /Mbits/) { sub("Mbits","",bw); bw_kbps=(bw+0)*1000 }
                    else if(bw ~ /Gbits/) { sub("Gbits","",bw); bw_kbps=(bw+0)*1000000 }
                    else { bw_kbps=bw+0 }
                }
            }
            if(jitter != "" && bw_kbps != "") {
                jitter_sum+=jitter; bw_sum+=bw_kbps; n++
            }
        }
        END {
            if(n>0) printf "%.3f,%.3f", jitter_sum/n, bw_sum/n
        }' "$log" > /tmp/iperfstats.txt

        stats=$(cat /tmp/iperfstats.txt)
        echo "$log,iperf,$start_time,$end_time,,,,${stats}" >> "$OUTCSV"
    fi
done

echo "[INFO] Retro summaries saved to $OUTCSV"
