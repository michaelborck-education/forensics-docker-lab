#!/bin/bash

# Display the welcome banner every time the container starts
cat /etc/banner.txt

# Execute the command passed to the container
# This allows 'docker compose run dfir /bin/bash' or
# 'docker compose run dfir fls ...' to work as expected.
exec "$@"
