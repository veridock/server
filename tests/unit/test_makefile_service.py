import os
import subprocess
import unittest
from unittest.mock import MagicMock, patch

import service_pb2

# Import the service to test
from grpc_server import MakefileService


class TestMakefileService(unittest.TestCase):
    def setUp(self):
        """Set up test fixtures before each test method."""
        self.service = MakefileService()
        self.context = MagicMock()

        # Save the original working directory
        self.original_cwd = os.getcwd()

    def tearDown(self):
        """Clean up after each test method."""
        # Restore the original working directory
        os.chdir(self.original_cwd)

    @patch("subprocess.run")
    def test_run_command_success(self, mock_run):
        """Test running a command successfully."""
        # Setup mock
        mock_result = MagicMock()
        mock_result.returncode = 0
        mock_result.stdout = "Command output"
        mock_result.stderr = ""
        mock_run.return_value = mock_result

        # Create a request
        request = service_pb2.CommandRequest(command="test")

        # Call the method
        response = self.service.RunCommand(request, self.context)

        # Assertions
        self.assertEqual(response.output, "Command output")
        self.assertEqual(response.error, "")
        self.assertEqual(response.return_code, 0)
        mock_run.assert_called_once_with(
            ["make", "test"],
            capture_output=True,
            text=True,
            cwd=os.path.dirname(os.path.abspath(__file__)),
        )

    @patch("subprocess.run")
    def test_run_command_with_args(self, mock_run):
        """Test running a command with arguments."""
        # Setup mock
        mock_result = MagicMock()
        mock_result.returncode = 0
        mock_result.stdout = "Command with args"
        mock_result.stderr = ""
        mock_run.return_value = mock_result

        # Create a request with arguments
        request = service_pb2.CommandRequest(command="test", args=["arg1", "arg2"])

        # Call the method
        response = self.service.RunCommand(request, self.context)

        # Assertions
        self.assertEqual(response.output, "Command with args")
        mock_run.assert_called_once_with(
            ["make", "test", "arg1", "arg2"],
            capture_output=True,
            text=True,
            cwd=os.path.dirname(os.path.abspath(__file__)),
        )

    @patch("subprocess.run")
    def test_run_command_error(self, mock_run):
        """Test handling command execution errors."""
        # Setup mock to raise an exception
        mock_run.side_effect = subprocess.CalledProcessError(
            returncode=1,
            cmd=["make", "test"],
            output="Command failed",
            stderr="Error details",
        )

        # Create a request
        request = service_pb2.CommandRequest(command="test")

        # Call the method
        response = self.service.RunCommand(request, self.context)

        # Assertions
        self.assertEqual(response.return_code, 1)
        self.assertIn("Error executing command", response.error)
        self.context.set_code.assert_called_once()
        self.context.set_details.assert_called_once()

    def test_working_directory(self):
        """Test that the service runs commands in the correct directory."""
        # Change to a temporary directory
        import tempfile

        with tempfile.TemporaryDirectory() as temp_dir:
            # Create a test Makefile
            makefile_path = os.path.join(temp_dir, "Makefile")
            with open(makefile_path, "w") as f:
                f.write('test:\n\techo "Test output"')

            # Create a request
            request = service_pb2.CommandRequest(command="test")

            # Call the method
            response = self.service.RunCommand(request, self.context)

            # Assertions
            self.assertEqual(response.return_code, 0)
            self.assertEqual(response.output.strip(), "Test output")
            self.assertEqual(response.error, "")


if __name__ == "__main__":
    unittest.main()
