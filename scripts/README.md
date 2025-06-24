# Development Environment Setup Scripts

This directory contains scripts to set up a complete development environment for the project.

## Installation Script

The main installation script `install_dependencies.sh` will install and configure all necessary dependencies:

- **Caddy**: Web server with automatic HTTPS
- **Ollama**: Local LLM runner
- **Go**: Programming language (required for some tools)
- **Python Dependencies**: All required Python packages
- **Build Tools**: Essential development tools

### Usage

1. Make the script executable:
   ```bash
   chmod +x scripts/install_dependencies.sh
   ```

2. Run the script (requires sudo for system packages):
   ```bash
   ./scripts/install_dependencies.sh
   ```

### What it installs

1. **System Dependencies**:
   - build-essential
   - curl
   - wget
   - git

2. **Caddy**:
   - Installs the latest stable version
   - Configures the system service
   - Adds the current user to the caddy group

3. **Ollama**:
   - Installs the latest version
   - Configures the system service
   - Adds the current user to the ollama group

4. **Go**:
   - Installs the latest version from the system package manager

5. **Python**:
   - Sets up a Python virtual environment
   - Installs all dependencies from requirements.txt

### Post-Installation

After running the script, you may need to:

1. Log out and log back in for group changes to take effect
2. Restart your terminal or run `source ~/.bashrc` (or your shell's equivalent)
3. Start the required services:
   ```bash
   # Start Caddy
   sudo systemctl start caddy
   
   # Start Ollama
   sudo systemctl start ollama
   ```

### Troubleshooting

- If you encounter permission issues, try running the script with `sudo`
- If a specific component fails to install, you can install it manually using the instructions in the script
- Check the script's output for any error messages

## Customization

You can modify the installation script to:
- Change versions of installed software
- Add additional dependencies
- Configure services differently

## License

This script is provided as-is under the MIT License.
