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

