#!/usr/bin/env python3
"""Generate Caddyfile with values from .env"""

from pathlib import Path
from dotenv import load_dotenv
import os

# Load environment variables from .env file
env_path = Path(__file__).parent / '.env'
load_dotenv(dotenv_path=env_path)

# Read the Caddyfile template
with open('Caddyfile.template', 'r') as f:
    template = f.read()

# Replace placeholders with environment variables
caddyfile = template.replace('${HTTP_PORT}', os.getenv('HTTP_PORT', '8088'))

# Write the generated Caddyfile
with open('Caddyfile', 'w') as f:
    f.write(caddyfile)

print("Generated Caddyfile with the following configuration:")
print(f"- HTTP_PORT: {os.getenv('HTTP_PORT', '8088')}")
