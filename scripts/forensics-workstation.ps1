#################################################################################
# DFIR Workstation Login Simulator - PowerShell Version for Windows
#
# This script provides an immersive entry experience for the Forensics Docker Lab
# It hides Docker commands and simulates logging into a dedicated DFIR workstation
#
# Usage: .\scripts\forensics-workstation.ps1 [analyst_name]
# Example: .\scripts\forensics-workstation.ps1 -AnalystName "Alice Johnson"
#################################################################################

param(
    [string]$AnalystName = "",
    [switch]$Help = $false
)

# Enable color output (PowerShell 7+)
$PSDefaultParameterValues['Out-Default:OutVariable'] = $null

# Color codes for Windows PowerShell
$Colors = @{
    Red    = "Red"
    Green  = "Green"
    Yellow = "Yellow"
    Blue   = "Cyan"
    Cyan   = "Cyan"
    NC     = "White"
}

# Configuration
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$DockerComposeCmd = "docker-compose"

#################################################################################
# Functions
#################################################################################

function Print-Banner {
    Write-Host ""
    Write-Host "  ╔═════════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Blue
    Write-Host "  ║                                                                 ║" -ForegroundColor $Colors.Blue
    Write-Host "  ║     DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY           ║" -ForegroundColor $Colors.Blue
    Write-Host "  ║                                                                 ║" -ForegroundColor $Colors.Blue
    Write-Host "  ║           Cyber Security Investigation Environment             ║" -ForegroundColor $Colors.Blue
    Write-Host "  ║                                                                 ║" -ForegroundColor $Colors.Blue
    Write-Host "  ╚═════════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Blue
    Write-Host ""
}

function Check-Docker {
    try {
        $dockerVersion = & docker --version 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "✗ Error: Docker is not installed or not in PATH" -ForegroundColor $Colors.Red
            Write-Host "  Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
            exit 1
        }
    }
    catch {
        Write-Host "✗ Error: Docker is not installed or not in PATH" -ForegroundColor $Colors.Red
        exit 1
    }

    try {
        $null = & docker info 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "✗ Error: Docker daemon is not running" -ForegroundColor $Colors.Red
            Write-Host "  Please start Docker Desktop and try again"
            exit 1
        }
    }
    catch {
        Write-Host "✗ Error: Docker daemon is not running" -ForegroundColor $Colors.Red
        exit 1
    }
}

function Check-EvidenceFiles {
    $usbImg = Join-Path $ProjectRoot "evidence" "usb.img"
    $usbE01 = Join-Path $ProjectRoot "evidence" "usb.E01"

    if (-not (Test-Path $usbImg) -and -not (Test-Path $usbE01)) {
        Write-Host "⚠ Warning: No evidence files found in evidence/ directory" -ForegroundColor $Colors.Yellow
        Write-Host "  Expected: usb.img or usb.E01"
        Write-Host "  Students should copy evidence files from OneDrive to evidence/ folder"
        Write-Host ""

        $response = Read-Host "Continue anyway? (y/n)"
        if ($response -notmatch "^[Yy]") {
            exit 0
        }
    }
}

function Prompt-AnalystName {
    if ([string]::IsNullOrWhiteSpace($AnalystName)) {
        Write-Host "Forensic Analyst Login" -ForegroundColor $Colors.Cyan
        $AnalystName = Read-Host "Enter analyst name (for case documentation)"

        if ([string]::IsNullOrWhiteSpace($AnalystName)) {
            $AnalystName = "analyst"
        }
    }

    return $AnalystName
}

function Show-CaseMenu {
    Write-Host ""
    Write-Host "Available Cases:" -ForegroundColor $Colors.Cyan
    Write-Host "  1 - USB_Imaging - Evidence handling, imaging and initial triage"
    Write-Host "  2 - Memory_Forensics - Memory analysis with Volatility 2"
    Write-Host "  3 - Autopsy_GUI - Graphical forensic examination"
    Write-Host "  4 - Email_Logs - Email artifact and log analysis"
    Write-Host "  5 - Network_Analysis - Network traffic and C2 detection"
    Write-Host "  6 - Final_Report - Synthesis and professional reporting"
    Write-Host "  0 - Skip case selection (all labs available)"
    Write-Host ""

    $labChoice = Read-Host "Select lab (0-6) [0]"
    if ([string]::IsNullOrWhiteSpace($labChoice)) {
        $labChoice = "0"
    }

    if ($labChoice -match "^[1-6]`$") {
        $labName = switch ($labChoice) {
            "1" { "USB_Imaging" }
            "2" { "Memory_Forensics" }
            "3" { "Autopsy_GUI" }
            "4" { "Email_Logs" }
            "5" { "Network_Analysis" }
            "6" { "Final_Report" }
        }
        Write-Host "Success: $labName selected" -ForegroundColor $Colors.Green
    }
    elseif ($labChoice -ne "0") {
        Write-Host "Warning: Invalid selection, proceeding with all labs" -ForegroundColor $Colors.Yellow
        $labChoice = "0"
    }

    return $labChoice
}

function Connect-ToWorkstation {
    param([string]$AnalystNameParam)

    Write-Host ""
    Write-Host "Connecting to DFIR Workstation..." -ForegroundColor $Colors.Blue
    Start-Sleep -Seconds 1
    Write-Host "Initializing forensic environment..." -ForegroundColor $Colors.Cyan
    Start-Sleep -Seconds 1
    Write-Host "✓ Connection established" -ForegroundColor $Colors.Green
    Start-Sleep -Seconds 1
    Write-Host ""

    # Change to project directory
    Set-Location $ProjectRoot

    # Sanitize analyst name for environment variable
    $AnalystNameSanitized = $AnalystNameParam -replace ' ', '_' -replace '[^\w]', ''

    # Set environment variable and run container
    $env:ANALYST_NAME = $AnalystNameSanitized

    try {
        & docker compose run --rm `
            --env "ANALYST_NAME=$AnalystNameSanitized" `
            -it dfir bash
    }
    catch {
        Write-Host "Error running Docker container: $_" -ForegroundColor $Colors.Red
        exit 1
    }

    # Container has exited
    Write-Host ""
    Write-Host "Disconnecting from DFIR Workstation..." -ForegroundColor $Colors.Cyan
    Start-Sleep -Seconds 1
    Write-Host "✓ Session ended" -ForegroundColor $Colors.Green
}

function Show-Help {
    Write-Host "Usage:" -ForegroundColor $Colors.Cyan
    Write-Host "  .\scripts\forensics-workstation.ps1 [options]"
    Write-Host ""
    Write-Host "Options:" -ForegroundColor $Colors.Cyan
    Write-Host "  -AnalystName NAME    Your name for case documentation"
    Write-Host "  -Help                Show this help message"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor $Colors.Cyan
    Write-Host "  .\scripts\forensics-workstation.ps1"
    Write-Host "  .\scripts\forensics-workstation.ps1 -AnalystName 'Alice Johnson'"
    Write-Host ""
    Write-Host "Inside the workstation:" -ForegroundColor $Colors.Cyan
    Write-Host "  ewfverify --evidence-file usb.E01"
    Write-Host "  fls -r evidence_image"
    Write-Host "  coc-log command note"
    Write-Host ""
    Write-Host "Exit with: exit" -ForegroundColor $Colors.Yellow
}

#################################################################################
# Main
#################################################################################

function Main {
    # Handle help flag
    if ($Help) {
        Show-Help
        exit 0
    }

    # Print welcome banner
    Print-Banner

    # System checks
    Check-Docker
    Check-EvidenceFiles

    # Get analyst name
    $AnalystName = Prompt-AnalystName

    # Optional case selection
    $LabChoice = Show-CaseMenu

    # Connect to workstation
    Connect-ToWorkstation $AnalystName

    # Cleanup and goodbye
    Write-Host "Thank you for using the Forensics Lab" -ForegroundColor $Colors.Cyan
    Write-Host "All work saved to cases folder" -ForegroundColor $Colors.Cyan
}

# Run main function
Main
