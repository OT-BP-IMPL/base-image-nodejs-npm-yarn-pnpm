#!/bin/bash
set -euo pipefail

TEST_IMAGE="bp-impl-test:latest"
DOCKERFILE_PATH="Dockerfile"

echo "========== Running Rootless Docker Tests =========="

# Build the image (requires docker/podman with rootless support)
echo "[TEST 1] Building Docker image..."
docker build -t "$TEST_IMAGE" -f "$DOCKERFILE_PATH" . || {
    echo "FAILED: Docker build failed"
    exit 1
}
echo "PASSED: Docker image built successfully"

# Test 1: User exists with correct UID
echo -e "\n[TEST 2] Verifying buildpiper user (UID 65522)..."
docker run --rm "$TEST_IMAGE" id buildpiper | grep -q "uid=65522" && {
    echo "PASSED: buildpiper user has UID 65522"
} || {
    echo "FAILED: buildpiper user UID mismatch"
    exit 1
}

# Test 2: Directories exist
echo -e "\n[TEST 3] Verifying required directories..."
DIRS=("/opt/nodejs" "/opt/npm" "/opt/pnpm" "/opt/yarn" "/bp/workspace" "/home/buildpiper/.cache/node-gyp")
for dir in "${DIRS[@]}"; do
    docker run --rm "$TEST_IMAGE" test -d "$dir" && {
        echo "PASSED: Directory $dir exists"
    } || {
        echo "FAILED: Directory $dir missing"
        exit 1
    }
done

# Test 3: Node versions installed
echo -e "\n[TEST 4] Verifying Node.js installations..."
docker run --rm "$TEST_IMAGE" ls /opt/nodejs/ | grep -q "node-v" && {
    echo "PASSED: Node.js versions installed"
} || {
    echo "FAILED: No Node.js versions found"
    exit 1
}

# Test 4: npm packages downloaded
echo -e "\n[TEST 5] Verifying npm packages..."
docker run --rm "$TEST_IMAGE" ls /opt/npm/ | grep -q "npm.*tgz" && {
    echo "PASSED: npm packages downloaded"
} || {
    echo "FAILED: npm packages not found"
    exit 1
}

# Test 5: yarn packages downloaded
echo -e "\n[TEST 6] Verifying yarn packages..."
docker run --rm "$TEST_IMAGE" ls /opt/yarn/ | grep -q "yarn.*tar.gz" && {
    echo "PASSED: yarn packages downloaded"
} || {
    echo "FAILED: yarn packages not found"
    exit 1
}

# Test 6: pnpm packages downloaded
echo -e "\n[TEST 7] Verifying pnpm packages..."
docker run --rm "$TEST_IMAGE" ls /opt/pnpm/ | grep -q "pnpm.*tgz" && {
    echo "PASSED: pnpm packages downloaded"
} || {
    echo "FAILED: pnpm packages not found"
    exit 1
}

# Test 7: User can run without sudo
echo -e "\n[TEST 8] Verifying non-root execution..."
docker run --user buildpiper --rm "$TEST_IMAGE" whoami | grep -q "buildpiper" && {
    echo "PASSED: Can execute as buildpiper user"
} || {
    echo "FAILED: Cannot execute as buildpiper user"
    exit 1
}

# Test 8: Directory ownership
echo -e "\n[TEST 9] Verifying directory ownership..."
docker run --rm "$TEST_IMAGE" ls -ld /opt | grep -q buildpiper && {
    echo "PASSED: /opt owned by buildpiper"
} || {
    echo "FAILED: /opt ownership incorrect"
    exit 1
}

# Test 9: switch_versions.sh executable
echo -e "\n[TEST 10] Verifying switch_versions.sh is executable..."
docker run --rm "$TEST_IMAGE" test -x /usr/local/bin/switch_versions.sh && {
    echo "PASSED: switch_versions.sh is executable"
} || {
    echo "FAILED: switch_versions.sh not executable"
    exit 1
}

echo -e "\n========== All Tests Passed! =========="