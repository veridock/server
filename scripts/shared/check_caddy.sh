#!/bin/bash

# Check if Caddy is installed
if ! command -v caddy >/dev/null; then
    echo "Caddy is not installed. Downloading binary..."
    CADDY_VERSION="2.7.5"
    CADDY_ARCH="amd64"
    CADDY_OS="linux"
    
    # Download from GitHub releases
    CADDY_URL="https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_${CADDY_OS}_${CADDY_ARCH}.tar.gz"
    echo "Downloading Caddy from ${CADDY_URL}"
    
    # Create temp directory
    temp_dir=$(mktemp -d)
    
    # Download and extract
    curl -L -o "${temp_dir}/caddy.tar.gz" "${CADDY_URL}"
    tar -xzf "${temp_dir}/caddy.tar.gz" -C "${temp_dir}"
    
    # Install to /usr/local/bin
    sudo install -m 755 "${temp_dir}/caddy" /usr/local/bin/
    
    # Clean up
    rm -rf "${temp_dir}"
    echo "Caddy installed successfully"
    caddy version
else
    echo "Caddy is already installed:"
    caddy version
fi
