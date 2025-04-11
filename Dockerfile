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

# Install multiple versions of JDK
RUN mkdir -p /opt/jdk && \
    curl -L https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12+7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz | tar xvz -C /opt/jdk && \
    curl -L https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2+8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.2_8.tar.gz | tar xvz -C /opt/jdk && \
    curl -L https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u312-b07/OpenJDK8U-jdk_x64_linux_hotspot_8u312b07.tar.gz | tar xvz -C /opt/jdk && \
    curl -L https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21+35/OpenJDK21U-jdk_x64_linux_hotspot_21_35.tar.gz | tar xvz -C /opt/jdk

# Install multiple versions of Maven
RUN mkdir -p /opt/maven && \
    curl -L https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar xvz -C /opt/maven && \
    curl -L https://archive.apache.org/dist/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz | tar xvz -C /opt/maven && \
    curl -L https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz | tar xvz -C /opt/maven && \
    curl -L https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz | tar xvz -C /opt/maven

# Install multiple versions of Node.js
RUN mkdir -p /opt/nodejs && \
    curl -L https://nodejs.org/dist/v14.21.3/node-v14.21.3-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v16.20.0/node-v16.20.0-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.gz | tar xvz -C /opt/nodejs && \
    curl -L https://nodejs.org/dist/v20.5.0/node-v20.5.0-linux-x64.tar.gz | tar xvz -C /opt/nodejs

# Set environment variables for JDK installations
ENV JAVA_VERSION ""
ENV JAVA_HOME_8=/opt/jdk/jdk8u312-b07
ENV JAVA_HOME_11=/opt/jdk/jdk-11.0.12+7
ENV JAVA_HOME_17=/opt/jdk/jdk-17.0.2+8
ENV JAVA_HOME_21=/opt/jdk/jdk-21+35

# Set environment variables for Maven installations
ENV MAVEN_VERSION ""
ENV MAVEN_HOME_363=/opt/maven/apache-maven-3.6.3
ENV MAVEN_HOME_381=/opt/maven/apache-maven-3.8.1
ENV MAVEN_HOME_354=/opt/maven/apache-maven-3.5.4
ENV MAVEN_HOME_399=/opt/maven/apache-maven-3.9.9

# Set environment variables for Node.js installations
ENV NODE_VERSION ""
ENV NODE_HOME_14=/opt/nodejs/node-v14.21.3-linux-x64
ENV NODE_HOME_16=/opt/nodejs/node-v16.20.0-linux-x64
ENV NODE_HOME_18=/opt/nodejs/node-v18.17.1-linux-x64
ENV NODE_HOME_20=/opt/nodejs/node-v20.5.0-linux-x64

# Add binaries to PATH
ENV PATH=$JAVA_HOME_8/bin:$JAVA_HOME_11/bin:$JAVA_HOME_17/bin:$JAVA_HOME_21/bin:$MAVEN_HOME_363/bin:$MAVEN_HOME_381/bin:$MAVEN_HOME_354/bin:$MAVEN_HOME_399/bin:$NODE_HOME_14/bin:$NODE_HOME_16/bin:$NODE_HOME_18/bin:$NODE_HOME_20/bin:$PATH

# Use the virtual environment's Python for the container
ENV VENV_PATH="/root/venv/bin:$PATH"

# Copy the script to switch versions
COPY switch_versions.sh /usr/local/bin/switch_versions.sh
RUN chmod +x /usr/local/bin/switch_versions.sh

# Set the entry point to the version switcher script
ENTRYPOINT ["/usr/local/bin/switch_versions.sh"]

# Default command
CMD ["bash"]