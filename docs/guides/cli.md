# CLI Reference

This guide covers the Veridock command-line interface (CLI) and its usage.

## Overview

The `veridock` CLI provides a convenient way to interact with the Veridock server and its components. It's the primary tool for managing the server, services, and configurations.

## Installation

The CLI is installed automatically when you install Veridock:

```bash
pip install veridock
```

Verify the installation:

```bash
veridock --version
```

## Basic Usage

### General Syntax

```bash
veridock [OPTIONS] COMMAND [ARGS]...
```

### Global Options

- `--config FILE`: Specify a custom config file (default: `.env`)
- `--debug`: Enable debug output
- `--version`: Show version and exit
- `--help`: Show help message and exit

## Commands

### `veridock init`

Initialize a new Veridock project.

```bash
veridock init [OPTIONS] [PATH]
```

**Options:**
- `--force`: Overwrite existing files
- `--no-examples`: Skip example files

**Example:**
```bash
veridock init my-project
cd my-project
```

### `veridock run`

Run a command in the Veridock runtime.

```bash
veridock run [OPTIONS] COMMAND [ARGS]...
```

**Options:**
- `--async`: Run command asynchronously
- `--timeout SECONDS`: Command timeout in seconds

**Examples:**
```bash
# Run a simple command
veridock run "echo 'Hello, Veridock!"

# Run a command with a timeout
veridock run --timeout 30 "long-running-command"
```

### `veridock service`

Manage Veridock services.

```bash
veridock service [OPTIONS] COMMAND [ARGS]...
```

**Subcommands:**
- `list`: List available services
- `start <name>`: Start a service
- `stop <name>`: Stop a service
- `restart <name>`: Restart a service
- `status <name>`: Show service status
- `logs <name>`: View service logs

**Examples:**
```bash
# List all services
veridock service list

# Start a service
veridock service start my-service

# View service logs
veridock service logs my-service --follow
```

### `veridock config`

Manage Veridock configuration.

```bash
veridock config [OPTIONS] COMMAND [ARGS]...
```

**Subcommands:**
- `show`: Show current configuration
- `get <key>`: Get a configuration value
- `set <key> <value>`: Set a configuration value
- `unset <key>`: Remove a configuration value
- `validate`: Validate configuration

**Examples:**
```bash
# Show current config
veridock config show

# Set a config value
veridock config set LOG_LEVEL DEBUG

# Validate config
veridock config validate
```

### `veridock logs`

View server logs.

```bash
veridock logs [OPTIONS] [SERVICE]
```

**Options:**
- `--follow, -f`: Follow log output
- `--tail LINES`: Number of lines to show from the end
- `--since TIME`: Show logs since a specific time
- `--until TIME`: Show logs before a specific time
- `--level LEVEL`: Filter by log level

**Examples:**
```bash
# Show recent logs
veridock logs

# Follow logs in real-time
veridock logs --follow

# Show logs for a specific service
veridock logs my-service
```

## Environment Variables

The CLI respects the following environment variables:

- `VERIDOCK_CONFIG`: Path to config file
- `VERIDOCK_DEBUG`: Enable debug mode
- `VERIDOCK_HOST`: Server host
- `VERIDOCK_PORT`: Server port
- `LOG_LEVEL`: Logging level

## Configuration File

The CLI looks for configuration in the following order:

1. Command-line arguments
2. Environment variables
3. `.env` file in current directory
4. `~/.config/veridock/config`
5. `/etc/veridock/config`

## Examples

### Starting a Development Server

```bash
# Initialize a new project
veridock init my-project
cd my-project

# Start the server in development mode
VERIDOCK_DEBUG=1 veridock run
```

### Managing Services

```bash
# Start all services
veridock service start --all

# Check service status
veridock service status

# View logs
veridock logs --follow
```

### Running Commands

```bash
# Run a simple command
veridock run "ls -la"

# Run a command with environment variables
veridock run "echo $HOME"

# Run a command asynchronously
veridock run --async "long-running-process"
```

## Tips and Tricks

### Command Aliases

Create shell aliases for common commands:

```bash
# Add to ~/.bashrc or ~/.zshrc
alias vd='veridock'
alias vdr='veridock run'
alias vds='veridock service'
```

### Debugging

Enable debug output:

```bash
VERIDOCK_DEBUG=1 veridock --help
```

### Tab Completion

Enable shell completion:

```bash
# Bash
source <(veridock --completion=bash)

# Zsh
source <(veridock --completion=zsh)

# Fish
veridock --completion=fish | source
```

## Troubleshooting

### Common Issues

1. **Command Not Found**
   - Verify installation: `pip show veridock`
   - Check PATH: `which veridock`

2. **Connection Refused**
   - Check if server is running: `veridock status`
   - Verify host and port

3. **Permission Denied**
   - Run with sudo if needed
   - Check file permissions

4. **Configuration Issues**
   - Verify config file exists
   - Check environment variables

## Next Steps

- [Learn about services](./services.md)
- [Explore the API reference](../api/README.md)
- [Check out example configurations](../examples/)
