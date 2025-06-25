# Services Guide

This guide explains how to work with services in Veridock.

## What are Services?

Services in Veridock are long-running processes that provide specific functionality. They can be:

- Web servers
- Database servers
- Background workers
- Custom applications

## Managing Services

### Listing Available Services

```bash
veridock service list
```

Or via API:

```bash
curl http://localhost:8082/service/list
```

### Starting a Service

```bash
veridock service start <service-name>
```

### Stopping a Service

```bash
veridock service stop <service-name>
```

### Checking Service Status

```bash
veridock service status <service-name>
```

## Built-in Services

Veridock comes with several built-in services:

1. **Web Server** - Serves static files and handles HTTP requests
2. **gRPC Server** - Handles gRPC API requests
3. **Scheduler** - Manages scheduled tasks

## Creating Custom Services

### Service Structure

A basic service has the following structure:

```
services/
  my-service/
    __init__.py
    service.py
    config.json
    requirements.txt
```

### Example Service

Here's a simple service that logs messages at regular intervals:

```python
# services/my-service/service.py
import time
import logging
from threading import Thread, Event

class MyService:
    def __init__(self, config):
        self.config = config
        self.running = Event()
        self.thread = None
        self.interval = config.get('interval', 5)
        
    def start(self):
        if self.running.is_set():
            return False
            
        self.running.set()
        self.thread = Thread(target=self._run)
        self.thread.daemon = True
        self.thread.start()
        return True
    
    def stop(self):
        if not self.running.is_set():
            return False
            
        self.running.clear()
        if self.thread:
            self.thread.join(timeout=5)
        return True
    
    def _run(self):
        while self.running.is_set():
            logging.info(f"Service is running (interval: {self.interval}s)")
            time.sleep(self.interval)

def create_service(config):
    return MyService(config)
```

### Service Configuration

Create a `config.json` file:

```json
{
    "name": "my-service",
    "description": "My custom service",
    "version": "1.0.0",
    "interval": 5
}
```

### Registering the Service

Create an `__init__.py` file:

```python
# services/my-service/__init__.py
from .service import create_service

def register():
    return {
        "name": "my-service",
        "create": create_service,
        "config_schema": {
            "type": "object",
            "properties": {
                "interval": {"type": "integer", "default": 5}
            }
        }
    }
```

## Service Dependencies

List your service's dependencies in `requirements.txt`:

```
requests>=2.25.0
python-dotenv>=0.15.0
```

## Service Lifecycle

1. **Initialization** - Service is loaded and configured
2. **Starting** - Service begins execution
3. **Running** - Service is active and processing
4. **Stopping** - Service is shutting down
5. **Stopped** - Service is no longer running

## Service Configuration

Services can be configured through:

1. Environment variables
2. Configuration files
3. API calls

Example configuration:

```yaml
services:
  my-service:
    enabled: true
    config:
      interval: 10
      log_level: INFO
```

## Monitoring Services

### Viewing Logs

```bash
veridock logs my-service
```

### Metrics

Services can expose metrics in Prometheus format:

```
# HELP service_requests_total Total number of requests
# TYPE service_requests_total counter
service_requests_total{service="my-service"} 42
```

## Best Practices

1. **Idempotency** - Services should handle being started multiple times
2. **Graceful Shutdown** - Clean up resources when stopping
3. **Error Handling** - Handle errors gracefully and log them
4. **Configuration** - Make services configurable
5. **Logging** - Include useful context in logs

## Example: Web Service

Here's how to create a simple web service:

```python
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class WebService:
    def __init__(self, config):
        self.config = config
        self.server = None
        
    def start(self):
        port = self.config.get('port', 8080)
        self.server = HTTPServer(('0.0.0.0', port), RequestHandler)
        self.server.service = self
        self.thread = Thread(target=self.server.serve_forever)
        self.thread.daemon = True
        self.thread.start()
        return True
        
    def stop(self):
        if self.server:
            self.server.shutdown()
            self.server.server_close()
            return True
        return False

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        response = {
            'status': 'ok',
            'service': 'web-service',
            'path': self.path
        }
        self.wfile.write(json.dumps(response).encode())

def create_service(config):
    return WebService(config)
```

## Next Steps

- [Learn about the runtime environment](./runtime.md)
- [Explore the API reference](../api/README.md)
- [Check out example services](../examples/custom-services.md)
