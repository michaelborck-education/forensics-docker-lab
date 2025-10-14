# Forensic Lab 5: Network Artifact Analysis

**Goal:** Analyse a packet capture (PCAP) to detect suspicious exfiltration.

**Skills:**  
- Use tshark/Wireshark in Docker.  
- Identify suspicious connections (IP, port, time).  
- Correlate with logs and USB events.  

---

## Evidence
- `evidence/network.pcap`

---

## Tasks
1. Hash the PCAP file (record in chain_of_custody).  
2. Run tshark to list connections:  
   ```bash
   docker run --rm -v $PWD/evidence:/evidence:ro corfr/tshark -r /evidence/network.pcap -q -z conv,tcp > cases/Lab_5/connections.txt
   ```

3. Identify suspicious sessions (large transfers, odd ports).  
4. Document in `network_report.md`.  

---

## Deliverables
- `cases/Lab_5/connections.txt`  
- `cases/Lab_5/network_report.md`
