# Baseline Summary: Latency & Jitter (Localhost Dry Run)

**Date:** 2025-09-18
**Host:** T14g2 (Ubuntu LTS)
**Environment:** Localhost loopback (127.0.0.1)
**Tools:** `ping`, `iperf3`, `chrony`

---

## 1. Ping Results (ICMP RTT)

**Command:**

```bash
./scripts/run_ping.sh 127.0.0.1 50
```

**Metrics:**

| Metric          | Value    |
| --------------- | -------- |
| Packets sent    | 50       |
| Packets lost    | 0 (0%)   |
| Min RTT         | 0.030 ms |
| Avg RTT         | 0.068 ms |
| Max RTT         | 0.136 ms |
| mdev (variance) | 0.023 ms |

*Result: Stable sub-0.1 ms RTT with no loss.*

---

## 2. UDP Results (iperf3 Jitter + Loss)

**Command:**

```bash
iperf3 -s   # Terminal A  
./scripts/run_iperf_udp.sh 127.0.0.1 5M 10   # Terminal B
```

**Metrics (10-second run):**

| Run | Bandwidth | Jitter (ms) | Loss (%) |
| --- | --------- | ----------- | -------- |
| 1   | 5.01 Mbps | 0.241       | 0        |
| 2   | 5.01 Mbps | 0.036       | 0        |

*Result: Near-perfect delivery at configured 5 Mbps, jitter consistently <0.3 ms.*

---

## 3. Clock Sync Results (Chrony)

**Command:**

```bash
./scripts/capture_chrony.sh
```

**Metrics:**

| Metric        | Value            |
| ------------- | ---------------- |
| System offset | 77 µs slow       |
| RMS offset    | 293 µs           |
| Ref source    | Vultr NTP server |
| Leap status   | Normal           |

*Result: Host clock synced within <1 ms to NTP reference.*

---

## 4. Observations

* Scripts populate `data/baseline/` with timestamped logs.
* Localhost tests validate the workflow before Raspberry Pis arrive.
* Sub-ms precision achieved, sufficient for industry-level jitter measurement.

---

## 5. Next Steps

* Repeat baseline on **two Pis (LAN)**.
* Compare LAN RTT/jitter to **NILE Zero Trust overlay**.
* Document if ICMP is filtered/allowed in NILE policies.
* Automate parsing → graphs in `/analysis/graphs/`.
