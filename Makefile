.PHONY: start verify setup help

help:
	@echo "Digital Forensics Lab - Quick Commands"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "  make setup      - Build Docker containers (first time only)"
	@echo "  make verify     - Verify your setup is correct"
	@echo "  make start      - Enter the forensic workstation"
	@echo ""
	@echo "Quick start:"
	@echo ""
	@echo "  1. make setup        (first time only, ~2-5 minutes)"
	@echo "  2. make verify       (optional, verify everything works)"
	@echo "  3. make start        (enter the lab environment)"
	@echo ""

setup:
	@echo "Building Docker containers for forensic analysis..."
	@echo ""
	docker compose build
	@echo ""
	@echo "✓ Build complete! Next: make verify"
	@echo ""

verify:
	@echo "Verifying forensics lab setup..."
	@echo ""
	@if command -v bash >/dev/null 2>&1; then \
		./scripts/verify_setup.sh; \
	else \
		call scripts\verify_setup.bat; \
	fi
	@echo ""

start:
	@if command -v bash >/dev/null 2>&1; then \
		./start.sh; \
	else \
		call start.bat; \
	fi
