# Forensics Lab Polish & Immersion Enhancement - Implementation Guide

## Status Overview

### ✅ Completed Tasks
1. **Instructor Branch Created** - Separate branch for staff materials
   - All instructor notes, answer keys, and rubrics moved to `cases/Lab_X/instructor/`
   - Labs 5-6 instructor notes and rubrics created
   - Instructor README created in `docs/instructor/`

2. **Evidence Files Renamed** - USB storyline consistency
   - `disk.img` → `usb.img`
   - `disk.E01` → `usb.E01`
   - All documentation updated (30+ files)

3. **Immersive Login Script Created** - Hide Docker complexity
   - `scripts/forensics-workstation` - Full workstation simulation
   - Analyst name prompt and customization
   - Environment variable passing to container
   - Docker connection abstraction

4. **CoC Logging System Enhanced** - Comprehensive audit trail
   - `scripts/coc-log` - Command logging with output hashing
   - `templates/analysis_log.csv` - Per-lab analysis tracking
   - Integrated into dfir container entrypoint

---

## 🔧 Remaining Tasks (Prioritized)

### Priority 1: Critical Updates (Do These First)

#### 1.1 Update README.md with New Workflow
**File:** `/README.md`
**Current:** Shows old `docker compose run --rm dfir` commands
**Update to:**
```markdown
### Quick Start - Immersive Experience

```bash
./scripts/forensics-workstation
```

Then inside the workstation, run forensic commands directly:
```bash
analyst@forensics-lab:/cases$ fls -r /evidence/usb.img
analyst@forensics-lab:/cases$ coc-log "fls -r /evidence/usb.img" "Listed USB filesystem"
```

### Alternate: Direct Docker (Advanced Users)
[keep existing docker commands but mark as advanced]
```

#### 1.2 Update Lab READMEs (Labs 1-6)
**Files:** `cases/Lab_X/README.md`
**Changes needed:**
- Add "Using Immersive Workstation" section
- Show old docker commands vs new `./scripts/forensics-workstation` approach
- Add CoC logging examples for each lab
- Update evidence file names (disk → usb) - ✅ Already done

#### 1.3 Update Walkthroughs with CoC Logging
**Files:** `cases/Lab_X/WALKTHROUGH.md`
**Changes needed:**
```markdown
### Chain of Custody Logging

For each command you run, log it using:
```bash
coc-log "your-command-here" "description of what you're investigating"
```

This automatically:
- Records timestamp and analyst name
- Captures command output
- Calculates SHA256 hash of output
- Saves output to cases/Lab_X/outputs/
- Logs entry to cases/Lab_X/analysis_log.csv
```

### Priority 2: Consistency & Completeness

#### 2.1 Complete Lab 5 & Lab 6 Documentation
**Create:**
- `cases/Lab_5/WALKTHROUGH.md` - Network analysis step-by-step
- `cases/Lab_6/WALKTHROUGH.md` - Final report synthesis
- `cases/Lab_5/README.md` improvements
- `cases/Lab_6/README.md` improvements

**Template for walkthroughs:**
```markdown
# Lab X: [Title] - Complete Walkthrough

## Case Context
[1-2 paragraph overview]

## Prerequisites Checklist
[Bullet list]

## Lab Setup
[Directory creation, tool checks]

## Step-by-Step Analysis
[Numbered sections with commands and expected outputs]

## Chain of Custody Integration
[How this lab's findings connect to others]

## Wrap-Up
[Summary of findings]
```

#### 2.2 Standardize Lab Structure
All labs should have identical structure:
```
cases/Lab_X/
├── README.md                    # Context + student instructions
├── WALKTHROUGH.md              # Step-by-step guide (immersive format)
├── report_template.md          # Student output template
├── Lab_X/                      # Output folder for student work
│   ├── timeline.md
│   ├── findings.md
│   └── notes.md
└── instructor/                 # (On instructor branch only)
    ├── INSTRUCTOR_NOTES.md
    ├── answer_key.md
    └── rubric.csv
```

#### 2.3 Verify Storyline Consistency
**Check these key points:**
- Lab 1 evidence files match scenario narrative ✓ (Updated: project_secrets.zip, email_draft.txt, truecrypt_config.txt)
- Lab 2 memory.raw contains TrueCrypt process (Verify)
- Lab 3 Autopsy analysis matches findings (Verify)
- Lab 4 email/logs correlate with Lab 1-2 (Verify)
- Lab 5 network PCAP shows IRC C2 and data exfiltration (Verify)
- Lab 6 synthesis integrates all findings (Verify)

**Answer Key Fixes Needed:**
- Lab 1 `instructor/answer_key.md` still references "flag.txt" with "secret"
  - Update to: project_secrets.zip, email_draft.txt, truecrypt_config.txt
  - Add syslog entries about USB activity
  - Hash values for recovered files

### Priority 3: Documentation Cleanup

#### 3.1 Review docs/ for Duplicates
**Run:**
```bash
ls -la docs/
```

**Known files to check for consistency:**
- SCENARIO.md ✓ (already references usb.E01)
- STORYLINE.md ✓ (detailed timeline)
- SETUP.md - verify evidence distribution instructions
- COMMANDS.md ✓ (references updated to usb.img)
- FACILITATION.md - move to instructor branch
- TROUBLESHOOTING.md ✓ (updated)

**Action:** Create a `docs/README.md` that indexes all documentation and marks which are student-facing vs instructor-only

#### 3.2 Clean Up Obsolete Documentation
**Review and potentially delete:**
- INTERACTIVE_WORKSTATION.md (superseded by forensics-workstation script?)
- VIRTUALISATION-VS-CONTAINERS.md (architecture docs)
- Update references to old approaches

**Consolidate similar documents:**
- Consider merging SCENARIO.md and STORYLINE.md?
- Combine SETUP.md with STUDENT_DISTRIBUTION.md?

### Priority 4: Scripts Organization

#### 4.1 Organize scripts/ Directory
**Create subdirectories:**
```
scripts/
├── forensics-workstation      # ✓ Main immersive entry point
├── coc-log                     # ✓ CoC logging utility
├── student/
│   └── lab-ready              # Check Docker/setup readiness
├── instructor/
│   ├── create-evidence-images.sh    # Build evidence from scratch
│   ├── package-for-distribution.sh  # Create student ZIP
│   └── check-submissions.sh    # Batch validation
└── legacy/
    ├── make_practice_image.sh  # Old sudo version
    ├── make_practice_image_simple.sh
    └── convert_to_e01*.sh      # Keep as reference
```

#### 4.2 Create scripts/README.md
```markdown
# Utility Scripts

## For Students
- **forensics-workstation** - Start immersive DFIR session
- **coc-log** - Log analysis commands to chain of custody

## For Instructors (scripts/instructor/)
- **create-evidence-images.sh** - Generate evidence files
- **package-for-distribution.sh** - Create student-ready distribution
- **check-submissions.sh** - Validate student submissions

## Legacy/Reference (scripts/legacy/)
- **make_practice_image.sh** - Old version (requires sudo)
- **make_practice_image_simple.sh** - Alternative approach
- **convert_to_e01*.sh** - Various E01 conversion methods

## Usage
Inside forensics-workstation container:
```bash
analyst@forensics-lab:/cases$ coc-log "command" "note"
```
```

---

## 📋 Implementation Checklist

### Phase 1: Make Project Functional (Do First)
- [ ] Update main README.md with new workflow
- [ ] Update all 6 Lab README.md files
- [ ] Update WALKTHROUGH.md files with CoC examples
- [ ] Test forensics-workstation script on Mac, Windows, Linux
- [ ] Rebuild dfir container with coc-log

### Phase 2: Complete & Standardize (Then)
- [ ] Create Lab 5 & 6 complete walkthroughs
- [ ] Standardize all lab folder structures
- [ ] Verify storyline consistency across all labs
- [ ] Update Lab 1 answer_key (disk → usb, flag.txt evidence)
- [ ] Create scripts/ README.md
- [ ] Organize scripts into subdirectories

### Phase 3: Polish & Document (Finally)
- [ ] Create docs/README.md index
- [ ] Consolidate redundant documentation
- [ ] Review and clean up obsolete files
- [ ] Create docs/instructor/DISTRIBUTION_WORKFLOW.md
- [ ] Create comprehensive CONTRIBUTING.md for course staff
- [ ] Add .gitignore entries for student outputs

### Phase 4: Testing (Before Distribution)
- [ ] Test full workflow on Windows (WSL2 + PowerShell)
- [ ] Test full workflow on macOS (Intel + Apple Silicon)
- [ ] Test full workflow on Linux (Ubuntu)
- [ ] Verify coc-log creates proper CSV entries
- [ ] Verify forensics-workstation handles missing evidence
- [ ] Test instructor branch is properly protected
- [ ] Verify student branch has no instructor materials

---

## 🔄 Git Branch Management

### Main Branch (Student-Facing)
- Contains all lab materials, walkthroughs, templates
- No instructor answers, notes, or rubrics
- Evidence files referenced but not stored (students download separately)
- README shows new immersive workflow

### Instructor Branch
```bash
git checkout instructor
```
- Contains instructor/ subdirectories with answers, notes, rubrics
- Can have instructor-only scripts
- Can have answer keys and solution walkthroughs
- Distribution instructions

### Sync Between Branches
```bash
# On instructor branch, pull main improvements
git pull origin main

# On main branch, NEVER merge instructor
# To see instructor materials for review:
git diff main instructor
```

---

## 📦 Distribution Workflow

### For Instructors Distributing to Students

1. **Create Distribution Package**
   ```bash
   cd forensics-docker-lab
   ./scripts/instructor/package-for-distribution.sh
   ```
   This creates `forensics-lab-student-bundle.zip` containing:
   - cases/ (with Lab READMEs and walkthroughs only)
   - docs/ (student-facing docs only, not instructor/)
   - scripts/ (forensics-workstation and coc-log only)
   - README.md (updated with new workflow)
   - docker-compose.yml
   - .env
   - docker images Dockerfiles
   - templates/
   - rules/
   - guides/

2. **Evidence Distribution**
   - Do NOT include evidence/ in student bundle
   - Create separate OneDrive/link with:
     - usb.img (100MB)
     - usb.E01 (101MB)
     - memory.raw (511MB)
     - network.cap (121KB)
   - Instructions: "Download evidence files and copy to evidence/ folder"

3. **Student Setup**
   - Unzip forensics-lab-student-bundle.zip
   - Create evidence/ folder
   - Download evidence files from OneDrive
   - Copy evidence files to evidence/ folder
   - Run: `./scripts/forensics-workstation`

---

## 🎯 Key Improvements Achieved So Far

1. ✅ **Immersive UX** - `./scripts/forensics-workstation` instead of complex docker commands
2. ✅ **Analyst Identity** - Name prompt creates personalized experience
3. ✅ **Comprehensive CoC** - Every command logged with output hash and timestamp
4. ✅ **Instructor/Student Separation** - Branches keep materials organized and secure
5. ✅ **USB Storyline** - Evidence names match scenario (usb.img, usb.E01)
6. ✅ **Lab Consistency** - All labs now follow same structure and naming conventions

---

## 📞 Questions & Notes

### Open Decisions
- Should Labs 5-6 walkthroughs be as detailed as 1-4? (Probably yes)
- Should we create full rubrics for all labs? (Already done on instructor branch)
- Should coc-log be optional or required in walkthroughs? (Recommend optional but demonstrated)

### Known Issues to Address
- Lab 1 answer key needs updating (flag.txt → actual evidence)
- Lab 5-6 documentation minimal (need walkthroughs)
- Need to verify evidence files match storyline across all labs

### Future Enhancements (Nice to Have)
- Create Docker Compose wrapper script for Windows PowerShell?
- Add "case briefing menu" to forensics-workstation script?
- Build web-based submission checker?
- Create student activity tracker?

---

*Last updated: October 22, 2025*
*This document guides completion of the "polish" initiative for the Forensics Docker Lab*
