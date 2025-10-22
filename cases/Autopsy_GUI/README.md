# Forensic Lab 3: Autopsy GUI (via noVNC)

**Goal:** Learn to navigate and document a forensic investigation using the Autopsy GUI inside Docker.

**Skills:**  
- Launch Autopsy via browser (noVNC).  
- Create a case and add evidence.  
- Explore file system, metadata, and keyword search features.  
- Export reports and document workflow.

---

## What to submit
- `cases/Autopsy_GUI/autopsy_case/` directory (exported case data).  
- `cases/Autopsy_GUI/autopsy_report.md` (template provided).

---

## Steps

1. **Start Autopsy services**
```bash
docker compose up -d novnc autopsy
# Access GUI at: http://localhost:8080/vnc.html
```

2. **Create a new case**
- Case name: `Lab3_<YourName>`  
- Base directory: `/cases/Autopsy_GUI/autopsy_case`  
- Add evidence: `/evidence/disk.img` (practice image from Lab1)

3. **Explore evidence**
- File system view (recover deleted files).  
- Keyword search (try "secret").  
- Hash lookup (optional).

4. **Generate Autopsy report**
Export HTML or PDF into `/cases/Autopsy_GUI/autopsy_case/export/`.

5. **Fill in autopsy_report.md** with screenshots and notes.

---

## Marking Rubric
- Correct setup and case creation (20%)  
- Evidence exploration (30%)  
- Report export and documentation (30%)  
- Clarity of submitted report (20%)
