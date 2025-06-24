#!/usr/bin/env python3
"""Simple gRPC client to test the Makefile service."""

import sys

import grpc
import service_pb2
import service_pb2_grpc


def run():
    # Set up a connection to the server
    channel = grpc.insecure_channel("localhost:50051")
    stub = service_pb2_grpc.MakefileServiceStub(channel)

    # Test running a command
    try:
        command = sys.argv[1] if len(sys.argv) > 1 else "help"
        print(f"Sending command: {command}")

        # Create a request
        request = service_pb2.CommandRequest(command=command)

        # Call the service
        response = stub.RunCommand(request)

        # Print the response
        print(f"Return code: {response.return_code}")
        print("--- STDOUT ---")
        print(response.output)
        print("--- STDERR ---")
        print(response.error)

    except grpc.RpcError as e:
        print(f"RPC failed: {e.code()}: {e.details()}")
    except Exception as e:
        print(f"Error: {str(e)}")


if __name__ == "__main__":
    run()
