"""Shared test configuration and fixtures."""

import os
import shutil
import tempfile
from pathlib import Path

import pytest


@pytest.fixture
def temp_dir():
    """Create and cleanup a temporary directory for tests."""
    temp_dir = tempfile.mkdtemp()
    yield Path(temp_dir)
    shutil.rmtree(temp_dir)


@pytest.fixture
def test_makefile(temp_dir):
    """Create a test Makefile in a temporary directory."""
    makefile_content = """
.PHONY: test help list

test:
	@echo "Running tests..."
	@echo "Tests passed"

help:
	@echo "Available commands:"
	@echo "  test    Run tests"
	@echo "  help    Show this help"

list:
	@echo "file1.txt file2.txt dir1/"
    """

    makefile_path = temp_dir / "Makefile"
    with open(makefile_path, "w") as f:
        f.write(makefile_content)

    # Create some test files and directories
    (temp_dir / "file1.txt").touch()
    (temp_dir / "file2.txt").touch()
    (temp_dir / "dir1").mkdir()

    return temp_dir


@pytest.fixture
def test_grpc_server():
    """Fixture that provides a test gRPC server."""
    import threading
    from concurrent import futures

    import grpc
    import service_pb2_grpc

    from grpc_server import MakefileService

    # Create a server
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    service_pb2_grpc.add_MakefileServiceServicer_to_server(MakefileService(), server)

    # Use port 0 to let the OS choose an available port
    port = server.add_insecure_port("[::]:0")

    # Start the server in a separate thread
    server.start()

    # Yield the server and port
    yield server, port

    # Cleanup
    server.stop(0)


@pytest.fixture
def test_http_server():
    """Fixture that provides a test HTTP server."""
    import socket
    import threading
    from http.server import HTTPServer

    from http_server import MakefileRequestHandler

    # Find an available port
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(("", 0))
        port = s.getsockname()[1]

    # Create and start the server
    server = HTTPServer(("", port), MakefileRequestHandler)
    server_thread = threading.Thread(target=server.serve_forever)
    server_thread.daemon = True
    server_thread.start()

    # Yield the server and port
    yield server, port

    # Cleanup
    server.shutdown()
    server.server_close()
    server_thread.join()
