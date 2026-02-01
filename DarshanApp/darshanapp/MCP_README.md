# Dart MCP Server Configuration

This project includes a local [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) server implemented in Dart.

## Server Script
The server script is located at: `tool/mcp_server.dart`.

## Setup Instructions

To use this server with an MCP client (like Claude Desktop), add the following configuration to your client's config file (e.g., `~/Library/Application Support/Claude/claude_desktop_config.json` on macOS).

**Note:** Replace `/Users/jiyaanmehta/Documents/Projects/DarshanApp/darshanapp` with the absolute path to your project if it's different.

```json
{
  "mcpServers": {
    "darshanapp": {
      "command": "dart",
      "args": [
        "/Users/jiyaanmehta/Documents/Projects/DarshanApp/darshanapp/tool/mcp_server.dart"
      ]
    }
  }
}
```

## Available Tools

- `echo`: simple echo tool for testing.
- `run_analyze`: runs `flutter analyze` on the project.

## Running Locally

You can test the server locally by running:
```bash
dart tool/mcp_server.dart
```
It accepts JSON-RPC messages over stdio.
