# Example: Handling Dialogs and Popups

## User Request

**User:** "Install this APK on my phone" (points to /path/to/app.apk)

## Agent Workflow

### Step 1: Check Device

```bash
android-use check-device
```

### Step 2: Install APK

```bash
android-use install-apk /path/to/app.apk
```

**Output:**
```
Performing Streamed Install
Success
```

Or it might show a permission dialog on the device that blocks installation.

### Step 3: Check for Permission Dialog

If installation seems stuck or asks for permissions:

```bash
android-use get-screen
```

**Possible Output (permission dialog):**
```json
{
  "elements": [
    {
      "text": "Allow this source?",
      "resourceId": "android:id/alertTitle",
      "center": [540, 600]
    },
    {
      "text": "Your phone is not allowed to install unknown apps from this source.",
      "center": [540, 750]
    },
    {
      "text": "SETTINGS",
      "resourceId": "android:id/button1",
      "clickable": true,
      "center": [300, 1000]
    },
    {
      "text": "CANCEL",
      "resourceId": "android:id/button2",
      "clickable": true,
      "center": [780, 1000]
    }
  ]
}
```

### Step 4: Handle the Dialog

User needs to enable "Install unknown apps" permission. Tap SETTINGS:

```bash
android-use tap 300 1000
```

### Step 5: Enable Permission

Get screen state:

```bash
android-use get-screen
```

**Output:**
```json
{
  "elements": [
    {"text": "Install unknown apps", "center": [540, 400]},
    {"text": "File manager", "center": [540, 600]},
    {"resourceId": "android:id/switchWidget", "center": [980, 600]}
  ]
}
```

Tap the switch to enable:

```bash
android-use tap 980 600
```

### Step 6: Go Back

```bash
android-use key BACK
```

### Step 7: Retry Installation

```bash
android-use install-apk /path/to/app.apk
```

### Step 8: Handle Installation Confirmation

After successful installation, a dialog might appear:

```bash
android-use get-screen
```

**Possible Output:**
```json
{
  "elements": [
    {
      "text": "App installed",
      "center": [540, 600]
    },
    {
      "text": "DONE",
      "resourceId": "android:id/button1",
      "center": [300, 1000]
    },
    {
      "text": "OPEN",
      "resourceId": "android:id/button2",
      "center": [780, 1000]
    }
  ]
}
```

### Step 9: Complete Installation

Tap DONE to close:

```bash
android-use tap 300 1000
```

Or tap OPEN to launch the app immediately:

```bash
android-use tap 780 1000
```

## Complete Agent Response

"I've installed the APK on your phone. I had to enable 'Install unknown apps' permission in Settings first. The app is now installed and ready to use."

## Key Points

- APK installation often requires "Install unknown apps" permission
- Watch for permission dialogs that block the installation flow
- Use `key BACK` to navigate back from settings screens
- Common dialog button text: "OK", "Allow", "Accept", "Cancel", "Dismiss"
- Always verify the final state after handling dialogs
- Some devices may show different permission flows
- Use `key HOME` to dismiss stuck dialogs and start over
