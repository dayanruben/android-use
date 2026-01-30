# Formatters

**Status:** Complete  
**Priority:** Medium

## Objective

Implement output formatters for CLI results.

## Subtasks

- [x] `src/shell/formatters/text.ts` - Human-readable output
- [x] `src/shell/formatters/json.ts` - JSON output (--json flag)
- [x] Formatter registry for extensibility

## Implementation

### Text Formatter
- ANSI colors (respects NO_COLOR env)
- Success/error/warning formatting
- Key-value pair display for data objects

### JSON Formatter
- `formatJson()` - pretty-printed
- `formatJsonCompact()` - single line
- `formatDataJson()` - data only

### Registry
- `getFormatter(format)` - get by name
- `registerFormatter(name, fn)` - add custom
- `format(result, format)` - convenience wrapper
