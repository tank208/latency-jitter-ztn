## DEVLOG — 2025-09-26

**System:** Pi-Jitter-1 & Pi-Jitter-2 (Raspberry Pi 4, Ubuntu Server LTS)  
**Workstation:** T14G2 (Ubuntu LTS)  
**Project:** RPi Latency Project — Baseline Measurements

### Objectives

- Bring both RPi units online, air-gapped, and accessible via the T14G2 over a dedicated switch.
    
- Establish a reproducible method to run long-term latency and jitter baseline tests without tethering to the T14G2.
    
- Set up a weekend-long unattended run (~67h).
    

### Actions Performed

1. **Networking Setup**
    
    - Verified `netplan` configs on Pis (`192.168.50.11` and `192.168.50.12`).
        
    - Confirmed successful SSH access from T14G2 to each Pi over Cat5 via the lab switch.
        
    - Isolated Pis from the internet (air-gap), but left T14G2 with Wi-Fi enabled for external comms.
        
2. **Baseline Testing**
    
    - Wrote scripts to automate `ping` and `iperf3` tests between Pis.
        
    - Ran a **24h baseline trial** — logs successfully written to `~/pi2pi_baseline_logs`.
        
    - Verified logs could be pulled back to T14G2 via `scp`.
        
3. **Resource Check**
    
    - Checked disk space (`df -h`) and memory (`free -h`) — ample capacity for multi-day runs.
        
    - Confirmed load average remains low, minimal CPU utilization during test.
        
4. **Weekend Run Setup**
    
    - Wrote `pi2pi_weekend.sh` master script:
        
        - Continuous **ping** from Pi-Jitter-1 → Pi-Jitter-2.
            
        - Three sequential **24h iperf3 UDP runs** (1Mbit bandwidth, 10s interval reporting).
            
    - Launched script with `nohup … & disown` so it survives logout.
        
    - Verified via `pgrep` that both ping and iperf3 client are running in background.
        

### Issues Encountered & Fixes

- **iperf3 duration limit:** Initially tried `t=242100s` (67h) which exceeded iperf’s max of 86400s.
    
    - Fix: Broke test into 3 × 24h runs.
        
- **Multiple duplicate processes:** Cleaned up with `pkill` and relaunched controlled master script.
    
- **scp confusion:** Corrected syntax by using quotes around remote path with `*` expansion.
    

### Next Steps (Monday 09-29-25)

1. Stop running jobs (`pkill ping`, `pkill iperf3`).
    
2. Collect logs from `~/pi2pi_baseline_logs` via `scp`.
    
3. Run initial parsing/analysis:
    
    - Ping jitter, packet loss, min/avg/max/σ.
        
    - Iperf throughput and jitter consistency over 72h.
        
4. Decide if we need to extend tests to 1-week runs or add background load (CPU/network).