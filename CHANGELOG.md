# Changelog For registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn

## [0.0.3] - 2025-07-02

### Added

* Added support for **Node.js 21.x**.
* Added support for **npm 9.x**, **10.x**, and **11.x** versions.
* Introduced `AIRGAP_ENV` environment variable:

  * Defaults to `true`.
  * Prevents runtime downloads when enabled, ensuring airgap/offline compatibility.
* Enhanced `switch_versions.sh` script to:

  * Log the selected versions of Node.js, npm, pnpm, and yarn.
  * Validate `AIRGAP_ENV` and block unsupported downloads if active.

### Fixed

* Resolved compatibility issues when switching between Node.js major versions and npm.
* Improved error handling for invalid or unsupported `NPM_VERSION` selections.
* Ensured consistent behavior when no environment variables are provided (defaults applied cleanly).

### Changed

* Updated default behavior to:

  * `AIRGAP_ENV=true` by default.
  * `NODE_VERSION=20` if unspecified.
  * `PNPM_VERSION=7.30.0` and `YARN_VERSION=1.22.19` if unspecified.
* Refined error messages in `switch_versions.sh` for clarity and consistency.
* Updated documentation to reflect new environment variables and version support.

---

## [0.0.2] - 2025-06-30

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
