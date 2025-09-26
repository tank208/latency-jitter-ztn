# DEVLOG – 2025-09-25

## Objective

Bring two Raspberry Pi 4 Model B units online (Ubuntu Server LTS) in an **air-gapped test network** for long-term latency and jitter baselining.

---

## Work Completed

### Raspberry Pi Setup

- Flashed Ubuntu Server LTS to 32GB microSD cards.
    
- Created `ssh` file and configured `network-config` with static IPs:
    
    - **Pi-Jitter-1** → `192.168.50.11/24`
        
    - **Pi-Jitter-2** → `192.168.50.12/24`
        
- Verified boot status (red + green LEDs) and first login via SSH.
    
- Resolved early issue where Pis were not responding due to mis-indented YAML.
    

### Network Configuration

- Configured **T14g2** with dual-homed setup:
    
    - **Wi-Fi** → internet (default route).
        
    - **Ethernet (enp5s0)** → static IP `192.168.50.1/24`, isolated subnet with Pis.
        
- Verified ICMP connectivity between T14g2 ↔ Pi-Jitter-1 with clean sub-millisecond latency.
    
- Created permanent `netplan` entry on T14g2 (`/etc/netplan/99-pi-lab.yaml`) for Ethernet.
    

### Package Installation

- Installed `iperf3` on Pis via **temporary NAT from T14g2**:
    
    - Enabled IP forwarding and iptables NAT rules.
        
    - Applied gateway/DNS config to Pis, verified external connectivity.
        
    - Ran `apt update && apt install -y iperf3` on each Pi.
        
    - Removed NAT rules and disabled forwarding, restoring full air-gap.
        
- Upgraded both Pis and created a **snapshot script** to capture system state:
    
    - Kernel version, OS release, package list, IP config, and hostname saved under `~/system_state/`.
        

### Baseline Testing Scripts

- Built **baseline_test.sh** on T14g2 to coordinate long-term ping and iperf3 UDP tests to both Pis.
    
- Decided final tests should be **Pi-to-Pi only** (exclude T14g2 datapath).
    
- Developed **pi2pi_baseline.sh** to run from Pi-Jitter-1 against Pi-Jitter-2, capturing:
    
    - Continuous ICMP ping logs.
        
    - 24h UDP jitter test logs.
        
- Discussed execution persistence: `nohup` for short-term runs, `systemd` service for professional long-term unattended execution.
    

---

## Lessons Learned

- **YAML indentation** in `network-config` is critical — a single tab can break static IP assignment.
    
- Raspberry Pi LED codes are the fastest way to confirm boot vs. SD card errors.
    
- Dual-homed laptop configuration allows safe isolation: internet on Wi-Fi, lab subnet on Ethernet.
    
- The right approach for ICS-style labs is to **freeze environment after upgrade** for consistent baseline measurements.
    
- Direct Pi↔Pi testing ensures cleaner data without management station bias.
    

---

## Next Steps

- Convert `pi2pi_baseline.sh` into a **systemd service** for fully unattended runs.
    
- Automate **log collection back to T14g2** after each run (e.g., nightly `scp`).
    
- Parse log data into CSV format for ingestion into Grafana/matplotlib.
    
- Extend testing to include **reverse direction** (Pi-Jitter-2 → Pi-Jitter-1) for asymmetry analysis.
    
