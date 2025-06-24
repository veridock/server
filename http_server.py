import os
import json
import subprocess
import http.server
import socketserver
from urllib.parse import urlparse, parse_qs

PORT = 8000
STATIC_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static')

class MakefileRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=STATIC_DIR, **kwargs)
    
    def do_GET(self):
        # Handle API endpoints
        if self.path == '/api/commands':
            self.handle_get_commands()
        else:
            # Serve static files
            return http.server.SimpleHTTPRequestHandler.do_GET(self)
    
    def do_POST(self):
        if self.path == '/api/run':
            self.handle_run_command()
        else:
            self.send_error(404, 'Not Found')
    
    def handle_get_commands(self):
        """Return the list of available Makefile commands."""
        try:
            # Try to get commands from the generated commands.js file
            commands_js_path = os.path.join(STATIC_DIR, 'commands.js')
            if os.path.exists(commands_js_path):
                with open(commands_js_path, 'r') as f:
                    content = f.read()
                    # Extract the array from the JavaScript file
                    import re
                    match = re.search(r'\[([^\]]+)\]', content)
                    if match:
                        commands = [cmd.strip(" '\"") for cmd in match.group(1).split(',')]
                        self.send_json_response({'commands': commands})
                        return
            
            # Fallback to parsing Makefile directly
            makefile_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'Makefile')
            if os.path.exists(makefile_path):
                with open(makefile_path, 'r') as f:
                    content = f.read()
                    # Simple regex to find .PHONY targets
                    import re
                    phony_matches = re.findall(r'\.PHONY:\s*([^\n]+)', content)
                    commands = []
                    for match in phony_matches:
                        commands.extend(cmd.strip() for cmd in match.split() if cmd.strip())
                    
                    # Remove duplicates and sort
                    commands = sorted(list(set(commands)))
                    self.send_json_response({'commands': commands})
                    return
            
            self.send_json_response({'commands': ['help', 'install', 'test', 'clean']})
            
        except Exception as e:
            self.send_error(500, f'Error getting commands: {str(e)}')
    
    def handle_run_command(self):
        """Execute a Makefile command and return the output."""
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))
            
            command = data.get('command', '').strip()
            if not command:
                self.send_error(400, 'Command is required')
                return
            
            # Sanitize the command to prevent command injection
            if not all(c.isalnum() or c in '_-' for c in command):
                self.send_error(400, 'Invalid command')
                return
            
            # Run the make command
            try:
                result = subprocess.run(
                    ['make', command],
                    capture_output=True,
                    text=True,
                    cwd=os.path.dirname(os.path.abspath(__file__)),
                    timeout=300  # 5 minutes timeout
                )
                
                self.send_json_response({
                    'output': result.stdout,
                    'error': result.stderr,
                    'return_code': result.returncode
                })
                
            except subprocess.TimeoutExpired:
                self.send_error(408, 'Command timed out')
            except Exception as e:
                self.send_error(500, f'Error executing command: {str(e)}')
                
        except json.JSONDecodeError:
            self.send_error(400, 'Invalid JSON')
        except Exception as e:
            self.send_error(500, f'Server error: {str(e)}')
    
    def send_json_response(self, data, status_code=200):
        """Send a JSON response."""
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))

def run_server():
    """Run the HTTP server."""
    handler = MakefileRequestHandler
    
    with socketserver.TCPServer(("", PORT), handler) as httpd:
        print(f"Serving at http://localhost:{PORT}")
        print("Press Ctrl+C to stop the server")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down server...")

if __name__ == '__main__':
    print(f"Starting HTTP server on port {PORT}...")
    print(f"Serving static files from: {STATIC_DIR}")
    run_server()
