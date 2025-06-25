# Makefile Client

This is a web-based interface for interacting with Makefile commands through a gRPC service.

## Features

- List available Makefile commands
- Execute commands directly from the web interface
- View command output in real-time
- Syntax highlighting for command output

## Usage

1. Ensure the gRPC server is running
2. Open the Makefile Client in your browser
3. Click on any command to execute it
4. View the output in the console

## Configuration

Update the following environment variables in your `.env` file:

```
GRPC_HOST=localhost
GRPC_PORT=50051
```
