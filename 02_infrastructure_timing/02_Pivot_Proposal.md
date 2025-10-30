### Purpose
To evolve the existing Raspberry Pi latency testbed (NILE-ZTS baseline) into a secure time synchronization research platform that aligns with the Energy Institute’s infrastructure resilience goals.

### Summary
Current configuration:
- Two Raspberry Pi 4B nodes
- Air-gapped switch (no external connectivity)
- Chrony-based network latency measurement scripts
- Data collection for baseline jitter analysis

Proposed enhancement:
- Integrate one or more Arduino Opta (micro PLCs) to simulate electrical relay devices.
- Maintain current NILE isolation.
- Add time synchronization experiments (PTP, NTP, hybrid).
- Begin resilience evaluation (GPS loss, overlay encryption).

### Rationale
This builds directly on existing data and hardware, leveraging the NILE setup to explore secure timing in industrial contexts without altering network topology. It satisfies both CIIR (ZTS testing) and Energy Institute (infrastructure protection) objectives.

### Next Step
Request permission from Dr. Shovic to proceed with hardware integration and initial timing experiments.
