# Ollama Chat

A web interface for interacting with Ollama's API, allowing you to chat with various AI models.

## Features

- Connect to Ollama's API
- Select from available models
- Interactive chat interface
- Real-time responses
- Simple and intuitive UI

## Prerequisites

- Ollama server running locally (default: http://localhost:11434)
- Modern web browser

## Usage

1. Ensure Ollama server is running
2. Open the Ollama Chat in your browser
3. Select a model from the dropdown
4. Type your message and press Enter or click Send
5. View the AI's response in the chat window

## Configuration

Update the following environment variable in your `.env` file if needed:

```
OLLAMA_API_URL=http://localhost:11434
```

## Available Models

The available models will be automatically detected from your Ollama installation.
