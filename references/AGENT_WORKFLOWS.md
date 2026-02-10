# Agent Workflow Examples

This document shows how agents should use android-use effectively.

## Agent Best Practices

### 1. Always Start with Device Check

```bash
# Check what devices are available
android-use check-device

# Output example:
# Multiple devices connected (2):
#   [PHYSICAL] 1A051FDF6007PA - Pixel 6
#   [EMULATOR] emulator-5554 - sdk_gphone64_arm64
```

When user says "phone" → use physical device
When user says "emulator" → use emulator

### 2. Get Screen State Before Acting

```bash
# Get compact JSON (recommended)
android-use get-screen

# The JSON contains pre-calculated center coordinates:
# {
#   "elements": [
#     {
#       "text": "Settings",
#       "resourceId": "com.android.settings:id/title",
#       "clickable": true,
#       "center": [540, 289]  <- Use these coordinates!
#     }
#   ]
# }
```

### 3. Tap Using Pre-Calculated Centers

```bash
# Good: Use center from get-screen output
android-use tap 540 289

# Bad: Don't calculate manually from bounds
```

### 4. Complete Workflow Example

```bash
# Step 1: Check device
android-use check-device

# Step 2: Wake device if needed
android-use wake

# Step 3: Get screen to understand current state
android-use get-screen

# Step 4: Perform action (tap button found in step 3)
android-use tap 540 289

# Step 5: Verify the action worked
android-use get-screen

# Step 6: Take screenshot for user if needed
android-use screenshot ./result.png
```

### 5. Handle Multi-Device Scenarios

```bash
# User says "on my phone"
# 1. Run check-device to see available devices
# 2. Identify physical device: [PHYSICAL] 1A051FDF6007PA
# 3. Use -s flag for all commands

android-use -s 1A051FDF6007PA get-screen
android-use -s 1A051FDF6007PA tap 540 289
```

### 6. Text Input Workflow

```bash
# 1. Tap the text field to focus it
android-use tap 540 184

# 2. Type the text
android-use type-text "Hello World"

# 3. Press ENTER if needed
android-use key ENTER
```

### 7. Common Dialog Handling

```bash
# Look for common buttons in get-screen output:
# - "OK"
# - "Allow" 
# - "Accept"
# - "Cancel"
# - "Dismiss"

# Tap the button using its center coordinates
android-use tap 540 1200

# Or dismiss with BACK key
android-use key BACK
```

### 8. Error Recovery

```bash
# If an action fails:
# 1. Get fresh screen state
android-use get-screen

# 2. Check if we're on expected screen
# 3. Handle popups/dialogs if present
# 4. Retry the action

# If device is offline:
adb kill-server && adb start-server
android-use check-device
```

## Quick Reference for Agents

| User Says | Agent Action |
|-----------|--------------|
| "tap the X button" | `get-screen` → find X → `tap <center>` |
| "type Y" | `tap <field>` → `type-text Y` |
| "go back" | `key BACK` |
| "open Z app" | `launch-app com.example.z` |
| "take screenshot" | `screenshot ./screen.png` |
| "on my phone" | Use `-s <physical_serial>` |
| "scroll down" | `swipe 540 1500 540 500` |
| "press home" | `key HOME` |

## Important Notes

1. **Always use get-screen first** - Understand the UI before acting
2. **Use pre-calculated center coordinates** from JSON output
3. **Wait between actions** - UI needs 500ms-1s to update
4. **Check your work** - get-screen after each action
5. **Be consistent** - Use same serial for all commands
6. **Handle dialogs** - Check for popups that block actions
