# API Documentation

This document describes the gRPC API for the Makefile Command Runner service.

## Service Definition

The service is defined in `service.proto` and provides the following RPC methods:

### RunCommand

Executes a Makefile command and returns the output.

#### Request
```protobuf
message CommandRequest {
  string command = 1;  // The make command to run (e.g., "test", "clean")
  repeated string args = 2;  // Optional arguments for the command
}
```

#### Response
```protobuf
message CommandResponse {
  string output = 1;  // Standard output from the command
  string error = 2;   // Standard error from the command
  int32 return_code = 3;  // Return code from the command
}
```

## Error Handling

The service may return the following gRPC status codes:

- `OK` (0): The command was executed successfully
- `INVALID_ARGUMENT` (3): Invalid command or arguments
- `INTERNAL` (13): An internal error occurred while executing the command

## Example Usage

### Python Client

```python
import grpc
import service_pb2
import service_pb2_grpc

def run_command(command, args=None):
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = service_pb2_grpc.MakefileServiceStub(channel)
        response = stub.RunCommand(
            service_pb2.CommandRequest(command=command, args=args or [])
        )
        return response

# Example usage
response = run_command("test")
print(f"Output: {response.output}")
if response.return_code != 0:
    print(f"Error: {response.error}")
```

## Authentication

Currently, the service does not implement authentication. It is recommended to:

1. Run the service behind a reverse proxy with authentication
2. Use gRPC interceptors for authentication
3. Ensure the service is only accessible on trusted networks
