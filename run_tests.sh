#!/bin/bash

# Exit on error
set -e

# Change to the project root directory
cd "$(dirname "$0")"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to run a test and print the result
run_test() {
    local test_name=$1
    local test_cmd=$2
    
    echo -n "Running $test_name... "
    
    if eval "$test_cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}PASSED${NC}"
        return 0
    else
        echo -e "${RED}FAILED${NC}"
        echo "Command that failed: $test_cmd"
        return 1
    fi
}

# Check if we're in a virtual environment
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Activating virtual environment..."
    source venv/bin/activate
fi

# Install test dependencies if needed
pip install -q pytest pytest-cov

echo "Starting tests..."

# Run gRPC tests
run_test "gRPC tests" "python -m pytest tests/grpc/test_client.py -v"

# Run HTTP tests
run_test "HTTP API tests" "python -m pytest tests/http/test_http.py -v"

# Run code coverage
# Note: This requires pytest-cov to be installed
# run_test "Code coverage" "python -m pytest --cov=. --cov-report=term-missing"

echo "All tests completed!"
