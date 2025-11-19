# Release Notes for `registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn` Docker Image

## Version: `0.0.5-nr`

### Release Date: November 18, 2025

---

### Overview

This release of the `registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn` Docker image builds upon the features introduced in versions `0.0.3` and `0.0.4`, introducing **non-root user support**, **automatic airgap fallback**, and enhanced security practices. The image now provides a seamless experience for both online and offline environments without requiring manual configuration.

---

### Key Features

#### 🔐 Security Improvements

* **Non-Root User Support**:
  * All package management and Node.js tools run as `buildpiper` user (UID 65522) instead of root.
  * Significantly improves container security and follows Docker best practices.
  * All `/opt` and home directory paths owned by buildpiper with proper permissions.

* **Proper Permission Handling**:
  * Fixed EACCES (permission denied) errors that occurred during npm global installations.
  * Ensured `/opt/nodejs` and `/home/buildpiper/.cache/node-gyp` are owned by buildpiper.
  * Native modules can be compiled without permission issues.

#### 🌐 Intelligent Airgap Mode

* **Automatic Fallback to Offline Mode**:
  * If npm install fails due to network connectivity, the script automatically switches to offline mode.
  * Falls back to pre-downloaded packages without any user configuration needed.
  * No need to manually set `AIRGAP_ENV=true` - the script detects and handles network failures gracefully.
  * Users don't need to know if they're in an airgap environment - it "just works"!

* **Enhanced `install_package()` Function**:
  * Intelligently attempts online installation first.
  * Automatically falls back to pre-downloaded packages if network fails.
  * Provides clear feedback with warnings and errors.
  * Works for npm, pnpm, and yarn packages.

#### 📦 Expanded Version Support

* **Node.js Versions** (now 6 versions):
  * 14.21.3, 16.20.0, 18.17.1, 20.5.0, **20.13.0** (NEW), 21.7.3

* **npm Versions** (now 8 versions):
  * 6.14.18, 7.24.2, 8.19.2, 9.8.1, 10.5.0, **10.5.2** (NEW), 10.9.2, 11.3.0

* **pnpm Versions** (4 versions):
  * 7.30.0, 8.6.0, 9.0.0, 10.8.1

* **yarn Versions** (2 versions):
  * 1.22.19, 1.22.22

#### 🎯 Default Behavior

* `AIRGAP_ENV=true` - Enabled by default (safer for all environments)
* `NODE_VERSION=20.5.0` - Latest LTS by default
* `NPM_VERSION=bundled` - Uses bundled npm with selected Node.js
* `PNPM_VERSION` - (optional) Leave unset to skip
* `YARN_VERSION` - (optional) Leave unset to skip

---

### What's Fixed in This Release

# Release Notes for `registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn`

## Version: `0.0.5-nr`

### Release Date: November 18, 2025

### Overview

This release introduces non-root user support, automatic airgap fallback, and improved permission handling to make the image safer and more resilient in both online and offline environments.

### Key Features

* Security: non-root `buildpiper` user (UID 65522) with proper ownership of `/opt` and home directories.
* Automatic airgap fallback: if online npm installs fail, the script enables offline mode and uses pre-downloaded packages.
* Expanded version support: Node.js `20.13.0` and npm `10.5.2` added.

### Fixes

* Resolved EACCES permission errors by fixing ownership and chown sequencing in the Dockerfile.
* Fixed npm global install issues and removed a duplicate `test-builder` stage.

### Changes

* `ENV AIRGAP_ENV=true` is set by default in the Dockerfile for safer offline behavior.
* `switch_versions.sh` includes `install_package()` to try online installs then fall back to local packages.

### How to use (examples)

Run interactive shell with defaults (auto-airgap enabled):

```bash
docker run -it registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.5-nr
```

Run a single command with chosen versions:

```bash
docker run --rm -e NODE_VERSION=20.13.0 -e NPM_VERSION=10.5.2 \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.5-nr \
  npm --version
```

To apply the environment to your current shell (recommended in interactive sessions):

```bash
source /usr/local/bin/switch_versions.sh
node -v
npm -v
```

### Environment variables

* `NODE_VERSION` (default `20.5.0`) — options: 14.21.3, 16.20.0, 18.17.1, 20.5.0, 20.13.0, 21.7.3
* `NPM_VERSION` (default `bundled`) — options: 6.14.18, 7.24.2, 8.19.2, 9.8.1, 10.5.0, 10.5.2, 10.9.2, 11.3.0, bundled
* `PNPM_VERSION` (optional) — options: 7.30.0, 8.6.0, 9.0.0, 10.8.1
* `YARN_VERSION` (optional) — options: 1.22.19, 1.22.22
* `AIRGAP_ENV` (default `true`) — set to `false` to allow runtime downloads

### Known limitations

* Offline fallback only works for versions that were pre-downloaded into the image.

### Migration notes

Users upgrading from 0.0.4 will benefit from automatic airgap detection and improved security (non-root user).
