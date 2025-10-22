FROM ubuntu:18.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python2.7 \
    python-pip \
    git \
    build-essential \
    python-dev \
    libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Volatility 2 from source
RUN git clone https://github.com/volatilityfoundation/volatility.git /tmp/volatility && \
    cd /tmp/volatility && \
    python setup.py install && \
    rm -rf /tmp/volatility

# Create working directory
WORKDIR /evidence

# Default command
CMD ["vol.py", "-h"]