---
title: "Existing NILE/RPi Infrastructure Map"
tags: [infrastructure, mapping, baseline]
---

## Hardware Inventory
| Node   | Device                | OS           | Function                             |
| ------ | --------------------- | ------------ | ------------------------------------ |
| RPi-A  | Raspberry Pi 4B (8GB) | Ubuntu 24.04 | Master node, PTP source              |
| RPi-B  | Raspberry Pi 4B (8GB) | Ubuntu 24.04 | Slave node, latency monitor          |
| Switch | TP-Link Gigabit       | Air-gapped   | Isolated LAN for deterministic tests |

## Network Layout
```css
                 ┌──────────────────────────────┐
                 │   CONTROL LAPTOP (Ubuntu)    │
                 │  • Data collection           │
                 │  • Visualization / Grafana   │
                 └────────────┬─────────────────┘
                              │
                    Air-gapped Ethernet switch
                              │
        ┌─────────────────────┼──────────────────────┐
        │                     │                      │
┌────────────┐        ┌────────────┐        ┌────────────────┐
│   RPi-A    │        │   RPi-B    │        │  Arduino Opta  │
│ PTP Master │        │ PTP Slave  │        │  (Micro PLC)   │
│ Chrony/ptp4l│       │ phc2sys    │        │ Modbus / MQTT  │
└────────────┘        └────────────┘        └────────────────┘
```

## Current Configuration
- Chrony running on both nodes
- Logging offset/jitter to CSV
- No GPS input, no ZTS overlay
