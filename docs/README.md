# Project Documentation

Welcome to the project documentation for the Makefile Command Runner. This documentation provides comprehensive information about the project's architecture, API, and usage guides.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [API Documentation](/docs/api/README.md)
- [Guides](/docs/guides/README.md)
- [Development](#development)

## Overview

The Makefile Command Runner is a web-based interface for executing Makefile commands. It provides a gRPC service for running commands and a web interface for interaction.

## Getting Started

### Prerequisites

- Python 3.10+
- pip (Python package manager)
- make

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd makefile-command-runner
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

### Running the Application

Start the gRPC server:
```bash
make run
```

## Development

### Project Structure

- `grpc_server.py` - gRPC server implementation
- `service.proto` - Protocol Buffers definition
- `static/` - Web interface files
- `tests/` - Test files

### Building the Project

```bash
make
```

### Running Tests

```bash
make test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
