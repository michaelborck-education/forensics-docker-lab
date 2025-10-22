# Documentation Index

## 📚 For Students - Essential Reading

**Start here:**
1. **[SCENARIO.md](SCENARIO.md)** - Complete case background (Cloudcore incident)
2. **[SETUP.md](SETUP.md)** - Installation and initial setup
3. **[COMMANDS.md](COMMANDS.md)** - Forensic command reference guide

**Lab-specific:**
- Each lab (cases/Lab_X/README.md) has its own detailed instructions
- See cases/Lab_X/WALKTHROUGH.md for step-by-step guidance
- Use QUICK_REFERENCE.md for quick syntax lookup

**Useful context:**
- **[GLOSSARY.md](GLOSSARY.md)** - Forensics terminology
- **[STORYLINE.md](STORYLINE.md)** - Investigation timeline and narrative
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and fixes

---

## 🏫 For Instructors - Teaching Materials

**Switch to instructor branch:**
```bash
git checkout instructor
```

**Then read:**
- **[docs/instructor/README.md](instructor/README.md)** - Instructor materials overview
- **[cases/Lab_X/instructor/INSTRUCTOR_NOTES.md](../cases/)** - Teaching tips for each lab
- **[cases/Lab_X/instructor/answer_key.md](../cases/)** - Expected findings
- **[cases/Lab_X/instructor/rubric.csv](../cases/)** - Grading rubrics

---

## 📖 Course Planning & Design

**Understanding the course:**
- **[COURSE_MAPPING.md](COURSE_MAPPING.md)** - How labs fit into curriculum
- **[ARCHITECTURE_DECISION.md](ARCHITECTURE_DECISION.md)** - Why Docker (not VMs)
- **[UNDERSTANDING-THE-INVESTIGATION-ENVIRONMENT.md](UNDERSTANDING-THE-INVESTIGATION-ENVIRONMENT.md)** - Lab environment explained

**Assignments & Grading:**
- **[ASSIGNMENT1.md](ASSIGNMENT1.md)** - Lab 1 assignment details
- **[ASSIGNMENT2.md](ASSIGNMENT2.md)** - Labs 2-4 assignment details
- **[RUBRICS.md](RUBRICS.md)** - Comprehensive grading rubrics (main branch)

**Facilitation & Workflow:**
- **[FACILITATION.md](FACILITATION.md)** - How to teach/facilitate labs
- **[WORKBOOK.md](WORKBOOK.md)** - Student report template

---

## 🔍 Reference & Troubleshooting

- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions
- **[COMMANDS.md](COMMANDS.md)** - Forensic tool reference
- **[GLOSSARY.md](GLOSSARY.md)** - Definitions and terminology

---

## 📋 Legacy/Reference Materials

These documents provide architectural context and historical decisions:

- **[INTERACTIVE_WORKSTATION.md](INTERACTIVE_WORKSTATION.md)** - Original Docker interaction patterns (superseded by forensics-workstation script)
- **[VIRTUALISATION-VS-CONTAINERS.md](VIRTUALISATION-VS-CONTAINERS.md)** - Architecture comparison (detailed in ARCHITECTURE_DECISION.md)
- **[STUDENT_DISTRIBUTION.md](STUDENT_DISTRIBUTION.md)** - Distribution workflow (instructor branch has detailed info)

---

## 🚀 Getting Started (Quick Links)

### For Students
1. Read **SCENARIO.md** → Understand the case
2. Run **./scripts/forensics-workstation** → Enter the lab
3. Follow **cases/Lab_X/README.md** → Start with Lab 1
4. Check **QUICK_REFERENCE.md** → Command syntax help

### For Instructors
1. **`git checkout instructor`** → Access instructor materials
2. Read **docs/instructor/README.md** → Understand branch structure
3. Check **cases/Lab_X/instructor/INSTRUCTOR_NOTES.md** → Teaching tips
4. Use **cases/Lab_X/instructor/rubric.csv** → Grading guidance

---

## 📞 File Organization

```
docs/
├── README.md                                    ← You are here (index)
├── instructor/                                  ← Instructor-only (on instructor branch)
│   └── README.md
├── SCENARIO.md                                  ← Read first: case background
├── SETUP.md                                     ← Installation guide
├── COMMANDS.md                                  ← Command reference
├── TROUBLESHOOTING.md                          ← Problem solving
├── STORYLINE.md                                ← Investigation narrative
├── GLOSSARY.md                                 ← Terminology
├── COURSE_MAPPING.md                           ← Curriculum integration
├── FACILITATION.md                             ← Teaching guidance
├── ASSIGNMENT1.md / ASSIGNMENT2.md             ← Assignment details
├── ARCHITECTURE_DECISION.md                    ← Docker vs VM decision
├── UNDERSTANDING-THE-INVESTIGATION-ENVIRONMENT.md
├── WORKBOOK.md                                 ← Student template
└── [Legacy reference docs]
```

---

## ✨ Recent Updates (Phase 2)

- ✅ All 6 labs now have consistent structure
- ✅ Immersive forensics-workstation script available
- ✅ Comprehensive CoC logging system
- ✅ Updated evidence naming (usb.img/usb.E01)
- ✅ Complete walkthroughs for Labs 5-6
- ✅ Instructor branch with separated materials
- ✅ Detailed Lab 1 answer key with grading notes

---

*Last updated: October 22, 2025 | Phase 2 Complete*
