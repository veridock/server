# PowerShell script for Windows installation

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

# Function to install Chocolatey if not installed
function Install-Chocolatey {
    if (-not (Test-CommandExists "choco")) {
        Write-Section "Installing Chocolatey"
        
        # Run PowerShell as administrator to install Chocolatey
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        
        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        Write-Output "${GREEN}Chocolatey installed successfully!${NC}"
    } else {
        Write-Output "${GREEN}Chocolatey is already installed.${NC}"
    }
}

# Function to install Caddy
function Install-Caddy {
    if (!(Get-Command caddy -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Caddy server..." -ForegroundColor Cyan
        choco install caddy -y
    } else {
        Write-Host "Caddy is already installed" -ForegroundColor Green
    }
}

# Function to install Python
function Install-Python {
    if (Test-CommandExists "python") {
        Write-Output "${GREEN}Python is already installed.${NC}"
        python --version
        return
    }

    Write-Section "Installing Python"
    
    if (-not (Test-CommandExists "choco")) {
        Write-Output "${YELLOW}Chocolatey is required to install Python. Installing Chocolatey first...${NC}"
        Install-Chocolatey
    }
    
    choco install python -y
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Output "${GREEN}Python installed successfully!${NC}"
}

# Function to install Python dependencies
function Install-PythonDependencies {
    Write-Section "Installing Python Dependencies"
    
    if (-not (Test-CommandExists "python")) {
        Write-Output "${YELLOW}Python is not installed. Installing Python first...${NC}"
        Install-Python
    }
    
    # Create virtual environment if it doesn't exist
    if (-not (Test-Path "venv")) {
        python -m venv venv
    }
    
    # Activate virtual environment and install requirements
    if (Test-Path "requirements.txt") {
        .\venv\Scripts\activate
        python -m pip install --upgrade pip
        python -m pip install -r requirements.txt
        deactivate
        Write-Output "${GREEN}Python dependencies installed successfully!${NC}"
    } else {
        Write-Output "${YELLOW}requirements.txt not found. Skipping Python dependencies.${NC}"
    }
}

# Function to install Git
function Install-Git {
    if (Test-CommandExists "git") {
        Write-Output "${GREEN}Git is already installed.${NC}"
        git --version
        return
    }

    Write-Section "Installing Git"
    
    if (-not (Test-CommandExists "choco")) {
        Write-Output "${YELLOW}Chocolatey is required to install Git. Installing Chocolatey first...${NC}"
        Install-Chocolatey
    }
    
    choco install git -y
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Output "${GREEN}Git installed successfully!${NC}"
}

# Function to install build tools
function Install-BuildTools {
    Write-Section "Installing Build Tools"
    
    # Install Visual Studio Build Tools if not installed
    if (-not (Test-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe")) {
        Write-Output "Installing Visual Studio Build Tools..."
        choco install visualstudio2019buildtools -y
    }
    
    # Install other build tools
    $tools = @("cmake", "make")
    
    foreach ($tool in $tools) {
        if (-not (Test-CommandExists $tool)) {
            Write-Output "Installing $tool..."
            choco install $tool -y
        }
    }
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Output "${GREEN}Build tools installed successfully!${NC}"
}

# Main installation function
function Start-Installation {
    # Check if running as administrator
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Output "${RED}This script requires administrator privileges. Please run as administrator.${NC}"
        exit 1
    }
    
    Write-Output "${YELLOW}Starting Windows installation...${NC}"
    
    # Install Chocolatey if not installed
    Install-Chocolatey
    
    # Install build tools
    Install-BuildTools
    
    # Install Git
    Install-Git
    
    # Install Caddy
    Install-Caddy
    
    # Install Python and dependencies
    Install-PythonDependencies
    
    Write-Output "\n${GREEN}Windows installation completed successfully!${NC}"
    Write-Output "${YELLOW}You may need to restart your terminal or computer for all changes to take effect.${NC}"
}

# Run the installation
Start-Installation
