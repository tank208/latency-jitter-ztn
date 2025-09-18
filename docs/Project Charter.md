# Project Charter: Latency & Jitter in Zero Trust Networks (NILE Case Study)

**Student Researcher:** Will Hall  
**Faculty Leads:** Dr. John Shovic, Dr. Mary Everett  
**Project Type:** FAFSA Work Study Research  
**Date:** September 17, 2025

---

## 1. Background & Rationale

Zero Trust networking (ZTN) platforms, such as the NILE campus solution, are designed to enforce identity-based segmentation, granular policy control, and continuous monitoring. While these systems address access and security challenges, a critical gap remains in understanding how latency and jitter affect industrial and operational technology environments where deterministic communication is essential.

This project establishes a reproducible testbed using Ubuntu-based endpoints to measure latency and jitter across both baseline (LAN) and NILE Zero Trust environments. The results will be used to provide an academic paper submission to NILE, highlighting jitter as an under-addressed factor in Zero Trust adoption for industry use cases.

---

## 2. Objectives

1. Establish two Ubuntu endpoints as test devices
2. Collect **baseline measurements** of latency, jitter, and packet loss using tools such as `ping`, `iperf3`, and `chrony` (for synchronized clocks).
3. Onboard the endpoints to the NILE Zero Trust server (pending IT support).
4. Validate whether ICMP traffic (ping) traverses NILE firewall/policy enforcement.
5. Compare **baseline vs. NILE** latency/jitter performance.
6. Document methodology, data, and analysis in a GitHub repository.
7. Deliver a **formal academic paper draft** on jitter measurement for submission to NILE.

---

## 3. Deliverables (Next 4 Weeks)

- **Week 1-2**:
    
    - Obtain test hardware.
    - Set up Ubuntu + baseline connectivity.
    - Initialize GitHub repository with `README.md`, `DEVLOG.md`, `/docs`, `/data`, `/analysis`.
    - Draft Gantt chart and system diagram.
        
- **Week 3-4**:
    
    - Implement `ping` + `iperf3` UDP testing between endpoints on LAN.
    - Configure `chrony` for time synchronization.
    - Test whether ICMP (ping) is permitted through NILE policies.
    - Collect baseline latency/jitter datasets.
    - Document results in repo.
        
- **Week 5-6**:
    
    - Coordinate with IT for NILE endpoint registration.
    - Replicate baseline tests through NILE.
    - Begin comparative analysis of jitter performance.
        
- **Week 6+**:
    
    - Consolidate data, generate graphs (Markdown or Grafana screenshots).
    - Draft paper sections: Abstract, Background, Methods, Preliminary Results.
    - Submit progress summary to Shovic/Everett for review.

---

## 4. Resources & Constraints

- **Resources**:
    
    - Ubuntu endpoints (lab hardware).
    - Ubuntu LTS operating system.
    - Open-source tools (`iperf3`, `chrony`, `ping`, Prometheus/Grafana optional).
    - GitHub repo for version control.
    
- **Constraints**:
    
    - Work study cap: $1000/semester (~55 hours at $16/hr).
    - Additional funding will be required (via EPAF or departmental support)
    - IT support required for NILE access (currently pending).

---

## 5. Success Criteria

- Working testbed with two endpoints exchanging traffic.
- Synchronized system clocks to support sub-ms jitter measurement.
- Baseline latency/jitter dataset documented in GitHub.
- Successful integration with NILE server (pending IT).
- Academic paper completed and reviewed by faculty by semester’s end.

---

## 6. Risks & Mitigations

- **IT Delay**: Baseline testing will proceed on LAN while awaiting NILE access.
- **Hardware availability**: Secure devices early via Everett.
- **Funding limits**: Track hours carefully; transition to EPAF once FAFSA allotment is reached.
- **Measurement Accuracy**: Use synchronized clocks (`chrony`) to ensure jitter measurements reflect true network variance.

---

**Approval**

- Dr. John Shovic: ____________
    
- Dr. Mary Everett: ____________