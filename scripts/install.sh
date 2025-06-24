#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux" ;;
        Darwin*)    echo "macos" ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

# Function to print section header
print_section() {
    echo -e "\n${YELLOW}=== $1 ===${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation function
main() {
    print_section "Starting Installation"
    OS=$(detect_os)
    
    echo -e "Detected OS: ${GREEN}$OS${NC}"
    
    # Check if the OS is supported
    if [ "$OS" = "unknown" ]; then
        echo -e "${RED}Error: Unsupported operating system.${NC}"
        exit 1
    fi
    
    # Check if the OS-specific install script exists
    if [ ! -f "scripts/$OS/install.sh" ]; then
        echo -e "${RED}Error: Installation script for $OS not found.${NC}"
        exit 1
    fi
    
    # Make the script executable and run it
    chmod +x "scripts/$OS/install.sh"
    echo -e "Running installation script for ${GREEN}$OS${NC}..."
    
    # Execute the OS-specific install script
    if "scripts/$OS/install.sh" "$@"; then
        echo -e "\n${GREEN}Installation completed successfully!${NC}"
    else
        echo -e "\n${RED}Installation failed.${NC}"
        exit 1
    fi
}

# Run the installation
main "$@"
