# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set non-interactive mode and configure timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Install packages, configure timezone, and clean up cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    curl \
    wget \
    unzip \
    tar \
    git \
    jq \
    tzdata \
    bash \
    gettext \
    libintl-perl \
    python3 \
    python3-pip \
    gcc \
    libffi-dev \
    libssl-dev \
    musl-tools \
    python3-dev \
    make \
    python3-venv && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create and activate the Python virtual environment, then install the cryptography library
RUN python3 -m venv /root/venv && \
    /root/venv/bin/pip install --upgrade pip && \
    /root/venv/bin/pip install --no-cache-dir cryptography

# Install multiple versions of Node.js
RUN mkdir -p /opt/nodejs && \
    curl -L https://nodejs.org/dist/v14.21.3/node-v14.21.3-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v16.20.0/node-v16.20.0-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v20.5.0/node-v20.5.0-linux-x64.tar.gz | tar xvz -C /opt/nodejs

# Set environment variables for Node.js installations
ENV NODE_VERSION ""
ENV NODE_HOME_14=/opt/nodejs/node-v14.21.3-linux-x64
ENV NODE_HOME_16=/opt/nodejs/node-v16.20.0-linux-x64
ENV NODE_HOME_18=/opt/nodejs/node-v18.17.1-linux-x64
ENV NODE_HOME_20=/opt/nodejs/node-v20.5.0-linux-x64

# Add Node.js binaries to PATH
ENV PATH=$NODE_HOME_14/bin:$NODE_HOME_16/bin:$NODE_HOME_18/bin:$NODE_HOME_20/bin:$PATH

# Use the virtual environment's Python for the container
ENV VENV_PATH="/root/venv/bin:$PATH"

# Copy the script to switch versions
COPY switch_versions.sh /usr/local/bin/switch_versions.sh
RUN chmod +x /usr/local/bin/switch_versions.sh

# Set the entry point to the version switcher script
ENTRYPOINT ["/usr/local/bin/switch_versions.sh"]

# Default command
CMD ["bash"]