# Lab 5 Instructor Notes - Network Forensics

## Overview
Lab 5 teaches network artifact analysis and correlation with earlier evidence findings. Students analyze PCAP files to identify IRC botnet C2 communication, malware downloads, and data exfiltration traffic.

## Key Teaching Points
- Network analysis as final evidence correlation piece
- IRC botnet identification and command tracking
- Correlating PCAP timestamps with disk/memory/email findings
- Large file transfers as exfiltration indicators

## Expected Student Findings
- IRC C2 server: hunt3d.devilz.net
- Botnet channel: #s01 and #sl0w3r
- Malware downloads: bbnz.exe, jocker.exe, ysbinstall_1000489_3.exe
- Exfiltration server: 203.0.113.50:8080
- Transfer volume: ~50MB matching project_secrets.zip size
- Timeline correlation: 2009-12-06, 10:32-10:45

## Evidence Verification
- `evidence/network.cap` should contain IRC traffic to hunt3d.devilz.net
- Consider checking network.cap was created correctly if students can't find expected packets

## Common Mistakes
1. Not filtering for IRC protocol (port 6667)
2. Forgetting to correlate PCAP timestamps with other evidence
3. Missing HTTP POST to exfil server due to packet size
4. Not noting suspicious executables in traffic

## Assessment Tips
- Award points for IRC identification even if exact C2 domain differs
- Accept any port 6667 traffic to suspicious hosts as C2 indication
- Check for correlation attempt with other labs (timeline matching)
