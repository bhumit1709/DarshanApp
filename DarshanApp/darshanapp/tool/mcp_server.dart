// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A server that implements the tools API using the [ToolsSupport] mixin.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:dart_mcp/server.dart';
import 'package:dart_mcp/stdio.dart';

void main() {
  // Create the server and connect it to stdio.
  MCPServerWithTools(stdioChannel(input: io.stdin, output: io.stdout));
}

/// This server uses the [ToolsSupport] mixin to provide tools to the client.
base class MCPServerWithTools extends MCPServer with ToolsSupport {
  MCPServerWithTools(super.channel)
      : super.fromStreamChannel(
          implementation: Implementation(
            name: 'darshanapp_mcp_server',
            version: '0.1.0',
          ),
          instructions: 'Provides tools for managing the DarshanApp project.',
        ) {
    registerTool(echoTool, _echo);
    registerTool(analyzeTool, _analyze);
  }

  /// A tool that echoes the input.
  final echoTool = Tool(
    name: 'echo',
    description: 'Echoes the input string back to the user.',
    inputSchema: Schema.object(
      properties: {
        'message': Schema.string(
          description: 'The message to echo',
        ),
      },
      required: ['message'],
    ),
  );

  /// The implementation of the `echo` tool.
  FutureOr<CallToolResult> _echo(CallToolRequest request) {
    final message = request.arguments!['message'] as String;
    return CallToolResult(
      content: [
        TextContent(
          text: 'Echo: $message',
        ),
      ],
    );
  }

  /// A tool that runs flutter analyze.
  final analyzeTool = Tool(
    name: 'run_analyze',
    description: 'Runs "flutter analyze" on the current project.',
    inputSchema: Schema.object(
      properties: {},
    ),
  );

  /// The implementation of the `run_analyze` tool.
  FutureOr<CallToolResult> _analyze(CallToolRequest request) async {
    final process = await io.Process.start(
      'flutter',
      ['analyze'],
      runInShell: true,
    );

    final output = await process.stdout.transform(utf8.decoder).join();
    final error = await process.stderr.transform(utf8.decoder).join();
    final exitCode = await process.exitCode;

    return CallToolResult(
      content: [
        TextContent(
          text: 'Exit Code: $exitCode\n\nOutput:\n$output\n\nError:\n$error',
        ),
      ],
      isError: exitCode != 0,
    );
  }
}
