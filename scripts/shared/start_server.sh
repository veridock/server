#!/bin/bash
# Start the FastAPI server with Uvicorn

set -e

# Source environment variables if .env exists
if [ -f "../../.env" ]; then
    export $(grep -v '^#' ../../.env | xargs)
fi

# Default values
HOST=${HOST:-0.0.0.0}
PORT=${PORT:-8000}
WORKERS=${WORKERS:-$(nproc)}
LOG_LEVEL=${LOG_LEVEL:-info}

# Create logs directory if it doesn't exist
mkdir -p ../../logs

# Start the server
echo "Starting FastAPI server on ${HOST}:${PORT} with ${WORKERS} workers..."
poetry run uvicorn veridock.main:app \
    --host $HOST \
    --port $PORT \
    --workers $WORKERS \
    --log-level $LOG_LEVEL \
    --log-config ../../logging.ini \
    --proxy-headers \
    --timeout-keep-alive 300 \
    --no-server-header
