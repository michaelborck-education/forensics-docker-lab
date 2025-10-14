# Interactive Mode Troubleshooting

## Issue: Banner Shows But No Prompt

If you see the banner but don't get a prompt when running `docker compose run --rm dfir`, this is likely due to how Docker handles TTY allocation.

## Solution: Add -it Flag

Use the `-it` flag explicitly:

```bash
# Correct command for interactive mode:
docker compose run --rm -it dfir
```

The `-it` flag means:
- `-i`: Keep STDIN open (interactive)
- `-t`: Allocate a pseudo-TTY (terminal)

## Why This Happens

While `docker-compose.yml` has `stdin_open: true` and `tty: true`, the `docker compose run` command sometimes needs explicit `-it` for interactive sessions, especially on:
- Windows with Git Bash or WSL
- macOS with certain terminal emulators
- Linux with non-standard shells

## Testing

```bash
# Test 1: Check banner appears
docker compose run --rm -it dfir

# You should see:
#   ________________________________________________________________
#  /                                                                \
# |   DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY              |
# ...
# analyst@forensics-lab:/cases$

# Test 2: Run a command
fls --version

# Test 3: Exit
exit
```

## Update Documentation

All student-facing documentation should use:
```bash
docker compose run --rm -it dfir
```

NOT:
```bash
docker compose run --rm dfir  # May hang without -it
```

## Files to Update

- [ ] SETUP.md
- [ ] COMMANDS.md
- [ ] cases/Lab_1/README.md
- [ ] cases/Lab_2/README.md
- [ ] cases/Lab_2/WALKTHROUGH.md
- [ ] STUDENT_DISTRIBUTION.md

## Search and Replace

```bash
# Find all instances
grep -r "docker compose run --rm dfir" --include="*.md" .

# Replace (do manually to preserve context):
# OLD: docker compose run --rm dfir
# NEW: docker compose run --rm -it dfir
```

## Platform-Specific Notes

### macOS
Usually works with or without `-it`, but recommended for consistency.

### Windows (Git Bash)
**Requires** `-it` or will hang. May also need `winpty`:
```bash
winpty docker compose run --rm -it dfir
```

### Windows (PowerShell)
Usually works with `-it`:
```bash
docker compose run --rm -it dfir
```

### Linux
Generally works without `-it`, but include for consistency.

## Alternative: Create Alias

Add to student setup instructions:

```bash
# Add to ~/.bashrc or ~/.zshrc
alias forensics='docker compose run --rm -it dfir'

# Then students just run:
forensics
```

## Background Mode (Not Interactive)

For services that run in background:
```bash
# Start in background
docker compose up -d dfir

# Attach to running container
docker compose exec dfir bash

# Stop background service
docker compose down
```

## Summary

**Always use:** `docker compose run --rm -it dfir` for interactive sessions.
