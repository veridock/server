# server
example# Makefile Command Runner

A web-based interface for running Makefile commands with a clean, user-friendly UI. This project provides both a gRPC server for programmatic access and an HTTP server with a web interface.

## Features

- Web-based UI for running Makefile commands
- Real-time command output streaming
- Command history and autocompletion
- Grouped command list for better organization
- Responsive design that works on desktop and mobile
- gRPC API for programmatic access
- REST API for web interface

## Prerequisites

- Python 3.10 or higher
- pip (Python package manager)
- make
- (Optional) Go 1.16+ (for gRPC code generation)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/veridock/server.git
   cd server
   ```

2. Create and activate a Python virtual environment:
   ```bash
   make venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   make install
   ```

4. (Optional) Install Go tools for gRPC code generation:
   ```bash
   make install-go-tools
   ```

## Usage

### Running the HTTP Server (Web Interface)

```bash
make run-http
```

Then open your browser to:
```
http://localhost:8000
```

### Running the gRPC Server

```bash
make run
```

The gRPC server will start on port 50051 by default.

### Available Make Commands

- `make help` - Show this help message
- `make venv` - Create a Python virtual environment
- `make install` - Install Python dependencies
- `make proto` - Generate gRPC code
- `make run` - Start the gRPC server
- `make run-http` - Start the HTTP server (web interface)
- `make stop` - Stop all running servers
- `make test` - Run tests
- `make generate-commands` - Update the command list for the web UI
- `make clean` - Remove generated files
- `make clean-all` - Remove virtual environment and generated files

## Project Structure

```
server/
├── Makefile           # Main Makefile with project commands
├── requirements.txt    # Python dependencies
├── service.proto       # gRPC service definition
├── grpc_server.py      # gRPC server implementation
├── http_server.py      # HTTP server with web interface
├── static/             # Web interface static files
│   ├── index.html     # Main HTML file
│   ├── app.js         # Frontend JavaScript
│   └── commands.js    # Auto-generated command list
└── tests/              # Test files
```

## API Documentation

### gRPC API

The gRPC service is defined in `service.proto`. The main service is `MakefileService` with the following RPC methods:

- `RunCommand(CommandRequest) returns (CommandResponse)` - Execute a Makefile command

### REST API (HTTP Server)

- `GET /` - Serve the web interface
- `GET /api/commands` - Get list of available Makefile commands
- `POST /api/run` - Execute a Makefile command
  - Request body: `{"command": "<make-command>"}`
  - Response: `{"output": "<stdout>", "error": "<stderr>", "return_code": <int>}`

## Development

1. Make your changes to the code
2. Run tests:
   ```bash
   make test
   ```
3. Generate updated command list for the web UI:
   ```bash
   make generate-commands
   ```
4. Start the development servers:
   ```bash
   make run      # gRPC server
   make run-http # HTTP server
   ```

## License

[Your License Here]

## Contributing

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request caddy proxy for PWA
