#!/bin/bash

display_usage() {
  echo "##############################################"
  echo "# Offline Node.js, npm, pnpm, and yarn Switcher #"
  echo "##############################################"
  echo "# Set environment variables:"
  echo "# NODE_VERSION: 14 | 16 | 18 | 20 | 21 | 22 | 24 (default: 14)"
  echo "# NPM_VERSION: Use offline .tgz only (see /opt/npm)"
  echo "# PNPM_VERSION: Uses offline .tgz (pre-mapped)"
  echo "# YARN_VERSION: 1.22.19 | 1.22.22 only (offline)"
  echo "##############################################"
  echo ""
}

# Defaults
NODE_VERSION=${NODE_VERSION:-14}
NPM_VERSION=${NPM_VERSION:-""}
PNPM_VERSION=${PNPM_VERSION:-""}
YARN_VERSION=${YARN_VERSION:-"1.22.19"}

# Set node paths
case $NODE_VERSION in
  14) NODE_HOME=$NODE_HOME_14; PNPM_TARBALL="/opt/pnpm/pnpm-7.30.0.tgz";;
  16) NODE_HOME=$NODE_HOME_16; PNPM_TARBALL="/opt/pnpm/pnpm-8.6.0.tgz";;
  18) NODE_HOME=$NODE_HOME_18; PNPM_TARBALL="/opt/pnpm/pnpm-9.0.0.tgz";;
  20) NODE_HOME=$NODE_HOME_20; PNPM_TARBALL="/opt/pnpm/pnpm-10.8.1.tgz";;
  21) NODE_HOME=$NODE_HOME_21; PNPM_TARBALL="/opt/pnpm/pnpm-10.8.1.tgz";;
  22) NODE_HOME=$NODE_HOME_22; PNPM_TARBALL="/opt/pnpm/pnpm-10.8.1.tgz";;
  24) NODE_HOME=$NODE_HOME_24; PNPM_TARBALL="/opt/pnpm/pnpm-10.8.1.tgz";;
  *) echo "Unsupported NODE_VERSION: $NODE_VERSION"; display_usage; exit 1;;
esac

export PATH=$NODE_HOME/bin:$PATH

# Offline npm install
if [ -n "$NPM_VERSION" ]; then
  NPM_TARBALL="/opt/npm/npm-${NPM_VERSION}.tgz"
  if [ -f "$NPM_TARBALL" ]; then
    npm install -g "$NPM_TARBALL"
  else
    echo "Error: NPM version tarball not found at $NPM_TARBALL"
    exit 1
  fi
fi

# Offline pnpm install
npm install -g "$PNPM_TARBALL"

# Offline yarn install
YARN_DIR=""
if [ "$YARN_VERSION" == "1.22.19" ]; then
  YARN_DIR="yarn-v1.22.19"
elif [ "$YARN_VERSION" == "1.22.22" ]; then
  YARN_DIR="yarn-v1.22.22"
else
  echo "Unsupported YARN_VERSION: $YARN_VERSION"; exit 1
fi

tar -xzf "/opt/yarn/${YARN_DIR}.tar.gz" -C /usr/local
ln -sf "/usr/local/${YARN_DIR}/bin/yarn" /usr/local/bin/yarn

# Log versions
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "pnpm: $(pnpm -v)"
echo "yarn: $(yarn -v)"

exec "$@"