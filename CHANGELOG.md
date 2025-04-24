## [0.0.1-alpha] - 2025-04-14

### Added
- Initial release of the Docker image based on Ubuntu 20.04.
- Installed multiple versions of Node.js:
  - Node.js 14.21.3
  - Node.js 16.20.0
  - Node.js 18.17.1
  - Node.js 20.5.0
- Included `npm` bundled with each Node.js version.
- Added `switch_versions.sh` script to dynamically switch between Node.js versions using the `NODE_VERSION` environment variable.
- Installed Python 3 and created a virtual environment with the `cryptography` library pre-installed.
- Configured timezone to `Asia/Kolkata` by default.
- Added essential tools and libraries:
  - `curl`, `wget`, `git`, `jq`, `bash`, `make`, `gcc`, `libssl-dev`, etc.

### Fixed
- Resolved potential issues with `switch_versions.sh` by ensuring correct shebang (`#!/bin/bash`) and executable permissions.

---

## [0.0.2-alpha] - 2025-04-24

### Added
- Pre-downloaded specific versions of `pnpm`:
  - `pnpm-7.30.0`
  - `pnpm-8.6.0`
  - `pnpm-9.0.0`
  - `pnpm-10.8.1`
- Pre-downloaded specific versions of `yarn`:
  - `yarn-v1.22.19`
  - `yarn-v1.22.22`
- Enhanced `switch_versions.sh` script to:
  - Dynamically switch between `pnpm` versions using the `PNPM_VERSION` environment variable.
  - Dynamically switch between `yarn` versions using the `YARN_VERSION` environment variable.
  - Warn users if an unsupported `YARN_VERSION` is specified and exit gracefully.
  - Handle additional arguments passed to the container and execute them or default to `bash`.

### Fixed
- Corrected URLs for downloading `yarn` tarballs to avoid `404` errors.
- Resolved issues with `pnpm` installation by ensuring compatibility with the selected Node.js version.
- Improved error handling in `switch_versions.sh` for unsupported `NODE_VERSION`, `NPM_VERSION`, `PNPM_VERSION`, and `YARN_VERSION`.

### Changed
- Updated `README.md` with detailed usage instructions, examples, and troubleshooting steps.
- Improved Dockerfile to ensure all dependencies are pre-downloaded, avoiding runtime downloads.

---

## [Unreleased]

### Planned
- Add support for additional Node.js versions as they are released.
- Include optional support for custom npm versions via an `NPM_VERSION` environment variable.
- Add automated tests for verifying Node.js and npm version switching.
- Optimize image size by removing unnecessary dependencies.
- Add support for additional `pnpm` and `yarn` versions.
- Include automated tests for verifying `pnpm` and `yarn` version switching.
- Optimize image size by removing unnecessary files after installation.
