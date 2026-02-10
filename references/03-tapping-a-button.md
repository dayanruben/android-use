# Example: Tapping a Button

## User Request

**User:** "Tap the Settings button on my phone"

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

### Step 2: Get Current Screen
Dump the UI hierarchy to find the Settings button:

```bash
android-use get-screen
```

**Output (excerpt):**
```json
{
  "elements": [
    {
      "text": "",
      "contentDesc": "Settings",
      "resourceId": "com.android.launcher:id/settings_button",
      "clickable": true,
      "center": [980, 1840]
    },
    {
      "text": "Settings",
      "contentDesc": "",
      "resourceId": "",
      "clickable": true,
      "center": [540, 600]
    }
  ],
  "withContentDesc": [
    {
      "text": "",
      "contentDesc": "Settings",
      "center": [980, 1840]
    }
  ],
  "withText": [
    {
      "text": "Settings",
      "center": [540, 600]
    }
  ]
}
```

**Analysis:** Found two Settings elements:
1. Icon with contentDesc "Settings" at [980, 1840] - likely the gear icon
2. Text label "Settings" at [540, 600] - likely a menu item

### Step 3: Tap the Button
Choose the appropriate one based on context. Let's tap the text label:

```bash
android-use tap 540 600
```

### Step 4: Verify

```bash
android-use get-screen
```

Look for Settings-specific elements like "Network & Internet", "Connected devices" to confirm Settings opened.

## Complete Agent Response

"I've tapped the Settings button. The Settings app should now be open."

## Alternative: Using Content Description

If searching by text doesn't work, try contentDesc:

```bash
android-use get-screen --json | jq '.withContentDesc[] | select(.contentDesc == "Settings") | .center'
# Output: [980, 1840]
android-use tap 980 1840
```

## Key Points

- Always use `get-screen` first to locate elements
- Search for both `text` and `contentDesc` fields
- The `withText` and `withContentDesc` arrays make searching easier
- Use pre-calculated `center` coordinates directly
- Verify the action worked by checking the screen again
