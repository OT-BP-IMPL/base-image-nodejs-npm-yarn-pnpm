# Release Notes for `mukumlmj/custom-ubuntu-nodejs-npm` Docker Image

## Version: `0.0.2-alpha`
### Release Date: April 24, 2025

---

### Overview
This release introduces enhanced functionality for managing multiple versions of `pnpm` and `yarn`, along with improved error handling and usability in the `switch_versions.sh` script. The image ensures all dependencies are pre-downloaded, making it suitable for offline environments.

---

### Features
- **pnpm Support**:
  - Pre-downloaded specific versions of `pnpm`:
    - `pnpm-7.30.0`
    - `pnpm-8.6.0`
    - `pnpm-9.0.0`
    - `pnpm-10.8.1`
  - Dynamically switch between `pnpm` versions using the `PNPM_VERSION` environment variable.

- **yarn Support**:
  - Pre-downloaded specific versions of `yarn`:
    - `yarn-v1.22.19`
    - `yarn-v1.22.22`
  - Dynamically switch between `yarn` versions using the `YARN_VERSION` environment variable.
  - Added error handling to warn users if an unsupported `YARN_VERSION` is specified.

- **Improved `switch_versions.sh` Script**:
  - Handles additional arguments passed to the container and executes them or defaults to starting a `bash` shell.
  - Enhanced error handling for unsupported `NODE_VERSION`, `NPM_VERSION`, `PNPM_VERSION`, and `YARN_VERSION`.
  - Logs the selected versions of Node.js, npm, pnpm, and yarn for better visibility.

- **Offline Compatibility**:
  - All required versions of `pnpm` and `yarn` are pre-downloaded during the Docker build process, ensuring no runtime downloads are required.

---

### Fixes
- Corrected URLs for downloading `yarn` tarballs to avoid `404` errors.
- Resolved issues with `pnpm` installation by ensuring compatibility with the selected Node.js version.
- Improved error handling in the `switch_versions.sh` script for unsupported versions.

---

### Known Issues
- **Unsupported Versions**:
  - If an unsupported version of Node.js, npm, pnpm, or yarn is specified, the container will display an error and exit.
  - Supported versions:
    - `NODE_VERSION`: `14`, `16`, `18`, `20`
    - `YARN_VERSION`: `1.22.19`, `1.22.22`
    - `pnpm`: Pre-downloaded versions only.

---

### Planned Enhancements
- Add support for additional versions of `pnpm` and `yarn`.
- Include automated tests for verifying `pnpm` and `yarn` version switching.
- Optimize the image size by removing unnecessary files after installation.

---

### How to Use
1. **Build the Image**:
   ```bash
   docker build -t custom-ubuntu-nodejs-npm .
   ```

2. **Run the Container**:
   ```bash
   docker run -it --rm \
     -e NODE_VERSION=16 \
     -e NPM_VERSION=8.19.2 \
     -e PNPM_VERSION=8.6.0 \
     -e YARN_VERSION=1.22.19 \
     custom-ubuntu-nodejs-npm
   ```

3. **Default Behavior**:
   - If no environment variables are specified, the container defaults to:
     - `NODE_VERSION=14`
     - `YARN_VERSION=1.22.19`

---

### Changelog
- **Added**:
  - Pre-downloaded specific versions of `pnpm` and `yarn`.
  - Dynamic version switching for `pnpm` and `yarn`.
  - Enhanced error handling in `switch_versions.sh`.
- **Fixed**:
  - Corrected `yarn` download URLs.
  - Resolved compatibility issues with `pnpm` and Node.js versions.
  