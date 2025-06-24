#!/bin/bash
# services.sh - Service management

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_DIR="$(dirname "$SCRIPT_DIR")/shared"

start_services() {
    echo "Starting all services..."
    "$SHARED_DIR/caddy.sh" start &
    # Add other services here
}

stop_services() {
    echo "Stopping all services..."
    "$SHARED_DIR/caddy.sh" stop
    # Add other services stop commands here
}

dev_services() {
    echo "Starting all services in dev mode..."
    "$SHARED_DIR/caddy.sh" dev &
    # Add other services here
}

case "$1" in
    start) start_services ;;
    stop)  stop_services ;;
    dev)   dev_services ;;
    *)     echo "Usage: $0 {start|stop|dev}"; exit 1 ;;
esac
