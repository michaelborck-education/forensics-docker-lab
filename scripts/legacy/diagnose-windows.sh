#!/bin/bash
# Diagnose Windows Docker build issues

echo "===== Docker Image Diagnostics ====="
echo ""

echo "1. Checking local entrypoint.sh line endings..."
file images/dfir-cli/entrypoint.sh
od -c images/dfir-cli/entrypoint.sh | head -3

echo ""
echo "2. Checking if image exists..."
docker images | grep forensic/dfir-cli

echo ""
echo "3. Checking entrypoint in built image..."
docker run --rm --entrypoint=/bin/sh forensic/dfir-cli:latest -c "ls -la /usr/local/bin/ | grep entry"

echo ""
echo "4. Checking if entrypoint is executable in image..."
docker run --rm --entrypoint=/bin/sh forensic/dfir-cli:latest -c "test -x /usr/local/bin/entrypoint.sh && echo 'EXECUTABLE' || echo 'NOT EXECUTABLE'"

echo ""
echo "5. Checking entrypoint shebang in image..."
docker run --rm --entrypoint=/bin/sh forensic/dfir-cli:latest -c "head -1 /usr/local/bin/entrypoint.sh | od -c"

echo ""
echo "6. Trying to run entrypoint directly..."
docker run --rm --entrypoint=/usr/local/bin/entrypoint.sh forensic/dfir-cli:latest --help

echo ""
echo "===== Diagnostics Complete ====="
