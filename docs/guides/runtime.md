# Runtime Environment

This guide explains the Veridock runtime environment and how to interact with it.

## Overview

The Veridock runtime provides a sandboxed environment for executing commands and managing services. It includes:

- A web-based interface for monitoring and control
- gRPC and HTTP/JSON APIs for programmatic access
- Service management system
- Command execution environment

## Accessing the Runtime

### Web Interface

The easiest way to interact with the runtime is through the web interface:

1. Start the server (if not already running):
   ```bash
   make run
   ```

2. Open your browser to:
   ```
   http://localhost:2019/runtime
   ```

### Using the CLI

The `veridock` CLI provides access to runtime features:

```bash
# Run a command
veridock run "echo 'Hello, Veridock!"

# List running services
veridock service list

# View logs
veridock logs
```

### API Access

Interact with the runtime programmatically:

```bash
# Get runtime status
curl http://localhost:8082/status

# List available commands
curl http://localhost:8082/makefile/list_commands

# Execute a command
curl -X POST http://localhost:8082/makefile/run_command \
  -H "Content-Type: application/json" \
  -d '{"command": "echo \"Hello, Veridock!\""}'
```

## Runtime Features

### Command Execution

Execute shell commands through the runtime:

```javascript
// Example JavaScript using fetch
async function runCommand(command) {
  const response = await fetch('http://localhost:8082/makefile/run_command', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ command })
  });
  return await response.json();
}

// Usage
runCommand('ls -la').then(console.log);
```

### Service Management

Manage services through the runtime:

```bash
# Start a service
curl -X POST http://localhost:8082/service/start \
  -H "Content-Type: application/json" \
  -d '{"name": "my-service"}'

# Stop a service
curl -X POST http://localhost:8082/service/stop \
  -H "Content-Type: application/json" \
  -d '{"name": "my-service"}'
```

### Event System

The runtime provides an event system for real-time notifications:

```javascript
// Subscribe to events
const eventSource = new EventSource('http://localhost:8082/events');

eventSource.onmessage = (event) => {
  console.log('Event received:', JSON.parse(event.data));
};

eventSource.onerror = (error) => {
  console.error('EventSource error:', error);
};
```

## Runtime Security

The runtime implements several security features:

- Command whitelisting
- Input validation
- Rate limiting
- CORS protection
- Authentication (when enabled)

## Customizing the Runtime

### Environment Variables

Customize the runtime behavior using environment variables in your `.env` file:

```ini
# Enable debug mode
VERIDOCK_DEBUG=true

# Set log level
LOG_LEVEL=DEBUG

# Configure command timeout (in seconds)
COMMAND_TIMEOUT=30
```

### Custom Commands

Add custom commands by creating Python modules in the `veridock/commands` directory. Each module should define a `register_commands` function that returns a dictionary of command names and their handlers.

## Troubleshooting

### Common Issues

1. **Command Not Found**
   - Ensure the command is in your PATH
   - Check command permissions
   - Verify the command is whitelisted

2. **Connection Refused**
   - Verify the server is running
   - Check the port number
   - Ensure no firewall is blocking the connection

3. **Permission Denied**
   - Run with appropriate permissions
   - Check file permissions
   - Verify user has access to required resources

## Next Steps

- [Learn about services](./services.md)
- [Explore the API reference](../api/README.md)
- [Check out example integrations](../examples/runtime-integration.md)
