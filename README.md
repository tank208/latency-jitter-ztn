# Latency & Jitter in Zero Trust Networks (NILE Case Study)

**Student:** Will Hall  
**Faculty:** Dr. John Shovic, Dr. Mary Everett  
**Project Type:** FAFSA Work Study Research (transitioning to EPAF as needed)  

## Overview
This repository contains the research artifacts for measuring latency and jitter 
in Zero Trust environments using the NILE campus platform. The project explores 
baseline LAN performance, NILE Zero Trust integration, and the implications 
for industrial/operational technology.

## Objectives
- Baseline LAN testing (ping, iperf3, chrony)
- Validate ICMP traversal in NILE policy enforcement
- Compare baseline vs. NILE latency and jitter
- Document results and analysis
- Produce an academic paper for NILE

## Repo Structure
- `docs/` — project charter, diagrams, measurement plans
- `data/` — raw logs (baseline vs. NILE)
- `analysis/` — summaries, graphs, notebooks
- `scripts/` — automation scripts for tests
- `DEVLOG.md` — daily/weekly logs

## Targets
- Sub-ms jitter measurement with synchronized clocks
- RTT goal: ≤50 ms baseline, ultimate target ~5 ms

## License
MIT License
