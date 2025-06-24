#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print section header
print_section() {
    echo -e "\n${YELLOW}=== $1 ===${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Homebrew if not installed
install_homebrew() {
    if ! command_exists brew; then
        print_section "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH if needed
        if [[ "$SHELL" == "/bin/zsh" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ "$SHELL" == "/bin/bash" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo -e "${GREEN}Homebrew is already installed.${NC}"
        brew --version
    fi
}

# Function to install Caddy
install_caddy() {
    if command_exists caddy; then
        echo -e "${GREEN}Caddy is already installed.${NC}"
        caddy version
        return 0
    fi

    print_section "Installing Caddy"
    
    if ! command_exists brew; then
        echo -e "${RED}Homebrew is required to install Caddy.${NC}"
        return 1
    fi
    
    brew install caddy
    
    echo -e "${GREEN}Caddy installed successfully!${NC}"}

# Function to install Ollama
install_ollama() {
    if command_exists ollama; then
        echo -e "${GREEN}Ollama is already installed.${NC}"
        ollama --version
        return 0
    fi

    print_section "Installing Ollama"
    
    # Install using the official script
    curl -fsSL https://ollama.com/install.sh | sh
    
    # Start the service
    brew services start ollama
    
    echo -e "${GREEN}Ollama installed successfully!${NC}"
}

# Function to install Python dependencies
install_python_deps() {
    print_section "Installing Python Dependencies"
    
    if ! command_exists python3; then
        echo "Python 3 is required but not installed. Installing..."
        brew install python
    fi
    
    # Create and activate virtual environment
    if [ ! -d "venv" ]; then
        python3 -m venv venv
    fi
    
    # Install requirements
    if [ -f "requirements.txt" ]; then
        source venv/bin/activate
        pip install --upgrade pip
        pip install -r requirements.txt
        deactivate
        echo -e "${GREEN}Python dependencies installed successfully!${NC}"
    else
        echo -e "${YELLOW}requirements.txt not found. Skipping Python dependencies.${NC}"
    fi
}

# Function to install build tools
install_build_tools() {
    print_section "Installing Build Tools"
    
    # Install Xcode Command Line Tools if not installed
    if ! xcode-select -p &>/dev/null; then
        echo "Installing Xcode Command Line Tools..."
        xcode-select --install
    fi
    
    # Install common build tools
    local packages=("cmake" "pkg-config" "git")
    
    for pkg in "${packages[@]}"; do
        if ! command_exists "$pkg"; then
            echo "Installing $pkg..."
            brew install "$pkg"
        fi
    done
}

# Main installation function
main() {
    echo -e "${YELLOW}Starting macOS installation...${NC}"
    
    # Install Homebrew if not installed
    install_homebrew
    
    # Install build tools
    install_build_tools
    
    # Install services
    install_caddy
    install_ollama
    
    # Install Python dependencies
    install_python_deps
    
    echo -e "\n${GREEN}macOS installation completed successfully!${NC}"
    echo -e "${YELLOW}You may need to restart your terminal for all changes to take effect.${NC}"
}

# Run the installation
main "$@"
