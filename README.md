# Latency & Jitter in Zero Trust Networks

**Student:** Will Hall  
**Faculty:** Dr. John Shovic, Dr. Mary Everett  
**Project Type:** FAFSA Work Study Research (transitioning to EPAF-funded Research)  
**Institution:** University of Idaho – Coeur d’Alene, Center for Intelligent Industrial Robotics (CIIR)
---

## Overview
The project measures latency and jitter in Zero-Trust environments and evaluates Precision Time Protocol (PTP) and Network Time Protocol (NTP) performance in industrial control system (ICS) and operational technology (OT) contexts.

The project began with baseline **latency and jitter** analysis across isolated and Zero-Trust networks (NILE platform) and is now expanding into **secure, low-cost time synchronization** for electrical and industrial systems under the Energy Institute.

---

## Project Phases

| Phase | Title | Description | Status |
|:------|:-------|:-------------|:--------|
| **01** | [Raspberry Pi Time Sync](./01_RPI_time_sync) | Establishes LAN latency and jitter baselines under NILE Zero Trust configurations. Uses Raspberry Pi 4B nodes, Chrony, and iperf3 for precise measurement. | Baseline complete |
| **02** | [Infrastructure Timing Pivot](./02_infrastructure_timing) | Builds on Phase 1 results by integrating micro-PLCs (Arduino Opta) for cyber-physical synchronization studies. Focus: PTP, GPS-independent timing, and secure overlays (Tailscale, WireGuard). | In development |
| **DEVLOG** | [Research Logbook](./DEVLOG) | Daily/weekly development notes, test results, and progress summaries for both phases. | Ongoing |

---

## Repository Structure
```
latency-jitter-ztn/
│
├── 01_RPI_time_sync/ # Phase 1 – NILE baseline testing
│ ├── 01_analysis/ # Data summaries, graphs, notebooks
│ ├── 02_data/baseline/ # Raw latency/jitter logs
│ ├── 03_docs/ # Setup notes, diagrams, test plans
│ └── 04_scripts/ # Automation scripts for tests
│
├── 02_infrastructure_timing/ # Phase 2 – Energy Institute pivot
│ ├── 00_Charter.md # Scope and objectives
│ ├── 01_Existing_Infrastructure_Map.md
│ ├── 02_Pivot_Proposal.md
│ ├── 03_Integration_Plan.md
│ ├── 04_Experiment_Design.md
│ ├── 05_Reporting_Plan.md
│ └── /experiments, /hardware # Data and implementation (planned)
│
├── DEVLOG/ # Research journal entries
├── README.md # This file
└── LICENSE # MIT license
```

---

## Phase Summaries

### **Phase I – Raspberry Pi Time Sync**
- **Goal:** Establishes baseline LAN latency and jitter using synchronized clocks on Raspberry Pi 4B nodes to validate deterministic Ethernet behavior and data acquisition consistency.
- **Hardware:** Raspberry Pi 4B nodes on isolated switch.  
- **Software:** Chrony, iperf3, ping, shell/Python automation.  
- **Deliverables:**
  - Baseline jitter dataset and analysis notebooks.  
  - Repeatable testing framework for Zero Trust comparison.  
  - Academic poster for NILE and CIIR Showcase 2025.  

---

### **Phase II – Infrastructure Timing Pivot**
- **Goal:** Expands to cyber-physical systems by integrating micro-PLCs for hardware-in-loop timing tests, comparing PTP and NTP accuracy under encrypted overlays.  
- **Hardware:** Raspberry Pi 4B + Arduino Opta (micro PLC).  
- **Software:** PTP (IEEE 1588), Chrony, WireGuard/Tailscale overlays.  
- **Deliverables:**
  - Experimental report on PTP vs Chrony precision.  
  - Prototype hybrid RPi–PLC testbed.  
  - Poster and paper submission for Energy Institute Showcase 2026.  

---

## Methodology

1. **Baseline (Phase 1):** Measure network jitter across air-gapped and NILE Zero Trust configurations.  
2. **Infrastructure Integration (Phase 2):** Couple network data with physical control timing.  
3. **Secure Overlay:** Test how encryption layers affect precision.
4. **Compare NTP vs PTP** performance under identical network conditions to quantify trade-offs in accuracy and resource load.
5. **Resilient PNT Analysis:** Explore GPS-denied synchronization and trustworthiness of timing sources.  
6. **Reporting:** Document, visualize, and publish results for academic and industry audiences.  

---

## Current Status
- Baseline data collection complete.  
- Pivot phase mapping (Energy Institute collaboration).  
- Integration and PTP testing scheduled.  

---

## License
MIT License — open for academic and research reuse with attribution.  

---

## Contact
**William Hall**  
Research Assistant – UI CS Lab CDA  
📧 hall4024@vandals.uidaho.edu 🔗 [github.com/tank208](https://github.com/tank208)
