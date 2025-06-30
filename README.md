Absolutely—here’s your **updated README** with a clear **Versions Detail** section showing exactly which versions are included:

---

# Custom Ubuntu Node.js, npm, pnpm, and Yarn Docker Image

## Overview

This project provides a Docker image based on Ubuntu 20.04 with multiple versions of Node.js, npm, pnpm, and Yarn pre-installed. It includes a script (`switch_versions.sh`) to dynamically switch between versions at runtime using environment variables.

---

## Features

* **Multiple Node.js Versions**: Includes Node.js versions 14, 16, 18, and 20.
* **Dynamic Version Switching**: Use environment variables to select the desired versions of Node.js, npm, pnpm, and Yarn.
* **Pre-downloaded Dependencies**: All required versions of pnpm and Yarn are pre-downloaded to ensure no runtime downloads.
* **Python Virtual Environment**: Includes a Python virtual environment for additional scripting needs.

---

## Versions Detail

Below are the pre-installed versions you can choose from:

| Tool        | Supported Versions                                         |
| ----------- | ---------------------------------------------------------- |
| **Node.js** | 14.x, 16.x, 18.x, 20.x                                     |
| **npm**     | Default per Node.js version or custom: e.g., 6.x, 7.x, 8.x |
| **pnpm**    | 7.30.0, 8.6.0                                              |
| **Yarn**    | 1.22.19, 1.22.22                                           |

**Here’s a one-table cheat sheet for you:**

| Variable       | Allowed Values                                                        |
| -------------- | --------------------------------------------------------------------- |
| `NODE_VERSION` | `14`, `16`, `18`, `20`, `21`                                               |
| `NPM_VERSION`  | Any valid npm version (e.g., `6.14.18`, `7.24.2`, `8.19.2`, `9.8.1`, `10.5.0`, `10.9.2`, `11.3.0`) |
| `PNPM_VERSION` | `7.30.0`, `8.6.0`, `9.0.0`, `10.8.1`                                                     |
| `YARN_VERSION` | `1.22.19`, `1.22.22`                                                  |


> ✅ **Tip:** You can override the default npm by specifying `NPM_VERSION`.

---

## Usage

### Build the Docker Image

```bash
docker build -t registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn .
```

### Run the Docker Container

Specify your desired versions with environment variables:

```bash
docker run -it --rm \
  -e NODE_VERSION=16 \
  -e NPM_VERSION=8.19.2 \
  -e PNPM_VERSION=8.6.0 \
  -e YARN_VERSION=1.22.19 \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.2-alpha
```

---

## Environment Variables

* `NODE_VERSION`: Node.js version (`14`, `16`, `18`, `20`). Default: `14`.
* `NPM_VERSION`: Specific npm version (e.g., `8.19.2`).
* `PNPM_VERSION`: Specific pnpm version (`7.30.0`, `8.6.0`).
* `YARN_VERSION`: Specific Yarn version (`1.22.19`, `1.22.22`).

---

## Example Commands

### Use Node.js 18 with default npm, pnpm, and Yarn versions

```bash
docker run -it --rm \
  -e NODE_VERSION=18 \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.2-alpha
```

### Use Node.js 16 with specific npm, pnpm, and Yarn versions

```bash
docker run -it --rm \
  -e NODE_VERSION=16 \
  -e NPM_VERSION=8.19.2 \
  -e PNPM_VERSION=8.6.0 \
  -e YARN_VERSION=1.22.22 \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:0.0.4-version-upgrade
```

---

## Notes

* If you specify an unsupported version, the container will display an error and exit.
* All dependencies are pre-downloaded during the build process.
* `switch_versions.sh` dynamically activates the desired versions.

---

## Troubleshooting

1. Confirm you’re using supported versions.
2. Ensure the Docker image builds successfully.
3. Check the logs for any version mismatch errors.

For help, please open an issue in the repository.
