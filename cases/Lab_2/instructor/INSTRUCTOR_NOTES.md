# Lab 2 - Instructor Notes & Changes Made

## Summary of Enhancements

Created a comprehensive `WALKTHROUGH.md` to supplement the existing `README.md`. The original README was too sparse for students unfamiliar with memory forensics.

## Key Issues Addressed

### 1. Evidence File Naming Mismatch
- **Issue:** README references `/evidence/memdump.raw` but actual file is `/evidence/memory.raw`
- **Fix:** All commands in WALKTHROUGH.md use correct path: `/evidence/memory.raw`
- **Action Required:** Update README.md to match, or rename evidence file

### 2. Missing Setup Instructions
- **Issue:** Commands output to non-existent directory
- **Fix:** Added `mkdir -p cases/Lab_2/vol_output` step
- **Benefit:** Students won't get "directory not found" errors

### 3. Lack of Context
- **Issue:** No connection to broader investigation
- **Fix:** Added "Case Context" section linking to 2009 Cloudcore story
- **Benefit:** Students understand WHY they're analyzing this memory dump

### 4. No Expected Outputs
- **Issue:** Students couldn't tell if commands worked
- **Fix:** Every step includes expected output format and what to look for
- **Benefit:** Self-guided troubleshooting and confidence

### 5. Missing Analysis Guidance
- **Issue:** Students ran commands but didn't know what findings meant
- **Fix:** Added "What to look for" sections with specific indicators
- **Benefit:** Critical thinking and pattern recognition development

## What's Included in WALKTHROUGH.md

### Sections:
1. **Overview** - Context and learning objectives
2. **Case Context** - Connection to Cloudcore investigation
3. **Prerequisites Checklist** - Setup verification
4. **Lab Setup** - Directory creation and CoC
5. **Step-by-Step Analysis** (7 detailed steps):
   - OS Profile Detection
   - Process Listing (pslist)
   - Process Tree (pstree)
   - Network Scanning (netscan)
   - DLL Analysis (optional)
   - Memory Dumping (optional)
   - Hidden Process Detection (advanced)
6. **Analysis Guidance** - Questions to answer
7. **Expected Key Findings** - What students should discover
8. **Completing the Report** - Template guidance
9. **Troubleshooting** - Common issues and solutions
10. **Submission Checklist**
11. **Going Further** - Optional extensions
12. **Additional Resources**

### Key Features:
- **Expected outputs** after each command
- **"What to look for"** interpretive guidance
- **Troubleshooting** for 5 common issues
- **Correlation prompts** to link with other labs
- **Time estimate** (90 minutes)
- **Submission checklist** for students

## Recommended Next Steps

### Option 1: Keep Both Documents
- Use `README.md` as quick reference
- Use `WALKTHROUGH.md` for full guidance
- Update README.md to fix file path and add: "See WALKTHROUGH.md for detailed instructions"

### Option 2: Replace README.md
- Rename `WALKTHROUGH.md` to `README.md`
- Keep original README as `README.ORIGINAL.md` for reference

### Option 3: Merge Documents
- Keep README structure but add sections from WALKTHROUGH:
  - Prerequisites checklist
  - Expected outputs
  - What to look for
  - Troubleshooting

## Files That Should Be Updated

1. **cases/Lab_2/README.md**
   - Line 21: Change `memdump.raw` to `memory.raw`
   - Lines 33-36: Fix all command paths to `/evidence/memory.raw`
   - Add: `mkdir -p cases/Lab_2/vol_output` before Step 2

2. **Root README.md or SETUP.md**
   - Mention that Lab 2 has comprehensive walkthrough
   - Link to Lab 2 WALKTHROUGH.md

3. **FACILITATION.md**
   - Line 16: Reference the new walkthrough for Lab 2
   - Note that WALKTHROUGH includes teaching tips inline

## Teaching Tips

### Before Lab:
- Ensure students have completed Lab 1 or read STORYLINE.md
- Pre-run volatility commands once to verify image compatibility
- Highlight that TrueCrypt is the "smoking gun" they should find

### During Lab:
- Let students struggle with analysis for 10-15 minutes before hinting
- Ask: "What's unusual about this process?" rather than "Find TrueCrypt"
- Connect findings to Lab 5 (network analysis) for correlation practice

### After Lab:
- Group discussion: "What does TrueCrypt + IRC suggest?"
- Preview Lab 6: "How will you correlate all evidence?"
- Emphasize documentation quality (forensics is 50% reporting)

## Estimated Student Time

- **Fast students:** 60 minutes
- **Average students:** 90 minutes
- **Struggling students:** 120 minutes (with walkthrough)

## Assessment Notes

### Grading with Walkthrough:
- Students now have detailed guidance, so raise expectations for:
  - Report completeness (all sections filled)
  - Analysis depth (not just running commands, but interpreting)
  - Correlation with other labs (cross-referencing)

### Red Flags:
- If student report exactly matches walkthrough without original analysis = plagiarism
- Check for unique insights or additional findings beyond walkthrough
- Submission checklist helps ensure completeness

## Optional Enhancements

Consider adding:
1. **Video walkthrough** of first 3 steps (10-minute screen recording)
2. **Sample completed report** (in instructor folder only)
3. **Quiz questions** based on findings (e.g., "What PID was TrueCrypt?")
4. **Peer review checklist** for Lab 6 integration

## Feedback Loop

After students complete Lab 2:
- Collect feedback on walkthrough clarity
- Note which sections caused confusion
- Track completion times
- Update WALKTHROUGH.md based on common questions

## Version Control

- Created: 2025-10-14
- Status: Initial version
- Next review: After first cohort completes Lab 2
- Maintenance: Update if Volatility 3 plugin names change

---

**Questions or Updates?**
Contact: [Add your contact info here]
