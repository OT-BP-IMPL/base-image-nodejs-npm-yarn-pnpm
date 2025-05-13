# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set non-interactive mode and configure timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    curl \
    ca-certificates \
    xz-utils \
    gnupg \
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

# Create directories for tools
RUN mkdir -p /opt/nodejs /opt/npm /opt/pnpm /opt/yarn /usr/local/bin /root/.nvm

# Install multiple versions of Node.js
RUN mkdir -p /opt/nodejs && \
    curl -L https://nodejs.org/dist/v14.21.3/node-v14.21.3-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v16.20.0/node-v16.20.0-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v20.5.0/node-v20.5.0-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v21.7.3/node-v21.7.3-linux-x64.tar.gz | tar xvz -C /opt/nodejs

# Set environment variables for Node.js installations
ENV NODE_HOME_14=/opt/nodejs/node-v14.21.3-linux-x64
ENV NODE_HOME_16=/opt/nodejs/node-v16.20.0-linux-x64
ENV NODE_HOME_18=/opt/nodejs/node-v18.17.1-linux-x64
ENV NODE_HOME_20=/opt/nodejs/node-v20.5.0-linux-x64
ENV NODE_HOME_21=/opt/nodejs/node-v21.7.3-linux-x64

# Add Node.js binaries to PATH
ENV PATH=$NODE_HOME_14/bin:$NODE_HOME_16/bin:$NODE_HOME_18/bin:$NODE_HOME_20/bin:$NODE_HOME_21/bin$PATH

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 14.21.3 && \
    nvm install 16.20.0 && \
    nvm install 18.17.1 && \
    nvm install 20.5.0 && \
    nvm install 21.7.3 && \
    nvm alias default 14.21.3

# Pre-download specific npm versions
RUN mkdir -p /opt/npm && \
    curl -fsSL https://registry.npmjs.org/npm/-/npm-6.14.17.tgz -o /opt/npm/npm-6.14.17.tgz && \
    curl -fsSL https://registry.npmjs.org/npm/-/npm-8.19.2.tgz -o /opt/npm/npm-8.19.2.tgz && \
    curl -fsSL https://registry.npmjs.org/npm/-/npm-9.8.1.tgz -o /opt/npm/npm-9.8.1.tgz && \
    curl -fsSL https://registry.npmjs.org/npm/-/npm-10.9.2.tgz -o /opt/npm/npm-10.9.2.tgz \
    curl -fsSL https://registry.npmjs.org/npm/-/npm-11.3.0.tgz -o /opt/npm/npm-11.3.0.tgz

# Pre-download specific pnpm versions
RUN mkdir -p /opt/pnpm && \
    curl -fsSL https://registry.npmjs.org/pnpm/-/pnpm-7.30.0.tgz -o /opt/pnpm/pnpm-7.30.0.tgz && \
    curl -fsSL https://registry.npmjs.org/pnpm/-/pnpm-8.6.0.tgz -o /opt/pnpm/pnpm-8.6.0.tgz && \
    curl -fsSL https://registry.npmjs.org/pnpm/-/pnpm-9.0.0.tgz -o /opt/pnpm/pnpm-9.0.0.tgz && \
    curl -fsSL https://registry.npmjs.org/pnpm/-/pnpm-10.8.1.tgz -o /opt/pnpm/pnpm-10.8.1.tgz

# Pre-download specific yarn versions
RUN mkdir -p /opt/yarn && \
    curl -fsSL https://github.com/yarnpkg/yarn/releases/download/v1.22.19/yarn-v1.22.19.tar.gz -o /opt/yarn/yarn-v1.22.19.tar.gz && \
    curl -fsSL https://github.com/yarnpkg/yarn/releases/download/v1.22.22/yarn-v1.22.22.tar.gz -o /opt/yarn/yarn-v1.22.22.tar.gz

# Copy the script to switch versions
COPY switch_versions.sh /usr/local/bin/switch_versions.sh
RUN chmod +x /usr/local/bin/switch_versions.sh

# Set the entry point to the version switcher script
ENTRYPOINT ["/usr/local/bin/switch_versions.sh"]

# Default command
CMD ["bash"]