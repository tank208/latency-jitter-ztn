# Baseline Test Protocol – Phase 1 (RPi → RPi)

**Experiment ID:**  
YYYYMMDD_HHMM (auto timestamp)  

**Operator:**  
Will Hall  

**Objective:**  
Measure baseline latency, jitter, and clock offset between two Raspberry Pi 4B nodes on an air-gapped LAN using Chrony and iperf3.  
This test validates deterministic timing behavior before applying Zero Trust or PTP layers.

---

## 1. Hardware / Network Configuration

| Parameter | Description |
|------------|-------------|
| Devices | RPi-A (master), RPi-B (slave) |
| OS | Ubuntu 24.04 (64-bit) |
| Network | Gigabit unmanaged switch (air-gapped) |
| Power | Bench supply / identical PSU |
| Time Source | Chrony (master local stratum 10) |
| Test Duration | 12 hours (minimum) |

---

## 2. Scripts Used

| Script | Path | Purpose |
|---------|------|----------|
| `pi2pi_baseline.sh` | `/04_scripts/pi2pi_baseline.sh` | Launches baseline iperf3 tests and logs transfer stats. |
| `capture_chrony.sh` | `/04_scripts/capture_chrony.sh` | Captures offset data from chrony tracking every interval. |
| `parse_results.sh` | `/04_scripts/parse_results.sh` | Extracts jitter/offset metrics into CSV for analysis. |
| `sync_pi_logs.sh` | `/04_scripts/sync_pi_logs.sh` | (optional) Syncs log files to main system for archiving. |

**Command Invocation:**
```bash
./pi2pi_baseline.sh
./capture_chrony.sh &
```

---
## 3. Data Files Generated
| File                               | Description                          |
| ---------------------------------- | ------------------------------------ |
| `iperf_pi1_to_pi2_<timestamp>.log` | iperf3 throughput & jitter results   |
| `chrony_log_<timestamp>.txt`       | Chrony offset / delay output         |
| `offsets.csv`                      | Parsed offset dataset for graphing   |
| `summary.json`                     | Auto-generated test summary (future) |


## 4. Key Parameters
| Metric                 | Value / Observation |
| ---------------------- | ------------------- |
| Average RTT (ping)     |                     |
| Mean jitter (ms)       |                     |
| Max jitter (ms)        |                     |
| Mean clock offset (µs) |                     |
| Max offset (µs)        |                     |
| Packet loss (%)        |                     |
| Bandwidth (Mbit/s)     |                     |


## 5. Observations

- Environmental notes (temperature, cable, switch).
- CPU load or throttling events.
- Any anomalies in offset drift or jitter spikes.

## 6. Parsing / Analysis

Run after test completion:
```
./parse_results.sh iperf_pi1_to_pi2_<timestamp>.log
./parse_results.sh chrony_log_<timestamp>.txt
```

Output CSVs are stored under:
```
01_RPI_time_sync/02_data/baseline/
```

Graphs generated with:
```
python3 plot_offsets.py offsets.csv
```

## 7. Conclusions / Next Steps
| Action                           | Responsible | Target Date |
| -------------------------------- | ----------- | ----------- |
| Validate Chrony offset stability | Will Hall   |             |
| Compare against PTP baseline     | Will Hall   |             |
| Integrate overlay encryption     |             |             |

