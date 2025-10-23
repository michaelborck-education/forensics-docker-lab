# Network_Analysis Lab - Student Walkthrough
## PCAP Network Traffic Analysis

**Time Estimate:** 1.5-2 hours
**Difficulty:** Intermediate
**Tools:** tshark, wireshark, strings, grep

---

## 📋 Pre-Lab Setup

### 1. Copy Templates

```bash
cp templates/chain_of_custody.csv cases/Network_Analysis/chain_of_custody.csv
cp templates/analysis_log.csv cases/Network_Analysis/analysis_log.csv
```

### 2. Verify Evidence

```bash
ls -lh evidence/network.cap
```

---

## 🚀 Connecting to the DFIR Workstation

**On macOS/Linux:**
```bash
./scripts/forensics-workstation
```

**On Windows (PowerShell):**
```powershell
.\scripts\forensics-workstation.bat
```

---

## 📦 Part 1: Chain of Custody

```bash
sha256sum /evidence/network.cap
md5sum /evidence/network.cap
```

**📋 Document in chain_of_custody.csv:**
- Evidence_ID: NETWORK-CAP-001
- SHA256_Hash: (paste)
- Evidence_Description: Network packet capture (network.cap)

---

## 📊 Part 2: PCAP Summary

Get overview of the capture:

```bash
# File info
file /evidence/network.cap

# Use tshark to get statistics
tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt
exit_code: 0
note: Get summary of all hosts in network capture
```

---

## 🔍 Part 3: Identify Suspicious Traffic

### Extract DNS Queries

```bash
tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt
exit_code: 0
note: Extract all DNS queries (which domains were contacted?)
```

### Extract HTTP Traffic

```bash
tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt
exit_code: 0
note: Extract HTTP requests (web browsing activity)
```

---

## 🌐 Part 4: Look for IRC (C2 Communication)

IRC uses port 6667 and 6668. Look for suspicious C2:

```bash
# Search for IRC connections
tshark -r /evidence/network.cap -Y "tcp.port==6667 or tcp.port==6668" -T fields -e ip.src -e tcp.dstport > /cases/Network_Analysis/irc_traffic.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "tcp.port==6667 or tcp.port==6668" > /cases/Network_Analysis/irc_traffic.txt
exit_code: 0
note: Search for IRC traffic (C2 Command & Control)
```

Review results:

```bash
cat /cases/Network_Analysis/irc_traffic.txt
```

**Key finding:** If you see IRC connections, this suggests command-and-control malware!

---

## 📤 Part 5: Detect Data Exfiltration

Look for large data transfers:

```bash
# Show all TCP conversations
tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt
exit_code: 0
note: List all TCP connections and data volumes
```

Review for large transfers:

```bash
cat /cases/Network_Analysis/tcp_conversations.txt | sort -k5 -h
```

**Look for:**
- Abnormally large data volumes
- Connections to external IPs
- Connections at unusual times

---

## 🔐 Part 6: Extract Packet Payloads (Advanced)

Export suspicious traffic for analysis:

```bash
# Export packets from specific IP to text
tshark -r /evidence/network.cap -Y "ip.addr==192.168.1.100" -T text > /cases/Network_Analysis/suspicious_ip_packets.txt
```

---

## 📊 Part 7: Timeline Analysis

Create timeline of network events:

```bash
# Extract all TCP SYN packets with timestamps
tshark -r /evidence/network.cap -Y "tcp.flags.syn==1" -T fields -e frame.time -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/connection_timeline.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "tcp.flags.syn==1" > /cases/Network_Analysis/connection_timeline.txt
exit_code: 0
note: Timeline of all connection attempts
```

---

## 🔗 Part 8: Correlate with Other Evidence

Cross-reference network findings with:
- **Memory forensics (Lab 2):** Did you find TrueCrypt? Match with network connections
- **Email analysis (Lab 4):** Were files emailed just before network exfiltration?
- **Disk forensics (Lab 1):** Recovered files match size/timing of network transfers?

Document correlations:

```bash
cat > /cases/Network_Analysis/correlation_notes.txt << 'EOF'
NETWORK FINDINGS CORRELATION

IRC C2 Traffic:
- Found: [yes/no]
- When: [timestamp]
- From: [source IP]
- To: [IRC server IP]
- Correlates to Lab 2?: [TrueCrypt process, PID, timestamp]

Data Exfiltration:
- Large transfer detected: [yes/no]
- Size: [MB]
- When: [timestamp]
- To: [external IP]
- Correlates to Lab 4?: [email sent when?]
- Correlates to Lab 1?: [suspicious files when?]

CONCLUSION:
Are events coordinated? Evidence of planned attack?
EOF
```

---

## 🚪 Part 9: Exit the Workstation

```bash
exit
```

---

## ✅ Deliverables

In `cases/Network_Analysis/`:

- ✅ `chain_of_custody.csv` - Evidence hash
- ✅ `analysis_log.csv` - Commands documented
- ✅ `host_summary.txt` - All hosts in capture
- ✅ `dns_queries.txt` - Domain name lookups
- ✅ `http_traffic.txt` - Web browsing
- ✅ `irc_traffic.txt` - C2 connections
- ✅ `tcp_conversations.txt` - All TCP flows
- ✅ `connection_timeline.txt` - Timeline of connections
- ✅ `correlation_notes.txt` - Cross-reference with other labs

---

## 📊 Analysis Summary

Document findings:

1. **Total packets:** (count)
2. **IRC C2 found:** (yes/no)
3. **Data exfiltration:** (size/destination)
4. **Suspicious domains:** (list)
5. **Timeline:** (when did attack happen?)
6. **Correlation:** (how does this fit with disk/memory/email findings?)

---

## 🆘 Troubleshooting

### "Cannot read PCAP file"
- Verify file format: `file /evidence/network.cap`
- Try: `tshark -r /evidence/network.cap -c 1`

### "No IRC traffic found"
- C2 might use different port
- Look at dns_queries.txt for suspicious domains
- Check other protocols (UDP, SSL)

### "tshark not found"
- Ensure you're inside the workstation
- Check: `which tshark`

---

## 📝 Summary - Quick Commands

```bash
# INSIDE the workstation:

# Hash verification
sha256sum /evidence/network.cap

# Host summary
tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt

# DNS queries
tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt

# HTTP traffic
tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt

# IRC (C2)
tshark -r /evidence/network.cap -Y "tcp.port==6667 or tcp.port==6668" > /cases/Network_Analysis/irc_traffic.txt

# TCP conversations (exfiltration)
tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt

# Exit
exit
```

---

**Remember:** Network evidence often shows HOW the attack happened - crucial for final report!
