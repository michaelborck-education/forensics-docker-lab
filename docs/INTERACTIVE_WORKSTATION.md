# Interactive Forensic Workstation Guide

## Overview

The forensics lab now features an **immersive interactive workstation experience**. Instead of running one-off Docker commands, students can "log into" a forensic workstation that feels like a real forensic lab environment.

## How to Enter the Workstation

```bash
# Build the workstation (first time only)
docker compose build dfir

# Enter the interactive forensic workstation
docker compose run --rm -it dfir
```

**Note:** The `-it` flag is **required** for interactive mode:
- `-i` = Keep STDIN open (interactive)
- `-t` = Allocate a pseudo-TTY (terminal)

## What You See

When you enter the workstation, you'll see a banner:

```
  ________________________________________________________________
 /                                                                \
|   DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY              |
|   Cloudcore 2009 Data Exfiltration Investigation               |
 \________________________________________________________________/

  🔍 Tools Installed:
    • Sleuth Kit (fls, icat, fsstat, tsk_recover, mmls, blkls)
    • TestDisk/PhotoRec (file carving)
    • Foremost (signature-based carving)
    • libewf-tools (E01 image support)
    • YARA (malware pattern matching)
    • exiftool, hashdeep, file utilities
    • grep, strings, vim, nano

  📦 Specialized Containers (run from host):
    • Volatility 3: docker compose run --rm vol3 vol -f ...
    • Plaso/log2timeline: docker compose run --rm plaso ...

  📁 Workspace Structure:
    /evidence → Read-only evidence storage (DO NOT MODIFY!)
    /cases    → Your analysis outputs and reports
    /rules    → YARA rules and signatures

  ⚠️  Forensic Best Practices:
    • Never modify original evidence (evidence/ is read-only)
    • Document EVERY command executed
    • Maintain chain of custody (use hashlog service)
    • Verify hashes before and after analysis

  📚 Quick Command Examples (inside this workstation):
    • List files in disk image:
      fls -r /evidence/disk.img

    • Recover deleted files:
      tsk_recover /evidence/disk.img recovered/

    • Calculate evidence hash:
      sha256sum /evidence/memory.raw

    • Search with YARA:
      yara -r /rules/malware.yar /evidence/

    • Search for patterns:
      grep -i "password" USB_Imaging/*.txt

  💡 Tips:
    • Use tab-completion for file paths
    • Redirect output to /cases/ for persistence
    • Type 'exit' to leave the workstation
    • Files in /cases persist on your host machine

  ________________________________________________________________

  Environment ready. Proceed with analysis...

analyst@forensics-lab:/cases$
```

## Working Inside the Workstation

Once inside, you can run forensic tools directly without the `docker compose run --rm dfir` prefix:

```bash
# List files in disk image
fls -r /evidence/disk.img

# Recover deleted files
tsk_recover -a /evidence/disk.img USB_Imaging/recovered/

# Search for patterns
grep -i "password" USB_Imaging/*.txt

# View file metadata
exiftool evidence/encrypted_container.dat

# Calculate hashes
sha256sum /evidence/*.raw

# Exit when done
exit
```

## Benefits of Interactive Mode

### For Students:
- **Less typing** - No need to repeat `docker compose run --rm dfir` before every command
- **More realistic** - Mirrors how real forensic workstations operate
- **Tab completion** - Press Tab to autocomplete file paths
- **Command history** - Use up/down arrows to recall previous commands
- **Persistent history** - Your command history is saved to `cases/.bash_history`

### For Learning:
- **Immersive experience** - Feels like working in a real forensic lab
- **Better focus** - The banner reminds you of available tools and best practices
- **Easier exploration** - Can quickly try different commands without syntax overhead
- **Forensic-themed prompt** - `analyst@forensics-lab:/cases$` reinforces the environment

## One-Off Commands (Still Supported)

You can still run single commands without entering the workstation:

```bash
# Run a single command
docker compose run --rm dfir fls -r /evidence/disk.img

# Pipe output
docker compose run --rm dfir fls -r /evidence/disk.img > output.txt
```

This is useful for:
- Quick one-liner commands
- Scripting and automation
- Running from CI/CD pipelines

## Technical Details

### Workspace Structure

When you're inside the workstation:
- **Current directory:** `/cases` (your working directory)
- **Evidence:** `/evidence` (read-only, cannot be modified)
- **Rules:** `/rules` (YARA rules and signatures)
- **Temp:** `/tmp` (writable temporary space)

### File Persistence

Files created in `/cases` persist on your host machine in `./cases/`:

```bash
# Inside workstation:
analyst@forensics-lab:/cases$ echo "test" > USB_Imaging/notes.txt

# On your host machine:
$ cat cases/USB_Imaging/notes.txt
test
```

### Command History

Your command history is saved to `cases/.bash_history` and persists across sessions:

```bash
# Inside workstation:
analyst@forensics-lab:/cases$ history
    1  fls -r /evidence/disk.img
    2  tsk_recover -a /evidence/disk.img USB_Imaging/recovered/
    3  grep -i "password" USB_Imaging/*.txt
```

### Forensic Security

The container is **read-only** except for:
- `/cases` - Your working directory (writable)
- `/tmp` - Temporary files (writable)
- `/evidence` - Evidence storage (read-only by design)

This prevents:
- Accidental modification of evidence
- Tampering with forensic tools
- Malicious code from persisting

## Troubleshooting

### Problem: Banner shows but no prompt appears

**Solution:** You forgot the `-it` flag. Use:
```bash
docker compose run --rm -it dfir
```

Without `-it`, the terminal won't attach properly.

### Problem: "Permission denied" when writing files

**Solution:** Write to `/cases` (which maps to `./cases/` on host):
```bash
# Wrong (read-only):
echo "test" > /evidence/test.txt

# Correct (writable):
echo "test" > /cases/USB_Imaging/test.txt
```

### Problem: Commands not found

**Solution:** Make sure you're inside the workstation:
```bash
# Wrong (on host):
$ fls --version
command not found: fls

# Correct (inside workstation):
$ docker compose run --rm -it dfir
analyst@forensics-lab:/cases$ fls --version
The Sleuth Kit ver 4.12.1
```

### Problem: Tab completion doesn't work

**Solution:** Ensure you used `-it` flag when entering the workstation.

### Problem: Can't access evidence files

**Solution:** Evidence files must be in the `./evidence/` folder on your host machine. They appear at `/evidence/` inside the container.

## Platform-Specific Notes

### macOS
Works perfectly. Use Terminal or iTerm2.

### Linux
Works perfectly. Most Linux terminals support the interactive mode natively.

### Windows

**Git Bash:**
May need `winpty`:
```bash
winpty docker compose run --rm -it dfir
```

**PowerShell:**
Usually works with `-it`:
```bash
docker compose run --rm -it dfir
```

**WSL2:**
Works perfectly, just like Linux.

## Specialized Containers

Some tools run in their own containers and must be invoked from your **host machine** (not inside the dfir workstation):

### Volatility 3 (Memory Forensics)
```bash
# Run from host:
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pslist.PsList
```

### Plaso (Timeline Analysis)
```bash
# Run from host:
docker compose run --rm plaso log2timeline.py /cases/timeline.plaso /evidence/disk.img
docker compose run --rm plaso psort.py -o l2tcsv /cases/timeline.plaso > cases/timeline.csv
```

### Why separate containers?
- Volatility 3 needs its own Python environment
- Plaso is a large, specialized tool
- Separation keeps the main workstation lightweight

## Typical Workflow

1. **Enter workstation:**
   ```bash
   docker compose run --rm -it dfir
   ```

2. **Do your analysis:**
   ```bash
   fls -r /evidence/disk.img > USB_Imaging/fls.txt
   tsk_recover -a /evidence/disk.img USB_Imaging/recovered/
   grep -i "suspicious" USB_Imaging/fls.txt
   ```

3. **Exit workstation:**
   ```bash
   exit
   ```

4. **Run specialized tools (from host):**
   ```bash
   docker compose run --rm hashlog
   docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pslist.PsList
   ```

5. **Re-enter workstation to review results:**
   ```bash
   docker compose run --rm -it dfir
   cat Memory_Forensics/vol_output/pslist.txt | less
   exit
   ```

## Tips for Students

1. **Use tab completion** - Type part of a filename and press Tab
2. **Use command history** - Press up arrow to recall previous commands
3. **Save your commands** - Your history is in `cases/.bash_history`
4. **Redirect output** - Save results: `command > output.txt`
5. **Use less for viewing** - View large files: `cat file.txt | less`
6. **Create directories first** - `mkdir -p USB_Imaging/output` before redirecting
7. **Check your work** - `ls -la USB_Imaging/` to see what you've created
8. **Exit cleanly** - Always type `exit` to leave the workstation

## Advanced: Creating an Alias

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
alias forensics='docker compose run --rm -it dfir'
```

Then just run:
```bash
forensics
```

Much cleaner!

## Summary

**Interactive mode** is the recommended way to use the forensics lab:
- More immersive and realistic
- Less typing, more productivity
- Better learning experience
- Forensically sound (read-only evidence)

**Use:** `docker compose run --rm -it dfir` to enter the workstation.

See [COMMANDS.md](COMMANDS.md) for a complete command reference.
