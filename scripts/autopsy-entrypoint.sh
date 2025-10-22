#!/bin/bash

# Autopsy VNC entrypoint script
# Uses DISPLAY_WIDTH and DISPLAY_HEIGHT environment variables

# Set defaults if not provided
WIDTH=${DISPLAY_WIDTH:-1280}
HEIGHT=${DISPLAY_HEIGHT:-720}

echo "Starting Autopsy with resolution: ${WIDTH}x${HEIGHT}"

# Start Xvfb with the configured resolution
Xvfb :1 -screen 0 ${WIDTH}x${HEIGHT}x16 &

# Wait for X server to start
sleep 5

# Set display
export DISPLAY=:1

# Start Autopsy
/opt/autopsy/bin/autopsy &

# Start VNC server
x11vnc -display :1 -forever -nopw -rfbport 5900 -shared
