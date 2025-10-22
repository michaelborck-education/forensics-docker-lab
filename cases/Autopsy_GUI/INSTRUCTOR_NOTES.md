# Lab 3 - Instructor Notes & Changes Made

## Summary of Enhancements

Created a comprehensive `WALKTHROUGH.md` to supplement the existing `README.md`. The original README was too sparse for students unfamiliar with GUI-based forensic tools and noVNC browser access.

## Key Issues Addressed

### 1. Missing noVNC Setup Instructions
- **Issue:** README mentions noVNC URL but no troubleshooting for browser access
- **Fix:** Added detailed browser setup and VNC connection steps
- **Benefit:** Students won't get stuck on "blank screen" or "connection refused"

### 2. Lack of Autopsy Workflow Guidance
- **Issue:** Students don't know what to click or what features matter
- **Fix:** Added step-by-step GUI navigation with screenshots descriptions
- **Benefit:** Structured exploration prevents random clicking and missed evidence

### 3. No Expected Findings Context
- **Issue:** Students don't know what they should discover in the disk image
- **Fix:** Added "What to look for" sections linking to case storyline
- **Benefit:** Purposeful analysis rather than aimless browsing

### 4. Missing Integration with Previous Labs
- **Issue:** Lab 3 feels disconnected from Labs 1-2 findings
- **Fix:** Added correlation sections linking disk image to memory analysis
- **Benefit:** Students see how GUI tools complement CLI analysis

### 5. No Export/Documentation Guidance
- **Issue:** Students don't know how to generate proper reports
- **Fix:** Added detailed export instructions and report completion guidance
- **Benefit:** Professional documentation habits development

## What's Included in WALKTHROUGH.md

### Sections:
1. **Overview** - Context and learning objectives
2. **Case Context** - Connection to Cloudcore investigation (Phase 3)
3. **Prerequisites Checklist** - Setup verification including browser testing
4. **Lab Setup** - Docker services and noVNC access
5. **Step-by-Step Analysis** (8 detailed steps):
   - Docker service startup
   - noVNC browser access
   - Autopsy case creation
   - Evidence ingestion
   - File system exploration
   - Keyword searching
   - Metadata analysis
   - Report generation
6. **Analysis Guidance** - Questions to answer
7. **Expected Key Findings** - What students should discover
8. **Completing the Report** - Template guidance with examples
9. **Troubleshooting** - Common noVNC and Autopsy issues
10. **Submission Checklist**
11. **Going Further** - Optional extensions
12. **Additional Resources**

### Key Features:
- **Browser compatibility notes** for noVNC
- **Screenshot descriptions** for each major step
- **"What to look for"** guidance linking to case evidence
- **Correlation prompts** to Labs 1-2 findings
- **Time estimate** (75 minutes)
- **Export troubleshooting** for different report formats

## Recommended Next Steps

### Option 1: Keep Both Documents
- Use `README.md` as quick reference
- Use `WALKTHROUGH.md` for full guidance
- Update README.md to add: "See WALKTHROUGH.md for detailed instructions"

### Option 2: Replace README.md
- Rename `WALKTHROUGH.md` to `README.md`
- Keep original README as `README.ORIGINAL.md` for reference

### Option 3: Merge Documents
- Keep README structure but add sections from WALKTHROUGH:
  - Browser requirements
  - Expected findings
  - Troubleshooting
  - Export guidance

## Files That Should Be Updated

1. **cases/Autopsy_GUI/README.md**
   - Add browser requirements (Chrome/Firefox recommended)
   - Add: "See WALKTHROUGH.md for detailed step-by-step instructions"
   - Mention expected time: 75 minutes

2. **Root README.md or SETUP.md**
   - Mention that Lab 3 requires browser access for noVNC
   - Link to Lab 3 WALKTHROUGH.md

3. **FACILITATION.md**
   - Reference the new walkthrough for Lab 3
   - Note that WALKTHROUGH includes teaching tips for GUI tools

## Teaching Tips

### Before Lab:
- Ensure students have completed Labs 1-2 or understand the case context
- Test noVNC access on classroom machines/browsers beforehand
- Emphasize that Autopsy complements, doesn't replace, CLI tools

### During Lab:
- Let students explore Autopsy interface for 10 minutes before structured walkthrough
- Ask: "How does this compare to your CLI findings from Labs 1-2?"
- Point out how GUI makes timeline visualization easier
- Encourage screenshot documentation for their report

### After Lab:
- Group discussion: "When would you use GUI vs CLI tools?"
- Preview Lab 4: "How will email evidence correlate with these disk findings?"
- Emphasize report quality - Autopsy reports are often presented to non-technical stakeholders

## Estimated Student Time

- **Fast students:** 60 minutes
- **Average students:** 75 minutes
- **Struggling students:** 90 minutes (with walkthrough)

## Assessment Notes

### Grading with Walkthrough:
- Students now have detailed guidance, so raise expectations for:
  - Report completeness (all sections filled with specific findings)
  - Screenshot documentation quality
  - Correlation analysis with previous labs
  - Professional report formatting

### Red Flags:
- If student report exactly matches walkthrough without original insights = plagiarism
- Check for unique discoveries beyond the expected findings
- Verify exported Autopsy report is included (not just recreated manually)

## Optional Enhancements

Consider adding:
1. **Video walkthrough** of Autopsy case creation (5-minute screen recording)
2. **Sample completed report** (in instructor folder only)
3. **Browser compatibility testing matrix** (Chrome vs Firefox vs Safari)
4. **Peer review checklist** for GUI vs CLI tool comparison
5. **Advanced Autopsy features** guide (timeline, data units, registry viewer)

## Feedback Loop

After students complete Lab 3:
- Collect feedback on noVNC browser experience
- Note which Autopsy features caused confusion
- Track completion times
- Update WALKTHROUGH.md based on common questions

## Version Control

- Created: 2025-10-21
- Status: Initial version
- Next review: After first cohort completes Lab 3
- Maintenance: Update if Autopsy version changes or noVNC issues arise

---

**Questions or Updates?**
Contact: [Add your contact info here]