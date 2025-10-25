@echo off
REM #############################################################################
REM # Digital Forensics Lab - Start Script (Windows)
REM #
REM # Simple root-level entry point to start the forensic workstation
REM # This script delegates to the main implementation in scripts/forensics-workstation.bat
REM #
REM # Usage: start.bat [analyst_name]
REM # Examples:
REM #   start.bat
REM #   start.bat "Alice Johnson"
REM #############################################################################

setlocal enabledelayedexpansion

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0

REM Call the actual implementation
call "%SCRIPT_DIR%scripts\forensics-workstation.bat" %*
