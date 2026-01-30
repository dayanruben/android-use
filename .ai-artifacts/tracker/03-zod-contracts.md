# Zod Contracts

**Status:** Complete  
**Priority:** High

## Objective

Define Zod schemas for input validation and output contracts.

## Subtasks

- [x] `src/core/contracts/inputs.ts` - Input schemas for all 10 commands
- [x] `src/core/contracts/outputs.ts` - Output schemas
- [x] `src/core/contracts/config.ts` - SkillConfigSchema
- [x] `src/core/contracts/index.ts` - Barrel export

## Input Schemas

- [x] CheckDeviceInputSchema
- [x] WakeInputSchema
- [x] GetScreenInputSchema
- [x] TapInputSchema
- [x] TypeTextInputSchema
- [x] SwipeInputSchema + SwipeDirectionInputSchema
- [x] KeyInputSchema
- [x] ScreenshotInputSchema
- [x] LaunchAppInputSchema
- [x] InstallApkInputSchema

## Output Schemas

- [x] DeviceOutputSchema, CheckDeviceOutputSchema
- [x] WakeOutputSchema
- [x] GetScreenOutputSchema
- [x] TapOutputSchema
- [x] TypeTextOutputSchema
- [x] SwipeOutputSchema
- [x] KeyOutputSchema
- [x] ScreenshotOutputSchema
- [x] LaunchAppOutputSchema
- [x] InstallApkOutputSchema
- [x] CommandResultSchema (generic JSON output)

## Config Schema

- [x] SkillConfigSchema: adbPath, timeoutMs, maxRetries, outputFormat, verbose, defaultSerial
- [x] DEFAULT_CONFIG + mergeConfig()

## Notes

Validate at boundary, trust interior.
