#!/bin/bash

# Display the forensic workstation banner
cat /etc/banner.txt

# Set HOME to writable location (container is read-only)
export HOME=/cases

# Set a forensic-themed prompt for interactive sessions
export PS1='\[\033[01;32m\]analyst@forensics-lab\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Set up bash history for convenience
export HISTFILE=/cases/.bash_history
export HISTSIZE=1000
export HISTFILESIZE=2000

# Bash needs a writable temp dir in read-only containers
export TMPDIR=/tmp

# Execute the command passed to the container
if [ "$#" -eq 0 ]; then
    # No command provided - start bash
    # Check if we have a TTY (interactive mode)
    if [ -t 0 ]; then
        # Interactive mode with TTY
        exec /bin/bash --norc
    else
        # No TTY - print message and exit cleanly
        echo ""
        echo "⚠️  No interactive terminal detected."
        echo "    For interactive mode, use: docker compose run --rm -it dfir"
        echo "    For one-off commands, use: docker compose run --rm dfir <command>"
        echo ""
        exit 0
    fi
else
    # Command provided - execute it
    exec "$@"
fi
