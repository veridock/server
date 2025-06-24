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

2. Create and activate a Python 3.11 virtual environment:
   ```bash
   python3.11 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Upgrade pip and install build dependencies:
   ```bash
   pip install --upgrade pip setuptools wheel
   ```

4. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

5. Generate gRPC code:
   ```bash
   python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. service.proto
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

1. Start the gRPC server:
   ```bash
   python grpc_server.py
   ```
   Or using make:
   ```bash
   make run
   ```

The gRPC server will start on port 50051 by default. You can specify a different port using the `--port` flag:
   ```bash
   python grpc_server.py --port 50052
   ```

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

### Prerequisites

- Python 3.11 or higher
- pip (Python package manager)
- make
- g++ or compatible C++ compiler
- Development headers for Python 3.11

### Setting Up Development Environment

1. Clone the repository and navigate to the project directory
2. Create and activate a Python 3.11 virtual environment:
   ```bash
   python3.11 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install development dependencies:
   ```bash
   pip install -r dev-requirements.txt
   ```
4. Install the package in development mode:
   ```bash
   pip install -e .
   ```
5. Generate gRPC code:
   ```bash
   python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. service.proto
   ```
6. Install pre-commit hooks (optional but recommended):
   ```bash
   pre-commit install
   ```

### Testing

Run the test suite using pytest:

```bash
# Run all tests
make test

# Or run specific test types
make test-unit     # Unit tests only
make test-http     # HTTP API tests only
make test-grpc     # gRPC API tests only
make test-coverage # Run tests with coverage report

# Run tests with pytest directly
pytest tests/unit/ -v          # Run unit tests
pytest tests/http/ -v          # Run HTTP API tests
pytest tests/grpc/ -v          # Run gRPC API tests
pytest --cov=. tests/ -v       # Run all tests with coverage
```

### Code Style and Quality

This project uses several tools to maintain code quality:

- **Black**: Code formatting
- **isort**: Import sorting
- **flake8**: Linting
- **mypy**: Static type checking

Run the following commands to ensure your code follows the style guidelines:

```bash
# Format code with Black
black .

# Sort imports with isort
isort .
# Run linter
flake8
# Run type checking
mypy .
```

### Development Workflow

1. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and write tests for new functionality.

3. Run the test suite and code quality checks:
   ```bash
   make test
   black .
   isort .
   flake8
   mypy .
   ```

4. Generate updated command list for the web UI if needed:
   ```bash
   make generate-commands
   ```

5. Start the development servers to test your changes:
   ```bash
   make run      # gRPC server
   make run-http # HTTP server with web interface
   ```

6. Commit your changes with a descriptive message:
   ```bash
   git commit -m "Add feature: your feature description"
   ```

7. Push your branch and create a pull request.

## Testing Strategy

This project follows a comprehensive testing strategy:

1. **Unit Tests**: Test individual components in isolation
   - gRPC service methods
   - HTTP request handlers
   - Utility functions

2. **Integration Tests**: Test interactions between components
   - gRPC client-server communication
   - HTTP API endpoints
   - Command execution

3. **End-to-End Tests**: Test the complete system
   - Full workflow from web UI to command execution
   - Error handling and edge cases

## Project Structure

```
server/
├── Makefile           # Main Makefile with project commands
├── requirements.txt    # Python dependencies
├── dev-requirements.txt # Development dependencies
├── setup.py           # Package configuration
├── pyproject.toml     # Build system and tool configuration
├── service.proto      # gRPC service definition
├── grpc_server.py     # gRPC server implementation
├── http_server.py     # HTTP server with web interface
├── static/            # Web interface static files
│   ├── index.html    # Main HTML file
│   ├── app.js        # Frontend JavaScript
│   └── commands.js   # Auto-generated command list
├── tests/             # Test files
│   ├── conftest.py   # Shared test fixtures
│   ├── unit/         # Unit tests
│   │   ├── __init__.py
│   │   ├── test_http_server.py
│   │   └── test_makefile_service.py
│   ├── http/         # HTTP API tests
│   │   └── test_http.py
│   └── grpc/         # gRPC API tests
│       └── test_client.py
└── scripts/          # Utility scripts
```

## License

[Your License Here]

## Contributing

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request caddy proxy for PWA
