import unittest
import requests
import json
import os
import sys
import subprocess
import time
from http.server import HTTPServer
import threading

# Add the parent directory to the path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Import the HTTP server
from http_server import MakefileRequestHandler, PORT as HTTP_PORT

class TestHTTPServer(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Start the HTTP server in a separate thread
        cls.server = HTTPServer(('', HTTP_PORT), MakefileRequestHandler)
        cls.server_thread = threading.Thread(target=cls.server.serve_forever)
        cls.server_thread.daemon = True
        cls.server_thread.start()
        
        # Wait for server to start
        time.sleep(1)
        
        # Base URL for API requests
        cls.base_url = f'http://localhost:{HTTP_PORT}'
    
    @classmethod
    def tearDownClass(cls):
        # Stop the server
        cls.server.shutdown()
        cls.server.server_close()
        cls.server_thread.join()
    
    def test_get_commands(self):
        """Test getting the list of available commands."""
        response = requests.get(f'{self.base_url}/api/commands')
        self.assertEqual(response.status_code, 200)
        
        data = response.json()
        self.assertIn('commands', data)
        self.assertIsInstance(data['commands'], list)
        self.assertGreater(len(data['commands']), 0)
    
    def test_run_valid_command(self):
        """Test running a valid Makefile command."""
        response = requests.post(
            f'{self.base_url}/api/run',
            json={'command': 'help'}
        )
        self.assertEqual(response.status_code, 200)
        
        data = response.json()
        self.assertIn('output', data)
        self.assertIn('error', data)
        self.assertIn('return_code', data)
        self.assertEqual(data['return_code'], 0)
        self.assertIn('Available targets:', data['output'])
    
    def test_run_invalid_command(self):
        """Test running an invalid Makefile command."""
        response = requests.post(
            f'{self.base_url}/api/run',
            json={'command': 'nonexistent-command'}
        )
        self.assertEqual(response.status_code, 200)
        
        data = response.json()
        self.assertIn('error', data)
        self.assertIn('No rule to make target', data['error'])
        self.assertNotEqual(data['return_code'], 0)
    
    def test_run_command_with_args(self):
        """Test running a command with arguments."""
        response = requests.post(
            f'{self.base_url}/api/run',
            json={
                'command': 'echo',
                'args': ['hello', 'world']
            }
        )
        self.assertEqual(response.status_code, 200)
        
        data = response.json()
        self.assertEqual(data['return_code'], 0)
        self.assertIn('hello world', data['output'])

if __name__ == '__main__':
    unittest.main()
