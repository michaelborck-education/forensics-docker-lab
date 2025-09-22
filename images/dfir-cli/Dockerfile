# DFIR CLI toolbox
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&     apt-get install -y --no-install-recommends       ca-certificates tzdata       sleuthkit       testdisk       foremost       ewf-tools       exiftool       hashdeep       bulk-extractor       yara       python3 python3-pip python3-venv       less file procps &&     pip3 install --no-cache-dir volatility3 &&     rm -rf /var/lib/apt/lists/*

WORKDIR /cases
ENTRYPOINT ["/bin/bash"]
