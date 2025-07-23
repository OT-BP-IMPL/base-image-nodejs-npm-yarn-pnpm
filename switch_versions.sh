#!/bin/bash
set -euo pipefail

display_usage() {
  echo ""
  echo "┌───────────────────────────────────────────────────────────────────────────────────┐"
  echo "│             🚀 Offline Node.js, npm, pnpm, and yarn Switcher                      │"
  echo "├───────────────────────────────────────────────────────────────────────────────────┤"
  echo "│  Set environment variables to control tool versions:                              │"
  echo "│                                                                                   │"
  echo "│  • NODE_VERSION:  14.21.3 | 16.20.0 | 18.17.1 | 20.5.0 | 21.7.3                   │"
  echo "│  • NPM_VERSION:   6.14.18 | 7.24.2 | 8.19.2 | 9.8.1 | 10.5.0 | 10.9.2 | 11.3.0    │"
  echo "│  • PNPM_VERSION:  7.30.0 | 8.6.0 | 9.0.0 | 10.8.1                                 │"
  echo "│  • YARN_VERSION:  1.22.19 | 1.22.22                                               │"
  echo "│                                                                                   │"
  echo "│  Leave NPM_VERSION / PNPM_VERSION / YARN_VERSION unset                            │"
  echo "│  or empty to skip switching them.                                                 │"
  echo "└───────────────────────────────────────────────────────────────────────────────────┘"
  echo ""
}

switch_version() {
  VALID_NODE_VERSIONS="14.21.3 16.20.0 18.17.1 20.5.0 21.7.3"
  VALID_NPM_VERSIONS="6.14.18 7.24.2 8.19.2 9.8.1 10.5.0 10.9.2 11.3.0"
  VALID_PNPM_VERSIONS="7.30.0 8.6.0 9.0.0 10.8.1"
  VALID_YARN_VERSIONS="1.22.19 1.22.22"

  NODE_VERSION="${NODE_VERSION:-20.5.0}"
  NPM_VERSION="${NPM_VERSION:-bundled}"

  if ! [[ " ${VALID_NODE_VERSIONS} " =~ " ${NODE_VERSION} " ]]; then
    echo "ERROR: Invalid NODE_VERSION: '${NODE_VERSION}'"
    display_usage
    exit 1
  fi

  if [[ -n "${NPM_VERSION:-}" && "${NPM_VERSION}" != "bundled" && ! " ${VALID_NPM_VERSIONS} " =~ " ${NPM_VERSION} " ]]; then
    echo "ERROR: Invalid NPM_VERSION: '${NPM_VERSION}'"
    display_usage
    exit 1
  fi

  if [[ -n "${PNPM_VERSION:-}" && ! " ${VALID_PNPM_VERSIONS} " =~ " ${PNPM_VERSION} " ]]; then
    echo "ERROR: Invalid PNPM_VERSION: '${PNPM_VERSION}'"
    display_usage
    exit 1
  fi

  if [[ -n "${YARN_VERSION:-}" && ! " ${VALID_YARN_VERSIONS} " =~ " ${YARN_VERSION} " ]]; then
    echo "ERROR: Invalid YARN_VERSION: '${YARN_VERSION}'"
    display_usage
    exit 1
  fi

  NODE_DIR="/opt/nodejs/node-v${NODE_VERSION}-linux-x64"
  if [ ! -x "${NODE_DIR}/bin/node" ]; then
    echo "ERROR: Node version '${NODE_VERSION}' not found in ${NODE_DIR}"
    exit 1
  fi

  # Remove previous Node paths
  PATH="$(echo "$PATH" | tr ':' '\n' | grep -v '^/opt/nodejs/' | paste -sd ':' -)"
  export PATH="${NODE_DIR}/bin:${PATH}"

  # Re-set npm_config_nodedir for native modules if in airgapped env
  if [ "${AIRGAP_ENV:-}" = "true" ]; then
    export npm_config_nodedir="/root/.cache/node-gyp/${NODE_VERSION}"
    echo "Using offline headers for Node ${NODE_VERSION}: ${npm_config_nodedir}"
  fi

  # Optionally install npm
  if [ "${NPM_VERSION}" != "bundled" ]; then
    echo "Installing npm@${NPM_VERSION}..."
    npm install -g "npm@${NPM_VERSION}"
    echo "Using npm:  $(npm -v)"
  fi

  # Optionally install pnpm
  if [ -n "${PNPM_VERSION:-}" ]; then
    echo "Installing pnpm@${PNPM_VERSION}..."
    npm install -g "pnpm@${PNPM_VERSION}"
    echo "Using pnpm: $(pnpm -v)"
  fi

  # Optionally install yarn
  if [ -n "${YARN_VERSION:-}" ]; then
    echo "Installing yarn@${YARN_VERSION}..."
    npm install -g "yarn@${YARN_VERSION}"
    echo "Using yarn: $(yarn -v)"
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🟢 Node.js   : $(node -v)"
  echo "📦 npm       : $(npm -v)"
  [ -n "${PNPM_VERSION:-}" ] && echo "📦 pnpm      : $(pnpm -v)"
  [ -n "${YARN_VERSION:-}" ] && echo "🧶 yarn      : $(yarn -v)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [ $# -gt 0 ]; then
    "$@"
  fi
}

switch_version "$@"
