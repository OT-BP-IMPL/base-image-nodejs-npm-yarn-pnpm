FROM ubuntu:20.04 as test-builder

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Copy the original Dockerfile content here
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata
ENV AIRGAP_ENV=true

RUN if command -v apk >/dev/null 2>&1; then \
      addgroup -g 65522 buildpiper && \
      adduser -u 65522 -G buildpiper -D -h /home/buildpiper buildpiper; \
    else \
      groupadd -g 65522 buildpiper && \
      useradd -u 65522 -g buildpiper -d /home/buildpiper -m buildpiper; \
    fi && \
    chown -R buildpiper:buildpiper /home/buildpiper

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
        vim \
        nano \
        python3-venv && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
    /src/reports \
    /bp/data \
    /bp/execution_dir \
    /opt/buildpiper/shell-functions \
    /opt/buildpiper/data \
    /bp/workspace \
    /usr/local/bin \
    /var/lib/apt/lists \
    /opt/python_versions \
    /opt/jdk \
    /opt/maven \
    /opt/yarn \
    /opt/pnpm \
    /opt/npm \
    /opt/nodejs \
    /opt/node_headers \
    /home/buildpiper/.cache/node-gyp \
    /home/buildpiper/.nvm \
    /home/buildpiper/.npm \
    /home/buildpiper/.pnpm \
    /home/buildpiper/.yarn \
    /app/venv && \
    chown -R buildpiper:buildpiper /src /bp /opt /usr /tmp /app /home/buildpiper

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

RUN for version in 14.21.3 16.20.0 18.17.1 20.5.0 20.13.0 21.7.3; do \
    mkdir -p /home/buildpiper/.cache/node-gyp/${version}; \
    tar -xzf /opt/node_headers/node-v${version}-headers.tar.gz -C /home/buildpiper/.cache/node-gyp/${version} --strip-components=1; \
done

RUN chown -R buildpiper:buildpiper /opt/nodejs /home/buildpiper/.cache/node-gyp

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

COPY --chown=buildpiper:buildpiper switch_versions.sh /usr/local/bin/switch_versions.sh
RUN chmod +x /usr/local/bin/switch_versions.sh

USER buildpiper

ENTRYPOINT ["/usr/local/bin/switch_versions.sh"]
