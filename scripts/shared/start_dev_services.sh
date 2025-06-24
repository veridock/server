#!/bin/bash

# Start Caddy server in dev mode
echo "Starting Caddy server in dev mode..."
caddy run --config Caddyfile --watch &

# Start gRPC server
echo "Starting gRPC server..."
poetry run python -m veridock.grpc_server &

echo "Services started in development mode"
