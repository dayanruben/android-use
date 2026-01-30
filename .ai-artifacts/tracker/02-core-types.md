# Core Types

**Status:** Complete  
**Priority:** High

## Objective

Define TypeScript types for the functional core.

## Subtasks

- [x] `src/core/types/device.ts` - Device info type
- [x] `src/core/types/coordinates.ts` - Point, Rect types
- [x] `src/core/types/keys.ts` - Keycode enum/map
- [x] `src/core/types/app.ts` - App/package types
- [x] `src/core/types/result.ts` - CommandResult type
- [x] `src/core/types/trace.ts` - ExecutionTrace type
- [x] `src/core/types/index.ts` - Barrel export

## Notes

These are pure types, no runtime validation (that's Zod's job).

## Summary

- **device.ts**: `Device`, `DeviceState`, `DeviceTransport`, `ScreenInfo`
- **coordinates.ts**: `Point`, `Rect`, `SwipeGesture`, `SwipeDirection` + pure utils
- **keys.ts**: `KEYCODES` const, `Keycode`, `KeyName`, `resolveKeycode()`
- **app.ts**: `PackageName`, `ActivityComponent`, `AppInfo`, `LaunchOptions`, `InstallOptions`
- **result.ts**: `CommandResult<T>`, `ErrorCode`, `ok()`, `err()`, `isOk()`, `isErr()`, `map()`
- **trace.ts**: `ExecutionTrace`, `TraceBuilder`, `createTraceBuilder()`
