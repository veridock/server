# PowerShell script for Windows update

# Colors for output
$GREEN = "\033[0;32m"
$YELLOW = "\033[1;33m"
$RED = "\033[0;31m"
$NC = "\033[0m" # No Color

# Function to print section header
function Write-Section {
    param (
        [string]$Title
    )
    Write-Output "`n${YELLOW}=== $Title ===${NC}"
}

# Function to check if a command exists
function Test-CommandExists {
    param (
        [string]$command
    )
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

# Function to update Chocolatey and packages
function Update-ChocolateyPackages {
    Write-Section "Updating Chocolatey and Packages"
    
    if (-not (Test-CommandExists "choco")) {
        Write-Output "${YELLOW}Chocolatey is not installed. Running installation script...${NC}"
        .\install.ps1
        return
    }
    
    # Update Chocolatey itself
    choco upgrade chocolatey -y
    
    # Upgrade all installed packages
    choco upgrade all -y
    
    # Clean up old versions
    choco upgrade chocolatey.extension -y
    
    Write-Output "${GREEN}Chocolatey and packages updated successfully!${NC}"}

# Function to update Caddy
function Update-Caddy {
    if (-not (Test-CommandExists "caddy")) {
        Write-Output "${YELLOW}Caddy is not installed. Running installation script...${NC}"
        .\install.ps1
        return
    }

    Write-Section "Updating Caddy"
    
    choco upgrade caddy -y
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Output "${GREEN}Caddy updated successfully!${NC}"}

# Function to update Python dependencies
function Update-PythonDependencies {
    Write-Section "Updating Python Dependencies"
    
    if (-not (Test-CommandExists "python")) {
        Write-Output "${YELLOW}Python is not installed. Running installation script...${NC}"
        .\install.ps1
        return
    }
    
    # Check if virtual environment exists
    if (-not (Test-Path "venv")) {
        Write-Output "${YELLOW}Virtual environment not found. Running installation script...${NC}"
        .\install.ps1
        return
    }
    
    # Update pip and install requirements
    if (Test-Path "requirements.txt") {
        .\venv\Scripts\activate
        python -m pip install --upgrade pip
        python -m pip install -r requirements.txt --upgrade
        deactivate
        Write-Output "${GREEN}Python dependencies updated successfully!${NC}"
    } else {
        Write-Output "${YELLOW}requirements.txt not found. Skipping Python dependencies.${NC}"
    }
}

# Main update function
function Start-Update {
    # Check if running as administrator
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Output "${RED}This script requires administrator privileges. Please run as administrator.${NC}"
        exit 1
    }
    
    Write-Output "${YELLOW}Starting Windows update...${NC}"
    
    # Update Chocolatey and packages
    Update-ChocolateyPackages
    
    # Update Caddy
    Update-Caddy
    
    # Update Python dependencies
    Update-PythonDependencies
    
    Write-Output "\n${GREEN}Windows update completed successfully!${NC}"
    Write-Output "${YELLOW}You may need to restart your computer for all changes to take effect.${NC}"
}

# Run the update
Start-Update
