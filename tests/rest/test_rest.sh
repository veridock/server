#!/bin/bash

# Test REST API using curl

echo "=== Testing REST API ==="

# Test 1: Run 'hello' command
echo "\nTest 1: Running 'hello' command"
curl -X POST http://localhost:8080/makefile/run_command \
  -H "Content-Type: application/json" \
  -d '{"command":"hello"}'

# Test 2: Run 'date' command
echo "\n\nTest 2: Running 'date' command"
curl -X POST http://localhost:8080/makefile/run_command \
  -H "Content-Type: application/json" \
  -d '{"command":"date"}'

echo "\n\nREST API tests completed!"
