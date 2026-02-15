#!/usr/bin/env python3
import sys

try:
    from vosk import Model, KaldiRecognizer
    import pyaudio
    import json
    
    print("Vosk modules loaded successfully")
    print("Loading model...")
    
    try:
        model = Model(lang='ru')
        print("Russian model loaded")
    except Exception as e:
        print(f"Error loading Russian model: {e}")
        print("Trying default model...")
        model = Model()
        print("Default model loaded")
    
    print("Vosk is ready for speech recognition")
    
except ImportError as e:
    print(f"ERROR: Missing module: {e}")
    print("Install with: pip install vosk pyaudio")
    sys.exit(1)
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)
