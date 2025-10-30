---
title: "Experiment Design – Infrastructure Timing Pivot"
tags: [experiment, design, methodology]
---

## Hypothesis
PTP can maintain sub-millisecond synchronization across RPi and Opta devices in an air-gapped environment without GPS dependency.

## Tools
- chrony, ptp4l, phc2sys
- Wireshark
- Python script for offset logging
- Grafana dashboard for visualization

## Experiments
1. **Baseline (Chrony only)** – record 12-hour drift.
2. **PTP Hardware Timestamping** – enable and compare.
3. **Security Overlay (WireGuard/Tailscale)** – observe added jitter.
4. **Fault Injection** – simulate network delay and measure recovery.
