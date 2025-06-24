# Veridock gRPC Server

A high-performance gRPC server with Caddy reverse proxy and web interface for the Veridock service.

## Features

- **gRPC Service**: Implements all four gRPC patterns (Unary, Server Streaming, Client Streaming, Bidirectional Streaming)
- **Caddy Reverse Proxy**: Handles HTTP/2, TLS termination, and WebSockets
- **Web Interface**: Interactive UI to test all gRPC endpoints
- **Modern Stack**: Built with Python, gRPC, and modern web technologies

## Prerequisites

- Python 3.8+
- Node.js 14+ (for web interface)
- Protocol Buffers Compiler (`protoc`)
- Caddy v2+ (for production deployment)

## Project Structure

```
/server
│
├── Caddyfile          # Caddy server configuration
├── Makefile           # Build and development tasks
├── service.proto      # Protocol Buffers service definition
├── grpc_server.py     # gRPC server implementation
├── static/            # Web interface
│   ├── index.html     # Main web page
│   └── app.js         # Frontend JavaScript
└── README.md          # This file
```

## Getting Started

### 1. Install Dependencies

```bash
# Install Python dependencies
pip install -r requirements.txt

# Install Protocol Buffers compiler and gRPC plugins
make install
```

### 2. Generate gRPC Code

```bash
make proto
```

### 3. Start the Servers

In separate terminals:

```bash
# Terminal 1: Start gRPC server
make server

# Terminal 2: Start Caddy
make caddy
```

Poniżej pełna lista plików przykładowego projektu wraz z ich zawartością, który zawiera:

- serwer gRPC (MakefileService w Pythonie),
- prosty Makefile z komendami,
- proxy reverse proxy w Caddy (serwuje frontend i proxyfikuje gRPC),
- frontend PWA (plik HTML + prosty JS),
- plik `.proto` z definicją usługi.

---
## 2. `Makefile` (do komend lokalnych i generowania gRPC)

```makefile
PROTO=service.proto
PY_OUT=.

.PHONY: all clean run hello date

all: gen

gen:
	python -m grpc_tools.protoc -I. --python_out=$(PY_OUT) --grpc_python_out=$(PY_OUT) $(PROTO)

clean:
	rm -f *_pb2.py *_pb2_grpc.py

run:
	python grpc_server.py

hello:
	echo "Hello from Makefile"

date:
	date
```

```markdown
# Projekt gRPC + Makefile + Caddy + PWA

## Uruchomienie

1. Zainstaluj zależności Pythona:
   ```
pip install grpcio grpcio-tools
   ```

2. Wygeneruj pliki gRPC:
   ```
make gen
   ```

3. Uruchom serwer gRPC:
   ```
make run
   ```

4. Uruchom Caddy:
   ```
caddy run --config Caddyfile
   ```

5. Otwórz w przeglądarce:
   ```
http://localhost:8080
   ```

6. Wpisz komendę z Makefile (np. `hello` lub `date`) i kliknij "Uruchom".

---

## Struktura

- `grpc_server.py` - serwer gRPC wywołujący komendy Makefile
- `Makefile` - komendy lokalne i generowanie gRPC
- `Caddyfile` - reverse proxy i serwowanie frontend
- `static/` - pliki frontendowe (HTML, JS)
- `service.proto` - definicja usługi gRPC
```

---


### Code Style and Quality

This project uses several tools to maintain code quality:

- **Black**: Code formatting
- **isort**: Import sorting
- **flake8**: Linting
- **mypy**: Static type checking

Run the following commands to ensure your code follows the style guidelines:

```bash
# Format code with Black
black .

# Sort imports with isort
isort .
# Run linter
flake8
# Run type checking
mypy .
```



### Code Style and Quality

This project uses several tools to maintain code quality:

- **Black**: Code formatting
- **isort**: Import sorting
- **flake8**: Linting
- **mypy**: Static type checking

Run the following commands to ensure your code follows the style guidelines:

```bash
# Format code with Black
black .

# Sort imports with isort
isort .
# Run linter
flake8
# Run type checking
mypy .
```

3. **End-to-End Tests**: Test the complete system
   - Full workflow from web UI to command execution
   - Error handling and edge cases

# Podsumowanie

Ten zestaw plików tworzy kompletny, ustandaryzowany projekt:

- Caddy serwuje frontend i proxyfikuje gRPC na różne porty,
- Pythonowy serwer gRPC wywołuje komendy Makefile,
- Frontend PWA komunikuje się z backendem przez proxy HTTP,
- Makefile ułatwia generowanie i uruchamianie serwera.

Dzięki temu masz prostą, transparentną i skalowalną architekturę do uruchamiania komend jako usług gRPC dostępnych z przeglądarki.

[1] https://caddyserver.com/docs/quick-starts/reverse-proxy
[2] https://caddy.community/t/configure-caddy-behind-ngnix-https-to-https/20158
[3] https://caddy.community/t/reverse-proxy-error-connection-refused/22793
[4] https://caddyserver.com/docs/caddyfile/directives/reverse_proxy
[5] https://stackoverflow.com/questions/72192987/how-to-configure-caddy-to-deliver-static-file-for-specific-url
[6] https://docs.opnsense.org/manual/how-tos/caddy.html
[7] https://openpeerpower.io/docs/ecosystem/caddy/
[8] https://www.youtube.com/watch?v=KDHtQTKAmrI
