#!/bin/bash
# caddy.sh - Caddy server management

CADDY_CONFIG="${PWD}/Caddyfile"

start() {
    echo "Starting Caddy server..."
    caddy run --config "$CADDY_CONFIG"
}

stop() {
    echo "Stopping Caddy server..."
    pkill -f "caddy run" || true
}

dev() {
    echo "Starting Caddy in development mode (HTTP only)..."
    caddy run --config "$CADDY_CONFIG" --adapter caddyfile --watch
}

case "$1" in
    start)   start ;;
    stop)    stop ;;
    dev)     dev ;;
    *)       echo "Usage: $0 {start|stop|dev}"; exit 1 ;;
esac
