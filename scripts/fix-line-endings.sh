#!/bin/bash
# Fix line endings for Docker files on Windows

echo "Fixing line endings for Docker compatibility..."

# Convert CRLF to LF for critical Docker files
dos2unix images/dfir-cli/entrypoint.sh 2>/dev/null || sed -i 's/\r$//' images/dfir-cli/entrypoint.sh
dos2unix images/dfir-cli/Dockerfile 2>/dev/null || sed -i 's/\r$//' images/dfir-cli/Dockerfile
dos2unix docker-compose.yml 2>/dev/null || sed -i 's/\r$//' docker-compose.yml

echo "✓ Line endings fixed"
echo ""
echo "Now rebuild the Docker image:"
echo "  docker compose build dfir"
