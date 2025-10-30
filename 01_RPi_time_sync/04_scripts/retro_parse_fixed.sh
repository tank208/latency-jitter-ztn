#!/bin/bash
# Retroactively parse ping + iperf3 logs into human-readable summaries

OUTCSV="analysis/baseline_retro_summary.csv"
mkdir -p analysis

echo "file,type,start,end,avg_latency_ms,min_latency_ms,max_latency_ms,avg_jitter_ms,avg_bw_kbps" > "$OUTCSV"

for log in "$@"; do
    if [[ $log == *ping*.log ]]; then
        # --- Extract epoch timestamps ---
        if grep -q '^\[' "$log"; then
            start_epoch=$(head -n 2 "$log" | grep '^\[' | head -n 1 | awk -F'[][]' '{print $2}' | cut -d'.' -f1)
            end_epoch=$(tail -n 1 "$log" | awk -F'[][]' '{print $2}' | cut -d'.' -f1)
            
            if [[ "$start_epoch" =~ ^[0-9]+$ && "$end_epoch" =~ ^[0-9]+$ ]]; then
                start_human=$(date -d @"$start_epoch" +"%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "UNKNOWN")
                end_human=$(date -d @"$end_epoch" +"%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "UNKNOWN")
            else
                start_human="UNKNOWN"
                end_human="UNKNOWN"
            fi
        else
            start_human="UNKNOWN"
            end_human="UNKNOWN"
        fi

        # --- Extract latency values (ms) - handle "time=0.333 ms" format ---
        grep 'time=' "$log" | sed 's/.*time=//; s/ ms.*//' | \
        awk '{
            sum+=$1; 
            if(NR==1) min=$1; 
            if($1<min) min=$1; 
            if($1>max) max=$1; 
            n++
        }
        END {
            if(n>0) printf "%.3f,%.3f,%.3f", sum/n, min, max
            else printf ",,"
        }' > /tmp/pingstats.txt

        stats=$(cat /tmp/pingstats.txt)
        echo "$log,ping,$start_human,$end_human,$stats,,,," >> "$OUTCSV"

    elif [[ $log == *iperf*.log ]]; then
        # --- Extract first/last interval from data lines ---
        start_interval=$(grep -E '^\[.*\].*[0-9]+-[0-9]+.*sec.*bits/sec' "$log" | head -n 1 | awk '{print $2}' 2>/dev/null || echo "UNKNOWN")
        end_interval=$(grep -E '^\[.*\].*[0-9]+-[0-9]+.*sec.*bits/sec' "$log" | tail -n 1 | awk '{print $2}' 2>/dev/null || echo "UNKNOWN")

        # --- Parse bandwidth and jitter ---
        # Check if this is a UDP test with jitter column or just bandwidth
        has_jitter=$(grep -E '^\[.*\].*sec.*bits/sec.*ms' "$log" | head -n 1)
        
        if [[ -n "$has_jitter" ]]; then
            # Parse UDP with jitter (format: ... Mbits/sec ... ms)
            grep -E '^\[.*\].*sec.*bits/sec' "$log" | awk '
            {
                jitter=""; bw_kbps="";
                
                # Look for jitter value (number followed by ms, typically after bits/sec)
                for(i=1;i<=NF;i++) {
                    if($i ~ /^[0-9.]+$/ && $(i+1) == "ms") {
                        jitter=$i
                    }
                    # Look for bandwidth
                    if($(i+1) == "Kbits/sec") {
                        bw_kbps=$i+0
                    }
                    else if($(i+1) == "Mbits/sec") {
                        bw_kbps=($i+0)*1000
                    }
                    else if($(i+1) == "Gbits/sec") {
                        bw_kbps=($i+0)*1000000
                    }
                    else if($(i+1) == "bits/sec") {
                        bw_kbps=($i+0)/1000
                    }
                }
                
                if(jitter != "" && bw_kbps != "") {
                    jitter_sum+=jitter; bw_sum+=bw_kbps; n++
                }
            }
            END {
                if(n>0) printf "%.3f,%.3f", jitter_sum/n, bw_sum/n
                else printf ","
            }' > /tmp/iperfstats.txt
        else
            # Parse bandwidth only (UDP without jitter or TCP)
            grep -E '^\[.*\].*sec.*bits/sec' "$log" | awk '
            {
                bw_kbps="";
                
                # Look for bandwidth
                for(i=1;i<=NF;i++) {
                    if($(i+1) == "Kbits/sec" || $(i+1) == "Kbits") {
                        bw_kbps=$i+0
                    }
                    else if($(i+1) == "Mbits/sec" || $(i+1) == "Mbits") {
                        bw_kbps=($i+0)*1000
                    }
                    else if($(i+1) == "Gbits/sec" || $(i+1) == "Gbits") {
                        bw_kbps=($i+0)*1000000
                    }
                    else if($(i+1) == "bits/sec") {
                        bw_kbps=($i+0)/1000
                    }
                }
                
                if(bw_kbps != "") {
                    bw_sum+=bw_kbps; n++
                }
            }
            END {
                if(n>0) printf ",%0.3f", bw_sum/n
                else printf ","
            }' > /tmp/iperfstats.txt
        fi

        stats=$(cat /tmp/iperfstats.txt)
        echo "$log,iperf,$start_interval,$end_interval,,,,${stats}" >> "$OUTCSV"
    fi
done

echo "[INFO] Retro summaries saved to $OUTCSV"
echo ""
echo "=== Summary ==="
column -t -s',' "$OUTCSV"
