# Configuration Guide

This guide explains how to configure Veridock Server to suit your needs.

## Configuration Overview

Veridock Server can be configured using:

1. Environment variables (recommended)
2. Command-line arguments
3. Configuration files

Environment variables take precedence over other configuration methods.

## Environment Variables

Create a `.env` file in your project root with the following variables:

```ini
# Server Configuration
VERIDOCK_HOST=0.0.0.0
VERIDOCK_PORT=50051
VERIDOCK_DEBUG=false

# HTTP Gateway
HTTP_GATEWAY_HOST=0.0.0.0
HTTP_GATEWAY_PORT=8082

# Caddy Configuration
CADDY_HOST=0.0.0.0
CADDY_HTTP_PORT=2019
CADDY_HTTPS_PORT=2020

# Logging
LOG_LEVEL=INFO
LOG_FORMAT=text

# Security
SECRET_KEY=your-secret-key-here
ALLOWED_ORIGINS=*

# Service Configuration
SERVICES_DIR=./services
TEMP_DIR=./tmp
```

## Configuration Options

### Server Configuration

- `VERIDOCK_HOST`: Host to bind the gRPC server to (default: `0.0.0.0`)
- `VERIDOCK_PORT`: Port to run the gRPC server on (default: `50051`)
- `VERIDOCK_DEBUG`: Enable debug mode (default: `false`)

### HTTP Gateway

- `HTTP_GATEWAY_HOST`: Host to bind the HTTP gateway to (default: `0.0.0.0`)
- `HTTP_GATEWAY_PORT`: Port to run the HTTP gateway on (default: `8082`)

### Caddy Web Server

- `CADDY_HOST`: Host to bind Caddy to (default: `0.0.0.0`)
- `CADDY_HTTP_PORT`: HTTP port (default: `2019`)
- `CADDY_HTTPS_PORT`: HTTPS port (default: `2020`)

### Logging

- `LOG_LEVEL`: Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- `LOG_FORMAT`: Log format (text or json)

### Security

- `SECRET_KEY`: Secret key for cryptographic operations
- `ALLOWED_ORIGINS`: Comma-separated list of allowed CORS origins

### Paths

- `SERVICES_DIR`: Directory to store service configurations (default: `./services`)
- `TEMP_DIR`: Directory for temporary files (default: `./tmp`)

## Configuration Precedence

1. Command-line arguments
2. Environment variables
3. `.env` file
4. Default values

## Example Configuration

For development:

```ini
VERIDOCK_DEBUG=true
LOG_LEVEL=DEBUG
LOG_FORMAT=text
```

For production:

```ini
VERIDOCK_DEBUG=false
LOG_LEVEL=WARNING
LOG_FORMAT=json
SECRET_KEY=change-this-to-a-secure-random-string
ALLOWED_ORIGINS=https://yourdomain.com,https://app.yourdomain.com
```

## Verifying Configuration

To verify your configuration:

```bash
# Print current configuration
veridock config show

# Validate configuration
veridock config validate
```

## Next Steps

- [Learn about the runtime environment](../guides/runtime.md)
- [Explore the CLI commands](../guides/cli.md)
- [See example configurations](../examples/)
