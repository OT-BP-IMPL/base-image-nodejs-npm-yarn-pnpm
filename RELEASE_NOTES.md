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

* ✅ **Permission Denied Errors**: Resolved EACCES errors during npm installations
* ✅ **Non-Root User Issues**: Fixed directory ownership and permissions for buildpiper user
* ✅ **Network Resilience**: Automatic fallback to offline packages on connection failure
* ✅ **Dockerfile Cleanup**: Removed duplicate test-builder stage
* ✅ **Version Consistency**: All npm versions in switch_versions.sh are now in Dockerfile

---

### What's Changed

* **Dockerfile Updates**:
  * Set `ENV AIRGAP_ENV=true` explicitly for better visibility
  * Added npm version 10.5.2 to download loop
  * Removed duplicate test-builder stage
  * All setup runs as root; USER buildpiper only after installation

* **switch_versions.sh Updates**:
  * New `install_package()` function with automatic fallback logic
  * Updated help message explaining automatic airgap fallback
  * Intelligent error handling for both online and offline scenarios
  * Better user feedback with warnings and error messages

---

### How to Use

```bash
# Default usage (automatic airgap fallback enabled)
docker run -it registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.5-nr

# Specify Node.js version
docker run -e NODE_VERSION=21.7.3 -it registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.5-nr

# Install specific npm version
docker run -e NODE_VERSION=20.5.0 -e NPM_VERSION=10.5.2 -it registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.5-nr

# Install pnpm (automatic fallback on network failure)
docker run -e NODE_VERSION=20.5.0 -e PNPM_VERSION=8.6.0 -it registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.5-nr

# Install yarn and pnpm together
docker run -e NODE_VERSION=21.7.3 -e NPM_VERSION=11.3.0 -e PNPM_VERSION=10.8.1 -e YARN_VERSION=1.22.22 -it registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.5-nr

# Run custom command
docker run -e NODE_VERSION=20.5.0 -it registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.5-nr npm --version
```

---

### Environment Variables

| Variable | Default | Options | Description |
|----------|---------|---------|-------------|
| `NODE_VERSION` | `20.5.0` | 14.21.3, 16.20.0, 18.17.1, 20.5.0, 20.13.0, 21.7.3 | Node.js version to use |
| `NPM_VERSION` | `bundled` | 6.14.18, 7.24.2, 8.19.2, 9.8.1, 10.5.0, 10.5.2, 10.9.2, 11.3.0, bundled | npm version to install globally |
| `PNPM_VERSION` | (unset) | 7.30.0, 8.6.0, 9.0.0, 10.8.1 | pnpm version to install (optional) |
| `YARN_VERSION` | (unset) | 1.22.19, 1.22.22 | yarn version to install (optional) |
| `AIRGAP_ENV` | `true` | true, false | Set to true for offline environments (automatic fallback on failure) |

---

### Known Issues & Limitations

* Only pre-downloaded versions are allowed. Specifying unsupported versions will cause an error.
* When network fails, automatic fallback only works for pre-downloaded packages.

---

### Planned Enhancements

* Add support for more npm/pnpm/yarn versions.
* Further reduce image size by optimizing layer caching.
* Include automated validation tests during image build.
* Add health checks for pre-downloaded packages.

---

### Migration from Previous Versions

Users coming from `0.0.4` or earlier versions will benefit from:

1. **No manual AIRGAP_ENV configuration needed** - automatic detection
2. **Better security** - non-root user by default
3. **No permission errors** - properly configured directories
4. **More npm versions** - 10.5.2 and other versions now supported

---

### Support & Feedback

For issues, questions, or feature requests, please contact the BuildPiper team.

---

### Planned Enhancements

* Add support for more npm/pnpm/yarn versions.
* Further reduce image size by cleaning up build artifacts.
* Include automated validation tests during image build.

---

### How to Use

#### 1. Build the Image

```bash
docker build -t registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.3 .
```

#### 2. Run the Container

Specify the desired versions via environment variables:

```bash
docker run -it --rm \
  -e NODE_VERSION=20 \
  -e NPM_VERSION=10.9.2 \
  -e PNPM_VERSION=9.0.0 \
  -e YARN_VERSION=1.22.22 \
  -e AIRGAP_ENV=true \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.3
```

#### 3. Default Behavior

If you omit environment variables, defaults will be applied:

* Node.js 14
* Default npm bundled with Node.js 14
* pnpm 7.30.0
* Yarn 1.22.19
* Airgap mode enabled (`AIRGAP_ENV=true`)

---

### Changelog

* **Added**:

  * Node.js 21.x support.
  * Airgap mode (`AIRGAP_ENV`).
  * npm 9.x, 10.x, and 11.x support.
  * Pre-downloaded `pnpm` and `yarn` versions.
  * Enhanced logging of active versions at runtime.

* **Fixed**:

  * Yarn tarball download issues.
  * Version compatibility across tools.
  * Error messaging and validation in `switch_versions.sh`.

---

✅ **Tip**: Always verify your version selections match the supported matrix before running the container.
