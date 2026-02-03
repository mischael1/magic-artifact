# Session Context - Magic Artifact App Fix

**Date:** Jan 28, 2026  
**Status:** Crash bug fixed in source code. APK rebuild needed.

## Problem Identified
App crashed on startup with error:
```
TypeError: must be real number, not complex
```

**Location:** `main.py` line 131 in `add_magic_particle()` method  
**Root cause:** Invalid math formula `(angle**0.5)` and `(3.14159 - angle)**0.5` produce complex numbers when angle > π

## Solution Implemented

### Changes made to `main.py`:
1. **Line 14:** Added `import math`
2. **Lines 124-128:** Fixed particle positioning:
   - OLD: `x = self.center_x + radius * (angle**0.5)` → complex number issue
   - NEW: `x = self.center_x + radius * math.cos(angle)` 
   - OLD: `y = self.center_y + radius * (3.14159 - angle) ** 0.5` → complex number issue
   - NEW: `y = self.center_y + radius * math.sin(angle)`

Also simplified from circular to rectangular particle distribution to avoid any edge cases.

### Why the app currently crashes:
The APK in `bin/magicartifact-0.1-debug.apk` (built at 02:57 on Jan 28) contains the OLD bytecode with the bug. Even though `main.py` source has been fixed, the compiled APK needs to be rebuilt.

## Current APK Status
- **File:** `C:\Users\GIGABYTE\opencode\bin\magicartifact-0.1-debug.apk`
- **Size:** 48M
- **Timestamp:** Jan 28 02:57 (OUTDATED - contains buggy bytecode)
- **Installed on emulator:** Yes, but will crash

## What Works
✅ App initializes UI successfully  
✅ SpellManager loads 5 spells from `data/spells.json`  
✅ VoiceManager initializes for wake-word detection  
✅ MediaPlayer initializes  
✅ Callbacks set up  
✅ Logs show all components ready  
❌ **Animation loop starts → crashes 2 seconds later on first particle spawn**

## What's Needed: Rebuild APK

### Option 1: Google Colab (Recommended - proven to work)
```
1. Zip entire opencode folder
2. Upload to Colab
3. Run: COLAB_BUILD_FINAL.ipynb (cell 4)
4. Download magicartifact-0.1-debug.apk
5. adb install -r bin/magicartifact-0.1-debug.apk
6. Test on emulator
```

### Option 2: WSL2/Linux with buildozer
```bash
cd opencode
buildozer android debug
```

### Option 3: Docker (if working)
```bash
docker build -t magic-artifact-builder -f Dockerfile .
docker run -v $(pwd):/workspace magic-artifact-builder
```

### Why not Windows buildozer?
- buildozer on Windows requires complex Android SDK/NDK setup
- Command `buildozer android debug` returns "Unknown command/target android"
- Environment is not properly configured
- Colab approach is faster and guaranteed to work

## Testing After Rebuild
```bash
# Install new APK
adb install -r bin/magicartifact-0.1-debug.apk

# Force stop old version
adb shell am force-stop org.magicartifact.magicartifact

# Start app
adb shell am start -n org.magicartifact.magicartifact/org.kivy.android.PythonActivity

# Check logs (should have NO Traceback about complex numbers)
adb logcat python:V
```

Expected on success:
- App starts
- "Слушаю пробуждение..." message shows
- No TypeError/Traceback in logs
- Animations run without crashes

## Files Modified
- `main.py` - Fixed particle animation math (lines 14, 124-128)
- `SESSION_CONTEXT.md` - This file (created for continuity)

## Files NOT Modified (should be fine)
- `buildozer.spec` - Already has proper exclusions
- `src/spell_manager.py` - Works correctly
- `src/voice_manager.py` - Works correctly  
- `src/media_player.py` - Works correctly
- `data/spells.json` - Valid data

## Emulator Status
- **Device:** Pixel_6, API 35
- **ADB connection:** ✅ emulator-5554 connected
- **App installed:** ✅ org.magicartifact.magicartifact v0.1 (old version)

## Next Steps for User
1. Rebuild APK using Colab (fastest option)
2. Wait ~60 minutes for build to complete
3. Download rebuilt APK to `bin/magicartifact-0.1-debug.apk`
4. Run `run_emulator.bat` or manually reinstall and test
5. Verify no crashes in logs
6. App should listen for "артефакт" wake word

## Key Learning
- The original particle math used `(angle**0.5)` for what should have been trigonometric functions
- This caused complex number errors when angle values entered the domain where square root of negative occurred
- Simple fix: use `math.cos()` and `math.sin()` instead
- Math error was in the deployed APK bytecode, so source fix alone isn't enough

---
**Ready to proceed?** Use Google Colab to rebuild APK with the fixed source code.
