# Configuration
VENV = venv
PYTHON = $(VENV)/bin/python3
PIP = $(VENV)/bin/pip
PROTO = service.proto
PY_OUT = .
PORT = 8000
GRPC_PORT = 50051

# Detect Python version
PYTHON_VERSION = $(shell python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')

# Check if running in a virtual environment
IS_VENV = $(shell python3 -c 'import sys; print(hasattr(sys, "real_prefix") or (hasattr(sys, "base_prefix") and sys.base_prefix != sys.prefix))')

# Python executable to use for virtual environment
PYTHON_EXEC = python3

# Check if we need to use python3.x explicitly
ifeq ($(shell which python3.10 2>/dev/null),)
    PYTHON_EXEC = python3
else
    PYTHON_EXEC = python3.10
endif

.PHONY: help
help:
	@echo "\n\033[1mMakefile Command Runner\033[0m\n"
	@echo "\033[1mSetup:\033[0m"
	@echo "  make venv         Create a Python virtual environment"
	@echo "  make install      Install Python dependencies"
	@echo "  make proto        Generate gRPC code\n"
	@echo "\033[1mDevelopment:\033[0m"
	@echo "  make run          Run the gRPC server"
	@echo "  make run-http     Run the HTTP server (port $(PORT))"
	@echo "  make stop         Stop all running servers\n"
	@echo "\033[1mTesting:\033[0m"
	@echo "  make test         Run tests"
	@echo "  make generate     Generate command list for web UI\n"
	@echo "\033[1mMaintenance:\033[0m"
	@echo "  make clean        Remove generated files"
	@echo "  make clean-all    Remove virtual environment and generated files\n"
	@echo "Run 'make' to see this help message.\n"

.PHONY: venv
venv:
	@if [ "$(IS_VENV)" = "False" ]; then \
		echo "Creating Python virtual environment..."; \
		$(PYTHON_EXEC) -m venv $(VENV); \
		$(PIP) install --upgrade pip; \
		$(PIP) install -r requirements.txt; \
		echo "Virtual environment created. Activate with: source $(VENV)/bin/activate"; \
	else \
		echo "Already in a virtual environment"; \
	fi

.PHONY: install
install: venv
	@echo "Installation complete. Run 'source $(VENV)/bin/activate' to activate the virtual environment."

# Install Go tools if Go is available
.PHONY: install-go-tools
install-go-tools:
	@if command -v go >/dev/null 2>&1; then \
		echo "Installing Go tools..."; \
		go install google.golang.org/protobuf/cmd/protoc-gen-go@latest; \
	else \
		echo "Go is not installed. Skipping Go tools installation."; \
	fi

.PHONY: proto
proto: $(PROTO)
	@echo "Generating Python gRPC code..."; \
	$(PYTHON) -m grpc_tools.protoc -I. --python_out=$(PY_OUT) --grpc_python_out=$(PY_OUT) $<
	@if command -v protoc-gen-go >/dev/null 2>&1; then \
		echo "Generating Go gRPC code..."; \
		protoc -I. --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative $<; \
	else \
		echo "protoc-gen-go not found. Skipping Go code generation."; \
	fi

.PHONY: run
run: generate-commands
	@echo "Starting gRPC server..."
	@GRPC_PORT=$(GRPC_PORT) $(PYTHON) grpc_server.py &
	@echo "gRPC server started on port $(GRPC_PORT)"
	@echo "Use 'make stop' to stop the server"

.PHONY: run-http
run-http: generate-commands
	@echo "Starting HTTP server on port $(PORT)..."
	@$(PYTHON) http_server.py

.PHONY: stop
stop:
	@echo "Stopping servers..."
	@-pkill -f "grpc_server.py" || true
	@-pkill -f "http_server.py" || true
	@echo "Servers stopped"

.PHONY: test test-unit test-http test-grpc test-coverage

# Run all tests
test: test-unit test-http test-grpc

# Run unit tests
test-unit:
	@echo "Running unit tests..."
	@$(PYTHON) -m pytest tests/unit/ -v

# Run HTTP API tests
test-http:
	@echo "Running HTTP API tests..."
	@$(PYTHON) -m pytest tests/http/ -v

# Run gRPC tests
test-grpc:
	@echo "Running gRPC tests..."
	@$(PYTHON) -m pytest tests/grpc/ -v

# Run tests with coverage report
test-coverage:
	@echo "Running tests with coverage..."
	@$(PYTHON) -m pytest --cov=. --cov-report=term-missing tests/

# Run all tests using the test script
run-tests: generate-commands
	@echo "Running all tests using test script..."
	@./run_tests.sh

.PHONY: generate-commands
generate-commands:
	@echo "Generating command list..."; \
	echo "// Auto-generated list of available Makefile commands" > static/commands.js; \
	echo "const availableCommands = [" >> static/commands.js; \
	grep '^\.PHONY:' Makefile | sed 's/^\.PHONY: //' | tr ' ' '\n' | grep -v '^\s*$$' | grep -v '^_' | sort | \
	sed "s/^/  '/" | sed "s/$$/',/" >> static/commands.js; \
	sed -i '$$ s/,\s*$$//' static/commands.js; \
	echo "\n];" >> static/commands.js; \
	echo "Command list generated in static/commands.js"

.PHONY: clean
clean:
	@echo "Cleaning Python cache and generated files..."; \
	find . -type f -name "*.py[co]" -delete; \
	find . -type d -name "__pycache__" -exec rm -r {} +; \
	rm -f service_pb2*.py service_pb2*.pyi service_grpc.py; \
	rm -f *.pb.go; \
	rm -f static/commands.js; \
	echo "Clean complete"

.PHONY: clean-all
clean-all: clean
	@echo "Removing virtual environment..."; \
	rm -rf $(VENV)
