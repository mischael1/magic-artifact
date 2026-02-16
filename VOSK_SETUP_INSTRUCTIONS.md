# Vosk Integration Setup Guide

## Current Status
✓ VoiceManager.kt fully implemented with Vosk integration
✓ AndroidManifest.xml has RECORD_AUDIO permission
✓ MainActivity.kt has permission handling and VoiceManager callbacks
✓ SpellRecognizer.kt has spell matching logic
✓ build.gradle.kts configured for local AAR dependency

## What's Done
1. **VoiceManager.kt** - Complete implementation with:
   - LibVosk initialization
   - Model extraction from assets
   - AudioRecord for microphone capture
   - Real-time partial and final results
   - Proper resource cleanup

2. **build.gradle.kts** - Updated with:
   - flatDir repository pointing to libs/
   - Local AAR dependency: `implementation(files("libs/vosk-android-0.3.50.aar"))`
   - JSON library for result parsing

3. **MainActivity.kt** - Has:
   - RECORD_AUDIO permission handling
   - VoiceManager callbacks for results
   - Integration with SpellRecognizer
   - Proper cleanup on destroy

## What You Need to Do

### Step 1: Download Vosk Android AAR
Download the vosk-android AAR from GitHub releases:
```
URL: https://github.com/alphacephei/vosk-android/releases/download/v0.3.50/vosk-android-0.3.50.aar
Place in: composeApp/libs/vosk-android-0.3.50.aar
```

**PowerShell script** (if downloads don't work manually):
```powershell
# Run this in the opencode directory:
$url = "https://github.com/alphacephei/vosk-android/releases/download/v0.3.50/vosk-android-0.3.50.aar"
$output = "composeApp\libs\vosk-android-0.3.50.aar"
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($url, $output)
```

### Step 2: Download Vosk Model
Download the English model from Alphacephei:
```
URL: https://alphacephei.com/vosk/models
Choose: Model for English (US) - Small model is recommended (~40MB)
```

Extract to: `composeApp/src/main/assets/model-en-us/`

**Model directory structure should be:**
```
composeApp/src/main/assets/model-en-us/
├── am/
├── ivector/
├── conf/
├── graph/
├── words.txt
└── ... other model files
```

### Step 3: Build and Test
```bash
# Build the app
./gradlew build

# Run on emulator or device
./gradlew installDebug
adb shell am start -n com.magicartifact.debug/com.magicartifact.MainActivity
```

## Key Implementation Details

### VoiceManager Flow
1. **Init**: Initialize LibVosk, extract model from assets, load model
2. **startListening()**: Create Recognizer, start AudioRecord in background thread
3. **captureAudio()**: Read audio bytes, feed to recognizer, parse JSON results
4. **Results**: 
   - Final result when voice activity ends (full text)
   - Partial results while speaking (intermediate text)
5. **stopListening()**: Stop AudioRecord, release resources

### Result Parsing
Results come as JSON:
```json
// Final result
{"result":["the", "quick", "brown", "fox"]}

// Partial result  
{"partial":"the quick"}
```

The code handles both formats and extracts the text for spell matching.

### Spell Recognition
The SpellRecognizer class uses Jaccard similarity to match recognized speech against 5 spells:
- fireball
- ice bolt
- shield
- healing
- lightning

## Troubleshooting

### "Model directory not found"
- Ensure `composeApp/src/main/assets/model-en-us/` exists with model files
- The app will extract from assets on first run
- Check logs: `adb logcat | grep VoiceManager`

### "Failed to create recognizer"
- Model may be corrupted
- Re-download model from https://alphacephei.com/vosk/models
- Ensure Recognizer is created with correct sample rate (16000 Hz)

### AudioRecord errors
- Permission must be granted before calling startListening()
- Check that RECORD_AUDIO permission is requested in MainActivity
- On Android 6.0+, runtime permissions are required

### Audio not being captured
- Emulator may need audio input configured
- Physical device recommended for testing
- Check that microphone is not muted

## Files Modified
- `composeApp/build.gradle.kts` - Added local AAR dependency
- `composeApp/src/main/kotlin/com/magicartifact/VoiceManager.kt` - Complete implementation
- `composeApp/src/main/kotlin/com/magicartifact/MainActivity.kt` - Already has permissions and callbacks
- `composeApp/src/main/AndroidManifest.xml` - Already has RECORD_AUDIO permission

## Next Steps
1. Download vosk-android-0.3.50.aar to composeApp/libs/
2. Download and extract Vosk English model to composeApp/src/main/assets/model-en-us/
3. Run `./gradlew build`
4. Test on device or emulator
