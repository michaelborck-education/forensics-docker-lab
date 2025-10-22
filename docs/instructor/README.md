# Instructor Branch - Staff Only

This branch (`instructor`) contains materials for course instructors, teaching assistants, and staff only. These materials should **not be distributed to students** who should use the `main` branch instead.

## Branch Usage

### For Instructors
```bash
# Clone with instructor branch
git clone -b instructor https://github.com/yourrepo/forensics-docker-lab.git

# Or switch existing clone to instructor branch
git checkout instructor
```

### For Students
Students should use the main branch (default):
```bash
git clone https://github.com/yourrepo/forensics-docker-lab.git
# Uses main branch automatically
```

## Contents of This Branch

### Per-Lab Instructor Materials
Each lab has an `instructor/` subfolder containing:

```
cases/Lab_X/instructor/
├── INSTRUCTOR_NOTES.md          # Teaching guidance, common mistakes, tips
├── INSTRUCTOR_WALKTHROUGH.md    # Detailed solution walkthrough (Lab 1)
├── answer_key.md                # Expected findings and analysis results
├── rubric.csv                   # Grading rubric for this lab
└── FACILITATION_GUIDE.md        # (Optional) Classroom facilitation notes
```

### Documentation
- `docs/instructor/GRADING_GUIDE.md` - Comprehensive rubric explanations
- `docs/instructor/FACILITATION.md` - Course-wide teaching strategies
- `docs/instructor/STUDENT_DISTRIBUTION.md` - Image distribution workflow
- `docs/instructor/TROUBLESHOOTING_EXTENDED.md` - In-depth solutions to student issues

### Scripts for Instructors
- `scripts/instructor/` directory contains:
  - `create-evidence-images.sh` - Build disk.img, memory.raw, network.cap
  - `package-for-distribution.sh` - Create student-ready distribution ZIP
  - `check-student-submissions.sh` - Batch submission validation

## Key Files NOT on Student Branch

The following are instructor-only and should never appear on `main`:
- Lab answer keys
- Grading rubrics
- Teaching notes
- Solution walkthroughs
- Facilitation guides
- Instructor scripts

## Workflow

### Before Semester
1. Prepare evidence images using scripts in `scripts/instructor/`
2. Upload to OneDrive/distribution platform
3. Create student assignment versions with appropriate limitations
4. Review all rubrics and answer keys for consistency

### During Semester
1. Refer to INSTRUCTOR_NOTES.md while teaching each lab
2. Check student submissions against rubric.csv
3. Use TROUBLESHOOTING_EXTENDED.md for complex issues
4. Keep instructor branch in sync with main (pull main updates)

### Between Semesters
1. Gather feedback from this semester's assessment
2. Update answer keys and rubrics based on student performance
3. Revise instructor notes if teaching approach changed
4. Merge back to main any non-sensitive documentation improvements

## Keeping Branches in Sync

### To pull main improvements to instructor branch
```bash
git checkout instructor
git pull origin main
# Resolve any conflicts (instructor files take priority)
```

### To keep instructor updates from leaking to main
- **Never merge** instructor → main
- **Only pull** main → instructor
- Use `.gitignore` to prevent accidental commits of student work to instructor branch

## Educational Purpose

This branch structure supports academic integrity by:
1. Preventing answer leaks (separate branches)
2. Making instructor resources discoverable by authorized staff
3. Supporting clear "student view" vs "instructor view" separation
4. Allowing version control of grading artifacts
5. Facilitating collaboration among teaching team

## Questions?

If instructor materials seem outdated or inconsistent, please:
1. Create an issue on the instructor branch
2. Coordinate with other instructors before pushing changes
3. Document any student-facing changes needed in main branch
4. Maintain parallel updates to keep branches useful

---

*This branch supports faculty collaboration and student assessment. Distribute main branch only to students.*
