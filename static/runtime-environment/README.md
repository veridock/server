# Runtime Environment

An interactive web-based environment for managing and running applications in the Veridock ecosystem.

## Features

- Real-time application management
- Interactive console for command execution
- Application marketplace
- Service status monitoring
- Drag-and-drop application installation

## Getting Started

1. Ensure all required services are running
2. Open the Runtime Environment in your browser
3. Use the sidebar to navigate between different sections
4. Install and run applications from the marketplace

## Components

### Dashboard
Overview of running applications and system status.

### Applications
Manage installed applications and their permissions.

### Marketplace
Browse and install new applications.

### Console
Interactive command-line interface for advanced users.

## Configuration

Update the following environment variables in your `.env` file as needed:

```
PORT=8088
GRPC_PORT=50051
GRPC_HOST=0.0.0.0
HTTP_GATEWAY_PORT=8082
```

## Development

For development purposes, you can start the development server with hot-reload:

```bash
make dev
```

## License

This project is part of the Veridock ecosystem.
