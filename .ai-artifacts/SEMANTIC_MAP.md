# SEMANTIC_MAP: android-use

CLI + library for Android device control via ADB.  
**Runtime:** Bun + TypeScript | **Architecture:** Functional Core / Imperative Shell

---

## Project Status

```
Phase 1: Foundation    [████████████] COMPLETE
Phase 2: Infrastructure [░░░░░░░░░░░░] NOT STARTED
Phase 3: Commands       [░░░░░░░░░░░░] NOT STARTED
Phase 4: CLI & Polish   [░░░░░░░░░░░░] NOT STARTED
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    IMPERATIVE SHELL                         │
│           (Side Effects: ADB, File I/O, Console)            │
│                                                             │
│  src/shell/                                                 │
│  ├── commands/     → Command implementations (EMPTY)        │
│  ├── providers/    → ADB abstraction (EMPTY)                │
│  ├── formatters/   → text/json output (EMPTY)               │
│  └── observability/→ Trace impl (EMPTY)                     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                     FUNCTIONAL CORE                         │
│              (Pure Logic: No I/O, No Side Effects)          │
│                                                             │
│  src/core/                                                  │
│  ├── types/        → Domain types (DONE)                    │
│  ├── contracts/    → Zod schemas (DONE)                     │
│  └── domain/       → Pure business logic (EMPTY)            │
└─────────────────────────────────────────────────────────────┘
```

---

## Domain Concepts

### Device Management
- `src/core/types/device.ts` → Device, DeviceState, DeviceTransport, ScreenInfo
- States: device|offline|unauthorized|no permissions|bootloader|recovery|sideload|unknown
- Transport: usb|wifi|unknown

### Coordinates & Gestures
- `src/core/types/coordinates.ts` → Point, Rect, SwipeGesture, SwipeDirection
- Pure utils: `rectCenter()`, `pointInRect()`

### Android Keys
- `src/core/types/keys.ts` → KEYCODES const, Keycode, KeyName
- 25+ keycodes: HOME, BACK, POWER, VOLUME_*, DPAD_*, MEDIA_*, etc.
- `resolveKeycode()`, `isKeyName()` helpers

### App Management
- `src/core/types/app.ts` → PackageName, ActivityComponent, AppInfo, LaunchOptions, InstallOptions
- `formatComponent()`, `parseComponent()` helpers

### Result Pattern
- `src/core/types/result.ts` → CommandResult<T>, ErrorCode, ResultError
- Error codes: INVALID_INPUT|ADB_FAILED|TIMEOUT|CANCELLED|DEVICE_NOT_FOUND|DEVICE_OFFLINE|DEVICE_UNAUTHORIZED|FILE_NOT_FOUND|PARSE_ERROR|UNKNOWN
- Utilities: `ok()`, `err()`, `isOk()`, `isErr()`, `map()`

### Execution Trace
- `src/core/types/trace.ts` → ExecutionTrace, AdbCall, TraceBuilder
- `createTraceBuilder()` factory

---

## Zod Contracts

### Input Schemas (`src/core/contracts/inputs.ts`)
| Schema | Purpose |
|--------|---------|
| CheckDeviceInputSchema | list/verify devices |
| WakeInputSchema | wake + dismiss lock |
| GetScreenInputSchema | dump UI XML |
| TapInputSchema | tap x,y |
| TypeTextInputSchema | type text |
| SwipeInputSchema | swipe start→end |
| SwipeDirectionInputSchema | swipe by direction |
| KeyInputSchema | press keycode |
| ScreenshotInputSchema | capture screen |
| LaunchAppInputSchema | launch app |
| InstallApkInputSchema | install APK |

### Output Schemas (`src/core/contracts/outputs.ts`)
- Per-command: DeviceOutput, WakeOutput, TapOutput, etc.
- Generic: CommandResultSchema, ExecutionTraceSchema

### Config (`src/core/contracts/config.ts`)
```typescript
SkillConfigSchema {
  adbPath: string = "adb"
  timeoutMs: number = 15000
  maxRetries: number = 1
  outputFormat: "text" | "json" = "text"
  verbose: boolean = false
  defaultSerial: string | null = null
}
```

---

## Data Flow (Planned)

```
CLI args → Zod validate → Command handler → ADB provider → Parse output → CommandResult<T>
                ↓                                                              ↓
           INVALID_INPUT                                              ok(data) | err(code)
```

---

## File Map

```
src/
├── index.ts              # CLI entry (placeholder)
├── core/
│   ├── types/
│   │   ├── index.ts      # Barrel export
│   │   ├── device.ts     # Device, DeviceState, ScreenInfo
│   │   ├── coordinates.ts# Point, Rect, SwipeGesture
│   │   ├── keys.ts       # KEYCODES, resolveKeycode()
│   │   ├── app.ts        # PackageName, AppInfo, LaunchOptions
│   │   ├── result.ts     # CommandResult<T>, ok(), err()
│   │   └── trace.ts      # ExecutionTrace, TraceBuilder
│   ├── contracts/
│   │   ├── index.ts      # Barrel export
│   │   ├── inputs.ts     # 11 input schemas
│   │   ├── outputs.ts    # 11 output schemas + CommandResultSchema
│   │   └── config.ts     # SkillConfigSchema, DEFAULT_CONFIG
│   └── domain/           # (empty - future pure logic)
├── shell/
│   ├── commands/         # (empty)
│   ├── providers/        # (empty)
│   ├── formatters/       # (empty)
│   └── observability/    # (empty)
└── tests/
    ├── core/             # (empty)
    └── shell/            # (empty)
```

---

## Path Aliases

```json
"@core/*"  → "src/core/*"
"@shell/*" → "src/shell/*"
```

---

## Dependencies

- `zod@4.3.6` - Schema validation
- `@biomejs/biome` - Lint/format (dev)
- `typescript@^5.0.0` - Type checking (peer)

---

## Planned Commands (v1)

| Command | Input Schema | Output Schema | Status |
|---------|--------------|---------------|--------|
| check-device | CheckDeviceInputSchema | CheckDeviceOutputSchema | ⏳ |
| wake | WakeInputSchema | WakeOutputSchema | ⏳ |
| get-screen | GetScreenInputSchema | GetScreenOutputSchema | ⏳ |
| tap | TapInputSchema | TapOutputSchema | ⏳ |
| type-text | TypeTextInputSchema | TypeTextOutputSchema | ⏳ |
| swipe | SwipeInputSchema | SwipeOutputSchema | ⏳ |
| key | KeyInputSchema | KeyOutputSchema | ⏳ |
| screenshot | ScreenshotInputSchema | ScreenshotOutputSchema | ⏳ |
| launch-app | LaunchAppInputSchema | LaunchAppOutputSchema | ⏳ |
| install-apk | InstallApkInputSchema | InstallApkOutputSchema | ⏳ |

---

## Key Principles

1. **Validate at boundary** - Zod at entry, trust interior
2. **Rich results** - CommandResult<T>, never primitives
3. **Provider abstraction** - LocalAdbProvider + MockAdbProvider
4. **Trace everything** - ExecutionTrace on every result
5. **3 abstraction levels** - CLI, command API, primitives

---

## Next Steps

1. Implement ADB provider (`src/shell/providers/`)
2. Add formatters (`src/shell/formatters/`)
3. Build command registry + hooks
4. Implement commands starting with `tap`
5. Wire up CLI router

---

<!-- GIT_COMMIT: 0c17cebe0ca3dbfed5d4217c226205aadf5a6b50 -->
