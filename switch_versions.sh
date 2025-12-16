#!/bin/bash
# Detect if the script is being sourced or executed
if [ "${BASH_SOURCE[0]}" != "$0" ]; then
  _IS_SOURCED=1
else
  _IS_SOURCED=0
fi

# Only enable strict mode when executed; when sourced we should avoid changing
# the caller's shell options unexpectedly.
if [ "${_IS_SOURCED:-0}" -eq 0 ]; then
  set -euo pipefail
fi

# Helper to exit or return depending on how the script is invoked
safe_exit() {
  local _code=${1:-0}
  if [ "${_IS_SOURCED:-0}" -eq 1 ]; then
    return "${_code}"
  else
    exit "${_code}"
  fi
}

display_usage() {
  echo ""
  echo "┌──────────────────────────────────────────────────────────────────────────────────────────────┐"
  echo "│                       🚀 Offline Node.js, npm, pnpm, and yarn Switcher                       │"
  echo "├──────────────────────────────────────────────────────────────────────────────────────────────┤"
  echo "│  Set environment variables to control tool versions:                                         │"
  echo "│                                                                                              │"
  echo "│  • NODE_VERSION:  14.21.3 | 16.20.0 | 18.17.1 | 20.5.0 | 20.13.0 | 21.7.3 | 22.8.0 | 24.7.0  │"
  echo "│  • NPM_VERSION:   6.14.18 | 7.24.2 | 8.19.2 | 9.8.1 | 10.5.0 | 10.5.2 | 10.9.2 | 11.3.0      │"
  echo "│  • PNPM_VERSION:  7.30.0 | 8.6.0 | 9.0.0 | 10.8.1                                            │"
  echo "│  • YARN_VERSION:  1.22.19 | 1.22.22                                                          │"
  echo "│                                                                                              │"
  echo "│  Leave NPM_VERSION / PNPM_VERSION / YARN_VERSION unset                                       │"
  echo "│  or empty to skip switching them.                                                            │"
  echo "│                                                                                              │"
  echo "│  💡 NOTE: If network connectivity fails, the script automatically switches to offline        │"
  echo "│     mode using pre-downloaded packages. No configuration needed!                             │"
  echo "└──────────────────────────────────────────────────────────────────────────────────────────────┘"
  echo ""
}

switch_version() {
  VALID_NODE_VERSIONS="14.21.3 16.20.0 18.17.1 20.5.0 20.13.0 21.7.3 22.8.0 24.7.0"
  VALID_NPM_VERSIONS="6.14.18 7.24.2 8.19.2 9.8.1 10.5.0 10.5.2 10.9.2 11.3.0"
  VALID_PNPM_VERSIONS="7.30.0 8.6.0 9.0.0 10.8.1"
  VALID_YARN_VERSIONS="1.22.19 1.22.22"

  NODE_VERSION="${NODE_VERSION:-20.5.0}"
  NPM_VERSION="${NPM_VERSION:-bundled}"
  PNPM_VERSION="${PNPM_VERSION:-7.30.0}"
  YARN_VERSION="${YARN_VERSION:-1.22.19}"

  if ! [[ " ${VALID_NODE_VERSIONS} " =~ " ${NODE_VERSION} " ]]; then
    echo "ERROR: Invalid NODE_VERSION: '${NODE_VERSION}'"
    display_usage
    safe_exit 1
  fi

  if [[ -n "${NPM_VERSION:-}" && "${NPM_VERSION}" != "bundled" && ! " ${VALID_NPM_VERSIONS} " =~ " ${NPM_VERSION} " ]]; then
    echo "ERROR: Invalid NPM_VERSION: '${NPM_VERSION}'"
    display_usage
    safe_exit 1
  fi

  if [[ -n "${PNPM_VERSION:-}" && ! " ${VALID_PNPM_VERSIONS} " =~ " ${PNPM_VERSION} " ]]; then
    echo "ERROR: Invalid PNPM_VERSION: '${PNPM_VERSION}'"
    display_usage
    safe_exit 1
  fi

  if [[ -n "${YARN_VERSION:-}" && ! " ${VALID_YARN_VERSIONS} " =~ " ${YARN_VERSION} " ]]; then
    echo "ERROR: Invalid YARN_VERSION: '${YARN_VERSION}'"
    display_usage
    safe_exit 1
  fi


  NODE_DIR="/opt/nodejs/node-v${NODE_VERSION}-linux-x64"
  if [ ! -x "${NODE_DIR}/bin/node" ]; then
    echo "ERROR: Node version '${NODE_VERSION}' not found in ${NODE_DIR}"
    safe_exit 1
  fi

  # Remove previous Node paths
  PATH="$(echo "$PATH" | tr ':' '\n' | grep -v '^/opt/nodejs/' | paste -sd ':' -)"
  export PATH="${NODE_DIR}/bin:${PATH}"

  # Re-set npm_config_nodedir for native modules if in airgapped env
  if [ "${AIRGAP_ENV:-}" = "true" ]; then
    export npm_config_nodedir="/home/buildpiper/.cache/node-gyp/${NODE_VERSION}"
    echo "Using offline headers for Node ${NODE_VERSION}: ${npm_config_nodedir}"
  fi

  # Function to install package with automatic airgap fallback
  install_package() {
    local package_spec="$1"
    local package_name="$2"
    
    if npm install -g "$package_spec" 2>&1; then
      return 0
    else
      local exit_code=$?
      echo "⚠️  WARNING: Failed to install $package_spec from registry. Attempting offline installation..."
      
      # Enable airgap mode automatically
      AIRGAP_ENV="true"
      export AIRGAP_ENV
      export npm_config_nodedir="/home/buildpiper/.cache/node-gyp/${NODE_VERSION}"
      
      # Try installing from pre-downloaded packages
      if [[ "$package_name" == "npm" ]]; then
        npm install -g "/opt/npm/npm-${NPM_VERSION}.tgz" 2>/dev/null && return 0
      elif [[ "$package_name" == "pnpm" ]]; then
        npm install -g "/opt/pnpm/pnpm-${PNPM_VERSION}.tgz" 2>/dev/null && return 0
      elif [[ "$package_name" == "yarn" ]]; then
        npm install -g "/opt/yarn/yarn-v${YARN_VERSION}.tar.gz" 2>/dev/null && return 0
      fi
      
      # If offline install also fails, show error
      echo "❌ ERROR: Failed to install $package_spec (both online and offline)."
      return 1
    fi
  }

  # Optionally install npm
  if [ "${NPM_VERSION}" != "bundled" ]; then
    echo "Installing npm@${NPM_VERSION}..."
    if ! install_package "npm@${NPM_VERSION}" "npm"; then
      echo "ERROR: npm installation failed"
      safe_exit 1
    fi
    echo "Using npm:  $(npm -v)"
  fi

  # Optionally install pnpm
  if [ -n "${PNPM_VERSION:-}" ]; then
    echo "Installing pnpm@${PNPM_VERSION}..."
    if ! install_package "pnpm@${PNPM_VERSION}" "pnpm"; then
      echo "ERROR: pnpm installation failed"
      safe_exit 1
    fi
    echo "Using pnpm: $(pnpm -v)"
  fi

  # Optionally install yarn
  if [ -n "${YARN_VERSION:-}" ]; then
    echo "Installing yarn@${YARN_VERSION}..."
    if ! install_package "yarn@${YARN_VERSION}" "yarn"; then
      echo "ERROR: yarn installation failed"
      safe_exit 1
    fi
    echo "Using yarn: $(yarn -v)"
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🟢 Node.js   : $(node -v)"
  echo "📦 npm       : $(npm -v)"
  [ -n "${PNPM_VERSION:-}" ] && echo "📦 pnpm      : $(pnpm -v)"
  [ -n "${YARN_VERSION:-}" ] && echo "🧶 yarn      : $(yarn -v)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # If a command was provided, run or exec it depending on whether we were
  # sourced. If no command was provided and the script was executed (not
  # sourced) we want to give the user an interactive shell that inherits the
  # configured environment so tools like `npm` are available. When the
  # script is sourced we simply return so the caller's shell keeps the
  # environment.
  if [ $# -gt 0 ]; then
    if [ "${_IS_SOURCED:-0}" -eq 1 ]; then
      # When sourced, run the command in the current shell so any changes persist
      "$@"
    else
      # When executed as entrypoint, replace the process so env is preserved for the child
      exec "$@"
    fi
  else
    if [ "${_IS_SOURCED:-0}" -eq 1 ]; then
      # Sourced and no command: nothing to do (env already set in caller)
      return 0
    else
      # Executed and no command: if interactive, drop into a shell that
      # inherits the environment so users can run npm/yarn/pnpm directly.
      if [ -t 0 ] || [ -t 1 ]; then
        echo "Entering interactive shell with configured Node/npm environment."
        echo "To apply the environment to your current shell, run: source /usr/local/bin/switch_versions.sh"
        exec "${SHELL:-/bin/bash}" -i
      else
        # Non-interactive execution with no command: exit successfully.
        safe_exit 0
      fi
    fi
  fi
}

switch_version "$@"
