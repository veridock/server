# Getting Started

Welcome to Veridock Server! This section will help you get up and running quickly.

## What is Veridock Server?

Veridock Server is a lightweight, extensible server that provides a runtime environment for executing commands and managing services. It features:

- gRPC and HTTP/JSON APIs
- Service management system
- Runtime environment for executing commands
- Web-based interface for monitoring and control

## Quick Start

1. [Install Veridock Server](./installation.md)
2. [Configure your environment](./configuration.md)
3. [Start using Veridock](./quick-start.md)

## System Requirements

- Python 3.8+
- Caddy web server (installed automatically)
- gRPC and Protocol Buffers (installed automatically)

## Installation Methods

1. **Using pip** (recommended):
   ```bash
   pip install veridock
   ```

2. **From source**:
   ```bash
   git clone https://github.com/veridock/server.git
   cd server
   make install
   ```

## Next Steps

- Learn how to [configure Veridock](./configuration.md)
- Explore the [CLI usage guide](../guides/cli.md)
- Check out the [examples](../examples/README.md) for practical use cases
