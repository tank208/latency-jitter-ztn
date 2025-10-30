# Latency & Jitter in Zero Trust Networks (NILE Case Study)

**Student:** Will Hall  
**Faculty:** Dr. John Shovic, Dr. Mary Everett  
**Collaborator:** John Kume, Executive Director – Energy Institute  
**Project Type:** FAFSA Work Study Research (transitioning to EPAF-funded Research)  
**Institution:** University of Idaho – Coeur d’Alene, CS Lab / Energy Institute Collaboration  

---

## Overview
This repository documents an evolving research effort to measure, analyze, and improve **network timing precision and synchronization** in Zero-Trust and industrial environments.  

The project began with baseline **latency and jitter** analysis across isolated and Zero-Trust networks (NILE platform) and is now expanding into **secure, low-cost time synchronization** for electrical and industrial systems under the Energy Institute.

---

## Project Phases

| Phase | Title | Description | Status |
|:------|:-------|:-------------|:--------|
| **01** | [Raspberry Pi Time Sync (NILE Baseline)](./01_RPI_time_sync) | Establishes LAN latency and jitter baselines under NILE Zero Trust configurations. Uses Raspberry Pi 4B nodes, Chrony, and iperf3 for precise measurement. | ✅ Baseline complete |
| **02** | [Infrastructure Timing Pivot (Energy Institute Collaboration)](./02_infrastructure_timing) | Builds on Phase 1 results by integrating micro-PLCs (Arduino Opta) for cyber-physical synchronization studies. Focus: PTP, GPS-independent timing, and secure overlays (Tailscale, WireGuard). | 🧩 In development |
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

### **Phase I – Raspberry Pi Time Sync (NILE Baseline)**
- **Goal:** Quantify latency, jitter, and clock synchronization performance on LAN and Zero Trust Network configurations using the NILE platform.  
- **Hardware:** Raspberry Pi 4B nodes on isolated switch.  
- **Software:** Chrony, iperf3, ping, shell/Python automation.  
- **Deliverables:**
  - Baseline jitter dataset and analysis notebooks.  
  - Repeatable testing framework for Zero Trust comparison.  
  - Academic poster for NILE and CIIR Showcase 2025.  

---

### **Phase II – Infrastructure Timing Pivot (Energy Institute Collaboration)**
- **Goal:** Extend Phase I results toward **cyber-physical infrastructure timing** challenges — particularly secure, GPS-independent synchronization for electrical relays and micro-PLCs.  
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
4. **Resilient PNT Analysis:** Explore GPS-denied synchronization and trustworthiness of timing sources.  
5. **Reporting:** Document, visualize, and publish results for academic and industry audiences.  

---

## Current Status
- ✅ Baseline data collection complete.  
- 🔄 Pivot phase mapping (Energy Institute collaboration).  
- 🧪 Integration and PTP testing scheduled.  

---

## License
MIT License — open for academic and research reuse with attribution.  

---

## Contact
**William Hall**  
Research Assistant – UI CS Lab CDA  
📧 hall4024@vandals.uidaho.edu 🔗 [github.com/tank208](https://github.com/tank208)
