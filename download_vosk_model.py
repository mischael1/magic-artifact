#!/usr/bin/env python3

import os
import urllib.request
import zipfile
from pathlib import Path

# Create cache directory
cache_dir = Path.home() / ".cache" / "vosk"
cache_dir.mkdir(parents=True, exist_ok=True)

# URL of the small Russian model
model_url = "https://alphacephei.com/vosk/models/vosk-model-small-ru-0.22.zip"
model_zip = cache_dir / "vosk-model-small-ru-0.22.zip"
model_dir = cache_dir / "vosk-model-small-ru-0.22"

if model_dir.exists():
    print("Model already exists")
else:
    print("Downloading Vosk Russian model...")
    try:
        urllib.request.urlretrieve(model_url, model_zip)
        print("Downloaded")
        
        print("Extracting...")
        with zipfile.ZipFile(model_zip, 'r') as zip_ref:
            zip_ref.extractall(cache_dir)
        print("Extracted")
        
        os.remove(model_zip)
    except Exception as e:
        print(f"ERROR: {e}")
        exit(1)

print("Vosk model is ready!")
print(f"Path: {model_dir}")
