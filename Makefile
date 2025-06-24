# Makefile - Project automation with Poetry
.PHONY: help run dev stop clean install update test proto check-poetry check-caddy generate-caddyfile generate-commands hello date

# Load environment variables from .env file
include .env
export $(shell sed 's/=.*//' .env)

SCRIPTS_DIR := scripts/shared
POETRY := poetry

.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  install     - Install all dependencies using Poetry"
	@echo "  run         - Start all services"
	@echo "  dev         - Start development environment"
	@echo "  stop        - Stop all services"
	@echo "  clean       - Clean up temporary files"
	@echo "  update      - Update dependencies"
	@echo "  test        - Run tests"
	@echo "  format      - Format code"
	@echo "  lint        - Lint code"
	@echo "  typecheck   - Run type checking"
	@echo "  hello       - Print a hello message"
	@echo "  date        - Show current date and time"

# Check if Poetry is installed
check-poetry:
	@$(SCRIPTS_DIR)/check_poetry.sh

# Check if Caddy is installed
check-caddy:
	@$(SCRIPTS_DIR)/check_caddy.sh

# Install dependencies using Poetry
install: check-poetry
	@echo "Installing dependencies..."
	@poetry install --no-root
	@echo "\n\033[1;32m✓ Dependencies installed successfully!\033[0m"

# Update dependencies
update: check-poetry
	@echo "Updating dependencies..."
	@poetry update
	@echo "\n\033[1;32m✓ Dependencies updated successfully!\033[0m"

# Generate Caddyfile from template
generate-caddyfile: check-poetry
	@echo "Generating Caddyfile from template..."

# Generate JSON list of available commands
generate-commands:
	@echo '{\n  "commands": [\n    { "name": "install", "description": "Install all dependencies using Poetry" },\n    { "name": "run", "description": "Start all services" },\n    { "name": "dev", "description": "Start development environment" },\n    { "name": "stop", "description": "Stop all services" },\n    { "name": "clean", "description": "Clean up temporary files" },\n    { "name": "update", "description": "Update dependencies" },\n    { "name": "test", "description": "Run tests" },\n    { "name": "format", "description": "Format code" },\n    { "name": "lint", "description": "Lint code" },\n    { "name": "typecheck", "description": "Run type checking" },\n    { "name": "hello", "description": "Print a hello message" },\n    { "name": "date", "description": "Show current date and time" },\n    { "name": "generate-commands", "description": "Generate JSON list of available commands" }\n  ]\n}'

# Generate gRPC code
proto:
	@if [ -n "$$(find . -maxdepth 1 -name '*.proto' -print -quit)" ]; then \
		echo "Generating gRPC code..."; \
		poetry run python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. ./*.proto; \
		echo "\n\033[1;32m✓ gRPC code generated successfully!\033[0m"; \
	else \
		echo "No .proto files found in the current directory"; \
	fi

# Run tests
test: check-poetry
	@echo "Running tests..."
	@poetry run pytest

# Build frontend assets
frontend:
	@echo "Building frontend..."
	@mkdir -p static
	@if [ -f "static/ollama.html" ]; then \
		echo "Frontend files already exist"; \
	else \
		echo "Copying frontend files..."; \
		cp -n static/ollama.html static/ || true; \
	fi
	@echo "\n\033[1;32m✓ Frontend ready!\033[0m"

# Ollama management
ollama:
	@echo "\n\033[1mOllama Management\033[0m"
	@echo "Available commands:"
	@echo "  make ollama-pull    Pull Ollama models"
	@echo "  make ollama-list    List available models"

ollama-pull: check-ollama
	@echo "Pulling Ollama models..."
	@ollama pull llama2
	@ollama pull llama3.2
	@ollama pull mistral
	@ollama pull codellama

ollama-list: check-ollama
	@echo "Available Ollama models:"
	@ollama list

check-ollama:
	@if ! command -v ollama &> /dev/null; then \
		echo "Ollama is not installed. Please install it first."; \
		echo "Visit https://ollama.ai for installation instructions."; \
		exit 1; \
	fi

# Service management
run: check-poetry check-caddy generate-caddyfile
	@echo "Starting all services..."
	@echo "Using configuration from .env:"
	@echo "- HTTP_PORT: $(HTTP_PORT)"
	@echo "- GRPC_HOST: $(GRPC_HOST)"
	@echo "- GRPC_PORT: $(GRPC_PORT)"
	@echo "- HTTP_GATEWAY_HOST: $(HTTP_GATEWAY_HOST)"
	@echo "- HTTP_GATEWAY_PORT: $(HTTP_GATEWAY_PORT)"
	@echo ""
	@$(SCRIPTS_DIR)/start_services.sh

dev: check-poetry generate-caddyfile
	@echo "Starting development environment..."
	@echo "Using configuration from .env:"
	@echo "- HTTP_PORT: $(HTTP_PORT)"
	@echo "- GRPC_HOST: $(GRPC_HOST)"
	@echo "- GRPC_PORT: $(GRPC_PORT)"
	@echo "- HTTP_GATEWAY_HOST: $(HTTP_GATEWAY_HOST)"
	@echo "- HTTP_GATEWAY_PORT: $(HTTP_GATEWAY_PORT)"
	@echo ""
	@$(SCRIPTS_DIR)/start_dev_services.sh

stop:
	@echo "Stopping all services..."
	@$(SCRIPTS_DIR)/stop_services.sh

# Clean up
clean:
	@echo "Cleaning up..."
	@rm -rf __pycache__ .pytest_cache build dist *.egg-info
	@find . -name "*.pyc" -delete
	@find . -name "*.pyo" -delete
	@find . -name "__pycache__" -delete
	@find . -name "*.so" -delete
	@rm -f *.log *.pid
	@echo "\n\033[1;32m✓ Clean complete!\033[0m"

# Format code
format:
	@$(POETRY) run black .
	@$(POETRY) run isort .

# Lint code
lint:
	@$(POETRY) run black --check .
	@$(POETRY) run isort --check-only .
	@$(POETRY) run mypy .

# Type check
typecheck:
	@$(POETRY) run mypy .

# Utility commands
hello:
	@echo "Hello from Makefile"

date:
	@date
