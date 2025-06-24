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

# Function to install package using the system package manager
install_package() {
    local pkg=$1
    if command_exists apt; then
        sudo apt install -y "$pkg"
    elif command_exists dnf; then
        sudo dnf install -y "$pkg"
    elif command_exists yum; then
        sudo yum install -y "$pkg"
    elif command_exists pacman; then
        sudo pacman -S --noconfirm "$pkg"
    else
        echo -e "${RED}Unsupported package manager. Please install $pkg manually.${NC}"
        return 1
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
    
    if command_exists apt; then
        sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
        sudo apt update
        sudo apt install -y caddy
    elif command_exists dnf; then
        dnf install -y 'dnf-command(copr)'
        dnf copr -y enable @caddy/caddy
        dnf install -y caddy
    elif command_exists yum; then
        yum install -y yum-plugin-copr
        yum copr -y enable @caddy/caddy
        yum install -y caddy
    elif command_exists pacman; then
        sudo pacman -S --noconfirm caddy
    else
        echo -e "${RED}Unsupported package manager. Please install Caddy manually.${NC}"
        return 1
    fi

    # Add user to the caddy group if it exists
    if getent group caddy >/dev/null; then
        sudo usermod -aG caddy "$USER"
    fi

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
    
    # Add current user to the ollama group
    sudo usermod -aG ollama "$USER"
    
    # Start and enable the service
    if command_exists systemctl; then
        sudo systemctl enable --now ollama
    fi
    
    echo -e "${GREEN}Ollama installed successfully!${NC}"
}

# Function to install Python dependencies
install_python_deps() {
    print_section "Installing Python Dependencies"
    
    if ! command_exists python3; then
        echo "Python 3 is required but not installed. Installing..."
        install_package python3
    fi
    
    if ! command_exists pip3; then
        echo "pip3 is not found. Installing..."
        install_package python3-pip
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
    
    local packages=("build-essential" "curl" "wget" "git")
    
    for pkg in "${packages[@]}"; do
        echo "Installing $pkg..."
        install_package "$pkg"
    done
}

# Main installation function
main() {
    echo -e "${YELLOW}Starting Linux installation...${NC}"
    
    # Update package lists
    if command_exists apt; then
        sudo apt update
    elif command_exists dnf; then
        sudo dnf update -y
    elif command_exists yum; then
        sudo yum update -y
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm
    fi
    
    # Install basic build tools
    install_build_tools
    
    # Install services
    install_caddy
    install_ollama
    
    # Install Python dependencies
    install_python_deps
    
    echo -e "\n${GREEN}Linux installation completed successfully!${NC}"
    echo -e "${YELLOW}You may need to log out and log back in for group changes to take effect.${NC}"
    echo -e "${YELLOW}Please restart your terminal or run 'source ~/.bashrc' to update your environment.${NC}"
}

# Run the installation
main "$@"
