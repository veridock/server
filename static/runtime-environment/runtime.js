class RuntimeEnvironment {
    constructor() {
        this.apps = new Map();
        this.services = new Map();
        this.runningApps = new Map();
        this.autoScroll = true;
        this.consoleOutput = document.getElementById('console-output');
        this.appWindow = document.getElementById('appWindow');
        this.appFrame = document.getElementById('appFrame');
        this.overlay = document.getElementById('overlay');
        this.fileInput = document.getElementById('fileInput');
        
        this.initialize();
    }
    
    initialize() {
        this.log('info', 'Initializing Veridock Runtime Environment...');
        this.setupEventListeners();
        this.initializeServices();
        this.loadInstalledApps();
        this.startSystemMonitor();
        this.log('success', 'Runtime Environment ready');
    }
    
    setupEventListeners() {
        // File input for app installation
        this.fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                this.installAppFromFile(e.target.files[0]);
            }
        });
        
        // App installation button
        document.querySelector('.install-app-btn')?.addEventListener('click', () => {
            this.fileInput.click();
        });
        
        // Close app window when clicking overlay
        this.overlay.addEventListener('click', () => {
            this.closeAppWindow();
        });
        
        // Handle keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.closeAppWindow();
            }
        });
    }
    
    initializeServices() {
        // Initialize core services
        this.registerService('file-system', {
            name: 'File System',
            status: 'running',
            version: '1.0.0'
        });
        
        this.registerService('network', {
            name: 'Network',
            status: 'running',
            version: '1.0.0'
        });
        
        this.registerService('security', {
            name: 'Security',
            status: 'running',
            version: '1.0.0'
        });
        
        this.log('info', 'Core services initialized');
    }
    
    loadInstalledApps() {
        // Mock data - in a real app, this would load from storage/API
        const defaultApps = [
            {
                id: 'calculator',
                name: 'Calculator',
                description: 'A simple calculator with advanced functions',
                version: '1.2.3',
                icon: '🧮',
                installed: true
            },
            {
                id: 'chess',
                name: 'Chess',
                description: 'Play chess against the AI or a friend',
                version: '2.0.1',
                icon: '♟️',
                installed: true
            },
            {
                id: 'notepad',
                name: 'Notepad',
                description: 'A simple text editor with AI assistance',
                version: '1.5.0',
                icon: '📝',
                installed: true
            },
            {
                id: 'weather',
                name: 'Weather',
                description: 'Check the weather forecast',
                version: '1.0.2',
                icon: '⛅',
                installed: false
            }
        ];
        
        defaultApps.forEach(app => {
            this.apps.set(app.id, app);
        });
        
        this.renderAppGrid();
    }
    
    renderAppGrid() {
        const grid = document.querySelector('.main-content');
        if (!grid) return;
        
        grid.innerHTML = '';
        
        this.apps.forEach(app => {
            const appCard = document.createElement('div');
            appCard.className = 'card';
            appCard.innerHTML = `
                <div class="card-header">
                    <h3 class="card-title">${app.name}</h3>
                    <div class="card-icon">${app.icon}</div>
                </div>
                <p class="card-description">${app.description}</p>
                <div class="card-meta">
                    <span>v${app.version}</span>
                    <span class="card-badge">${app.installed ? 'Installed' : 'Install'}</span>
                </div>
            `;
            
            appCard.addEventListener('click', () => {
                if (app.installed) {
                    this.runApp(app.id);
                } else {
                    this.installApp(app.id);
                }
            });
            
            grid.appendChild(appCard);
        });
    }
    
    runApp(appId) {
        const app = this.apps.get(appId);
        if (!app) {
            this.log('error', `App not found: ${appId}`);
            return;
        }
        
        this.log('info', `Starting ${app.name}...`);
        
        // Set app window title
        document.getElementById('appWindowTitle').textContent = app.name;
        
        // Load app content (in a real app, this would load the actual app)
        this.appFrame.srcdoc = `
            <!DOCTYPE html>
            <html>
            <head>
                <title>${app.name}</title>
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                        margin: 0;
                        padding: 20px;
                        background: #f5f5f5;
                        color: #333;
                    }
                    .app-container {
                        max-width: 800px;
                        margin: 0 auto;
                        background: white;
                        border-radius: 8px;
                        padding: 20px;
                        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    }
                    h1 {
                        margin-top: 0;
                        color: #2c3e50;
                    }
                </style>
            </head>
            <body>
                <div class="app-container">
                    <h1>${app.name}</h1>
                    <p>This is a placeholder for the ${app.name} application.</p>
                    <p>In a real implementation, this would load the actual application interface.</p>
                </div>
            </body>
            </html>
        `;
        
        // Show the app window
        this.showAppWindow();
    }
    
    showAppWindow() {
        this.appWindow.classList.add('active');
        this.overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
    
    closeAppWindow() {
        this.appWindow.classList.remove('active');
        this.overlay.classList.remove('active');
        document.body.style.overflow = '';
    }
    
    installApp(appId) {
        const app = this.apps.get(appId);
        if (!app) {
            this.log('error', `App not found: ${appId}`);
            return;
        }
        
        this.log('info', `Installing ${app.name}...`);
        
        // Simulate installation
        setTimeout(() => {
            app.installed = true;
            this.renderAppGrid();
            this.log('success', `${app.name} installed successfully`);
        }, 1500);
    }
    
    installAppFromFile(file) {
        const reader = new FileReader();
        
        reader.onload = (e) => {
            try {
                const appData = JSON.parse(e.target.result);
                this.log('info', `Installing app from file: ${file.name}`);
                
                // Validate app data
                if (!appData.id || !appData.name) {
                    throw new Error('Invalid app format: missing required fields');
                }
                
                // Add or update the app
                this.apps.set(appData.id, {
                    ...appData,
                    installed: true,
                    fromFile: true
                });
                
                this.renderAppGrid();
                this.log('success', `App "${appData.name}" installed successfully`);
                
            } catch (error) {
                this.log('error', `Failed to install app: ${error.message}`);
            }
        };
        
        reader.onerror = () => {
            this.log('error', 'Failed to read the app file');
        };
        
        reader.readAsText(file);
    }
    
    registerService(serviceId, serviceInfo) {
        this.services.set(serviceId, {
            ...serviceInfo,
            id: serviceId,
            lastUpdated: new Date()
        });
        
        this.log('info', `Service registered: ${serviceInfo.name} (${serviceId})`);
        this.updateServiceStatus();
    }
    
    updateServiceStatus() {
        // In a real app, this would update the UI with service status
        let allServicesRunning = true;
        
        this.services.forEach(service => {
            if (service.status !== 'running') {
                allServicesRunning = false;
            }
        });
        
        const statusDot = document.querySelector('.status-dot');
        if (statusDot) {
            statusDot.className = 'status-dot ' + (allServicesRunning ? 'active' : 'warning');
        }
    }
    
    startSystemMonitor() {
        // Update system stats periodically
        this.updateSystemStats();
        setInterval(() => this.updateSystemStats(), 5000);
    }
    
    updateSystemStats() {
        // Simulate system stats
        const updateElement = (id, value) => {
            const el = document.getElementById(id);
            if (el) el.textContent = value;
        };
        
        // Random values for demo purposes
        const cpu = Math.floor(10 + Math.random() * 40);
        const memory = Math.floor(30 + Math.random() * 50);
        const disk = Math.floor(10 + Math.random() * 30);
        
        updateElement('cpu-usage', `${cpu}%`);
        updateElement('memory-usage', `${memory}%`);
        updateElement('disk-usage', `${disk}%`);
        
        // Update uptime
        const now = new Date();
        const uptimeMs = now - this.startTime;
        const uptimeStr = this.formatUptime(uptimeMs);
        updateElement('uptime', uptimeStr);
    }
    
    formatUptime(ms) {
        const seconds = Math.floor(ms / 1000) % 60;
        const minutes = Math.floor(ms / (1000 * 60)) % 60;
        const hours = Math.floor(ms / (1000 * 60 * 60)) % 24;
        const days = Math.floor(ms / (1000 * 60 * 60 * 24));
        
        const parts = [];
        if (days > 0) parts.push(`${days}d`);
        if (hours > 0) parts.push(`${hours}h`);
        if (minutes > 0 && days === 0) parts.push(`${minutes}m`);
        if (seconds > 0 && days === 0 && hours === 0) parts.push(`${seconds}s`);
        
        return parts.join(' ') || '0s';
    }
    
    log(level, message) {
        const timestamp = new Date().toLocaleTimeString();
        const logLine = document.createElement('div');
        logLine.className = 'console-line';
        
        let levelClass = 'log-info';
        let levelText = 'INFO';
        
        switch (level) {
            case 'error':
                levelClass = 'log-error';
                levelText = 'ERROR';
                console.error(`[${timestamp}] ${message}`);
                break;
            case 'warn':
            case 'warning':
                levelClass = 'log-warning';
                levelText = 'WARN';
                console.warn(`[${timestamp}] ${message}`);
                break;
            case 'success':
                levelClass = 'log-success';
                levelText = 'SUCCESS';
                console.log(`[${timestamp}] ${message}`);
                break;
            case 'debug':
                levelClass = 'log-debug';
                levelText = 'DEBUG';
                console.debug(`[${timestamp}] ${message}`);
                break;
            case 'command':
                levelClass = 'log-command';
                levelText = 'COMMAND';
                console.log(`[${timestamp}] $ ${message}`);
                break;
            default:
                console.log(`[${timestamp}] ${message}`);
        }
        
        logLine.innerHTML = `
            <span class="console-time">${timestamp}</span>
            <span class="log-level ${levelClass}">${levelText}</span>
            <span class="console-message">${message}</span>
        `;
        
        this.consoleOutput.appendChild(logLine);
        
        // Auto-scroll to bottom if enabled
        if (this.autoScroll) {
            this.consoleOutput.scrollTop = this.consoleOutput.scrollHeight;
        }
    }
    
    clearConsole() {
        this.consoleOutput.innerHTML = '';
        this.log('info', 'Console cleared');
    }
    
    toggleAutoScroll() {
        this.autoScroll = !this.autoScroll;
        const statusEl = document.getElementById('autoScrollStatus');
        if (statusEl) {
            statusEl.textContent = this.autoScroll ? 'On' : 'Off';
        }
        this.log('info', `Auto-scroll ${this.autoScroll ? 'enabled' : 'disabled'}`);
    }
}

// Initialize the runtime when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', () => {
    // Add start time for uptime calculation
    window.runtime = new RuntimeEnvironment();
    window.runtime.startTime = new Date();
    
    // Expose methods to the global scope for HTML event handlers
    window.runApp = (appId) => window.runtime.runApp(appId);
    window.installApp = (appId) => window.runtime.installApp(appId);
    window.closeAppWindow = () => window.runtime.closeAppWindow();
    window.clearConsole = () => window.runtime.clearConsole();
    window.toggleAutoScroll = () => window.runtime.toggleAutoScroll();
});
