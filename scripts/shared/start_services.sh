#!/bin/bash

# Source environment variables from .env
if [ -f "$PWD/.env" ]; then
    export $(grep -v '^#' $PWD/.env | xargs)
fi

# Set default values if not set
: ${HTTP_PORT:=8088}
: ${GRPC_HOST:=localhost}
: ${GRPC_PORT:=50051}
: ${HTTP_GATEWAY_PORT:=8082}

# Start Caddy server
echo "Starting Caddy server on port ${HTTP_PORT}..."
# Generate Caddyfile if it doesn't exist
if [ ! -f "$PWD/Caddyfile" ]; then
    echo "Generating Caddyfile..."
    poetry run python generate_caddyfile.py
fi

caddy start --config Caddyfile || caddy run --config Caddyfile &

# Start gRPC server
echo "Starting gRPC server on ${GRPC_HOST}:${GRPC_PORT}..."
poetry run python -m veridock.grpc_server --host ${GRPC_HOST} --port ${GRPC_PORT} &

# Start HTTP gateway
echo "Starting HTTP gateway on port ${HTTP_GATEWAY_PORT}..."
poetry run python -m veridock.http_gateway --port ${HTTP_GATEWAY_PORT} &

echo -e "\nServices started successfully!"
echo "- Caddy: http://localhost:${HTTP_PORT}"
echo "- gRPC: ${GRPC_HOST}:${GRPC_PORT}"
echo "- HTTP Gateway: http://localhost:${HTTP_GATEWAY_PORT}"
