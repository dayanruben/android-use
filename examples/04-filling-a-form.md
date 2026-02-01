# Example: Filling a Form

## User Request

**User:** "Log into the Gmail app on my phone"

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

### Step 2: Launch Gmail

```bash
android-use launch-app com.google.android.gm
```

Wait 2-3 seconds for the app to load.

### Step 3: Get Screen State

```bash
android-use get-screen
```

**Possible Output (sign-in screen):**
```json
{
  "elements": [
    {
      "text": "Email or phone",
      "resourceId": "com.google.android.gm:id/identifier_id",
      "clickable": true,
      "center": [540, 800]
    },
    {
      "text": "Next",
      "resourceId": "com.google.android.gm:id/identifier_next",
      "clickable": true,
      "center": [540, 1000]
    }
  ]
}
```

### Step 4: Tap Email Field

```bash
android-use tap 540 800
```

Wait 0.5 seconds for the field to focus.

### Step 5: Type Email

```bash
android-use type-text "user@gmail.com"
```

### Step 6: Tap Next Button

```bash
android-use tap 540 1000
```

Wait 2 seconds for the password screen to load.

### Step 7: Get New Screen State

```bash
android-use get-screen
```

**Possible Output:**
```json
{
  "elements": [
    {
      "text": "Enter your password",
      "resourceId": "com.google.android.gm:id/password",
      "clickable": true,
      "center": [540, 800]
    },
    {
      "text": "Next",
      "resourceId": "com.google.android.gm:id/password_next",
      "clickable": true,
      "center": [540, 1000]
    }
  ]
}
```

### Step 8: Tap Password Field

```bash
android-use tap 540 800
```

### Step 9: Type Password

```bash
android-use type-text "mypassword123"
```

### Step 10: Submit

```bash
android-use tap 540 1000
```

### Step 11: Handle 2FA (if prompted)

If a 2FA screen appears:

```bash
android-use get-screen
# Look for "Try another way" or 2FA options
# Guide user through their preferred 2FA method
```

### Step 12: Verify Login

```bash
android-use get-screen
# Look for inbox elements like "Compose", "Inbox", email subjects
```

## Complete Agent Response

"I've opened Gmail and attempted to log in with the provided credentials. If 2FA is enabled, you'll need to complete that step on your device."

## Key Points

- Form workflow: Tap field → Type → Submit
- Wait between steps for UI transitions (0.5-2 seconds)
- Re-run `get-screen` after each major transition
- Some apps may show CAPTCHA or 2FA - handle gracefully
- Never store or log sensitive credentials
- Use `type-text` for entering text - it handles special characters
