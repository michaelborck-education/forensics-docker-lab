# DFIR CLI toolbox
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install forensic tools and utilities (including build tools for Python packages)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates tzdata \
      sleuthkit \
      testdisk \
      foremost \
      ewf-tools \
      exiftool \
      hashdeep \
      yara \
      python3 python3-pip python3-venv \
      less file procps \
      vim nano \
      curl wget \
      grep findutils \
      git \
      build-essential python3-dev \
      && pip3 install --no-cache-dir --break-system-packages \
         volatility3 \
         pycryptodome \
         distorm3 \
      && rm -rf /var/lib/apt/lists/*

# Install Volatility 2 (for legacy Windows XP/Vista/2000 support)
RUN git clone https://github.com/volatilityfoundation/volatility.git /opt/volatility2 \
    && cd /opt/volatility2 \
    && git checkout 2.6.1 \
    && ln -s /opt/volatility2/vol.py /usr/local/bin/vol2 \
    && chmod +x /opt/volatility2/vol.py

# Copy banner and entrypoint script
COPY banner.txt /etc/banner.txt
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make entrypoint executable
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /cases

# Set entrypoint to display banner and handle commands
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command for interactive mode
CMD ["/bin/bash"]
