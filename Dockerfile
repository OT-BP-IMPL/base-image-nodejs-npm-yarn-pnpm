FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata
ENV AIRGAP_ENV=true

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
        python3 \
        python3-pip \
        build-essential \
        libffi-dev \
        libssl-dev \
        python3-dev \
        g++ \
        python3-venv && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 🔸 Create non-root buildpiper user and group
RUN addgroup --gid 1001 buildpiper && \
    adduser --disabled-password --gecos "" --uid 1001 --gid 1001 --home /home/buildpiper buildpiper && \
    mkdir -p /home/buildpiper && \
    chown -R buildpiper:buildpiper /home/buildpiper



# 🔸 Create node-related folders
RUN mkdir -p /opt/nodejs /opt/npm /opt/pnpm /opt/yarn /opt/node_headers /root/.cache/node-gyp && \
    chown -R buildpiper:buildpiper /opt /root/.cache/node-gyp

WORKDIR /opt

RUN set -eux; \
    for version in 14.21.3 16.20.0 18.17.1 20.5.0 21.7.3; do \
        curl --retry 5 --retry-delay 2 --max-time 60 --connect-timeout 10 -L --fail -o node-v${version}.tar.xz \
          https://nodejs.org/dist/v${version}/node-v${version}-linux-x64.tar.xz; \
        tar -xf node-v${version}.tar.xz -C /opt/nodejs; \
        rm node-v${version}.tar.xz; \
        curl -fsSL -o /opt/node_headers/node-v${version}-headers.tar.gz \
          https://nodejs.org/dist/v${version}/node-v${version}-headers.tar.gz; \
    done

RUN for version in 14.21.3 16.20.0 18.17.1 20.5.0 21.7.3; do \
    mkdir -p /root/.cache/node-gyp/${version}; \
    tar -xzf /opt/node_headers/node-v${version}-headers.tar.gz -C /root/.cache/node-gyp/${version} --strip-components=1; \
done

RUN set -eux; \
    cd /opt/npm; \
    for v in 6.14.18 7.24.2 8.19.2 9.8.1 10.5.0 10.9.2 11.3.0; do \
        curl -fsSL -O https://registry.npmjs.org/npm/-/npm-${v}.tgz; \
    done

RUN set -eux; \
    cd /opt/pnpm; \
    for v in 7.30.0 8.6.0 9.0.0 10.8.1; do \
        curl -fsSL -O https://registry.npmjs.org/pnpm/-/pnpm-${v}.tgz; \
    done

RUN set -eux; \
    cd /opt/yarn; \
    for v in 1.22.19 1.22.22; do \
        curl -fsSL -O https://github.com/yarnpkg/yarn/releases/download/v${v}/yarn-v${v}.tar.gz; \
    done

# 🔸 Copy version switcher and give permission
COPY --chown=buildpiper:buildpiper switch_versions.sh /usr/local/bin/switch_versions.sh
RUN chmod +x /usr/local/bin/switch_versions.sh

# 🔸 Set working directory for user
WORKDIR /home/buildpiper

# 🔸 Change ownership of necessary folders
RUN mkdir -p /home/buildpiper/.cache /bp/workspace && \
    chown -R buildpiper:buildpiper /home/buildpiper /bp /opt /root/.cache

# 🔸 Switch to non-root user
USER buildpiper

ENTRYPOINT ["/usr/local/bin/switch_versions.sh"]
# CMD ["bash"]
