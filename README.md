# Makefile Command Runner

A web-based interface for running Makefile commands with gRPC backend.

## Features

- **Web Interface**: Simple and intuitive web UI for running Makefile commands
- **gRPC Backend**: High-performance gRPC service for command execution
- **Cross-Platform**: Works on Windows, macOS, and Linux
- **Docker Support**: Easy deployment with Docker

## Quick Start

### Prerequisites

- Python 3.10+
- make
- pip (Python package manager)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd makefile-command-runner
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

### Running the Application

Start the gRPC server:
```bash
make run
```

Then open `http://localhost:8080` in your web browser.

## Documentation

For detailed documentation, please see the [docs](docs/README.md) directory.

- [API Documentation](docs/api/README.md)
- [Guides](docs/guides/README.md)
- [Development](docs/guides/README.md#development)

## Project Structure

```
.
├── docs/               # Documentation
├── static/             # Web interface
│   ├── index.html      # Main web page
│   └── app.js          # Frontend JavaScript
├── tests/              # Test files
├── grpc_server.py      # gRPC server implementation
├── service.proto       # Protocol Buffers service definition
├── Makefile            # Build and development tasks
├── requirements.txt    # Python dependencies
└── README.md           # This file
```



    Katalog static/ zawiera pliki frontendowe (HTML, JS, CSS).

    Frontend odwołuje się do /makefile/run_command lub /mcp/run_command na tym samym hoście i porcie.

3. Korzyści takiego podejścia

    Jeden punkt wejścia dla frontendu i backendów.

    Brak problemów z CORS, bo frontend i proxy są na tym samym adresie.

    Transparentność — użytkownik nie musi znać portów backendów.

    Możliwość łatwej rozbudowy o kolejne usługi i ścieżki.

    Serwowanie plików statycznych bez potrzeby osobnego serwera.

4. Alternatywy i narzędzia produkcyjne

    Nginx jako reverse proxy z konfiguracją location do różnych backendów i root do plików statycznych.

    Traefik lub Envoy — nowoczesne proxy z dynamicznym routingiem i obsługą gRPC.

    W przypadku Nginx można użyć proxy_pass do backendów gRPC (z odpowiednią konfiguracją HTTP/2).

5. Podsumowanie

    Ustaw proxy jako reverse proxy z routingiem HTTP do różnych backendów gRPC na różnych portach.

    Serwuj frontend (plik HTML i zasoby) z tego samego proxy.

    Dzięki temu frontend komunikuje się z backendami przez proxy na tym samym hoście i porcie, co upraszcza integrację i eliminuje problemy CORS.

    Proxy działa transparentnie, ukrywając szczegóły portów i protokołów backendów.

Jeśli chcesz, mogę pomóc przygotować przykładową konfigurację Nginx lub rozwinąć proxy w Pythonie z pełną obsługą statycznych plików i routingu.


Wyjaśnienia

    root * ./static — katalog z plikami frontendowymi (np. index.html, JS, CSS).

    file_server — serwuje statyczne pliki pod /.

    handle_path /makefile/* — ścieżka proxy do usługi gRPC Makefile działającej na localhost:50051.

    handle_path /mcp/* — ścieżka proxy do usługi MCP/Ollama na localhost:50052.

    transport http { versions h2c 2 } — wymusza HTTP/2 cleartext (h2c) do backendu gRPC bez TLS.

    flush_interval -1 — nie buforuje odpowiedzi, co jest wymagane dla streaming RPC.

Jak to działa z frontendem

    Frontend (np. index.html w ./static) komunikuje się z backendami przez ścieżki /makefile/run_command lub /mcp/run_command.

    Wszystkie żądania idą na ten sam port 8080 i są transparentnie przekazywane do odpowiednich backendów.

    Brak problemów z CORS, bo frontend i proxy są na tym samym hoście i porcie.

Uruchomienie

    Umieść pliki frontendowe w katalogu ./static.

    Uruchom serwery gRPC na portach 50051 (Makefile) i 50052 (MCP).

    Uruchom Caddy z tym Caddyfile:

    text
    caddy run --config Caddyfile

    Otwórz przeglądarkę na http://localhost:8080 i korzystaj z aplikacji.

Dalsze wskazówki

    Możesz dodać TLS (HTTPS) bardzo łatwo, podając nazwę domeny zamiast :8080.

    Możesz rozbudować routing o kolejne ścieżki i backendy.

    Caddy automatycznie obsługuje HTTP/2 i HTTP/1.1.

    flush_interval -1 jest kluczowe dla poprawnej obsługi gRPC streaming.

Podsumowanie

Caddy 2 to lekki, prosty w konfiguracji serwer, który świetnie nadaje się na reverse proxy dla gRPC i statycznych plików frontendowych. Dzięki powyższej konfiguracji masz:

    Jeden punkt wejścia dla frontendu i wielu backendów gRPC,

    Transparentną komunikację między frontendem a backendami na różnych portach,

    Obsługę gRPC streaming i HTTP/2 cleartext (h2c),

    Proste serwowanie plików PWA.


    Caddy serwuje frontend i proxyfikuje gRPC na różne porty,

    Pythonowy serwer gRPC wywołuje komendy Makefile,

    Frontend PWA komunikuje się z backendem przez proxy HTTP,

    Makefile ułatwia generowanie i uruchamianie serwera.

Dzięki temu masz prostą, transparentną i skalowalną architekturę do uruchamiania komend jako usług gRPC dostępnych z przeglądarki.

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
