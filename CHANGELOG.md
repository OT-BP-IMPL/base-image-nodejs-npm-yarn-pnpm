# Changelog For registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn

## [0.0.5-nr] - 2025-11-18

### Added

* Support for Node.js `20.13.0` and npm `10.5.2` in the Dockerfile and `switch_versions.sh`.
* Non-root user `buildpiper` (UID 65522) with proper ownership of `/opt` and home directories.
* Automatic airgap fallback in `switch_versions.sh` — on network failure the script sets `AIRGAP_ENV=true` and installs from pre-downloaded packages.

### Fixed

* Resolved EACCES permission errors by ensuring proper ownership of `/opt/nodejs` and `/home/buildpiper/.cache/node-gyp`.
* Ensured all setup/install steps run as root; switched to `USER buildpiper` only after installation and chown operations.
* Removed duplicate `test-builder` stage and added missing npm `10.5.2` to the download loop.

### Changed

* Set `ENV AIRGAP_ENV=true` in the Dockerfile by default (safer for offline/airgapped environments).
* Added an `install_package()` helper in `switch_versions.sh` that attempts online installs and falls back to local packages.
* Improved documentation and help output to explain automatic offline fallback and usage patterns.

---

## [0.0.4] - 2025-07-23

### Added

* Support for Node.js `21.x`.
* Support for npm `9.x`, `10.x`, and `11.x`.
* Introduced `AIRGAP_ENV` environment variable (defaults to `true`) to prevent runtime downloads in offline environments.
* Enhanced `switch_versions.sh` to log selected versions and validate inputs.

### Fixed

* Compatibility fixes when switching Node.js major versions and npm.
* Improved error handling for invalid version selections.

### Changed

* Updated default behavior: `NODE_VERSION=20` if unspecified; `PNPM_VERSION=7.30.0`; `YARN_VERSION=1.22.19`.

---

## [0.0.3] - 2025-07-02

### Added

* Initial support for Node.js `21.x` and expanded npm support.

---

## [Unreleased]

### Planned

* Add more Node/npm/pnpm/yarn versions and automated tests.
