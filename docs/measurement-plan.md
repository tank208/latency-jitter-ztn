# Measurement Plan: Latency & Jitter in Zero Trust Networks (NILE Case Study)

**Author:** Will Hall
**Date:** September 18, 2025

---

## 1. Purpose

This document defines the measurement methodology for capturing latency, jitter, and packet loss across two Ubuntu endpoints. The plan covers both baseline LAN testing and NILE Zero Trust integration. Results will be logged in the GitHub repository and later analyzed for inclusion in an academic paper.

---

## 2. Metrics

* **Latency (RTT)** – Round-trip time of ICMP packets (measured with `ping`).
* **Jitter** – Variation in packet delay, calculated from UDP traffic (measured with `iperf3`).
* **Packet Loss** – Percentage of dropped packets (from `ping` and `iperf3`).
* **Clock Sync Offset** – Difference between endpoint system clocks (measured with `chrony`).

---

## 3. Tools

* `ping` – ICMP RTT distribution.
* `iperf3` – UDP latency, jitter, and loss.
* `chrony` – NTP-based clock synchronization.
* Bash scripts (`/scripts/`) for automated capture.

---

## 4. Procedure

### 4.1 Pre-Test Setup

1. Ensure endpoints (Host A, Host B) are running Ubuntu LTS.
2. Install required tools:

   ```bash
   sudo apt update
   sudo apt install -y iperf3 chrony
   ```
3. Synchronize system clocks with Chrony:

   ```bash
   sudo systemctl enable --now chrony
   chronyc tracking
   chronyc sources -v
   ```
4. Confirm both endpoints report stable synchronization (<1 ms offset if possible).

---

### 4.2 Ping Test (ICMP RTT)

**Purpose:** Establish RTT distribution and test ICMP traversal in NILE.

**Command:**

```bash
./scripts/run_ping.sh <target_ip> 200
```

**Output:**

* Minimum / Average / Maximum RTT (ms)
* Packet loss (%)
* Variance (`mdev`)

**Acceptance Target:**

* RTT baseline: ≤5 ms LAN, ≤50 ms NILE overlay
* Loss: ≤0.5%

---

### 4.3 UDP Test (Jitter + Loss)

**Purpose:** Measure jitter and packet loss under controlled UDP stream.

**Commands:**

1. On Host B (server):

   ```bash
   iperf3 -s
   ```
2. On Host A (client):

   ```bash
   ./scripts/run_iperf_udp.sh <server_ip> 10M 30
   ```

**Output:**

* Jitter (ms)
* Packet loss (%)
* Bandwidth delivered (Mbps)

**Acceptance Target:**

* Jitter: ≤5 ms baseline, ≤10 ms NILE overlay
* Loss: ≤1%

---

### 4.4 Clock Sync Verification

**Purpose:** Confirm sub-ms precision in timestamps.

**Command:**

```bash
./scripts/capture_chrony.sh
```

**Output:**

* Chrony tracking offset (ms/µs)
* List of active NTP sources

**Acceptance Target:**

* Clock offset < 1 ms

---

## 5. Data Storage

* All outputs stored under `/data/` with timestamped filenames:

  * `ping_<host>_to_<target>_<date>.txt`
  * `iperf_udp_<host>_to_<server>_<date>.txt`
  * `chrony_<host>_<date>.txt`

* Subfolders:

  * `/data/baseline/` → LAN tests
  * `/data/nile/` → NILE Zero Trust tests

---

## 6. Analysis Approach

1. Extract RTT stats from ping logs (`awk '/rtt/ {print $4}'`).
2. Parse jitter and loss from iperf3 outputs.
3. Compare baseline vs. NILE averages.
4. Visualize data (Markdown tables, Grafana screenshots, or matplotlib plots).

---

## 7. Reporting

* Weekly results summarized in `DEVLOG.md`.
* Graphs and analysis stored in `/analysis/`.
* Interim progress report to faculty at Week 6.
* Academic paper draft by semester’s end.
