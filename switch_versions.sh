#!/bin/bash

# Function to display usage instructions
display_usage() {
  echo "##############################################"
  echo "# Welcome to the Node.js, npm, pnpm, and yarn Switcher #"
  echo "##############################################"
  echo "# Usage:"
  echo "# Set the following environment variables to control the versions:"
  echo "#"
  echo "# - NODE_VERSION: Choose from 14, 16, 18, or 20 (default: 14)"
  echo "# - NPM_VERSION: Specify the npm version (default: version for the selected Node.js)"
  echo "# - PNPM_VERSION: Specify the pnpm version (default: version for the selected Node.js)"
  echo "# - YARN_VERSION: Specify the yarn version (default: 1.22.19)"
  echo "#"
  echo "# Example:"
  echo "# docker run -it --rm -e NODE_VERSION=16 -e NPM_VERSION=8.19.2 -e PNPM_VERSION=8.6.0 -e YARN_VERSION=3.5.1 custom-ubuntu-nodejs-npm"
  echo "##############################################"
  echo ""
}

# Default versions
NODE_VERSION=${NODE_VERSION:-14}
NPM_VERSION=${NPM_VERSION:-""}
PNPM_VERSION=${PNPM_VERSION:-""}
YARN_VERSION=${YARN_VERSION:-"1.22.19"}

# Check for unsupported NODE_VERSION
if [ "$NODE_VERSION" != "14" ] && [ "$NODE_VERSION" != "16" ] && [ "$NODE_VERSION" != "18" ] && [ "$NODE_VERSION" != "20" ]; then
  echo "Error: Unsupported NODE_VERSION: $NODE_VERSION"
  display_usage
  exit 1
fi

# Switch Node.js version
if [ "$NODE_VERSION" == "14" ]; then
  export NODE_HOME=$NODE_HOME_14
  export PNPM_TARBALL="/opt/pnpm/pnpm-7.30.0.tgz"
elif [ "$NODE_VERSION" == "16" ]; then
  export NODE_HOME=$NODE_HOME_16
  export PNPM_TARBALL="/opt/pnpm/pnpm-8.6.0.tgz"
elif [ "$NODE_VERSION" == "18" ]; then
  export NODE_HOME=$NODE_HOME_18
  export PNPM_TARBALL="/opt/pnpm/pnpm-9.0.0.tgz"
elif [ "$NODE_VERSION" == "20" ]; then
  export NODE_HOME=$NODE_HOME_20
  export PNPM_TARBALL="/opt/pnpm/pnpm-10.8.1.tgz"
fi

# Update PATH
export PATH=$NODE_HOME/bin:$PATH

# Ensure nvm is loaded
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Use the correct Node.js version
nvm use $NODE_VERSION

# Use the correct npm version
if [ -n "$NPM_VERSION" ]; then
  npm install -g npm@$NPM_VERSION
fi

# Install pnpm from the pre-downloaded tarball
npm install -g $PNPM_TARBALL

# Install yarn from the pre-downloaded tarball
if [ "$YARN_VERSION" == "1.22.19" ]; then
  tar -xzf /opt/yarn/yarn-v1.22.19.tar.gz -C /usr/local && ln -sf /usr/local/yarn-v1.22.19/bin/yarn /usr/local/bin/yarn
elif [ "$YARN_VERSION" == "1.22.22" ]; then
  tar -xzf /opt/yarn/yarn-v1.22.22.tar.gz -C /usr/local && ln -sf /usr/local/yarn-v1.22.22/bin/yarn /usr/local/bin/yarn
else
  echo "Error: Specified YARN_VERSION ($YARN_VERSION) is not available. Pre-downloaded versions are: 1.22.19, 1.22.22."
  exit 1
fi

# Log the selected versions
echo "Using Node.js version: $NODE_VERSION ($NODE_HOME)"
echo "Using npm version: $(npm --version)"
echo "Using pnpm version: $(pnpm --version)"
echo "Using yarn version: $(yarn --version)"

# Execute the passed command
exec "$@"
