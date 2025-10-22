# Phase 2 Implementation Checklist - Lab Consistency & Standardization

**Current Status:** Completed foundation, ready for Phase 2 execution
**Date:** October 22, 2025

---

## ✅ Phase 1 Completed (9 tasks)

- [x] Create instructor branch and move staff materials
- [x] Rename evidence files (disk → usb)
- [x] Create forensics-workstation (bash)
- [x] Create forensics-workstation.ps1 (PowerShell)
- [x] Enhance CoC logging system
- [x] Update main README
- [x] Move scripts to legacy/ subdirectory
- [x] Enhance verify_setup.sh
- [x] Add QUICK_REFERENCE.md and implementation guides

---

## 📋 Phase 2 Checklist - Apply to Each Lab

This task repeats for **Labs 2, 3, 4, 5, and 6** (Lab 1 done). Each takes ~10-15 minutes.

### For Each Lab (Repeat 5 times)

#### Step 1: Add Quick Start Section (After intro)
```markdown
## 🚀 Quick Start - Immersive Workstation

**Get started immediately with the immersive DFIR experience:**

**Mac/Linux:**
```bash
cd /path/to/forensics-docker-lab
./scripts/forensics-workstation
```

**Windows PowerShell:**
```powershell
.\scripts\forensics-workstation.ps1
```

You'll be prompted for your analyst name, then you're ready to work.

---
```

#### Step 2: Update Step 0 (Enter workstation)
Replace old Docker command with immersive approach:

**FROM:**
```bash
# First time only: Build the forensic container
docker compose build dfir

# Enter the interactive forensic workstation
docker compose run --rm -it dfir
```

**TO:**
```bash
# Recommended approach (hides Docker complexity):
./scripts/forensics-workstation
# (or on Windows: .\scripts\forensics-workstation.ps1)

# Advanced alternative (direct Docker):
docker compose build dfir
docker compose run --rm -it dfir
```

#### Step 3: Add CoC Examples to Key Steps
Find major commands in each lab and add examples like:

```bash
# First time (walkthrough):
fls -r /evidence/usb.img

# Second time (assignment):
coc-log "fls -r /evidence/usb.img" "Initial filesystem listing"
```

---

## 🎯 Lab-Specific Updates

### Lab 2 (Memory Forensics)
**Files to update:**
- `cases/Lab_2/README.md` - Add immersive section + CoC examples
- `cases/Lab_2/WALKTHROUGH.md` - Add CoC logging examples for vol2 commands

**Key commands to demonstrate CoC:**
```bash
coc-log "vol2 -f /evidence/memory.raw imageinfo" "Identify OS profile"
coc-log "vol2 -f /evidence/memory.raw -p WinXPSP2x86 pslist" "List running processes"
coc-log "vol2 -f /evidence/memory.raw -p WinXPSP2x86 netscan" "Show network connections"
```

### Lab 3 (Autopsy GUI)
**Files to update:**
- `cases/Lab_3/README.md` - Add immersive section
- `cases/Lab_3/WALKTHROUGH.md` - Note that Autopsy writes to `/cases/` via browser

**Note:** Autopsy is accessed via browser (noVNC), so CoC logging would be for support commands only:
```bash
coc-log "ls /cases/autopsy_case/" "Check Autopsy case directory"
```

### Lab 4 (Email & Logs)
**Files to update:**
- `cases/Lab_4/README.md` - Add immersive section
- `cases/Lab_4/WALKTHROUGH.md` - Add CoC examples for analysis commands

**Key commands:**
```bash
coc-log "grep -i secret /evidence/logs/*" "Search logs for indicators"
coc-log "python3 cases/Lab_4/analyse_emails.py" "Analyze email artifacts"
```

### Lab 5 (Network Forensics) ⭐ Needs Walkthrough
**Files to update:**
- `cases/Lab_5/README.md` - Add immersive section
- `cases/Lab_5/WALKTHROUGH.md` - **CREATE THIS FILE** (currently minimal)

**Walkthrough should cover:**
- Opening PCAP in network analysis tools
- Looking for IRC C2 traffic (port 6667, hunt3d.devilz.net)
- Identifying malware downloads
- Finding exfiltration traffic to 203.0.113.50:8080
- Timeline correlation with earlier labs

**Key commands:**
```bash
coc-log "tshark -r /evidence/network.cap -Y 'tcp.port==6667'" "Filter for IRC C2 traffic"
coc-log "tshark -r /evidence/network.cap -Y 'ip.dst==203.0.113.50'" "Find exfiltration traffic"
```

### Lab 6 (Final Report) ⭐ Needs Walkthrough
**Files to update:**
- `cases/Lab_6/README.md` - Add immersive section
- `cases/Lab_6/WALKTHROUGH.md` - **CREATE THIS FILE** (currently minimal)

**Walkthrough should emphasize:**
- Integrating findings from all 5 previous labs
- Building timeline from Plaso + memory + network findings
- Writing professional conclusions
- Proper chain of custody integration

---

## 🔄 Apply Updates: Template Commands

### For Lab 2:
```bash
# Open Lab 2 README
code cases/Lab_2/README.md

# Find "## What to submit" or similar heading
# Add the Quick Start section before it
# Update Step 0 to feature immersive approach
# Add CoC examples to vol2 commands
```

### For Lab 3:
```bash
# Similar to Lab 2
code cases/Lab_3/README.md
# Note: Autopsy is GUI-based, so adjust CoC examples accordingly
```

### Continue for Labs 4, 5, 6...

---

## ⚡ Fast Implementation Strategy

Rather than updating labs one-by-one, you could:

1. **Create a template file** with the standard sections
2. **Copy template to each Lab X/README.md**
3. **Customize for each lab's specific focus**

**Template locations:**
- Quick Start section - same for all
- Step 0 - same for all
- CoC examples - customize for each lab's tools

---

## 📝 After Updating All Labs

Once Labs 2-6 have immersive sections:

1. **Verify consistency**
   - All labs have same structure
   - All mention forensics-workstation script
   - All show walkthrough vs assignment differences

2. **Test walkthroughs**
   - Follow each lab's README on fresh system
   - Verify immersive entry works
   - Verify CoC logging produces expected output

3. **Update any remaining docs**
   - docs/COMMANDS.md - update if old
   - docs/SETUP.md - refer to forensics-workstation
   - Any other references to docker commands

---

## 🎓 Student Experience After Phase 2

**Current:** All students see detailed, consistent lab structure
- Lab 1: ✅ Complete (immersive, CoC examples)
- Lab 2: Needs update (~10 min)
- Lab 3: Needs update (~10 min)
- Lab 4: Needs update (~10 min)
- Lab 5: Needs walkthrough + CoC (~15 min)
- Lab 6: Needs walkthrough + CoC (~15 min)

**After Phase 2 completion:**
- All 6 labs follow same structure
- Students know exactly what to expect
- Consistent immersive experience
- Clear separation of walkthrough vs assignment
- Professional CoC logging examples throughout

---

## 💡 Estimated Effort

| Task | Est. Time | Difficulty |
|------|-----------|------------|
| Update Lab 2 README | 10 min | Easy |
| Update Lab 3 README | 10 min | Easy |
| Update Lab 4 README | 10 min | Easy |
| Create Lab 5 WALKTHROUGH | 15 min | Medium |
| Create Lab 6 WALKTHROUGH | 15 min | Medium |
| Verify consistency | 10 min | Easy |
| Final testing | 30 min | Medium |
| **TOTAL** | **100 min** | **Low-Medium** |

---

## 🚀 Next Steps

1. Update Lab 2 README with immersive section
2. Update Lab 3 README with immersive section
3. Update Lab 4 README with immersive section
4. Create Lab 5 WALKTHROUGH (use STORYLINE.md for context)
5. Create Lab 6 WALKTHROUGH (use Lab 5 structure as template)
6. Do a final consistency pass across all labs
7. Commit and test

---

## 📞 Questions for Refinement

When implementing Lab updates, consider:

1. **Lab 5 Network Analysis** - Should walk through specific IRC C2 indicators?
2. **Lab 6 Final Report** - Any specific report sections required?
3. **CoC Logging Examples** - Any labs where coc-log doesn't make sense?
4. **Autopsy in Lab 3** - Should provide command-line alternatives to GUI?

---

*This checklist guides Phase 2 implementation for consistent, student-friendly lab structure*
