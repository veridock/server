#!/bin/bash
# certs.sh - Certificate management

CERT_DIR="${PWD}/certs"

generate_self_signed() {
    echo "Generating self-signed certificate..."
    mkdir -p "$CERT_DIR"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$CERT_DIR/privkey.pem" \
        -out "$CERT_DIR/fullchain.pem" \
        -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
    echo "Certificates generated in $CERT_DIR/"
}

case "$1" in
    generate) generate_self_signed ;;
    *)        echo "Usage: $0 {generate}"; exit 1 ;;
esac
