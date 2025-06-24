import grpc
import unittest
import os
import sys
import time
from concurrent import futures
import threading

# Add the parent directory to the path so we can import the generated gRPC code
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import service_pb2
import service_pb2_grpc

class TestMakefileService(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Start the gRPC server in a separate process
        cls.server_process = None
        cls.server_port = '50051'
        
        # Import the server module
        from grpc_server import serve, MakefileService
        
        # Start the server in a separate thread
        cls.server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
        service_pb2_grpc.add_MakefileServiceServicer_to_server(
            MakefileService(), cls.server)
        cls.server.add_insecure_port(f'[::]:{cls.server_port}')
        cls.server.start()
        
        # Create a channel and stub
        channel = grpc.insecure_channel(f'localhost:{cls.server_port}')
        cls.stub = service_pb2_grpc.MakefileServiceStub(channel)
    
    @classmethod
    def tearDownClass(cls):
        # Stop the server
        cls.server.stop(0)
    
    def test_run_valid_command(self):
        """Test running a valid Makefile command."""
        response = self.stub.RunCommand(
            service_pb2.CommandRequest(command='help')
        )
        self.assertIsNotNone(response)
        self.assertEqual(response.return_code, 0)
        self.assertIn('Available targets:', response.output)
    
    def test_run_invalid_command(self):
        """Test running an invalid Makefile command."""
        response = self.stub.RunCommand(
            service_pb2.CommandRequest(command='nonexistent-command')
        )
        self.assertIsNotNone(response)
        self.assertNotEqual(response.return_code, 0)
        self.assertIn('No rule to make target', response.error)

if __name__ == '__main__':
    unittest.main()
