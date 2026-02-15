# Architecture Overview - Magic Artifact

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     User Interface Layer                     │
│  ┌──────────────────────────────────────────────────────┐  │
│  │        MagicArtifactApp.kt (Compose UI)              │  │
│  │  ┌────────────────────────────────────────────────┐  │  │
│  │  │  • Animated spell visualizer (particles)        │  │  │
│  │  │  • Spell button controls                        │  │  │
│  │  │  • Voice listen button                          │  │  │
│  │  │  • Status/feedback text                         │  │  │
│  │  │  • Sound effect triggers                        │  │  │
│  │  └────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
    ┌────▼──┐ ┌─────▼────┐ ┌───▼─────┐
    │ Voice │ │  Sound   │ │ Config  │
    │  Mgr  │ │ Effects  │ │ Loader  │
    └───────┘ └──────────┘ └─────────┘
         │
┌────────▼──────────────────────────────────────────────────┐
│             Voice Recognition Layer                       │
│  ┌────────────────────────────────────────────────────┐  │
│  │    VoiceRecognition.kt (Microphone + Audio)        │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │  • Microphone capture (AudioSystem)           │  │  │
│  │  │  • RMS energy calculation (voice detection)   │  │  │
│  │  │  • PCM to WAV conversion                      │  │  │
│  │  │  • Coroutine-based async processing           │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  └────────────────────────────────────────────────────┘  │
└────────────────────┬──────────────────────────────────────┘
                     │
        ┌────────────▼──────────────┐
        │ SpeechRecognitionAPI.kt   │
        │ (OpenAI Whisper Client)   │
        │ ┌──────────────────────┐  │
        │ │ • Ktor HTTP client   │  │
        │ │ • WAV file upload    │  │
        │ │ • JSON response parse│  │
        │ │ • Error handling     │  │
        │ └──────────────────────┘  │
        └────────────┬───────────────┘
                     │
        ┌────────────▼──────────────────────┐
        │  OpenAI Whisper API                │
        │  (Cloud Speech-to-Text)            │
        │  POST /v1/audio/transcriptions     │
        └────────────┬──────────────────────┘
                     │
        ┌────────────▼──────────────┐
        │ Spell Keyword Matcher     │
        │ ┌──────────────────────┐  │
        │ │ • Russian keywords   │  │
        │ │ • English keywords   │  │
        │ │ • Pattern matching   │  │
        │ │ • Spell selection    │  │
        │ └──────────────────────┘  │
        └────────────┬───────────────┘
                     │
                ┌────▼────┐
                │ Trigger │
                │  Spell  │
                │ & Sound │
                └─────────┘
```

## Data Flow Diagram

```
User speaks
    │
    ▼
Microphone Input
    │
    ├─────────────────────────────────┐
    │                                 │
    ▼ (No API key)                    ▼ (With API key)
  Simulate: Random                  Record to buffer
  selection from [огонь,            │
  лед, молния]                       ▼
    │                            Detect speech/silence
    │                                 │
    │                                 ▼
    │                            Convert to WAV
    │                                 │
    │                                 ▼
    └────────────┬──────────────► Send to Whisper API
                 │                    │
                 ▼                    ▼
            API Response          Receive transcription
                 │                    │
                 ▼                    ▼
            Match Keywords         Extract spell
                 │                    │
                 └────────┬───────────┘
                          │
                          ▼
                   Recognized Spell
                  (огонь/лед/молния)
                          │
                ┌─────────┴──────────┐
                │                    │
                ▼                    ▼
            Animation           Play Sound
            (particles)          (procedural)
                │                    │
                └─────────┬──────────┘
                          │
                          ▼
                    Ready for next
                    command
```

## Component Interaction

```
┌─────────────────────────────────────────────────────┐
│ MagicArtifactApp                                    │
│ ┌────────────────────────────────────────────────┐ │
│ │ State Variables:                               │ │
│ │  • voiceRecognition: VoiceRecognition?         │ │
│ │  • soundEffects: SoundEffects?                 │ │
│ │  • isListening: Boolean                        │ │
│ │  • statusText: String                          │ │
│ │  • isActive: Boolean (animation state)         │ │
│ └────────────────────────────────────────────────┘ │
│                                                   │
│ ┌────────────────────────────────────────────────┐ │
│ │ on Listen Click:                               │ │
│ │  voiceRecognition.startListening()             │ │
│ │        │                                        │ │
│ │        └─► VoiceRecognition.captureAudio()     │ │
│ │                 │                               │ │
│ │                 ├─► Detect speech              │ │
│ │                 ├─► Save to WAV                │ │
│ │                 └─► recognizeCommand()         │ │
│ │                      │                          │ │
│ │                      ├─► SpeechRecognitionAPI  │ │
│ │                      │        .transcribeAudio() │ │
│ │                      │        │                │ │
│ │                      │        └─► Whisper API │ │
│ │                      │            (HTTP POST) │ │
│ │                      │                        │ │
│ │                      └─► matchSpellCommand()  │ │
│ │                           │                    │ │
│ │                      onRecognized callback ─┐ │ │
│ │                                              │ │ │
│ │ on Spell Recognized:                        │ │ │
│ │  ├─ triggerSpell(spellName)                │ │ │
│ │  │   └─ isActive = true (triggers animation)│ │ │
│ │  │                                           │ │ │
│ │  └─ soundEffects.playSound(spell)           │ │ │
│ │      └─ Generate sine wave                  │ │ │
│ │      └─ Play via AudioSystem                │ │ │
│ └────────────────────────────────────────────────┘ │
│                                                   │
│ ┌────────────────────────────────────────────────┐ │
│ │ Animation Loop:                                │ │
│ │  LaunchedEffect { while(true) { animation++ } │ │
│ │                                                │ │
│ │  MagicArtifactWidget(animation, isActive)     │ │
│ │   └─ Draws circles & particles                │ │
│ │   └─ Red center if isActive = true            │ │
│ │   └─ 30 particles if active, 10 if idle       │ │
│ └────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

## File Organization

```
composeApp/
│
├── src/
│   │
│   ├── commonMain/
│   │   └── kotlin/
│   │       ├── MagicArtifactApp.kt    ◄─── Main UI
│   │       ├── App.kt
│   │       └── managers/
│   │           └── SpellManager.kt
│   │
│   ├── desktopMain/
│   │   └── kotlin/
│   │       ├── Main.kt                ◄─── Entry point
│   │       ├── VoiceRecognition.kt    ◄─── Audio capture
│   │       ├── SpeechRecognitionAPI.kt◄─── Whisper client
│   │       ├── SoundEffects.kt        ◄─── Audio generation
│   │       └── Config.kt              ◄─── Configuration
│   │
│   └── desktopTest/
│       └── kotlin/
│
├── build.gradle.kts                   ◄─── Dependencies
└── resources/
    └── (empty)

Root Directory:
├── config.properties                  ◄─── API keys
├── QUICK_START.md
├── SPEECH_RECOGNITION_SETUP.md
├── FEATURES_IMPLEMENTED.md
├── IMPLEMENTATION_SUMMARY.md
└── ARCHITECTURE.md                    ◄─── This file
```

## Dependency Graph

```
MagicArtifactApp.kt
    │
    ├─────────────────┬──────────────┬──────────────┐
    │                 │              │              │
    ▼                 ▼              ▼              ▼
VoiceRecognition  SoundEffects   Config.kt     Compose
    │                 │              │         UI Framework
    │                 │              └─────┐
    │                 │                     │
    ▼                 └────────┬────────────┘
SpeechRecognitionAPI           │
    │                          │
    ├────────┬────────┐        │
    │        │        │        │
    ▼        ▼        ▼        ▼
  Ktor    Serialization   Java Sound
  Client   (JSON)        System
    │                         │
    └──────────┬──────────────┘
               │
               ▼
          OpenAI API
          (Network)
```

## Request/Response Cycle

### 1. Audio Capture Cycle
```
┌─ Microphone
│   └─ TargetDataLine (16kHz, 16-bit, Mono)
│       └─ RMS Calculation (voice detection)
│           └─ Buffer accumulation (PCM bytes)
│               └─ Voice Activity Detected
│                   └─ WAV Encoding
│                       └─ File Ready
```

### 2. API Communication Cycle
```
┌─ Ktor HttpClient
│   └─ POST multipart/form-data
│       └─ URL: https://api.openai.com/v1/audio/transcriptions
│           ├─ Header: Authorization: Bearer <KEY>
│           ├─ Field: model=whisper-1
│           └─ Body: <WAV audio bytes>
│
└─ Response
    └─ HTTP 200 OK
        └─ JSON: {"text": "огонь"}
            └─ Parsing
                └─ String extracted
                    └─ Keyword matching
                        └─ Spell selected
```

### 3. Spell Trigger Cycle
```
┌─ Spell matched (e.g., "огонь")
│   │
│   ├─ onRecognized callback invoked
│   │
│   ├─ UI State Updated
│   │   ├─ isActive = true
│   │   └─ statusText = "Огонь"
│   │
│   ├─ Animation triggered
│   │   └─ Center circle turns red
│   │   └─ Particles increase to 30
│   │   └─ Runs for ~500ms
│   │
│   └─ Sound triggered
│       └─ Frequency = 600Hz (Fire)
│       └─ Duration = 300ms
│       └─ Plays immediately
│
└─ Return to listening state
```

## Memory Model

```
Heap Memory (~50MB typical)
│
├─ Gradle Runtime: ~30MB
│
├─ Audio Buffers
│   └─ Recording buffer: ~128KB
│   └─ WAV temp file: ~1-2MB
│
├─ HTTP Client (Ktor)
│   └─ Connection pool: ~1-2MB
│   └─ Request/Response: varies
│
└─ UI State
    └─ Compose runtime: ~5-10MB
    └─ Textures & Drawings: ~2-5MB
```

## Error Handling Chain

```
Try-Catch Blocks:
│
├─ VoiceRecognition.captureAudio()
│   └─ Catches: LineUnavailableException, IOException
│   └─ Fallback: Show error message
│
├─ SpeechRecognitionAPI.transcribeAudio()
│   └─ Catches: HttpRequestException, JsonException
│   └─ Fallback: Return "Ошибка API"
│
├─ Config loader
│   └─ Catches: FileNotFoundException, IOException
│   └─ Fallback: Use defaults
│
└─ SoundEffects.playSound()
    └─ Catches: LineUnavailableException, IOException
    └─ Fallback: Silent (no audio)
```

## Thread/Coroutine Model

```
Main Thread (UI)
    │
    ├─ Compose Recomposition
    ├─ Button clicks
    └─ Animation updates

IO Dispatcher (Kotlin Coroutine)
    │
    ├─ Audio capture (captureAudio)
    ├─ File I/O (WAV writing)
    ├─ Network calls (Whisper API)
    └─ Configuration loading

Audio Thread (Java)
    │
    └─ TargetDataLine operations
    └─ Clip playback
```

## Configuration Flow

```
AppConfig.init()
    │
    ├─ Try: load from config.properties
    │   └─ File in working directory
    │   └─ Parse with Properties
    │
    ├─ Try: load from classpath
    │   └─ Packaged in JAR
    │   └─ Parse with Properties
    │
    └─ Fallback: empty Properties
        └─ getOpenAIKey() returns ""
        └─ App operates in simulation mode
```

## Scaling Considerations

### Current Limitations
- Single microphone input
- Sequential processing (one speech at a time)
- Single API client instance
- Desktop only (no Android/Web)

### To Scale To Multiple Users
- Use queues for concurrent recognition
- Connection pooling for HTTP
- Batch WAV files if needed
- Move to server-based architecture

### To Scale To Multiple Spells
- Extend matchSpellCommand() map
- Add spell database instead of hardcoded list
- Implement fuzzy matching for typos

### Performance Optimization Points
- Audio buffer pooling (reduce allocations)
- Cache Whisper responses (avoid duplicate API calls)
- Lazy load Ktor client (on first use)
- Compact WAV files (reduce upload size)

## Summary

The architecture follows these principles:
- **Separation of Concerns**: UI, Voice, API layers
- **Reactive Programming**: Compose for UI, Coroutines for async
- **Graceful Degradation**: Works without API key (simulation)
- **Resource Management**: Proper cleanup on exit
- **Error Resilience**: Try-catch at system boundaries
