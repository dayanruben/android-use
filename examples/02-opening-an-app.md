# Example: Opening an App

## User Request

**User:** "Open Chrome on my phone and go to example.com"

## Agent Workflow

### Step 1: Check Device

```bash
android-use check-device
```

**Output:**
```
Connected devices (1):
  [PHYSICAL] 1A051FDF6007PA - Pixel 6
```

Only one device - no need for `-s` flag.

### Step 2: Launch Chrome

```bash
android-use launch-app com.android.chrome
```

### Step 3: Wait for App to Load
Wait 1-2 seconds for Chrome to fully load.

### Step 4: Get Screen State
Understand the current UI:

```bash
android-use get-screen
```

**Output (excerpt):**
```json
{
  "elements": [
    {
      "text": "Search or type URL",
      "resourceId": "com.android.chrome:id/url_bar",
      "clickable": true,
      "center": [540, 184]
    }
  ]
}
```

### Step 5: Tap Address Bar
Use the pre-calculated center coordinates:

```bash
android-use tap 540 184
```

### Step 6: Type URL

```bash
android-use type-text "example.com"
```

### Step 7: Press Enter

```bash
android-use key ENTER
```

### Step 8: Verify
Wait a moment and take a screenshot to confirm:

```bash
android-use screenshot ./chrome_result.png
```

## Complete Agent Response

"I've opened Chrome on your phone and navigated to example.com. Here's a screenshot of the result."

## Key Points

- Chrome package name: `com.android.chrome`
- Always get screen state before tapping to find correct coordinates
- Use `center` coordinates from JSON output directly
- Common package names:
  - Chrome: `com.android.chrome`
  - Settings: `com.android.settings`
  - Gmail: `com.google.android.gm`
  - YouTube: `com.google.android.youtube`
