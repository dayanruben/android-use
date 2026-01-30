# ADB Provider

**Status:** Complete  
**Priority:** High

## Objective

Implement provider abstraction for ADB execution.

## Subtasks

- [x] `src/shell/providers/adb.ts` - AdbProvider interface
- [x] `src/shell/providers/adb-local.ts` - LocalAdbProvider (Bun.spawn)
- [x] `src/shell/providers/adb-mock.ts` - MockAdbProvider (tests)
- [x] AbortSignal support for cancellation
- [x] Timeout handling

## Implementation

### Interface (`adb.ts`)

- `ExecOptions`: timeoutMs, signal, serial
- `AdbResult`: exitCode, stdout, stderr, durationMs
- `AdbProvider`: exec(args, options)
- Helpers: `isAdbSuccess()`, `buildAdbArgs()`

### LocalAdbProvider (`adb-local.ts`)

- Uses `Bun.spawn()` for subprocess
- Timeout via `setTimeout` + `proc.kill()`
- AbortSignal listener for cancellation
- Configurable `adbPath`

### MockAdbProvider (`adb-mock.ts`)

- Pattern-based response matching
- Call history recording
- Delay simulation
- Preset responses: MOCK_DEVICES_RESPONSE, MOCK_UI_DUMP
