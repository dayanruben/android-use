# Example: Taking a Screenshot

## User Request

**User:** "Take a screenshot of my phone"

## Agent Workflow

### Step 1: Check Device
First, verify which devices are connected:

```bash
android-use check-device
```

**Output:**
```
Multiple devices connected (2):
  [PHYSICAL] 1A051FDF6007PA - Pixel 6
  [EMULATOR] emulator-5554 - sdk_gphone64_arm64
```

**Decision:** User said "phone" - use the physical device (1A051FDF6007PA).

### Step 2: Take Screenshot
Use the physical device serial for all commands:

```bash
android-use -s 1A051FDF6007PA screenshot ./phone_screen.png
```

**Output:**
```
Screenshot saved to ./phone_screen.png
```

### Step 3: Confirm Success
Show the screenshot to the user and confirm the file location.

## Complete Agent Response

"I've taken a screenshot of your Pixel 6 and saved it as `phone_screen.png` in the current directory."

## Key Points

- Always check devices first to identify the correct one
- Use `-s <serial>` flag for all commands when multiple devices exist
- Physical devices are typically what users mean by "phone"
- Screenshots are saved in the current working directory by default
