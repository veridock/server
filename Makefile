# Makefile - Project automation with Poetry
.PHONY: help run dev stop clean install update test proto

SCRIPTS_DIR := scripts/shared
POETRY := poetry

.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  install     - Install all dependencies using Poetry"

# Check if Poetry is installed
check-poetry:
	@if ! command -v poetry >/dev/null; then \
		echo "Poetry is not installed. Installing..."; \
		curl -sSL https://install.python-poetry.org | python3 -; \
		export PATH="$$HOME/.local/bin:$$PATH"; \
	fi

# Check if Caddy is installed
check-caddy:
	@if ! command -v caddy >/dev/null; then \
		echo "Caddy is not installed. Installing..."; \
		sudo apt-get update && sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https; \
		curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg; \
		curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list; \
		sudo apt-get update; \
		sudo apt-get install -y caddy; \
		sudo systemctl enable --now caddy; \
	fi

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
run: install frontend check-caddy
	@echo "Starting all services..."
	@$(SCRIPTS_DIR)/services.sh start

# Development mode with hot-reload
dev: install frontend check-caddy
	@echo "Starting development environment..."
	@$(SCRIPTS_DIR)/services.sh dev

# Stop all services
stop:
	@echo "Stopping all services..."
	@if pgrep -f "uvicorn veridock.main:app" > /dev/null; then \
		pkill -f "uvicorn veridock.main:app"; \
		echo "Stopped FastAPI server"; \
	else \
		echo "No running servers found"; \
	fi

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
