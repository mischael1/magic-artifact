# Setup Verification Checklist

Use this checklist to verify your Magic Artifact installation is working correctly.

## Prerequisites Check

- [ ] Java 11 or higher installed
  ```bash
  java -version
  # Should show: openjdk version "11.0.x" or higher
  ```

- [ ] Gradle wrapper exists
  ```bash
  ls gradlew.bat  # Windows
  ls gradlew      # Linux/Mac
  ```

- [ ] Project structure is intact
  ```bash
  ls composeApp/src/desktopMain/kotlin/
  # Should contain: VoiceRecognition.kt, SpeechRecognitionAPI.kt, etc.
  ```

## File Verification

### Required New Files
- [ ] `config.properties` exists
- [ ] `composeApp/src/desktopMain/kotlin/VoiceRecognition.kt` exists
- [ ] `composeApp/src/desktopMain/kotlin/SpeechRecognitionAPI.kt` exists
- [ ] `composeApp/src/desktopMain/kotlin/SoundEffects.kt` exists
- [ ] `composeApp/src/desktopMain/kotlin/Config.kt` exists

### Documentation Files
- [ ] `QUICK_START.md` exists
- [ ] `SPEECH_RECOGNITION_SETUP.md` exists
- [ ] `FEATURES_IMPLEMENTED.md` exists
- [ ] `ARCHITECTURE.md` exists
- [ ] `IMPLEMENTATION_SUMMARY.md` exists
- [ ] `PROJECT_DOCUMENTATION_INDEX.md` exists
- [ ] This file exists

### Modified Files
- [ ] `composeApp/build.gradle.kts` has Ktor dependencies
- [ ] `composeApp/src/commonMain/kotlin/MagicArtifactApp.kt` has SoundEffects

## Configuration Check

- [ ] `config.properties` exists in project root
- [ ] Can edit with text editor (not binary)
- [ ] Contains these lines:
  ```
  # Speech Recognition Configuration
  openai_api_key=
  ```

## API Key Verification

### Option A: With API Key
1. [ ] Go to https://platform.openai.com/api-keys
2. [ ] Copy your API key
3. [ ] Edit `config.properties`:
   ```
   openai_api_key=sk-xxxxxxxxxxxxxx
   ```
4. [ ] Save file

### Option B: Without API Key (Testing Only)
- [ ] Leave `config.properties` empty
- [ ] App will run in simulation mode (random spell selection)

## Dependency Verification

Check that build.gradle.kts has these dependencies:

```
✓ io.ktor:ktor-client-core:2.3.0
✓ io.ktor:ktor-client-okhttp:2.3.0
✓ io.ktor:ktor-client-logging:2.3.0
✓ io.ktor:ktor-serialization-kotlinx-json:2.3.0
```

## Build Verification

### Step 1: Clean build
```bash
./gradlew.bat clean  # Windows
./gradlew clean      # Linux/Mac
```
- [ ] Command completed without errors

### Step 2: Build project
```bash
./gradlew.bat composeApp:build -x test  # Windows
./gradlew composeApp:build -x test      # Linux/Mac
```
- [ ] Build successful (BUILD SUCCESSFUL message)
- [ ] No error messages
- [ ] Took less than 5 minutes

### Step 3: Check build output
```bash
ls composeApp/build/
# Should contain 'classes', 'resources', etc.
```
- [ ] Build artifacts exist

## System Check

### Audio System
- [ ] Microphone is connected
- [ ] Microphone is enabled (not muted)
- [ ] Test microphone works in system settings

**Windows:**
- [ ] Settings → Sound → Volume
- [ ] Select input microphone
- [ ] Test microphone

**Linux:**
- [ ] Run: `alsamixer`
- [ ] Check microphone input level (not 0)

**Mac:**
- [ ] System Preferences → Security & Privacy → Microphone
- [ ] App is listed as allowed

### Network Check (if using API key)
- [ ] Can connect to internet
- [ ] Can reach https://platform.openai.com
- [ ] Firewall allows outbound HTTPS (port 443)

## Runtime Verification

### Start the App
```bash
./gradlew.bat composeApp:run  # Windows
./gradlew composeApp:run      # Linux/Mac
```

Check these items while app is running:

- [ ] **App Window Opens**
  - Purple background visible
  - Title "МАГИЧЕСКИЙ АРТЕФАКТ" displayed
  - Three concentric circles visible

- [ ] **UI Elements Visible**
  - "🎤 Слушать" button present
  - "Огонь" (Fire) button present
  - "Лед" (Ice) button present
  - "Молния" (Lightning) button present
  - Status text area visible

- [ ] **Initialization Message**
  - Status shows: "Инициализация..." initially
  - Then: "Нажми 'Слушать' или скажи заклинание..."
  - OR: "⚠ Нет API ключа..." (if no API key configured)

- [ ] **Animation Works**
  - Particles visible around center circle
  - Particles rotate smoothly
  - No lag or stuttering

## Functionality Test (Without API Key)

These tests work in simulation mode:

### Test 1: Manual Spell Trigger
1. [ ] Click "Огонь" button
2. [ ] Center circle turns red
3. [ ] Status shows "Заклинание! Огонь"
4. [ ] Hear sound effect (if speakers enabled)

### Test 2: Ice Spell
1. [ ] Click "Лед" button
2. [ ] Center circle turns red
3. [ ] Hear different sound effect
4. [ ] Status shows "Заклинание! Лед"

### Test 3: Lightning Spell
1. [ ] Click "Молния" button
2. [ ] Center circle turns red
3. [ ] Hear yet another sound effect
4. [ ] Status shows "Заклинание! Молния"

### Test 4: Particles Increase
1. [ ] Press any spell button
2. [ ] Watch particle count increase during active state
3. [ ] Particles return to idle count after effect

### Test 5: Sound Effects Different
1. [ ] Click "Огонь" - low frequency tone
2. [ ] Click "Лед" - high frequency tone
3. [ ] Click "Молния" - medium frequency tone
4. [ ] Each should sound noticeably different

## Functionality Test (With API Key)

### Test 1: Listening Activated
1. [ ] Click "🎤 Слушать" button
2. [ ] Button changes to "🎤 Слушаю..."
3. [ ] Button turns green
4. [ ] Status shows "🎤 Говори: Огонь, Лед, Молния"

### Test 2: Audio Detection
1. [ ] Make sound near microphone
2. [ ] Status shows "🎤 Слушаю... (Xs)" with increasing time
3. [ ] Proves microphone is detecting audio

### Test 3: Speech Recognition
1. [ ] While listening, clearly say: "Огонь"
2. [ ] Wait 1-2 seconds for API response
3. [ ] Status should show:
   - "✓ Обработка..." (processing)
   - "Распознано: Огонь" (recognized)
4. [ ] Red animation triggered
5. [ ] Sound effect plays

### Test 4: Multiple Languages
1. [ ] Say "Fire" (English)
2. [ ] Should be recognized as "Огонь"
3. [ ] Say "Ice" (English)
4. [ ] Should be recognized as "Лед"

### Test 5: Error Handling
1. [ ] Say something not a spell (e.g., "Hello")
2. [ ] Status shows "Не распознано: 'hello'"
3. [ ] No animation triggered
4. [ ] Ready to listen again

### Test 6: Stop Listening
1. [ ] While listening, click "🎤 Слушаю..." button
2. [ ] Button changes back to "🎤 Слушать" (gray)
3. [ ] Microphone stops recording
4. [ ] Status shows "Нажми 'Слушать' для начала"

## Advanced Verification

### Memory Usage
```bash
# While app is running, check memory
# Windows: Task Manager → Memory
# Linux: top → RES column
# Mac: Activity Monitor → Real Memory
```
- [ ] Using less than 500MB RAM

### CPU Usage
- [ ] CPU spikes only during speech processing
- [ ] Smooth 60 FPS animation (no stuttering)
- [ ] No maxed out cores

### Network (with API key)
```bash
# Monitor network activity while speaking
# Windows: Task Manager → Performance → Open Resource Monitor
# Linux: nethogs or iftop
# Mac: Activity Monitor → Network
```
- [ ] Upload spike during speech (WAV file)
- [ ] Download spike (API response)

### Debug Output
- [ ] No error messages in console
- [ ] No warnings (unless expected)
- [ ] Clean shutdown on window close

## Troubleshooting Guide

| Issue | Check | Solution |
|-------|-------|----------|
| App won't start | Java version | `java -version` must be 11+ |
| Build fails | Dependencies | Run `./gradlew clean` |
| No sound | Audio output | Check system speakers |
| Microphone not detected | Audio input | Check system settings |
| API errors | Configuration | Verify API key in config.properties |
| Slow recognition | Network | Check internet connection |
| "Ошибка API" | API key | Verify key at https://platform.openai.com/account/api-keys |

## Performance Baseline

Document these values to track performance:

| Metric | Baseline | Actual | Status |
|--------|----------|--------|--------|
| App startup | < 3s | ___ | ✓/✗ |
| First animation | Immediate | ___ | ✓/✗ |
| Button response | < 100ms | ___ | ✓/✗ |
| Recognition latency | 1-2s | ___ | ✓/✗ |
| Memory usage | < 200MB | ___ | ✓/✗ |
| CPU usage (idle) | < 5% | ___ | ✓/✗ |
| Animation FPS | 60 | ___ | ✓/✗ |

## Sign-Off

- [ ] All required files present
- [ ] Configuration complete
- [ ] Build successful
- [ ] App runs without errors
- [ ] UI displays correctly
- [ ] Animations work smoothly
- [ ] At least one spell works (manual or voice)
- [ ] Ready for use

**Installation Status: ✅ VERIFIED** (when all items checked)

**Date Verified:** _______________
**Verified By:** _______________
**System:** _______________ (Windows/Linux/Mac)
**Java Version:** _______________
**API Key Configured:** Yes / No

---

## Next Steps

1. **If all checks passed:**
   - Read QUICK_START.md
   - Start using the app
   - Try voice commands if API key configured

2. **If some checks failed:**
   - Review relevant troubleshooting section
   - Check SPEECH_RECOGNITION_SETUP.md
   - Post issue details if needed

3. **If you want to learn more:**
   - Read FEATURES_IMPLEMENTED.md
   - Study ARCHITECTURE.md
   - Review source code with comments

---

## Support Resources

- **Quick Issues**: QUICK_START.md Troubleshooting
- **Setup Issues**: SPEECH_RECOGNITION_SETUP.md Troubleshooting
- **Code Issues**: ARCHITECTURE.md
- **General Help**: PROJECT_DOCUMENTATION_INDEX.md

**Good luck with the Magic Artifact! ✨🎆⚡**
