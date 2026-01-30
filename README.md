# android-use

CLI + library for Android device control via ADB.

## Installation

```bash
bun install
```

## Quick Start

```bash
# List connected devices
bun run start check-device

# Tap at coordinates
bun run start tap 500 800

# Type text
bun run start type-text "Hello World"

# Press key
bun run start key HOME

# Take screenshot
bun run start screenshot ./screen.png

# Launch app
bun run start launch-app com.example.app
```

## Commands

| Command | Description | Usage |
|---------|-------------|-------|
| `check-device` | List/verify devices | `check-device [serial]` |
| `wake` | Wake + dismiss lock | `wake [serial]` |
| `get-screen` | Dump UI XML | `get-screen [serial]` |
| `tap` | Tap coordinates | `tap <x> <y> [serial]` |
| `type-text` | Type text | `type-text <text> [serial]` |
| `swipe` | Swipe gesture | `swipe <x1> <y1> <x2> <y2> [ms] [serial]` |
| `key` | Press keycode | `key <code\|name> [serial]` |
| `screenshot` | Capture screen | `screenshot [output] [serial]` |
| `launch-app` | Launch app | `launch-app <package> [serial]` |
| `install-apk` | Install APK | `install-apk <path> [serial]` |

## Global Options

```
-s, --serial <id>     Target device
--adb-path <path>     ADB binary path (default: adb)
--timeout <ms>        Timeout (default: 15000)
--retries <n>         Max retries (default: 1)
--json                JSON output
--verbose             Verbose logging
```

## JSON Output

Use `--json` for structured output:

```bash
bun run start --json check-device
```

```json
{
  "success": true,
  "exitCode": 0,
  "data": { "devices": [...], "count": 1 },
  "message": "Found 1 device(s)",
  "trace": { ... }
}
```

## Programmatic API

```typescript
import { tap, checkDevice, registry } from "./src/shell/commands/index.ts";
import { createLocalAdbProvider } from "./src/shell/providers/index.ts";
import { createTraceBuilder } from "./src/core/types/trace.ts";
import { DEFAULT_CONFIG } from "./src/core/contracts/config.ts";

const ctx = {
  adb: createLocalAdbProvider(),
  config: DEFAULT_CONFIG,
  trace: createTraceBuilder("tap"),
};

const result = await tap(["500", "800"], ctx);
console.log(result.success); // true
```

## Key Names

For `key` command: `HOME`, `BACK`, `MENU`, `POWER`, `VOLUME_UP`, `VOLUME_DOWN`, `ENTER`, `TAB`, `DEL`, `ESCAPE`, `DPAD_UP`, `DPAD_DOWN`, `DPAD_LEFT`, `DPAD_RIGHT`, etc.

## Architecture

- **Functional Core**: Pure types, Zod schemas, domain logic (`src/core/`)
- **Imperative Shell**: ADB provider, commands, CLI (`src/shell/`)
- **Provider abstraction**: `LocalAdbProvider` (real) + `MockAdbProvider` (tests)

## Development

```bash
bun run dev        # Watch mode
bun run typecheck  # Type check
bun test           # Run tests
bun run build      # Build
```

## License

MIT
