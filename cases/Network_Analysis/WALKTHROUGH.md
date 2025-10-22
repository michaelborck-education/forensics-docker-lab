# Lab 5: Network Artifact Analysis - Complete Walkthrough

## Case Context

On **December 6, 2009, 10:30 AM**, forensic analysts detected suspicious outbound traffic from the suspect workstation. A network packet capture was collected. Your job is to analyze the PCAP to identify:

- **IRC C2 Communication** - Command & control server connection
- **Malware Downloads** - Suspicious executable downloads
- **Data Exfiltration** - Large file transfer to external server
- **Timeline Correlation** - Match with disk/memory/email findings

---

## Prerequisites Checklist

- [ ] Completed Labs 1-4 (understand disk/memory/email findings)
- [ ] Read docs/STORYLINE.md (investigation timeline)
- [ ] `evidence/network.pcap` exists (~121 KB)
- [ ] Docker is running
- [ ] Immersive workstation ready: `./scripts/forensics-workstation`

---

## Lab Setup

```bash
mkdir -p cases/Network_Analysis/outputs
```

---

## Step-by-Step Analysis

### Step 1: Enter Workstation & Verify PCAP

**Walkthrough (First Time):**
```bash
./scripts/forensics-workstation
# Inside:
sha256sum /evidence/network.cap
file /evidence/network.cap
```

**Assignment (With CoC):**
```bash
coc-log "sha256sum /evidence/network.cap" "Verify network capture integrity"
coc-log "file /evidence/network.cap" "Identify PCAP file format"
```

**Expected:** Shows PCAP file type, hash recorded.

---

### Step 2: Extract Network Conversations

**Walkthrough:**
```bash
# List all TCP conversations
tshark -r /evidence/network.pcap -q -z conv,tcp | head -20

# List DNS queries
tshark -r /evidence/network.pcap -Y dns -T fields -e dns.qry.name
```

**Assignment (With CoC):**
```bash
coc-log "tshark -r /evidence/network.cap -q -z conv,tcp" "Extract TCP conversations"
coc-log "tshark -r /evidence/network.cap -Y dns -T fields -e dns.qry.name" "Extract DNS queries"
```

**What to look for:**
- Port 6667 (IRC protocol)
- External IPs (not 192.168.x.x or 127.x.x.x)
- Large byte transfers (data exfiltration)

---

### Step 3: Find IRC C2 Traffic

**Walkthrough:**
```bash
# Filter for IRC traffic (port 6667)
tshark -r /evidence/network.cap -Y "tcp.port==6667" -T fields -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport
```

**Assignment (With CoC):**
```bash
coc-log "tshark -r /evidence/network.cap -Y 'tcp.port==6667'" "Filter IRC C2 traffic (port 6667)"
```

**Expected Findings:**
- Connection to `hunt3d.devilz.net` (C2 server)
- Botnet channel #s01 or #sl0w3r
- Process name might show IRC bot activity

**Note:** If you see IRC traffic, document:
- Server IP/hostname
- Timestamp
- Channel names
- Bot nickname (hint: `damn-0262937047`)

---

### Step 4: Identify Malware Downloads

**Walkthrough:**
```bash
# Look for HTTP traffic with .exe files
tshark -r /evidence/network.cap -Y "http and ip.dst == 203.0.113.50" -T fields -e http.host -e http.request.uri
```

**Assignment:**
```bash
coc-log "tshark -r /evidence/network.cap -Y 'http and ip.dst == 203.0.113.50'" "Find HTTP traffic to suspected exfil server"
```

**Expected:**
- Executable files downloaded (ysbinstall_1000489_3.exe, etc.)
- HTTP POSTs to external server
- Large data transfers (~50 MB)

---

### Step 5: Analyze Data Exfiltration

**Walkthrough:**
```bash
# Find large transfers
tshark -r /evidence/network.cap -q -z io,phs | grep -E "^Total|->|bytes"
```

**Assignment:**
```bash
coc-log "tshark -r /evidence/network.cap -q -z io,phs" "Analyze total data flow (protocol hierarchy)"
```

**What to document:**
- **Source IP:** Suspect workstation (internal)
- **Destination:** External server (203.0.113.50:8080)
- **Data Size:** ~50 MB (matches project_secrets.zip size from Lab 1)
- **Timestamp:** 2009-12-06, 10:32-10:45 (matches email in Lab 4)

---

### Step 6: Correlate with Earlier Findings

**Timeline Integration:**

Document connections to previous labs:

| Lab | Finding | Network Evidence |
|-----|---------|------------------|
| Lab 1 | deleted files, project_secrets.zip | ~50MB data transfer matches |
| Lab 2 | TrueCrypt process, outbound TCP | Network shows external connections |
| Lab 4 | Email to exfil@personal.com, USB mount 10:50 AM | IRC C2 active 10:32-10:45 AM |
| Lab 5 | **This lab** | IRC C2 + exfil traffic proves orchestrated attack |

**Assignment:**
```bash
# Document your findings
cat > cases/Network_Analysis/findings.txt << 'EOF'
Network Analysis Findings:
- IRC C2 Connection: hunt3d.devilz.net (port 6667)
- Botnet Channels: #s01, #sl0w3r
- Bot Nickname: damn-0262937047
- Malware Downloaded: ysbinstall_1000489_3.exe (and others)
- Exfiltration Target: 203.0.113.50:8080
- Data Volume: ~50 MB
- Timeline: 2009-12-06 10:32-10:45 UTC
- Correlation: Matches project_secrets.zip from Lab 1
EOF
```

---

## Key Findings Summary

**What you should discover:**

1. ✅ **IRC Botnet C2** - Attacker communicates via IRC channel
2. ✅ **Malware Deployment** - Multiple executables downloaded
3. ✅ **Data Exfiltration** - 50 MB transfer to external server
4. ✅ **Timeline Correlation** - Matches Lab 1-4 findings perfectly
5. ✅ **Attack Orchestration** - IRC bot used for coordinated exfil

---

## Wrap-Up

**Submit:**
- `cases/Network_Analysis/analysis_log.csv` (from coc-log commands)
- `cases/Network_Analysis/findings.txt` (or network_report.md)
- Any exported PCAP analysis files

**For Final Report (Lab 6):**
- Save IRC C2 details (server, channels, timeline)
- Note data size and destination
- Reference this analysis in final timeline

---

*Network forensics reveals the coordination layer of the attack. Combined with disk/memory/email evidence, this proves orchestrated insider threat.*
