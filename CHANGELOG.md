# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

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

## [Unreleased]

### Planned
- Add support for additional Node.js versions as they are released.
- Include optional support for custom npm versions via an `NPM_VERSION` environment variable.
- Add automated tests for verifying Node.js and npm version switching.
- Optimize image size by removing unnecessary dependencies.