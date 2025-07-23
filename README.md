# Custom Ubuntu Node.js, npm, pnpm, and Yarn Docker Image

## Overview

This project provides a Docker image based on Ubuntu 20.04 with multiple versions of Node.js, npm, pnpm, and Yarn pre-installed. It includes a script (`switch_versions.sh`) to dynamically switch between versions at runtime using environment variables.

---

## Features

* **Multiple Node.js Versions**: Includes Node.js versions 14, 16, 18, 20, and 21.
* **Dynamic Version Switching**: Use environment variables to select the desired versions of Node.js, npm, pnpm, and Yarn.
* **Pre-downloaded Dependencies**: All required versions are downloaded during build time—no runtime downloads required.
* **Airgap Mode**: `AIRGAP_ENV` ensures the container operates without internet access.
* **Python Virtual Environment**: Includes a Python virtual environment for additional scripting needs.

---

## Versions Detail

Below are the pre-installed versions you can choose from:

| Tool        | Supported Versions                                                   |
| ----------- | -------------------------------------------------------------------- |
| **Node.js** | 14.x, 16.x, 18.x, 20.x, 21.x                                         |
| **npm**     | Any valid version per Node.js (e.g., 6.x, 7.x, 8.x, 9.x, 10.x, 11.x) |
| **pnpm**    | 7.30.0, 8.6.0, 9.0.0, 10.8.1                                         |
| **Yarn**    | 1.22.19, 1.22.22                                                     |

---

### Version Cheat Sheet

| Variable       | Allowed Values                                                                           |
| -------------- | ---------------------------------------------------------------------------------------- |
| `NODE_VERSION` | `14.21.3`, `16.20.0`, `18.17.1`, `20.5.0`, `21.7.3`                                      |
| `NPM_VERSION`  | Any valid npm version (e.g., `6.14.18`, `7.24.2`, `8.19.2`, `9.8.1`, `10.9.2`, `11.3.0`) |
| `PNPM_VERSION` | `7.30.0`, `8.6.0`, `9.0.0`, `10.8.1`                                                     |
| `YARN_VERSION` | `1.22.19`, `1.22.22`                                                                     |
| `AIRGAP_ENV`   | `true` or `false` (Default: `true`)                                                      |

✅ **Tip:** You can override the default npm version for each Node.js version.

---

## Usage

### Build the Docker Image

```bash
docker build -t registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn .
```

### Run the Docker Container

Specify your desired versions via environment variables:

```bash
docker run -it --rm \
  -e NODE_VERSION=20 \
  -e NPM_VERSION=10.9.2 \
  -e PNPM_VERSION=9.0.0 \
  -e YARN_VERSION=1.22.22 \
  -e AIRGAP_ENV=true \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:latest
```

---

## Environment Variables

* `NODE_VERSION`: Node.js version (`14`, `16`, `18`, `20`, `21`). Default: `14`.
* `NPM_VERSION`: Specific npm version (e.g., `8.19.2`).
* `PNPM_VERSION`: Specific pnpm version (`7.30.0`, `8.6.0`, `9.0.0`, `10.8.1`).
* `YARN_VERSION`: Specific Yarn version (`1.22.19`, `1.22.22`).
* `AIRGAP_ENV`: If `true`, disables any network installation attempts. Default: `true`.

---

## Example Commands

### Use Node.js 18 with default npm, pnpm, and Yarn in airgap mode

```bash
docker run -it --rm \
  -e NODE_VERSION=18 \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:latest
```

### Use Node.js 16 with specific npm, pnpm, and Yarn versions

```bash
docker run -it --rm \
  -e NODE_VERSION=16 \
  -e NPM_VERSION=8.19.2 \
  -e PNPM_VERSION=8.6.0 \
  -e YARN_VERSION=1.22.22 \
  -e AIRGAP_ENV=true \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:latest
```

### Use Node.js 21 without airgap restrictions (not recommended)

```bash
docker run -it --rm \
  -e NODE_VERSION=21 \
  -e NPM_VERSION=11.3.0 \
  -e PNPM_VERSION=10.8.1 \
  -e AIRGAP_ENV=false \
  registry.buildpiper.in/base-image/nodejs-npm-pnpm-yarn:latest
```

---

## Error Handling

* If you specify an **unsupported version**, the container will display a clear error and exit.
* All tools are pre-downloaded at build time—no network access is needed when `AIRGAP_ENV=true`.
* `switch_versions.sh` verifies the specified versions before applying them.

---

## Troubleshooting

1. Confirm you’re using supported versions (`NODE_VERSION`, `NPM_VERSION`, `PNPM_VERSION`, `YARN_VERSION`).
2. Ensure the Docker image built successfully.
3. Check container logs for version mismatch errors.
4. If necessary, rebuild the image to update the list of pre-installed versions.

---

## Contributing

Feel free to open issues or pull requests to add more tool versions or improve the switching logic.
