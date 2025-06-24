#!/bin/bash

# Check if Poetry is installed
if ! command -v poetry >/dev/null; then
    echo "Poetry is not installed. Installing..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
    echo "Poetry installed successfully"
else
    echo "Poetry is already installed"
fi
