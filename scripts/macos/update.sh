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

# Function to update Homebrew and packages
update_homebrew() {
    print_section "Updating Homebrew and Packages"
    
    if ! command_exists brew; then
        echo -e "${YELLOW}Homebrew is not installed. Installing...${NC}"
        ../install.sh
        return
    fi
    
    # Update Homebrew itself
    brew update
    
    # Upgrade all installed packages
    brew upgrade
    
    # Clean up old versions
    brew cleanup
    
    # Check for any issues
    brew doctor
    
    echo -e "${GREEN}Homebrew and packages updated successfully!${NC}"}

# Function to update Caddy
update_caddy() {
    if ! command_exists caddy; then
        echo -e "${YELLOW}Caddy is not installed. Installing...${NC}"
        ../install.sh
        return
    fi

    print_section "Updating Caddy"
    
    brew upgrade caddy
    
    echo -e "${GREEN}Caddy updated successfully!${NC}"}

# Function to update Ollama
update_ollama() {
    if ! command_exists ollama; then
        echo -e "${YELLOW}Ollama is not installed. Installing...${NC}"
        ../install.sh
        return
    fi

    print_section "Updating Ollama"
    
    # Stop the service if running
    if brew services list | grep -q ollama; then
        brew services stop ollama
    fi
    
    # Run the update command
    curl -fsSL https://ollama.com/install.sh | sh
    
    # Start the service
    brew services start ollama
    
    echo -e "${GREEN}Ollama updated successfully!${NC}"}

# Main update function
main() {
    echo -e "${YELLOW}Starting macOS update...${NC}"
    
    # Update Homebrew and packages
    update_homebrew
    
    # Update Caddy
    update_caddy
    
    # Update Ollama
    update_ollama
    
    echo -e "\n${GREEN}macOS update completed successfully!${NC}"
    echo -e "${YELLOW}You may need to restart any running services for changes to take effect.${NC}"
}

# Run the update
main "$@"
