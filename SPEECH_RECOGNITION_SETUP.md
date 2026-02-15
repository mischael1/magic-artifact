# Speech Recognition Setup Guide

The Magic Artifact voice assistant now supports **real speech-to-text recognition** via OpenAI's Whisper API.

## Quick Setup

### 1. Get OpenAI API Key

1. Visit https://platform.openai.com/api-keys
2. Sign up or log in to your OpenAI account
3. Create a new API key
4. Copy your API key

### 2. Configure the App

Edit `config.properties` in the project root:

```properties
openai_api_key=sk-your-api-key-here
```

Replace `sk-your-api-key-here` with your actual API key.

### 3. Run the App

```bash
./gradlew composeApp:run
```

The app will now use Whisper API for real speech recognition.

## Features

- **Real Speech-to-Text**: Uses OpenAI Whisper for accurate voice recognition
- **Spell Recognition**: Automatically detects Russian spell commands:
  - Огонь (Fire) / Fire / Файр
  - Лед (Ice) / Ice / Лёд / Холод
  - Молния (Lightning) / Lightning / Гром / Spark

- **Multiple Languages**: Whisper API supports 99+ languages
- **Fallback Mode**: If no API key configured, uses random selection (simulation mode)

## Pricing

OpenAI Whisper API costs:
- **$0.02 per minute** of audio
- First-time usage: Includes $5 free trial credits

Typical usage:
- 1 minute of speech commands = ~$0.02
- Running 1000 commands = ~$20

## Alternative APIs (Future Implementation)

Other services to consider:
- **Google Cloud Speech-to-Text** - More accurate, similar pricing
- **Yandex SpeechKit** - Better Russian language support, cheaper
- **Local Model** - Self-hosted with no API costs (requires more compute)

## Troubleshooting

### "⚠ Нет API ключа"
- Make sure `config.properties` exists in project root
- Check that `openai_api_key` is filled in
- Restart the app

### "Ошибка API"
- Verify your API key is valid at https://platform.openai.com/account/api-keys
- Check your account has available credits
- Ensure you're not exceeding rate limits

### Audio not being recorded
- Check your microphone is connected and not muted
- On Windows: Check Sound settings > Input devices
- On Linux: Run `alsamixer` to check input levels
- On Mac: Check System Preferences > Security & Privacy > Microphone

## API Key Security

**Never commit your API key to Git!**

Best practices:
1. Keep `config.properties` in `.gitignore` (already configured)
2. Use environment variables in production
3. Rotate keys regularly
4. Monitor usage at https://platform.openai.com/account/usage/overview

## Implementation Details

### How It Works

1. **Audio Capture**: Microphone input detected via Java's `AudioSystem`
2. **Voice Detection**: Calculates RMS energy to detect speech
3. **Audio File**: Saves PCM data as WAV format
4. **API Call**: Sends WAV to OpenAI Whisper API
5. **Spell Matching**: Extracts spell name from transcribed text
6. **Animation**: Triggers visual effects when spell recognized

### File Structure

```
composeApp/src/desktopMain/kotlin/
  ├── VoiceRecognition.kt    - Audio capture & processing
  ├── SpeechRecognitionAPI.kt - Whisper API integration
  └── Config.kt              - Configuration loader
```

## Next Steps

1. Get an OpenAI API key
2. Add it to `config.properties`
3. Run `./gradlew composeApp:run`
4. Click "🎤 Слушать" and speak a spell command
5. Watch the magical effects trigger in real-time
