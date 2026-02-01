# Example: Scrolling to Find Content

## User Request

**User:** "Find the 'Developer options' in Settings"

## Agent Workflow

### Step 1: Check Device

```bash
android-use check-device
```

### Step 2: Open Settings

```bash
android-use launch-app com.android.settings
```

Wait 1 second for Settings to load.

### Step 3: Get Screen State

```bash
android-use get-screen
```

**Output (excerpt):**
```json
{
  "elements": [
    {"text": "Network & Internet", "center": [540, 400]},
    {"text": "Connected devices", "center": [540, 550]},
    {"text": "Apps", "center": [540, 700]},
    {"text": "Notifications", "center": [540, 850]},
    {"text": "Battery", "center": [540, 1000]}
  ],
  "scrollable": [
    {"resourceId": "com.android.settings:id/main_content", "bounds": [0, 200, 1080, 2200]}
  ]
}
```

**Analysis:** Developer options is not visible. Need to scroll down.

### Step 4: Scroll Down

Swipe from bottom to top (scrolls content down):

```bash
android-use swipe 540 1500 540 500 500
```

Parameters: startX startY endX endY duration_ms
- Start at bottom of screen (y=1500)
- Swipe up to top (y=500)
- Duration: 500ms

### Step 5: Check Again

```bash
android-use get-screen
```

**Output:**
```json
{
  "elements": [
    {"text": "Storage", "center": [540, 400]},
    {"text": "Sound", "center": [540, 550]},
    {"text": "Display", "center": [540, 700]},
    {"text": "Wallpaper & style", "center": [540, 850]},
    {"text": "Accessibility", "center": [540, 1000]},
    {"text": "Security & privacy", "center": [540, 1150]},
    {"text": "Location", "center": [540, 1300]}
  ]
}
```

Still not there. Continue scrolling.

### Step 6: Scroll Again

```bash
android-use swipe 540 1500 540 500 500
```

### Step 7: Check Again

```bash
android-use get-screen
```

**Output:**
```json
{
  "elements": [
    {"text": "Passwords & accounts", "center": [540, 400]},
    {"text": "Google", "center": [540, 550]},
    {"text": "System", "center": [540, 700]},
    {"text": "About phone", "center": [540, 850]},
    {"text": "Developer options", "center": [540, 1000]}
  ]
}
```

**Found!** Developer options at coordinates [540, 1000].

### Step 8: Tap Developer Options

```bash
android-use tap 540 1000
```

### Step 9: Verify

```bash
android-use get-screen
# Should show Developer options menu with USB debugging, etc.
```

## Complete Agent Response

"I scrolled through Settings and found Developer options. I've opened it - you should now see the Developer options menu with settings like USB debugging, Stay awake, etc."

## Key Points

- Use `swipe` to scroll: `swipe startX startY endX endY duration`
- Scroll down: swipe from bottom (high Y) to top (low Y)
- Scroll up: swipe from top (low Y) to bottom (high Y)
- Always re-run `get-screen` after scrolling to check for target
- Typical scroll amounts: 500-1000 pixels
- Add 500ms duration for smooth scrolling
- Some screens may need multiple scroll attempts
