#!/bin/bash

################################################################################
# Quick Setup - One-liner for new Mac
# 
# Download and run this script on a fresh Mac to set up everything:
#   bash <(curl -s https://raw.githubusercontent.com/vasudevdm/config/main/quick-setup.sh)
#
# Or with tools:
#   bash <(curl -s https://raw.githubusercontent.com/vasudevdm/config/main/quick-setup.sh) --tools
#
################################################################################

set -e

# Clone repo and run setup
REPO_PATH="${HOME}/Projects/config"

if [ ! -d "$REPO_PATH" ]; then
    echo "Cloning config repository..."
    mkdir -p "$(dirname "$REPO_PATH")"
    git clone https://github.com/vasudevdm/config.git "$REPO_PATH"
fi

cd "$REPO_PATH"

# Make setup script executable and run it
chmod +x setup.sh
./setup.sh --all "$@"
