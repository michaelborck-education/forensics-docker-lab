# Instructor Facilitation Guide

## Overview
This repo supports 6 labs on DFIR exfil investigation (2009 Cloudcore story). Time: 6-9 hours total (90min/lab + 2hr Lab 6).

## Prep
1. Setup (SETUP.md): Build/test tools.
2. Evidence: Populate evidence/ (usb.img via script, memory.ram, network.cap, mbox/logs as is).
3. Student materials: Provide repo; warn on spoilers (ANSWER_KEY.md).
4. Tools: Ensure Docker; install tshark/Wireshark host-side for Lab 5 demo.

## Teaching Tips
- **Intro**: Present STORYLINE.md as case brief; quiz timeline phases.
- **Lab 1**: Demo carving live (show flag.txt); discuss CoC importance.
- **Lab 2**: Pre-run volatility on memory.ram; highlight TrueCrypt as "smoking gun".
- **Lab 3**: Walkthrough Autopsy interface; pair with Lab 1 findings.
- **Lab 4**: Use grep on logs/mbox for teaching "signal from noise".
- **Lab 5**: Wireshark GUI for network.cap (filter irc); explain C2 deniability.
- **Lab 6**: Group activity for correlation; review unified report rubric.
- **Engagement**: Red herrings (e.g., dummy log lines); extensions (YARA rule for IRC).
- **Assessment**: Use RUBRICS.md; auto-grade via hashes in CoC CSV.

## Timing/Adaptations
- Short version: Skip GUI (Lab 3 optional).
- Advanced: Add bulk_extractor for exfil keywords.

See TROUBLESHOOTING.md for student issues. Feedback to issues.

## Course Mapping
See COURSE_MAPPING.md for a 12-week syllabus integrating theory and labs.
