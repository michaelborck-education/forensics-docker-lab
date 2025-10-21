FROM python:2.7-alpine

# Install system dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    python-dev \
    libffi-dev \
    git

# Install Volatility 2 from source
RUN git clone https://github.com/volatilityfoundation/volatility.git /tmp/volatility && \
    cd /tmp/volatility && \
    python setup.py install && \
    rm -rf /tmp/volatility

# Create working directory
WORKDIR /evidence

# Default command
CMD ["vol.py", "-h"]