# Email_Logs Lab - Student Walkthrough
## Email & System Log Analysis

**Time Estimate:** 1.5-2.5 hours
**Difficulty:** Intermediate
**Tools:** grep, awk, Python, text analysis tools

---

## 📋 Pre-Lab Setup

### 1. Copy Templates to Your Lab Folder

```bash
cp templates/chain_of_custody.csv cases/Email_Logs/chain_of_custody.csv
cp templates/analysis_log.csv cases/Email_Logs/analysis_log.csv
```

### 2. Verify Evidence Files

```bash
# On your host machine
ls -lh evidence/
# You should see: mail.mbox, network.cap, and possibly logs/
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

## 📧 Part 1: Chain of Custody - Hash Email Evidence

```bash
sha256sum /evidence/mail.mbox
md5sum /evidence/mail.mbox
```

**📋 Document in chain_of_custody.csv:**
- Evidence_ID: EMAIL-001
- SHA256_Hash: (paste hash)
- Analyst_Name: (your name)
- Evidence_Description: Mailbox file (mail.mbox) containing email evidence

---

## 📨 Part 2: Extract Email Headers

Mailbox (.mbox) files are text-based collections of emails. Extract headers to see sender, recipient, date, subject:

```bash
# List all senders and recipients
grep -E "^From:|^To:|^Date:|^Subject:" /evidence/mail.mbox > /cases/Email_Logs/email_headers.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep -E "^From:|^To:|^Date:|^Subject:" /evidence/mail.mbox > /cases/Email_Logs/email_headers.txt
exit_code: 0
note: Extract email headers (sender, recipient, date, subject)
```

Review the headers:

```bash
cat /cases/Email_Logs/email_headers.txt
```

**What to look for:**
- Emails to suspicious external addresses
- Timing patterns (batch of emails sent at specific time?)
- Large attachments mentioned in subject

---

## 🔍 Part 3: Search for Sensitive Keywords in Email

```bash
# Search for suspicious keywords
grep -i "confidential\|secret\|password\|admin\|export\|backup" /evidence/mail.mbox > /cases/Email_Logs/email_keywords.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep -i "confidential|secret|password|admin|export|backup" /evidence/mail.mbox > /cases/Email_Logs/email_keywords.txt
exit_code: 0
note: Search for sensitive keywords in email content
```

Review results:

```bash
wc -l /cases/Email_Logs/email_keywords.txt
head -20 /cases/Email_Logs/email_keywords.txt
```

---

## 📊 Part 4: Extract Individual Emails

Extract complete emails for detailed analysis:

```bash
# Split mailbox into individual emails
split -p "^From " /evidence/mail.mbox /cases/Email_Logs/email_
```

List extracted emails:

```bash
ls -lh /cases/Email_Logs/email_* | head -20
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: split -p "^From " /evidence/mail.mbox /cases/Email_Logs/email_
exit_code: 0
note: Extract individual emails from mailbox for analysis
```

---

## 📝 Part 5: Analyze Email Content

Review extracted emails for suspicious content:

```bash
# Count total emails
ls /cases/Email_Logs/email_* | wc -l

# Look at first email
cat /cases/Email_Logs/email_aa | head -50

# Search for attachments across all emails
grep -i "Content-Disposition: attachment" /cases/Email_Logs/email_* | wc -l
```

**Questions to answer:**
1. How many emails total?
2. Are there attachments? How many?
3. Which email addresses appear most frequently?
4. Any emails to external domains?

---

## 📋 Part 6: Analyze System Logs (Optional)

If log files exist, analyze them:

```bash
# Check what logs are available
ls -lh /evidence/logs/
```

If USB logs exist:

```bash
# Extract USB device activity
grep -i "usb" /evidence/logs/* > /cases/Email_Logs/usb_activity.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep -i "usb" /evidence/logs/* > /cases/Email_Logs/usb_activity.txt
exit_code: 0
note: Extract USB device connection/disconnection events from system logs
```

---

## 📈 Part 7: Timeline Correlation

Compare email timestamps with evidence from other labs:

**Create a timeline file:**

```bash
cat > /cases/Email_Logs/correlation_timeline.txt << 'EOF'
CORRELATION WITH OTHER LABS

Lab 1 (USB Imaging) Findings:
- Files deleted: [date/time from Lab 1]
- Timestamps of suspicious files:

Lab 2 (Memory Forensics) Findings:
- Memory dump captured: [timestamp]
- TrueCrypt running: [yes/no]

Lab 4 (Email_Logs) Findings:
- Emails sent: [dates/times]
- To external address: [yes/no]

Lab 5 (Network Analysis) Findings:
- Network capture date: [when]
- Suspicious traffic detected: [what/when]

TIMELINE ALIGNMENT:
Do the events correlate? Were files deleted, then encrypted, then emailed, then exfiltrated?
EOF
cat /cases/Email_Logs/correlation_timeline.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Created correlation_timeline.txt manually
exit_code: 0
note: Correlate email evidence with findings from Labs 1, 2, 5
```

---

## 🚪 Part 8: Exit the Workstation

```bash
exit
```

---

## ✅ Deliverables

You should have created in `cases/Email_Logs/`:

- ✅ `chain_of_custody.csv` - Evidence hash
- ✅ `analysis_log.csv` - All commands documented
- ✅ `email_headers.txt` - Extracted email headers
- ✅ `email_keywords.txt` - Keyword search results
- ✅ `email_*` - Individual email files
- ✅ `usb_activity.txt` - Log analysis (if applicable)
- ✅ `correlation_timeline.txt` - Timeline comparison

---

## 📊 Analysis Summary

Document your findings:

1. **Total emails:** (count of email_* files)
2. **Suspicious recipients:** (external email addresses)
3. **Keywords found:** (count and list of top keywords)
4. **Attachment count:** (total attachments in mailbox)
5. **Timeline patterns:** (suspicious timing?)
6. **Correlation with other labs:** (do events align?)

---

## 🆘 Troubleshooting

### "No mail.mbox file"
- Check evidence/ folder exists
- Verify file is named exactly mail.mbox
- Check file permissions

### "Split command doesn't work"
- Use alternative: `awk` to split emails
- Or use Python script to parse mbox files
- Ask instructor for email parsing script

### "grep finds nothing"
- Keywords might use different case or spelling
- Try broader search patterns
- Check file actually contains readable text

---

## 📚 Next Steps

After this lab:

1. Review all extracted emails
2. Identify most suspicious communications
3. Document sender/recipient patterns
4. Proceed to Network_Analysis (Lab 5) when ready

Network traffic analysis will corroborate email findings!

---

## 📝 Summary - Quick Command Reference

```bash
# INSIDE the workstation:

# Hash verification
sha256sum /evidence/mail.mbox
md5sum /evidence/mail.mbox

# Extract headers
grep -E "^From:|^To:|^Date:|^Subject:" /evidence/mail.mbox > /cases/Email_Logs/email_headers.txt

# Keyword search
grep -i "confidential|secret|password|export" /evidence/mail.mbox > /cases/Email_Logs/email_keywords.txt

# Split into individual emails
split -p "^From " /evidence/mail.mbox /cases/Email_Logs/email_

# Count attachments
grep -i "Content-Disposition: attachment" /cases/Email_Logs/email_* | wc -l

# Search logs (if available)
grep -i "usb" /evidence/logs/* > /cases/Email_Logs/usb_activity.txt

# Exit workstation
exit
```

---

**Remember:** Email evidence often provides direct proof of intent and knowledge!
