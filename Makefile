# Makefile - Project automation
.PHONY: help run dev stop clean venv proto test install update

SCRIPTS_DIR := scripts/shared
VENV := venv
PYTHON := $(VENV)/bin/python3
PIP := $(VENV)/bin/pip

.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  run         - Start all services (Ollama, gRPC, Caddy)"
	@echo "  dev         - Start all services in dev mode (Caddy dev)"
	@echo "  stop        - Stop all services"
	@echo "  venv        - Create Python virtual environment"
	@echo "  proto       - Generate gRPC code from .proto files"
	@echo "  test        - Run tests"
	@echo "  install     - Install all dependencies"
	@echo "  update      - Update all dependencies"
	@echo "  clean       - Clean up temporary files"
	@echo "  help        - Show this help message"

run: venv
	@$(SCRIPTS_DIR)/services.sh start

dev: venv
	@$(SCRIPTS_DIR)/services.sh dev

stop:
	@$(SCRIPTS_DIR)/services.sh stop

venv:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Creating Python virtual environment..."; \
		python3 -m venv $(VENV); \
		$(PIP) install --upgrade pip; \
		[ -f requirements.txt ] && $(PIP) install -r requirements.txt || echo "No requirements.txt found"; \
	fi

proto:
	@if [ -d "protobuf" ] && [ -n "$$(ls protobuf/*.proto 2>/dev/null)" ]; then \
		echo "Generating gRPC code..."; \
		mkdir -p protobuf; \
		python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. protobuf/*.proto; \
	else \
		echo "No .proto files found in protobuf/ directory"; \
	fi

test: venv
	@echo "Running tests..."
	@$(PYTHON) -m pytest

install: venv
	@echo "Installing dependencies..."
	@$(PIP) install --upgrade pip setuptools wheel
	@$(PIP) install --only-binary :all: grpcio==1.73.0 grpcio-tools==1.73.0
	@$(PIP) install -r requirements.txt
	@if [ ! -f .env ] && [ -f .env.example ]; then \
		echo "Copying .env.example to .env"; \
		cp .env.example .env; \
	fi

update: venv
	@echo "Updating dependencies..."
	@$(PIP) install --upgrade -r requirements.txt

clean:
	@echo "Cleaning up..."
	@rm -rf __pycache__ .pytest_cache
	@find . -name "*.pyc" -delete
	@find . -name "*.pyo" -delete
	@find . -name "__pycache__" -delete
	@rm -f *.log *.pid
