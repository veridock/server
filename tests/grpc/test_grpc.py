#!/usr/bin/env python3
import grpc
import service_pb2
import service_pb2_grpc


def run():
    # Create a channel to the server
    with grpc.insecure_channel("localhost:50051") as channel:
        # Create a stub (client)
        stub = service_pb2_grpc.MakefileServiceStub(channel)

        # Test 1: Run 'hello' command
        print("Test 1: Running 'hello' command")
        response = stub.RunCommand(service_pb2.CommandRequest(command="hello"))
        print(f"Response: {response.output}")

        # Test 2: Run 'date' command
        print("\nTest 2: Running 'date' command")
        response = stub.RunCommand(service_pb2.CommandRequest(command="date"))
        print(f"Response: {response.output}")


if __name__ == "__main__":
    print("=== Testing gRPC Client ===\n")
    run()
