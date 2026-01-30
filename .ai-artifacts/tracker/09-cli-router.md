# CLI Router

**Status:** Complete  
**Priority:** High

## Objective

Implement CLI entry point with argument parsing and dispatch.

## Subtasks

- [x] `src/index.ts` - Entry point
- [x] `src/shell/cli.ts` - Argument parsing
- [x] Global flags handling
- [x] Command dispatch to registry
- [x] Exit code mapping

## Global Flags

- [x] `-s, --serial <id>` - Device serial
- [x] `--adb-path <path>` - ADB binary path
- [x] `--timeout <ms>` - Timeout in ms
- [x] `--retries <n>` - Retry count
- [x] `--json` - JSON output
- [x] `--verbose` - Verbose logging
- [x] `--help` - Show help
- [x] `--version` - Show version

## Implementation

- `parseArgs()` - Parse argv into CliArgs
- `showHelp()` - Display usage info
- `showVersion()` - Display version
- `runCli()` - Main entry, returns exit code
