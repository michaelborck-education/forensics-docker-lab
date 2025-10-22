# Architecture Decision: Interactive Workstation vs. One-Off Commands

## Current Situation

You have **two approaches** to running forensic labs:

### Approach 1: Current Root Setup (One-Off Commands)
- **Location:** Root `docker-compose.yml` and `images/dfir-cli/Dockerfile`
- **Base Image:** Debian slim
- **Style:** Run tools as one-off commands: `docker compose run --rm vol3 vol -f ...`
- **User Experience:** More like a CLI utility, less immersive
- **Tools:** Comprehensive (TSK, Volatility3, Plaso, YARA, bulk_extractor, etc.)

### Approach 2: Archive Lab 1 (Interactive Workstation)
- **Location:** `_archive/foresnsic-lab-ass-1-dfir/`
- **Base Image:** Alpine 3.19
- **Style:** Interactive shell with banner: `docker compose run --rm dfir` → bash prompt
- **User Experience:** Immersive "logging into a forensic workstation"
- **Tools:** Basic (TSK, libewf only)

## The Problem

**Lab 2 (Memory Forensics) requires Volatility 3, which is NOT in the Alpine setup.**

Alpine's package limitations:
- ❌ No `volatility3` package in Alpine repos
- ❌ Would need to install Python3, pip, compile dependencies
- ❌ Volatility3 has heavy Python dependencies (over 100MB+ worth)
- ❌ Alpine's musl libc can cause issues with Python packages

Debian/Ubuntu advantages:
- ✅ Easy `pip3 install volatility3`
- ✅ Better Python package compatibility
- ✅ More complete tooling (Plaso, bulk_extractor, YARA)
- ✅ Handles all 6 labs without issues

## Recommendation: **Hybrid Approach**

Keep the root Docker setup (Debian-based) but **add the interactive workstation experience**.

### Why This Works Best:

1. **One container for all labs** - Students don't switch environments
2. **Rich toolset** - Volatility3, Plaso, YARA all pre-installed
3. **Interactive feel** - Banner, persistent bash session
4. **Smaller overhead** - One build instead of per-lab builds
5. **Consistent workflow** - Same environment Lab 1-6

---

## Implementation Plan

### Step 1: Enhance Root Dockerfile
Add banner + entrypoint to `images/dfir-cli/Dockerfile`:

```dockerfile
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install all forensic tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates tzdata \
      sleuthkit testdisk foremost ewf-tools \
      exiftool hashdeep bulk-extractor yara \
      python3 python3-pip python3-venv \
      less file procps vim nano curl \
      && pip3 install --no-cache-dir volatility3 \
      && rm -rf /var/lib/apt/lists/*

# Copy banner and entrypoint
COPY banner.txt /etc/banner.txt
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /cases
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
```

### Step 2: Create Banner
`images/dfir-cli/banner.txt`:

```
  ________________________________________________________________
 /                                                                \
|   DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY              |
|   Cloudcore 2009 Data Exfiltration Investigation               |
 \________________________________________________________________/

  🔍 Tools Installed:
    • Sleuth Kit (fls, icat, fsstat, tsk_recover, mmls)
    • Volatility 3 (memory forensics: vol -f /evidence/memory.raw ...)
    • TestDisk/PhotoRec (file carving)
    • Foremost (signature-based carving)
    • libewf-tools (E01 image support)
    • YARA (malware pattern matching)
    • Plaso/log2timeline (via separate container)
    • bulk_extractor, exiftool, hashdeep

  📁 Workspace Structure:
    /evidence → Read-only evidence storage (DO NOT MODIFY!)
    /cases    → Your analysis outputs and reports
    /rules    → YARA rules and signatures

  ⚠️  Forensic Best Practices:
    • Never modify original evidence (evidence/ is read-only)
    • Document EVERY command executed
    • Maintain chain of custody (use hashlog)
    • Verify hashes before and after analysis

  📚 Quick Start:
    • Lab 1: Disk forensics → fls, icat, tsk_recover
    • Lab 2: Memory forensics → vol -f /evidence/memory.raw windows.pslist.PsList
    • Lab 5: Network analysis → Use tshark/Wireshark on host
    • Lab 6: Full correlation → Combine all findings

  Type 'exit' to leave the workstation. Files in /cases persist on your host.
  ________________________________________________________________

analyst@forensics-lab:/cases$
```

### Step 3: Create Entrypoint
`images/dfir-cli/entrypoint.sh`:

```bash
#!/bin/bash

# Display forensic workstation banner
cat /etc/banner.txt

# Set a forensic-themed prompt
export PS1='\[\033[01;32m\]analyst@forensics-lab\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Execute the command (default: /bin/bash for interactive)
exec "$@"
```

### Step 4: Update docker-compose.yml
Modify the `dfir` service:

```yaml
services:
  dfir:
    build: ./images/dfir-cli
    image: forensic/dfir-cli:latest
    user: "${PUID}:${PGID}"
    read_only: true
    working_dir: /cases
    volumes:
      - ./evidence:/evidence:ro
      - ./cases:/cases
      - ./rules:/rules:ro
    tmpfs:
      - /tmp
    stdin_open: true    # Keep STDIN open (for interactive)
    tty: true           # Allocate pseudo-TTY (for interactive)
    # Default command is bash (from Dockerfile CMD)
```

### Step 5: Update All Lab READMEs

**Interactive Mode (Recommended):**
```bash
# Enter the forensic workstation
docker compose run --rm dfir

# Now you're inside! Run commands directly:
fls -r /evidence/usb.img
vol -f /evidence/memory.raw windows.pslist.PsList > vol_output/pslist.txt
exit
```

**One-Off Mode (Still supported):**
```bash
docker compose run --rm dfir fls -r /evidence/usb.img
```

---

## Benefits of This Approach

### For Students:
1. **Immersive experience** - Feels like logging into a real forensic workstation
2. **Less typing** - No need to repeat `docker compose run --rm dfir` before every command
3. **Contextual** - Banner reminds them of tools, best practices, workspace structure
4. **Persistent session** - Can run multiple commands, use tab-completion, history
5. **Less intimidating** - More like using a regular Linux system

### For Instructors:
1. **One container** - Build once, use for all 6 labs
2. **Consistent** - Same environment, same workflow across labs
3. **Flexible** - Students can still run one-off commands if needed
4. **Demonstrable** - Easy to screen-share and demonstrate in class
5. **Realistic** - Mirrors how real forensic labs work (dedicated workstations)

### Technical:
1. **Debian-based** - Full tool compatibility (Volatility3, Plaso, etc.)
2. **Read-only** - Evidence protection built-in
3. **Portable** - Works on macOS, Linux, Windows (Docker Desktop)
4. **Reproducible** - Students get identical environments
5. **Scalable** - Easy to add more tools without breaking labs

---

## Migration Checklist

- [ ] Copy `banner.txt` and `entrypoint.sh` from archive to `images/dfir-cli/`
- [ ] Update `images/dfir-cli/Dockerfile` with entrypoint logic
- [ ] Add `stdin_open: true` and `tty: true` to `dfir` service in root `docker-compose.yml`
- [ ] Rebuild: `docker compose build dfir`
- [ ] Test interactive mode: `docker compose run --rm dfir`
- [ ] Update all lab READMEs with interactive workflow
- [ ] Update SETUP.md with "Enter the forensic workstation" instructions
- [ ] Create COMMANDS.md in root (like archive version) with common commands
- [ ] Test all 6 labs in interactive mode

---

## Alternative Considered: Per-Lab Containers

**Why NOT do this:**
- ❌ Students would build 6 different images (confusion, disk space)
- ❌ Alpine can't handle Volatility3 easily
- ❌ Each lab would have different tool availability
- ❌ More complex docker-compose.yml management
- ❌ Harder to maintain (6 Dockerfiles vs 1)

**When this WOULD make sense:**
- If labs had conflicting tool versions (they don't)
- If trying to minimize image size (not priority for education)
- If teaching Docker itself (but you're teaching forensics)

---

## Answer to Your Question

> Do we need to make a set just for Lab_2?

**No.** Use the root Docker setup (Debian-based) for ALL labs, but enhance it with the interactive workstation experience from the archive.

> Will Alpine work for Lab_2?

**No.** Alpine lacks Volatility3 and would require significant work to compile Python packages. Debian/Ubuntu is the right choice.

> I want the 'feel' of logging on to a workstation

**Yes!** Add the banner + entrypoint to the root Dockerfile. This gives you the immersive experience while keeping all tools available.

---

## Next Steps

1. **Implement the hybrid approach** (banner + entrypoint in root Dockerfile)
2. **Test with Lab 1 and Lab 2** to verify workflow
3. **Update all walkthroughs** to show interactive mode first
4. **Create a COMMANDS.md** at root level with common patterns
5. **Update SETUP.md** with "Enter the Workstation" quick start

Want me to implement this now?
