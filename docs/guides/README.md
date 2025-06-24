# Guides

This section contains guides for using and developing the Makefile Command Runner.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- Python 3.10 or later
- make
- pip (Python package manager)
- Git (for development)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd makefile-command-runner
   ```

2. Set up the virtual environment:
   ```bash
   make venv
   ```

3. Install development dependencies:
   ```bash
   pip install -r dev-requirements.txt
   ```

## Development Workflow

### Code Style

This project uses:
- Black for code formatting
- Flake8 for linting
- isort for import sorting
- mypy for type checking

Run the following commands before committing:

```bash
black .
isort .
flake8 .
mypy .
```

### Pre-commit Hooks

Install pre-commit hooks:

```bash
pre-commit install
```

## Testing

Run the test suite:

```bash
make test
```

Or run specific tests:

```bash
pytest tests/unit/test_http_server.py -v
```

## Deployment

### Building the Package

```bash
python setup.py sdist bdist_wheel
```

### Publishing

1. Build the package
2. Upload to PyPI:
   ```bash
   twine upload dist/*
   ```

## Troubleshooting

### Common Issues

#### gRPC Connection Issues

If you encounter connection issues with the gRPC server:
1. Verify the server is running
2. Check the port number (default: 50051)
3. Ensure no firewall is blocking the connection

#### Python Version Mismatch

Ensure you're using Python 3.10 or later. Check with:

```bash
python --version
```

### Getting Help

If you encounter issues not covered in this guide:
1. Check the [issue tracker](https://github.com/yourusername/makefile-command-runner/issues)
2. Open a new issue if your problem isn't reported
