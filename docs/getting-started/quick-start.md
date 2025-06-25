# Quick Start Guide

This guide will help you get up and running with Veridock Server in just a few minutes.

## Prerequisites

- Veridock Server installed (see [Installation Guide](./installation.md))
- Basic terminal/command line knowledge
- (Optional) `curl` or Postman for API testing

## Step 1: Start the Server

1. Open a terminal and navigate to your project directory
2. Start the server:
   ```bash
   make run
   ```
   This will start:
   - gRPC server on port 50051
   - HTTP gateway on port 8082
   - Caddy web server on port 2019

## Step 2: Verify the Installation

Open your web browser and navigate to:
```
http://localhost:2019
```

You should see the Veridock web interface.

## Step 3: Running Your First Command

### Using the Web Interface

1. Open the web interface at `http://localhost:2019`
2. Navigate to the "Runtime" section
3. Enter a command in the input field (e.g., `echo "Hello, Veridock!"`)
4. Click "Run" and see the output

### Using cURL

```bash
curl -X POST http://localhost:8082/makefile/run_command \
  -H "Content-Type: application/json" \
  -d '{"command": "echo \"Hello, Veridock!\""}'
```

### Using the CLI

```bash
veridock run "echo 'Hello, Veridock!'"
```

## Step 4: Explore the API

### List Available Commands

```bash
curl http://localhost:8082/makefile/list_commands
```

### Get System Status

```bash
curl http://localhost:8082/status
```

## Step 5: Create Your First Service

1. Create a new service:
   ```bash
   veridock service add my-service
   ```

2. Start the service:
   ```bash
   veridock service start my-service
   ```

3. Check service status:
   ```bash
   veridock service status
   ```

## Next Steps

- Learn how to [configure Veridock](./configuration.md)
- Explore the [CLI commands](../guides/cli.md)
- Check out [example use cases](../examples/README.md)
- Learn about the [runtime environment](../guides/runtime.md)
