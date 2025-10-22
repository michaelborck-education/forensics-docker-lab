# YARA Rules - Malware Detection

This folder contains YARA rules for pattern-based malware detection across forensic evidence.

## Rules

### `lab1_example.yar` - Educational Example
A basic YARA rule demonstrating syntax and string matching patterns.

**Purpose:** Educational - shows how YARA rules work.
**Usage:**
```bash
# Inside forensic workstation
yara /rules/lab1_example.yar /evidence/usb.img
```

## How to Use YARA Rules

### Inside the Forensic Workstation
```bash
./scripts/forensics-workstation

# Run YARA against evidence
analyst@forensics-lab:/cases$ yara /rules/lab1_example.yar /evidence/usb.img

# Run against recovered files
analyst@forensics-lab:/cases$ yara /rules/lab1_example.yar USB_Imaging/tsk_recover_out/

# Log to chain of custody (if assignment)
analyst@forensics-lab:/cases$ coc-log "yara /rules/lab1_example.yar /evidence/usb.img" "Malware pattern matching"
```

## Mounting Rules in Container

The `rules/` folder is automatically mounted read-only in the container at `/rules`.

See `docker-compose.yml` line 17:
```yaml
volumes:
  - ./rules:/rules:ro
```

## Expanding the Rules Collection

To add more YARA rules:

1. **Create rule file:** `rules/lab3_autopsy_indicators.yar`
2. **Add rule syntax** (example):
```yara
rule SuspiciousFilePattern {
    strings:
        $str1 = "malware_signature"
        $str2 = "suspicious_pattern"
    condition:
        any of them
}
```

3. **Test rule:**
```bash
yara rules/new_rule.yar /evidence/usb.img
```

4. **Reference in lab README** if applicable

## Notes

- YARA rules are pattern-matching (not execution) - safe to run on evidence
- Rules are complementary to other forensic tools
- Most useful on Lab 3 (Autopsy) for hash lookups and pattern detection
- Can be used throughout labs 1-6 for suspicious artifact identification

---

*YARA is a powerful tool for forensic analysts to identify malware and suspicious patterns in evidence files.*
