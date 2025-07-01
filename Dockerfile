FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Install dependencies
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
        build-essential \
        libffi-dev \
        libssl-dev \
        musl-tools \
        python3-dev \
        python3-venv && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create directories for storing all the tools
RUN mkdir -p /opt/nodejs /opt/npm /opt/pnpm /opt/yarn /opt/node_headers

WORKDIR /opt

# Download Node.js binaries
RUN curl -fsSL -o node-v14.tar.xz https://nodejs.org/dist/v14.21.3/node-v14.21.3-linux-x64.tar.xz && \
    curl -fsSL -o node-v16.tar.xz https://nodejs.org/dist/v16.20.0/node-v16.20.0-linux-x64.tar.xz && \
    curl -fsSL -o node-v18.tar.xz https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.xz && \
    curl -fsSL -o node-v20.tar.xz https://nodejs.org/dist/v20.5.0/node-v20.5.0-linux-x64.tar.xz && \
    curl -fsSL -o node-v21.tar.xz https://nodejs.org/dist/v21.7.3/node-v21.7.3-linux-x64.tar.xz && \
    tar -xf node-v14.tar.xz -C /opt/nodejs && \
    tar -xf node-v16.tar.xz -C /opt/nodejs && \
    tar -xf node-v18.tar.xz -C /opt/nodejs && \
    tar -xf node-v20.tar.xz -C /opt/nodejs && \
    tar -xf node-v21.tar.xz -C /opt/nodejs && \
    rm -f node-v*.tar.xz

# Download Node.js headers for node-gyp offline builds
RUN for version in 14.21.3 16.20.0 18.17.1 20.5.0 21.7.3; do \
      curl -fsSL -o /opt/node_headers/node-v${version}-headers.tar.gz \
        https://nodejs.org/dist/v${version}/node-v${version}-headers.tar.gz; \
    done

# # Download npm tarballs
# RUN curl -fsSL -o /opt/npm/npm-6.14.18.tgz https://registry.npmjs.org/npm/-/npm-6.14.18.tgz && \
#     curl -fsSL -o /opt/npm/npm-7.24.2.tgz https://registry.npmjs.org/npm/-/npm-7.24.2.tgz && \
#     curl -fsSL -o /opt/npm/npm-8.19.2.tgz https://registry.npmjs.org/npm/-/npm-8.19.2.tgz && \
#     curl -fsSL -o /opt/npm/npm-9.8.1.tgz https://registry.npmjs.org/npm/-/npm-9.8.1.tgz && \
#     curl -fsSL -o /opt/npm/npm-10.9.2.tgz https://registry.npmjs.org/npm/-/npm-10.9.2.tgz && \
#     curl -fsSL -o /opt/npm/npm-11.3.0.tgz https://registry.npmjs.org/npm/-/npm-11.3.0.tgz

# Download pnpm tarballs
RUN curl -fsSL -o /opt/pnpm/pnpm-7.30.0.tgz https://registry.npmjs.org/pnpm/-/pnpm-7.30.0.tgz && \
    curl -fsSL -o /opt/pnpm/pnpm-8.6.0.tgz https://registry.npmjs.org/pnpm/-/pnpm-8.6.0.tgz && \
    curl -fsSL -o /opt/pnpm/pnpm-9.0.0.tgz https://registry.npmjs.org/pnpm/-/pnpm-9.0.0.tgz && \
    curl -fsSL -o /opt/pnpm/pnpm-10.8.1.tgz https://registry.npmjs.org/pnpm/-/pnpm-10.8.1.tgz

# Download Yarn tarballs
RUN curl -fsSL -o /opt/yarn/yarn-v1.22.19.tar.gz https://github.com/yarnpkg/yarn/releases/download/v1.22.19/yarn-v1.22.19.tar.gz && \
    curl -fsSL -o /opt/yarn/yarn-v1.22.22.tar.gz https://github.com/yarnpkg/yarn/releases/download/v1.22.22/yarn-v1.22.22.tar.gz

# Copy the switching script
COPY switch_versions.sh /usr/local/bin/switch_versions.sh
RUN chmod +x /usr/local/bin/switch_versions.sh

# Default workdir
WORKDIR /src

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/switch_versions.sh"]

# By default, just start bash (you can override)
CMD ["bash"]
