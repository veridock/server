#!/bin/bash

# Source environment variables from .env
if [ -f "$PWD/.env" ]; then
    export $(grep -v '^#' $PWD/.env | xargs)
fi

# Set default values if not set
: ${HTTP_PORT:=8088}
: ${GRPC_PORT:=50051}
: ${HTTP_GATEWAY_PORT:=8082}

echo "Stopping all services..."

# Stop Caddy server
echo "- Stopping Caddy server (port ${HTTP_PORT})..."
pkill -f "caddy run" || true
pkill -f "caddy start" || true

# Stop gRPC server
echo "- Stopping gRPC server (port ${GRPC_PORT})..."
pkill -f "python.*-m veridock.grpc_server" || true

# Stop HTTP gateway
echo "- Stopping HTTP gateway (port ${HTTP_GATEWAY_PORT})..."
pkill -f "python.*-m veridock.http_gateway" || true

# Kill any remaining processes on the configured ports
for port in ${HTTP_PORT} ${GRPC_PORT} ${HTTP_GATEWAY_PORT}; do
    echo "- Checking for processes on port ${port}..."
    if command -v lsof >/dev/null; then
        pid=$(lsof -t -i:${port} || true)
        if [ -n "$pid" ]; then
            echo "  Found process $pid on port $port, killing..."
            kill -9 $pid 2>/dev/null || true
        fi
    fi
done

echo -e "\nAll services stopped successfully!"
