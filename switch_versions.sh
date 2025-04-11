!/bin/bash

# Function to display usage instructions
display_usage() {
  echo "##############################################"
  echo "# Welcome to the Node.js & npm Switcher      #"
  echo "##############################################"
  echo "# Usage:"
  echo "# Set the following environment variables to control the versions:"
  echo "#"
  echo "# - NODE_VERSION: Choose from 14, 16, 18, or 20 (default: 14)"
  echo "#   Example: NODE_VERSION=16"
  echo "#"
  echo "# If no values are provided, the script will default to Node.js 14."
  echo "##############################################"
  echo ""
}

# Default version
NODE_VERSION=${NODE_VERSION:-14}

# Check for unsupported NODE_VERSION
if [ "$NODE_VERSION" != "14" ] && [ "$NODE_VERSION" != "16" ] && [ "$NODE_VERSION" != "18" ] && [ "$NODE_VERSION" != "20" ]; then
  echo "Error: Unsupported NODE_VERSION: $NODE_VERSION"
  display_usage
  exit 1
fi

# Switch Node.js version
if [ "$NODE_VERSION" == "14" ]; then
  export NODE_HOME=$NODE_HOME_14
elif [ "$NODE_VERSION" == "16" ]; then
  export NODE_HOME=$NODE_HOME_16
elif [ "$NODE_VERSION" == "18" ]; then
  export NODE_HOME=$NODE_HOME_18
elif [ "$NODE_VERSION" == "20" ]; then
  export NODE_HOME=$NODE_HOME_20
fi

# Update PATH
export PATH=$NODE_HOME/bin:$PATH

# Log the selected Node.js and npm versions
echo "Using Node.js version: $NODE_VERSION ($NODE_HOME)"
echo "Using npm version: $(npm --version)"

# Execute the passed command
exec "$@"