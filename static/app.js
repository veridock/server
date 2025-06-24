// Global variables
let availableCommands = [];
let isRunning = false;

// DOM elements
const commandsContainer = document.getElementById('commandsContainer');
const commandInput = document.getElementById('commandInput');
const runButton = document.getElementById('runButton');
const outputElement = document.getElementById('output');

// Initialize the application
async function init() {
    try {
        // Load available commands
        await loadCommands();
        
        // Set up event listeners
        setupEventListeners();
        
        console.log('Application initialized');
    } catch (error) {
        console.error('Error initializing application:', error);
        showError('Failed to initialize application. Please check the console for details.');
    }
}

// Load available commands from the server
async function loadCommands() {
    try {
        // First try to load from the generated commands.js file
        if (typeof availableCommands !== 'undefined' && Array.isArray(availableCommands)) {
            console.log('Using preloaded commands');
        } else {
            // Fallback to fetching from the server
            const response = await fetch('/api/commands');
            if (!response.ok) throw new Error('Failed to load commands');
            const data = await response.json();
            availableCommands = data.commands;
        }
        
        renderCommandList();
    } catch (error) {
        console.error('Error loading commands:', error);
        commandsContainer.innerHTML = '<p class="error">Failed to load commands. Please refresh the page to try again.</p>';
    }
}

// Render the list of available commands
function renderCommandList() {
    if (!availableCommands || availableCommands.length === 0) {
        commandsContainer.innerHTML = '<p class="error">No commands available</p>';
        return;
    }
    
    commandsContainer.innerHTML = '';
    
    // Group commands by prefix (text before first dash if exists)
    const commandGroups = {};
    availableCommands.forEach(cmd => {
        const prefix = cmd.includes('-') ? cmd.split('-')[0] : 'other';
        if (!commandGroups[prefix]) {
            commandGroups[prefix] = [];
        }
        commandGroups[prefix].push(cmd);
    });
    
    // Sort groups
    const sortedGroups = Object.keys(commandGroups).sort();
    
    // Create HTML for each group
    sortedGroups.forEach(group => {
        const groupElement = document.createElement('div');
        groupElement.className = 'command-group';
        
        const groupTitle = document.createElement('h3');
        groupTitle.textContent = group === 'other' ? 'Other Commands' : `${group}-*`;
        groupElement.appendChild(groupTitle);
        
        const commandsList = document.createElement('div');
        commandsList.className = 'commands-list';
        
        // Sort commands in the group
        const sortedCommands = [...commandGroups[group]].sort();
        
        sortedCommands.forEach(cmd => {
            const cmdElement = document.createElement('div');
            cmdElement.className = 'command-item';
            cmdElement.textContent = cmd;
            cmdElement.title = `Run: ${cmd}`;
            cmdElement.addEventListener('click', () => {
                commandInput.value = cmd;
                runCommand();
            });
            commandsList.appendChild(cmdElement);
        });
        
        groupElement.appendChild(commandsList);
        commandsContainer.appendChild(groupElement);
    });
}

// Set up event listeners
function setupEventListeners() {
    // Run command when clicking the Run button
    runButton.addEventListener('click', runCommand);
    
    // Run command when pressing Enter in the input field
    commandInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter' && !isRunning) {
            runCommand();
        }
    });
    
    // Enable/disable Run button based on input
    commandInput.addEventListener('input', () => {
        runButton.disabled = !commandInput.value.trim() || isRunning;
    });
}

// Run the selected command
async function runCommand() {
    const command = commandInput.value.trim();
    if (!command || isRunning) return;
    
    isRunning = true;
    runButton.disabled = true;
    runButton.textContent = 'Running...';
    
    // Clear previous output
    outputElement.textContent = `$ make ${command}\n\nRunning...`;
    outputElement.scrollTop = outputElement.scrollHeight;
    
    try {
        const response = await fetch('/api/run', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ command })
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        
        // Display the command output
        let output = `$ make ${command}\n\n`;
        
        if (data.output) {
            output += data.output;
        }
        
        if (data.error) {
            output += `\n\nError:\n${data.error}`;
            outputElement.className = 'error';
        } else {
            outputElement.className = 'success';
        }
        
        outputElement.textContent = output;
    } catch (error) {
        console.error('Error running command:', error);
        outputElement.textContent = `$ make ${command}\n\nError: ${error.message}`;
        outputElement.className = 'error';
    } finally {
        isRunning = false;
        runButton.disabled = false;
        runButton.textContent = 'Run';
        outputElement.scrollTop = outputElement.scrollHeight;
    }
}

// Show error message
function showError(message) {
    const errorElement = document.createElement('div');
    errorElement.className = 'error';
    errorElement.textContent = message;
    document.body.insertBefore(errorElement, document.body.firstChild);
}

// Initialize the application when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', init);
