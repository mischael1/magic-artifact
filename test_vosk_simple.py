#!/usr/bin/env python3
import sys
import json
from vosk import Model, KaldiRecognizer
import pyaudio

print("Loading Vosk model...")
try:
    model = Model(lang='ru')
    print("Model loaded OK")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)

print("Starting mic test...")
p = pyaudio.PyAudio()
stream = p.open(format=pyaudio.paInt16, channels=1, rate=16000, input=True, frames_per_buffer=4096)

rec = KaldiRecognizer(model, 16000)
rec.SetWords([["artfakt"], ["shield"], ["fire"], ["heal"]])

print("Listening... speak now:")
while True:
    data = stream.read(4096)
    if rec.AcceptWaveform(data):
        result = json.loads(rec.Result())
        text = ' '.join(result.get('result', []))
        if text:
            print(f"RECOGNIZED: {text}")
            with open("recognized_text.txt", "a") as f:
                f.write(f"{text}\n")
    else:
        partial = json.loads(rec.PartialResult())
        text = partial.get('partial', '')
        if text:
            print(f"partial: {text}")
