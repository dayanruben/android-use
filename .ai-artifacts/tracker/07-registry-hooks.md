# Registry & Hooks

**Status:** Complete  
**Priority:** Medium

## Objective

Implement command registry and lifecycle hooks.

## Subtasks

- [x] `src/shell/registry.ts` - Command registry
- [x] `registerCommand(name, handler)` function
- [x] `onBeforeCommand` hook
- [x] `onAfterCommand` hook
- [x] CommandContext type

## Implementation

### CommandContext
```typescript
interface CommandContext {
  adb: AdbProvider;
  config: SkillConfig;
  trace: TraceBuilder;
  signal?: AbortSignal;
}
```

### Registry Class
- `register(name, handler)` - add command
- `get(name)` - get handler
- `has(name)` - check existence
- `list()` - all command names
- `execute(name, args, ctx)` - run with hooks

### Hooks
- `onBefore(hook)` - pre-command
- `onAfter(hook)` - post-command
- Async support

### Convenience Functions
- `registerCommand()`
- `onBeforeCommand()`
- `onAfterCommand()`
