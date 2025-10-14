#!/bin/bash

# Display the forensic workstation banner
cat /etc/banner.txt

# Set HOME to writable location (container is read-only)
export HOME=/cases

# Fix "I have no name!" by setting USER environment variable
# This works even in read-only containers
export USER=analyst
export LOGNAME=analyst

# Create .bashrc in /cases with forensic prompt (bash will source this on interactive start)
cat > /cases/.bashrc << 'EOF'
# Forensic workstation prompt
export PS1='\[\033[01;32m\]analyst@forensics-lab\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export USER=analyst
export LOGNAME=analyst
EOF

# Also export for non-interactive commands
export PS1='\[\033[01;32m\]analyst@forensics-lab\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Set up bash history for convenience
export HISTFILE=/cases/.bash_history
export HISTSIZE=1000
export HISTFILESIZE=2000

# Bash needs a writable temp dir in read-only containers
export TMPDIR=/tmp

# Execute the command passed to the container
# This allows both:
# - Interactive: docker compose run --rm -it dfir (CMD provides /bin/bash)
# - One-off: docker compose run --rm dfir fls /evidence/disk.img
exec "$@"
