# Installation Guide

This guide will walk you through installing Veridock Server on your system.

## Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Git (for development installations)
- Caddy web server (will be installed automatically)

## Installation Methods

### Method 1: Using pip (Recommended)

1. Create and activate a virtual environment (recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install Veridock Server:
   ```bash
   pip install veridock
   ```

### Method 2: From Source

1. Clone the repository:
   ```bash
   git clone https://github.com/veridock/server.git
   cd server
   ```

2. Install dependencies:
   ```bash
   make install
   ```
   
   This will:
   - Install Python dependencies using Poetry
   - Install Caddy web server
   - Set up the development environment

## Verifying the Installation

After installation, verify that the `veridock` command is available:

```bash
veridock --version
```

You should see the installed version number if everything was installed correctly.

## Post-Installation

1. **Initialize Configuration**:
   ```bash
   veridock init
   ```
   This will create a `.env` file with default settings.

2. **Start the Server**:
   ```bash
   make run
   ```
   This will start the gRPC server, HTTP gateway, and Caddy web server.

## Troubleshooting

### Common Issues

1. **Caddy Installation Fails**
   - Ensure you have write permissions to `/usr/local/bin`
   - Try running the installer with `sudo`
   - Or install Caddy manually from [caddyserver.com](https://caddyserver.com/docs/install)

2. **Python Dependencies Fail to Install**
   - Ensure you have Python development headers installed
   - On Ubuntu/Debian: `sudo apt-get install python3-dev python3-venv`
   - On macOS: `xcode-select --install`

3. **Port Conflicts**
   - By default, Veridock uses ports 2019 (HTTP) and 50051 (gRPC)
   - Change these in the `.env` file if needed

## Next Steps

- [Configure your environment](./configuration.md)
- [Learn the basics with our Quick Start guide](./quick-start.md)
