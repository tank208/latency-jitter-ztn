---
title: "Integration Plan: Raspberry Pi + Arduino Opta"
tags: [integration, PLC, hardware]
---

## Objective
Extend the testbed to include a micro-PLC device to simulate relay-level timing behavior.

## Hardware Plan
| Component | Role | Interface | Notes |
|------------|------|------------|-------|
| Arduino Opta | Edge relay simulation | Ethernet (Modbus TCP / MQTT) | Acts as consumer of time data |
| RPi-A | Time source | Ethernet | Maintains PTP master clock |
| RPi-B | Monitor node | Ethernet | Captures timing drift |
| Switch | LAN backbone | N/A | Air-gapped deterministic segment |

## Data Flow
1. RPi-A publishes synchronized time packets.
2. Opta subscribes via Modbus/MQTT.
3. Opta logs local time delta to SD or serial.
4. RPi-B captures both streams and calculates offset.

## Constraints
- Maintain network isolation.
- No GPS or external NTP until baseline established.
- Power via isolated PSU or bench supply.
