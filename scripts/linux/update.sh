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

# Function to update Caddy
update_caddy() {
    if ! command_exists caddy; then
        echo -e "${YELLOW}Caddy is not installed. Installing...${NC}"
        ./install.sh
        return
    fi

    print_section "Updating Caddy"
    
    if command_exists apt; then
        sudo apt update
        sudo apt install --only-upgrade -y caddy
    elif command_exists dnf; then
        sudo dnf update -y caddy
    elif command_exists yum; then
        sudo yum update -y caddy
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm caddy
    fi
    
    echo -e "${GREEN}Caddy updated successfully!${NC}"}

# Function to update Ollama
update_ollama() {
    if ! command_exists ollama; then
        echo -e "${YELLOW}Ollama is not installed. Installing...${NC}"
        ./install.sh
        return
    fi

    print_section "Updating Ollama"
    
    # Stop the service if running
    if command_exists systemctl; then
        sudo systemctl stop ollama
    fi
    
    # Run the update command
    curl -fsSL https://ollama.com/install.sh | sh
    
    # Restart the service
    if command_exists systemctl; then
        sudo systemctl start ollama
    fi
    
    echo -e "${GREEN}Ollama updated successfully!${NC}"}

# Function to update system packages
update_system_packages() {
    print_section "Updating System Packages"
    
    if command_exists apt; then
        sudo apt update && sudo apt upgrade -y
    elif command_exists dnf; then
        sudo dnf update -y
    elif command_exists yum; then
        sudo yum update -y
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm
    fi
}

# Main update function
main() {
    echo -e "${YELLOW}Starting Linux update...${NC}"
    
    # Update system packages
    update_system_packages
    
    # Update Caddy
    update_caddy
    
    # Update Ollama
    update_ollama
    
    echo -e "\n${GREEN}Linux update completed successfully!${NC}"
    echo -e "${YELLOW}You may need to restart any running services for changes to take effect.${NC}"
}

# Run the update
main "$@"
