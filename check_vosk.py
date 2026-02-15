#!/usr/bin/env python3
import sys
import json
from vosk import Model, KaldiRecognizer
import struct
import math

print("Step 1: Loading Vosk model...")
try:
    model = Model(lang='ru')
    print("OK: Model loaded")
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)

print("\nStep 2: Creating recognizer...")
try:
    rec = KaldiRecognizer(model, 16000)
    print("OK: Recognizer created")
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)

print("\nStep 3: Reading test audio file...")
try:
    test_file = sys.argv[1] if len(sys.argv) > 1 else "audio.wav"
    with open(test_file, 'rb') as f:
        print(f"Reading: {test_file}")
        f.seek(44)  # Skip WAV header
        chunks = 0
        while True:
            data = f.read(4096)
            if not data:
                break
            chunks += 1
            if rec.AcceptWaveform(data):
                result = json.loads(rec.Result())
                text = ' '.join(result.get('result', []))
                if text:
                    print(f"PARTIAL: {text}")
        
        print(f"OK: Read {chunks} chunks")
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)

print("\nStep 4: Getting final result...")
try:
    result = json.loads(rec.FinalResult())
    text = ' '.join(result.get('result', []))
    print(f"FINAL: {text}")
    
    if text:
        print(f"\nSUCCESS: Recognized: '{text}'")
        with open("recognized_text.txt", "a") as f:
            f.write(f"{text}\n")
    else:
        print("\nNO TEXT: Recognition returned empty")
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)
