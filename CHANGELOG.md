# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-02-01

### Added
- Initial release of android-use
- CLI tool for Android device control via ADB
- Commands: check-device, wake, get-screen, tap, type-text, swipe, key, screenshot, launch-app, install-apk
- Compact JSON output format with pre-calculated tap coordinates
- Full XML output option
- Multi-device support with serial targeting
- TypeScript programmatic API
- Comprehensive examples for common workflows
- Agent-optimized workflows and documentation
- Screen caching to `/tmp/.ai-artifacts/skills/android-use/`

### Features
- **Smart Screen Parsing**: Automatically filters UI elements and calculates tap coordinates
- **Multi-Device Support**: Handle multiple physical devices and emulators
- **Agent-Optimized**: Designed for AI agents with clear workflows
- **JSON Output**: Structured output for programmatic use
- **Error Handling**: Retries, timeouts, and verbose logging

### Documentation
- Comprehensive README with installation instructions
- SKILL.md with agent workflows
- Examples directory with practical scripts
- Agent workflows documentation
- Multi-device management examples
