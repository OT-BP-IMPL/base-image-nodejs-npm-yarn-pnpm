# Release Notes for `custom-ubuntu-nodejs-npm` Docker Image

## Version: `0.0.1-alpha`
### Release Date: April 14, 2025

---

### Overview
This is the initial release of the `custom-ubuntu-nodejs-npm` Docker image. The image is based on Ubuntu 20.04 and provides a flexible environment for working with multiple versions of Node.js and npm. It includes a dynamic version-switching script to simplify development workflows.

---

### Features
- **Node.js Support**:
  - Pre-installed Node.js versions: `14.21.3`, `16.20.0`, `18.17.1`, and `20.5.0`.
  - Bundled `npm` with each Node.js version.

- **Dynamic Version Switching**:
  - Use the `NODE_VERSION` environment variable to switch between Node.js versions dynamically.
  - Supported versions: `14`, `16`, `18`, and `20`.

- **Python Virtual Environment**:
  - Includes Python 3 with a pre-configured virtual environment.
  - Installed the `cryptography` library for secure scripting needs.

- **Essential Tools**:
  - Installed tools and libraries: `curl`, `wget`, `git`, `jq`, `bash`, `make`, `gcc`, `libssl-dev`, and more.

- **Timezone Configuration**:
  - Default timezone set to `Asia/Kolkata`.

---

### Fixes
- Resolved potential issues with the `switch_versions.sh` script:
  - Ensured the correct shebang (`#!/bin/bash`) is used.
  - Verified executable permissions for the script.

---

### Known Issues
- **Unsupported Node.js Versions**:
  - If an unsupported `NODE_VERSION` is specified, the container will display an error and exit.
  - Supported versions: `14`, `16`, `18`, and `20`.

- **npm Version Customization**:
  - Currently, the `npm` version is tied to the bundled version with Node.js. Custom npm versions can be installed manually inside the container.

---

### Planned Enhancements
- Add support for additional Node.js versions as they are released.
- Include optional support for custom npm versions via an `NPM_VERSION` environment variable.
- Add automated tests for verifying Node.js and npm version switching.
- Optimize the image size by removing unnecessary dependencies.

---

### How to Use
1. **Build the Image**:
   ```bash
   docker build -t custom-ubuntu-nodejs-npm .