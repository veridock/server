#!/usr/bin/env python3
"""gRPC server for the Makefile Command Runner."""

import os
import subprocess
import signal
import sys
import logging
from concurrent import futures
import grpc
import service_pb2
import service_pb2_grpc

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class MakefileService(service_pb2_grpc.MakefileServiceServicer):
    """Implementation of the MakefileService."""

    def RunCommand(self, request, context):
        """Run a Makefile command and return the result."""
        try:
            # Build the command to run
            cmd = ['make']
            if request.command:
                cmd.append(request.command)
            if request.args:
                cmd.extend(request.args)

            logger.info(f"Running command: {' '.join(cmd)}")

            # Run the command
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                cwd=os.getcwd()
            )

            # Log the result
            logger.debug(f"Command completed with return code: {result.returncode}")
            if result.stdout:
                logger.debug(f"stdout: {result.stdout}")
            if result.stderr:
                logger.warning(f"stderr: {result.stderr}")

            # Return the response
            return service_pb2.CommandResponse(
                output=result.stdout,
                error=result.stderr,
                return_code=result.returncode
            )

        except Exception as e:
            error_msg = f"Error executing command: {str(e)}"
            logger.error(error_msg, exc_info=True)
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details(error_msg)
            return service_pb2.CommandResponse(
                output="",
                error=error_msg,
                return_code=-1
            )


def serve(port=50051):
    """Start the gRPC server."""
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    service_pb2_grpc.add_MakefileServiceServicer_to_server(
        MakefileService(), server)

    # Listen on the given port
    server_address = f'[::]:{port}'
    server.add_insecure_port(server_address)

    # Start the server
    server.start()
    logger.info(f"gRPC server started on port {port}")

    # Handle graceful shutdown
    def signal_handler(sig, frame):
        logger.info("Shutting down gRPC server...")
        server.stop(0)
        logger.info("gRPC server stopped")
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    # Keep the server running
    server.wait_for_termination()


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Run the gRPC server for Makefile commands')
    parser.add_argument('--port', type=int, default=50051,
                        help='The port to listen on (default: 50051)')
    args = parser.parse_args()

    serve(port=args.port)
