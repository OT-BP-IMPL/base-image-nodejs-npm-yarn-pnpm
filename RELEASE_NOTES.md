# Release Notes for `registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn` Docker Image

## Version: `0.0.3`

### Release Date: July 2, 2025

---

### Overview

This release significantly expands support for Node.js, npm, pnpm, and Yarn versions, introduces an **airgap mode** (`AIRGAP_ENV`), and further improves the runtime switching script. The image remains fully pre-downloaded, making it ideal for airgapped and secure environments.

---

### Features

* **Expanded Node.js Support**:

  * Added Node.js `21.x` to the list of supported versions.

* **npm Support**:

  * Added support for a broader range of npm versions:

    * `6.x`
    * `7.x`
    * `8.x`
    * `9.x`
    * `10.x`
    * `11.x`
  * Dynamically switch npm versions via `NPM_VERSION`.

* **pnpm Support**:

  * Pre-downloaded versions:

    * `pnpm-7.30.0`
    * `pnpm-8.6.0`
    * `pnpm-9.0.0`
    * `pnpm-10.8.1`

* **yarn Support**:

  * Pre-downloaded versions:

    * `yarn-v1.22.19`
    * `yarn-v1.22.22`

* **Airgap Mode**:

  * Added the `AIRGAP_ENV` environment variable.

    * When `AIRGAP_ENV=true` (default), the container prevents any runtime downloads.
    * Useful for secure and offline environments.

* **Improved `switch_versions.sh` Script**:

  * Logs the selected versions of Node.js, npm, pnpm, and yarn at startup.
  * Validates all selected versions before switching.
  * Supports execution of additional commands passed to the container.
  * Provides clear error messages for unsupported versions.

* **Default Behavior**:

  * Defaults to:

    * `NODE_VERSION=14`
    * `NPM_VERSION` bundled with Node.js 14
    * `PNPM_VERSION=7.30.0`
    * `YARN_VERSION=1.22.19`
    * `AIRGAP_ENV=true`

---

### Fixes

* Fixed issues with version mismatch between Node.js and npm.
* Resolved `404` errors when downloading Yarn tarballs.
* Improved error handling for invalid version selections.
* Corrected compatibility issues when switching pnpm versions across Node.js major versions.

---

### Known Issues

* Specifying unsupported versions of Node.js, npm, pnpm, or yarn will cause the container to display an error and exit.
* Currently, only **pre-downloaded versions** are allowed in airgap mode (`AIRGAP_ENV=true`).

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
