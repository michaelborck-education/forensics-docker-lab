# Lab 1 — Triage Report (Template)

**Student:** <Name / ID>  
**Date:** <YYYY-MM-DD>  
**Case ID:** LAB1-<YourInitials>

## 1. Scope & Evidence Summary
- Evidence source: `evidence/usb.img` (practice image)
- Chain-of-custody reference: `cases/chain_of_custody.csv` rows from <start time> to <end time>
- Hash algorithm: SHA-256
- Verified baseline hash? ☐Yes / ☐No — Hash: `<value>`

## 2. Methods (Reproducible Steps)
- Commands used (copy/paste exact commands):
  ```bash
  # example
  docker compose run --rm dfir fls -r -m / /evidence/usb.img > cases/Lab1/fls.txt
  ```

- Tools and versions (if relevant).

## 3. Findings
### 3.1 Recovered Artifacts

- Path(s) & description(s):
  - `/cases/Lab1/tsk_recover_out/...` → <explain significance>
- Hash each recovered file you reference:
  ```bash
  docker compose run --rm dfir hashdeep -r /cases/Lab1/tsk_recover_out > cases/Lab1/recovered_hashes.txt
  ```

### 3.2 Timeline Highlights
- Notable events (3–5) with timestamps & rationale:
  1) <timestamp> — <event> — Why it matters
  2) ...

- Attach or reference `cases/Lab1/timeline.csv`

## 4. Integrity & Limitations
- Read-only evidence mounts used? ☐Yes / ☐No
- Any contamination risks observed? <notes>
- Limitations or uncertainties: <notes>

## 5. Conclusion
- Short summary of what happened and key evidence.

## 6. Appendix
- Command log (optional), hashes, screenshots (optional).
