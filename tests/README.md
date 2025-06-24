# Test Scripts

This directory contains test scripts for both REST API and gRPC clients.

## Prerequisites

1. Make sure the server is running:
   ```bash
   make run
   ```

2. In a separate terminal, run Caddy:
   ```bash
   caddy run --config Caddyfile
   ```

## Testing REST API with curl

Run the REST API test script:

```bash
# Make the script executable
chmod +x tests/rest/test_rest.sh

# Run the test script
tests/rest/test_rest.sh
```

## Testing gRPC Client

Run the gRPC test script:

```bash
# Make the script executable
chmod +x tests/grpc/test_grpc.py

# Install required Python packages
pip install grpcio grpcio-tools

# Run the test script
python tests/grpc/test_grpc.py
```

## Manual Testing with curl

You can also test the REST API manually:

```bash
# Run a command
curl -X POST http://localhost:8080/makefile/run_command \
  -H "Content-Type: application/json" \
  -d '{"command":"hello"}'

# List files in current directory
curl -X POST http://localhost:8080/makefile/run_command \
  -H "Content-Type: application/json" \
  -d '{"command":"list-files"}'
```
