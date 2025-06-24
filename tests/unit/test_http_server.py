import json
import os
import sys
import unittest
from http import HTTPStatus
from unittest.mock import MagicMock, mock_open, patch

# Add the parent directory to the path so we can import the server
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Import the server module
from http_server import MakefileRequestHandler


class TestHTTPServer(unittest.TestCase):
    def setUp(self):
        """Set up test fixtures before each test method."""
        # Create a mock request object
        self.request = MagicMock()
        self.request.makefile.side_effect = [
            MagicMock(read=MagicMock(return_value=b"GET /api/commands HTTP/1.1\r\n")),
            MagicMock(read=MagicMock(return_value=b"")),
        ]

        # Create a mock server
        self.server = MagicMock()
        self.server.server_address = ("localhost", 8000)

        # Create the handler
        self.handler = MakefileRequestHandler(
            self.request, self.server.server_address, self.server
        )

        # Mock the send_response method
        self.handler.send_response = MagicMock()
        self.handler.send_header = MagicMock()
        self.handler.end_headers = MagicMock()
        self.handler.wfile = MagicMock()

    def test_handle_get_commands(self):
        """Test handling GET /api/commands request."""
        # Setup
        self.handler.path = "/api/commands"

        # Mock the response data
        test_commands = ["command1", "command2", "command3"]

        # Mock the subprocess.run call
        with patch("subprocess.run") as mock_run:
            # Setup mock
            mock_result = MagicMock()
            mock_result.returncode = 0
            mock_result.stdout = "command1\ncommand2\ncommand3\n"
            mock_run.return_value = mock_result

            # Call the method
            self.handler.do_GET()

            # Assertions
            self.handler.send_response.assert_called_with(HTTPStatus.OK)
            self.handler.send_header.assert_called_with(
                "Content-Type", "application/json"
            )
            self.handler.end_headers.assert_called_once()

            # Get the response data
            response_data = json.loads(
                self.handler.wfile.write.call_args[0][0].decode("utf-8")
            )
            self.assertIn("commands", response_data)
            self.assertEqual(len(response_data["commands"]), 3)

    def test_handle_run_command(self):
        """Test handling POST /api/run request."""
        # Setup
        self.handler.path = "/api/run"
        self.handler.headers = {"Content-Length": "25"}

        # Mock the request data
        request_data = {"command": "test"}

        # Mock the rfile.read call
        self.request.rfile.read.return_value = json.dumps(request_data).encode("utf-8")

        # Mock the subprocess.run call
        with patch("subprocess.run") as mock_run:
            # Setup mock
            mock_result = MagicMock()
            mock_result.returncode = 0
            mock_result.stdout = "Test output\n"
            mock_result.stderr = ""
            mock_run.return_value = mock_result

            # Call the method
            self.handler.do_POST()

            # Assertions
            self.handler.send_response.assert_called_with(HTTPStatus.OK)

            # Get the response data
            response_data = json.loads(
                self.handler.wfile.write.call_args[0][0].decode("utf-8")
            )
            self.assertEqual(response_data["output"], "Test output\n")
            self.assertEqual(response_data["error"], "")
            self.assertEqual(response_data["return_code"], 0)

    def test_handle_run_command_with_args(self):
        """Test handling POST /api/run request with arguments."""
        # Setup
        self.handler.path = "/api/run"
        self.handler.headers = {"Content-Length": "50"}

        # Mock the request data with arguments
        request_data = {"command": "test", "args": ["arg1", "arg2"]}

        # Mock the rfile.read call
        self.request.rfile.read.return_value = json.dumps(request_data).encode("utf-8")

        # Mock the subprocess.run call
        with patch("subprocess.run") as mock_run:
            # Setup mock
            mock_result = MagicMock()
            mock_result.returncode = 0
            mock_result.stdout = "Test with args\n"
            mock_result.stderr = ""
            mock_run.return_value = mock_result

            # Call the method
            self.handler.do_POST()

            # Assertions
            self.handler.send_response.assert_called_with(HTTPStatus.OK)

            # Verify the command was called with arguments
            mock_run.assert_called_once()
            self.assertEqual(mock_run.call_args[0][0], ["make", "test", "arg1", "arg2"])

    def test_handle_invalid_json(self):
        """Test handling invalid JSON in the request body."""
        # Setup
        self.handler.path = "/api/run"
        self.handler.headers = {"Content-Length": "10"}

        # Mock invalid JSON data
        self.request.rfile.read.return_value = b"invalid json"

        # Call the method
        self.handler.do_POST()

        # Assertions
        self.handler.send_error.assert_called_with(
            HTTPStatus.BAD_REQUEST, "Invalid JSON"
        )

    def test_handle_missing_command(self):
        """Test handling a request with a missing command."""
        # Setup
        self.handler.path = "/api/run"
        self.handler.headers = {"Content-Length": "15"}

        # Mock request data without a command
        self.request.rfile.read.return_value = b'{"not_a_command": 1}'

        # Call the method
        self.handler.do_POST()

        # Assertions
        self.handler.send_error.assert_called_with(
            HTTPStatus.BAD_REQUEST, "Command is required"
        )


if __name__ == "__main__":
    unittest.main()
