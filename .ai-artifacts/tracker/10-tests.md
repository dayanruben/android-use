# Tests

**Status:** Deferred  
**Priority:** Medium

## Objective

Comprehensive test coverage for core and shell.

## Note

Deferred to separate testing agent.

## Suggested Test Categories

### Core Tests (Pure, no mocks)
- device-parser.ts - parseDeviceList, findDevice
- text-escape.ts - escapeForAdbInput, splitTextForInput

### Schema Tests (Zod validation)
- Input validation (valid/invalid cases)
- Output serialization

### Shell Tests (MockAdbProvider)
- Each command with mock provider
- Error handling
- Timeout/cancellation

### CLI Tests
- Argument parsing
- JSON output contract
