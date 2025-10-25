#!/bin/bash

#################################################################################
# Digital Forensics Lab - Start Script
#
# Simple root-level entry point to start the forensic workstation
# This script delegates to the main implementation in scripts/forensics-workstation
#
# Usage: ./start.sh [analyst_name]
# Examples:
#   ./start.sh
#   ./start.sh "Alice Johnson"
#################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/scripts/forensics-workstation" "$@"
