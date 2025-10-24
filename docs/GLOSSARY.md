# Glossary - Forensic Analysis Terms

## Core Forensic Concepts

- **Chain-of-Custody (CoC)**: Log of evidence handling showing who accessed evidence, when, and why. Digital evidence includes hashes (SHA-256, MD5) to prove integrity. Documented in `cases/*/chain_of_custody.csv`.

- **Write Blocker**: Hardware device that prevents accidental modification of evidence during imaging. Used with USB devices, hard drives, etc. to maintain forensic integrity.

- **Carving**: Recovering files from unallocated disk space using file headers/footers without relying on filesystem metadata. Useful for deleted files.

## Tools Used in These Labs

- **Autopsy**: GUI forensic analysis framework for filesystem examination, timeline analysis, and artifact extraction.

- **Sleuth Kit (fls, icat, fsstat)**: Command-line tools for filesystem analysis, deleted file recovery, and file extraction.

- **Volatility2/3**: Memory analysis framework for examining RAM dumps. Tools like `pslist` (processes), `netscan` (network connections), and `psxview` (process verification).

- **tshark**: Command-line network packet analyzer. Used for protocol filtering (DNS, HTTP, IRC) and data volume analysis.

- **Wireshark**: GUI version of tshark for interactive network traffic analysis.

- **YARA**: Rule-based malware and file pattern scanner (optional).

## Attack Indicators

- **C2 (Command and Control)**: Communication channel for remote malware control. In these labs, demonstrated via IRC connections to external servers.

- **Exfiltration**: Data theft - sensitive data being transferred to external servers. Network analysis shows large outbound data volumes.

- **Keylogger**: Software that captures keyboard input. Detected in memory analysis and filesystem examination.

- **TrueCrypt**: Encryption tool for creating hidden volumes. Detected as running process in memory, evidence file on disk.

- **IRC (Internet Relay Chat)**: Legacy chat protocol (ports 6667-6669) used by botnets for C2 communication.

## Investigation Phases

- **Triage**: Quick initial examination with wildcards and filters to identify evidence and suspicious files.

- **Deep Dive**: Detailed analysis of specific evidence using precise paths and tools, documenting exact findings.

- **Correlation**: Cross-referencing findings across multiple evidence sources (disk, memory, network, email) to build the complete attack picture.

- **Reporting**: Compilation of findings into professional reports suitable for legal proceedings.
