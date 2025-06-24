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

# Function to update Python dependencies
update_python_deps() {
    print_section "Updating Python Dependencies"
    
    if [ -f "requirements.txt" ]; then
        if [ -d "venv" ]; then
            source venv/bin/activate
            pip install --upgrade pip
            pip install -r requirements.txt --upgrade
            deactivate
        else
            echo -e "${YELLOW}Virtual environment not found. Running installation first...${NC}"
            ./scripts/install.sh
        fi
    else
        echo -e "${YELLOW}requirements.txt not found.${NC}"
    fi
}

# Function to update system packages (OS specific)
update_system_packages() {
    local os=$1
    print_section "Updating System Packages"
    
    case "$os" in
        linux)
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt upgrade -y
            elif command -v dnf &> /dev/null; then
                sudo dnf update -y
            elif command -v yum &> /dev/null; then
                sudo yum update -y
            elif command -v pacman &> /dev/null; then
                sudo pacman -Syu --noconfirm
            fi
            ;;
        macos)
            if command -v brew &> /dev/null; then
                brew update && brew upgrade
            fi
            ;;
        windows)
            echo -e "${YELLOW}Please update packages using your package manager (e.g., Chocolatey, Winget)${NC}"
            ;;
    esac
}

# Main update function
main() {
    print_section "Starting Update"
    OS=$(detect_os)
    
    echo -e "Detected OS: ${GREEN}$OS${NC}"
    
    # Check if the OS is supported
    if [ "$OS" = "unknown" ]; then
        echo -e "${RED}Error: Unsupported operating system.${NC}"
        exit 1
    fi
    
    # Update system packages
    update_system_packages "$OS"
    
    # Update Python dependencies
    update_python_deps
    
    # Run OS-specific update script if it exists
    if [ -f "scripts/$OS/update.sh" ]; then
        chmod +x "scripts/$OS/update.sh"
        echo -e "\nRunning OS-specific updates..."
        "scripts/$OS/update.sh"
    fi
    
    echo -e "\n${GREEN}Update completed successfully!${NC}"
}

# Run the update
main "$@"
