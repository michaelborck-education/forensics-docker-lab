# Forensic Lab 5: Network Artifact Analysis

**Goal:** Analyse a packet capture (PCAP) to detect suspicious exfiltration.

**Skills:**  
- Use tshark/Wireshark in Docker.  
- Identify suspicious connections (IP, port, time).  
- Correlate with logs and USB events.  

---

## 🚀 Quick Start - Immersive Workstation

**Mac/Linux:** `./scripts/forensics-workstation`
**Windows:** `.\scripts\forensics-workstation.ps1`

---

## Evidence
- `evidence/network.pcap`

---

## Tasks
1. Hash the PCAP file (record in chain_of_custody).
2. Run tshark to list connections.
3. Identify suspicious sessions (large transfers, odd ports).
4. Document in `network_report.md` - Start with: `cp templates/WORKBOOK.md cases/Network_Analysis/network_report.md`  

---

## Deliverables
- `cases/Network_Analysis/connections.txt`  
- `cases/Network_Analysis/network_report.md`
