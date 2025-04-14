# Custom Ubuntu Node.js & npm Docker Image

## Overview

This project provides a Docker image based on Ubuntu 20.04 with multiple versions of Node.js and npm pre-installed. It includes a script (`switch_versions.sh`) to dynamically switch between Node.js versions at runtime using environment variables.

---

## Features

- **Multiple Node.js Versions**: Includes Node.js versions 14, 16, 18, and 20.
- **Dynamic Version Switching**: Use the `NODE_VERSION` environment variable to select the desired Node.js version.
- **Bundled npm**: Each Node.js version comes with its corresponding npm version.
- **Python Virtual Environment**: Includes a Python virtual environment for additional scripting needs.

---

## Usage

### Build the Docker Image

To build the Docker image, run:

```bash
docker build -t custom-ubuntu-nodejs-npm .