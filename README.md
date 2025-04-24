# Custom Ubuntu Node.js, npm, pnpm, and Yarn Docker Image

## Overview

This project provides a Docker image based on Ubuntu 20.04 with multiple versions of Node.js, npm, pnpm, and Yarn pre-installed. It includes a script (`switch_versions.sh`) to dynamically switch between versions at runtime using environment variables.

---

## Features

- **Multiple Node.js Versions**: Includes Node.js versions 14, 16, 18, and 20.
- **Dynamic Version Switching**: Use environment variables to select the desired versions of Node.js, npm, pnpm, and Yarn.
- **Pre-downloaded Dependencies**: All required versions of pnpm and Yarn are pre-downloaded to ensure no runtime downloads.
- **Python Virtual Environment**: Includes a Python virtual environment for additional scripting needs.

---

## Usage

### Build the Docker Image

To build the Docker image, run:

```bash
docker build -t mukulmj/custom-ubuntu-nodejs-npm .
```

### Run the Docker Container

To run the container and specify the desired versions of Node.js, npm, pnpm, and Yarn, use the following command:

```bash
docker run -it --rm \
  -e NODE_VERSION=16 \
  -e NPM_VERSION=8.19.2 \
  -e PNPM_VERSION=8.6.0 \
  -e YARN_VERSION=1.22.19 \
  mukulmj/custom-ubuntu-nodejs-npm:0.0.2-alpha
```

### Environment Variables

- `NODE_VERSION`: Specify the Node.js version to use. Supported values are `14`, `16`, `18`, and `20`. Default is `14`.
- `NPM_VERSION`: Specify the npm version to use. If not specified, the default npm version for the selected Node.js version will be used.
- `PNPM_VERSION`: Specify the pnpm version to use. If not specified, the default pnpm version for the selected Node.js version will be used.
- `YARN_VERSION`: Specify the Yarn version to use. Supported values are `1.22.19` and `1.22.22`. Default is `1.22.19`.

---

## Example Commands

### Use Node.js 18 with Default npm, pnpm, and Yarn Versions

```bash
docker run -it --rm -e NODE_VERSION=18 mukulmj/custom-ubuntu-nodejs-npm:0.0.2-alpha
```

### Use Node.js 16 with Specific npm, pnpm, and Yarn Versions

```bash
docker run -it --rm \
  -e NODE_VERSION=16 \
  -e NPM_VERSION=8.19.2 \
  -e PNPM_VERSION=8.6.0 \
  -e YARN_VERSION=1.22.22 \
  mukulmj/custom-ubuntu-nodejs-npm
```

---

## Notes

- If an unsupported version of Node.js, npm, pnpm, or Yarn is specified, the container will display an error message and exit.
- All dependencies are pre-downloaded during the Docker build process to ensure no runtime downloads are required.
- The `switch_versions.sh` script dynamically switches between versions based on the provided environment variables.

---

## Troubleshooting

If you encounter issues, ensure that:

1. The specified versions of Node.js, npm, pnpm, and Yarn are supported.
2. The Docker image is built successfully using the provided `Dockerfile`.

For further assistance, feel free to reach out or open an issue in the repository.
