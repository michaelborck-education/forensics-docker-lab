# Forensics Docker Lab: Overall Investigative Timeline and Story

## Case Background
This lab series simulates a digital forensics investigation into a suspected data exfiltration incident at Cloudcore Inc., a mid-sized software company. On 2025-08-15, IT security detected anomalous network activity and USB usage on employee workstations. The incident response team imaged affected systems (disks, memory) and collected logs, emails, and PCAPs. Your role is a forensic analyst piecing together the timeline of events.

## Key Timeline of Events (Chronological Narrative)
The following outlines the suspected exfiltration storyline, derived from artifacts across all labs. Each lab builds on prior findings to construct a coherent picture.

### Incident Setup (Pre-2025-08-10)
- **Context:** Employee \"Alex Doe\" (suspect) works in engineering with access to proprietary source code and client data.
- **Initial Actions:** Alex copies sensitive files (e.g., `project_secrets.zip`) to a workstation for staging.

### Phase 1: Local Preparation and Deletion (2025-08-10 to 08-12)
- **Disk Activity:** Files are created and mounted (visible in EXT4 timestamps). Deleted files like `flag.txt` (placeholder for secrets) are recovered via carving.
- **Link to Labs:** Lab 1 (Imaging & Triage) – Establish chain-of-custody for `disk.img`, recover deleted artifacts using Sleuth Kit and Foremost, build initial Plaso timeline showing file creation/deletion events around 08-10 14:30-15:00.
- **Key Findings:** Deleted file contained partial project notes; timeline shows mount at `/mnt/usb` followed by deletion to hide tracks.

### Phase 2: Memory Capture and Process Analysis (2025-08-12, 10:00 AM)
- **Activity:** Alex runs a staging script, spawning suspicious processes (e.g., `exfil.exe` disguised as `notepad.exe`).
- **Link to Labs:** Lab 2 (Memory Forensics) – Analyze `memdump.raw` with Volatility 3. Plugins reveal hidden processes (PID 1234: suspicious parent-child tree), network connections to localhost (staging data), and dumped process memory containing encoded file fragments.
- **Key Findings:** Process tree shows injection into legitimate apps; netscan detects outbound prep to IP 192.168.1.100 (suspect's home IP).

### Phase 3: GUI Exploration and Deep Dive (2025-08-12, Afternoon)
- **Activity:** Full filesystem walkthrough identifies metadata anomalies (e.g., modified timestamps on `/home/alex/Documents/secrets/`).
- **Link to Labs:** Lab 3 (Autopsy GUI) – Load `disk.img` into Autopsy via noVNC. Keyword search for \"secret\" yields metadata hits; recover thumbnails of USB drive icons.
- **Key Findings:** Autopsy reports confirm file modifications post-deletion; hash lookups match known good artifacts.

### Phase 4: Email and Log Correlation (2025-08-13)
- **Activity:** Alex emails attachments to external account (`exfil@personal.com`) and inserts USB for physical transfer.
- **Link to Labs:** Lab 4 (Email & Logs) – Parse `mail.mbox` for headers showing sent emails with ZIP attachments (08-13 09:45). Logs (`/var/log/syslog`) show USB mount events (e.g., \"New USB device found, ID 08-13 09:50\") correlating with email timestamps.
- **Key Findings:** Email headers reveal BCC to external domain; logs confirm USB serial \"12345-ABC\" insertion right after email, suggesting staged data transfer.

### Phase 5: Network Exfiltration Confirmation (2025-08-13, 10:30 AM)
- **Activity:** Data transferred over network post-USB staging (large HTTP POST to suspicious server).
- **Link to Labs:** Lab 5 (Network Analysis) – Tshark on `network.pcap` identifies TCP sessions to external IP 203.0.113.50:8080 (08-13 10:32-10:45), with ~50MB transfers matching `project_secrets.zip` size.
- **Key Findings:** Filters show non-standard ports and user-agent strings indicative of custom exfil tool; timestamps align with USB removal log.

### Phase 6: Incident Closure and Reporting (Post-Incident)
- **Overall Impact:** Exfiltrated data includes source code and client PII; potential IP theft.
- **Link to Labs:** Lab 6 (Consolidation) – Correlate all sources into a unified timeline (e.g., Plaso + PCAP + logs). Produce final report for management, recommending employee termination and system purge.

## Visual Timeline Reference
See `forensic_case_timeline.png` (or `.svg`) for a graphical overview of correlated events across sources. Key markers:
- Red: Suspicious actions (deletions, mounts, outbound traffic).
- Blue: Corroborating evidence (timestamps, hashes).
- Green: Chain-of-custody verification points.

## Learning Progression
- **Labs 1-3:** Build foundational skills (disk/memory analysis).
- **Labs 4-5:** Add correlation (logs/email/network).
- **Lab 6:** Synthesize into professional report.

This storyline ensures labs are interconnected: Start with isolated artifacts, end with holistic investigation. Update as needed based on your analysis findings.