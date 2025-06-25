#!/bin/bash

# Exit on error
set -e

# Check if Caddy is installed
if ! command -v caddy >/dev/null; then
    echo "Caddy is not installed. Downloading binary..."
    
    # Use latest stable version
    CADDY_VERSION="2.8.0"
    CADDY_ARCH="amd64"
    
    # Detect OS
    case "$(uname -s)" in
        Linux*)     CADDY_OS="linux";;
        Darwin*)    CADDY_OS="mac";;
        *)          echo "Unsupported OS"; exit 1;;
    esac
    
    # Architecture detection
    case "$(uname -m)" in
        x86_64)     CADDY_ARCH="amd64";;
        arm64|aarch64) CADDY_ARCH="arm64";;
        *)          echo "Unsupported architecture"; exit 1;;
    esac
    
    # Download from GitHub releases
    CADDY_URL="https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_${CADDY_OS}_${CADDY_ARCH}.tar.gz"
    echo "📥 Downloading Caddy v${CADDY_VERSION} for ${CADDY_OS}-${CADDY_ARCH}..."
    
    # Create temp directory
    temp_dir=$(mktemp -d)
    trap 'rm -rf "$temp_dir"' EXIT
    
    # Download and extract
    echo "🔗 Downloading from ${CADDY_URL}"
    if ! curl -fsSL -o "${temp_dir}/caddy.tar.gz" "${CADDY_URL}"; then
        echo "❌ Failed to download Caddy"
        exit 1
    fi
    
    echo "📦 Extracting Caddy..."
    if ! tar -xzf "${temp_dir}/caddy.tar.gz" -C "${temp_dir}"; then
        echo "❌ Failed to extract Caddy"
        exit 1
    fi
    
    # Install to /usr/local/bin (requires sudo)
    echo "🛠️  Installing Caddy to /usr/local/bin (requires sudo privileges)..."
    if ! sudo mv "${temp_dir}/caddy" "/usr/local/bin/"; then
        echo "❌ Failed to install Caddy. Try running with sudo."
        exit 1
    fi
    
    # Set executable permissions
    sudo chmod +x "/usr/local/bin/caddy"
    
    # Verify installation
    if command -v caddy >/dev/null; then
        echo "✅ Caddy installed successfully: $(caddy version)"
    else
        echo "❌ Caddy installation failed"
        exit 1
    fi
else
    echo "✅ Caddy is already installed: $(caddy version)"
fi
