#!/usr/bin/env bash
set -e

# You must define these ENV variables:
# NODE_VERSION, NPM_VERSION, PNPM_VERSION, YARN_VERSION

echo "Switching versions using environment variables:"
echo "NODE_VERSION=${NODE_VERSION}"
echo "NPM_VERSION=${NPM_VERSION}"
echo "PNPM_VERSION=${PNPM_VERSION}"
echo "YARN_VERSION=${YARN_VERSION}"

# Clear old binaries
rm -f /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/pnpm /usr/local/bin/yarn

# Link Node.js
if [ -n "$NODE_VERSION" ]; then
  NODE_PATH="/opt/nodejs/node-v${NODE_VERSION}.*"
  NODE_BIN=$(find $NODE_PATH -type f -name node)
  NODE_DIR=$(dirname "$NODE_BIN")
  ln -s "$NODE_DIR/node" /usr/local/bin/node
  ln -s "$NODE_DIR/npm" /usr/local/bin/npm
  echo "Switched Node.js to version:"
  node --version
fi

# # Switch npm (if specified)
# if [ -n "$NPM_VERSION" ]; then
#   cd /tmp
#   tar -xzf /opt/npm/npm-${NPM_VERSION}.tgz
#   ln -s /tmp/package/bin/npm-cli.js /usr/local/bin/npm
#   echo "Switched npm to version:"
#   npm --version
# fi

# Switch pnpm (if specified)
if [ -n "$PNPM_VERSION" ]; then
  cd /tmp
  tar -xzf /opt/pnpm/pnpm-${PNPM_VERSION}.tgz
  ln -s /tmp/package/bin/pnpm.cjs /usr/local/bin/pnpm
  chmod +x /usr/local/bin/pnpm
  echo "Switched pnpm to version:"
  pnpm --version
fi

# Switch Yarn (if specified)
if [ -n "$YARN_VERSION" ]; then
  cd /tmp
  tar -xzf /opt/yarn/yarn-v${YARN_VERSION}.tar.gz
  ln -s /tmp/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn
  chmod +x /usr/local/bin/yarn
  echo "Switched Yarn to version:"
  yarn --version
fi

# Continue with CMD
exec "$@"
