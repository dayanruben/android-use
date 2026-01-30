# Commands Implementation

**Status:** Complete  
**Priority:** High

## Objective

Implement all 10 commands following the established pattern.

## Commands

- [x] `check-device` - list/verify connected devices
- [x] `wake` - wake device and dismiss lock
- [x] `get-screen` - dump UI XML hierarchy
- [x] `tap` - tap coordinates
- [x] `type-text` - type text with escaping
- [x] `swipe` - swipe gestures
- [x] `key` - press keycodes
- [x] `screenshot` - capture screen
- [x] `launch-app` - launch apps by name/package
- [x] `install-apk` - install APKs

## Pure Domain Functions (Core)

- [x] `src/core/domain/device-parser.ts` - parseDeviceList, findDevice
- [x] `src/core/domain/text-escape.ts` - escapeForAdbInput, splitTextForInput

## Implementation Pattern

Each command:
1. Parse args with Zod schema
2. Execute ADB calls via provider
3. Record calls in trace
4. Return typed CommandResult

All commands auto-register via `registerCommand()`.
