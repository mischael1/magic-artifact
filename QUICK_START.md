# Magic Artifact - Quick Start Guide

## What This Is

A Kotlin Multiplatform voice-controlled magical assistant with:
- Real-time speech recognition via OpenAI Whisper
- Interactive UI with animated spell effects
- Sound effects for spell casting
- Desktop application (Linux/Mac/Windows compatible)

## Prerequisites

- Java 11 or higher
- OpenAI API key ($5 free trial available)
- Microphone input device

## 5-Minute Setup

### Step 1: Get API Key (2 minutes)
```
1. Go to https://platform.openai.com/api-keys
2. Sign up or log in
3. Create new API key
4. Copy the key
```

### Step 2: Configure App (1 minute)
Edit `config.properties` in project root:
```properties
openai_api_key=sk-xxxxxxxxxxxxxx
```

### Step 3: Run App (2 minutes)
```bash
# Windows
gradlew.bat composeApp:run

# Linux/Mac
./gradlew composeApp:run
```

The app will:
1. Initialize voice recognition
2. Open a window with purple magical interface
3. Ready to listen for commands

## Using the App

### Voice Commands
Click "🎤 Слушать" (Listen) button and say one of:

**Russian:**
- Огонь (Fire)
- Лед (Ice)  
- Молния (Lightning)

**English:**
- Fire / Огонь
- Ice / Cold
- Lightning / Thunder / Spark

### Manual Testing
Click the spell buttons directly:
- **Огонь** (magenta) - Red flame effect
- **Лед** (cyan) - Cold icy effect
- **Молния** (yellow) - Electric lightning effect

### What You'll See
1. Center circle shows spell is active (red)
2. Particles expand outward
3. Sound effect plays based on spell
4. Status text shows recognized command

## Troubleshooting

### "⚠ Нет API ключа" (No API key)
- Check `config.properties` file exists
- Verify `openai_api_key` has your key
- Restart the app

### Microphone not working
- Windows: Settings → Sound → Input devices (check enabled)
- Linux: `alsamixer` → adjust input levels
- Mac: System Preferences → Security & Privacy → Microphone

### "Не распознано" (Not recognized)
- Speak clearly
- Check your API key is valid
- Try English keywords if Russian fails
- Verify network connection

## What Happens Inside

```
You speak → Microphone captures audio → 
Sent to OpenAI Whisper API → 
Transcribed to text → 
Spell keywords extracted → 
Animation & sound triggered
```

## File Locations

| File | Purpose |
|------|---------|
| `config.properties` | API key configuration |
| `composeApp/src/desktopMain/kotlin/VoiceRecognition.kt` | Audio capture |
| `composeApp/src/commonMain/kotlin/MagicArtifactApp.kt` | Main UI |
| `composeApp/build.gradle.kts` | Build configuration |

## Cost (Budget)

- **Free tier**: $5 free credits
- **Pay-as-you-go**: $0.02 per minute of audio
- **Typical usage**: 1 min commands = $0.02 = ~1000 commands for $20

## Next Steps

1. **Test voice commands** - Click listen and speak
2. **Check API usage** - https://platform.openai.com/account/usage
3. **Customize colors** - Edit MagicArtifactApp.kt colors
4. **Add more spells** - Extend spell list in VoiceRecognition.kt

## Need Help?

See `SPEECH_RECOGNITION_SETUP.md` for detailed setup guide
See `FEATURES_IMPLEMENTED.md` for technical details

## Common Issues

| Issue | Solution |
|-------|----------|
| App won't start | Check Java version: `java -version` |
| Build fails | Run `./gradlew clean` first |
| Microphone silently fails | Check Windows Sound settings for input |
| "Ошибка API" | Verify API key at https://platform.openai.com/account/api-keys |
| Slow recognition | Check network, API response time varies |

## Advanced: No API Key Mode

The app can run without API key (simulated recognition):
- Randomly selects a spell
- Useful for testing UI/animations
- Just leave `config.properties` key empty

## Uninstall

Just delete the folder. No system files modified.
