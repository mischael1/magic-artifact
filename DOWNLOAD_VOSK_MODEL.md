# Download Vosk Speech Recognition Model

## Quick Links
- **Vosk Models Page**: https://alphacephei.com/vosk/models
- **Recommended Model**: Small English US model (~40MB)

## Where to Download
1. Go to: https://alphacephei.com/vosk/models
2. Look for "English" section
3. Download "Model for English (US)" - choose the small version (faster, smaller size)

## How to Place the Model

### 1. Create the assets directory
```bash
mkdir composeApp/src/main/assets/model-en-us
```

### 2. Extract the downloaded model
The model file will be a ZIP archive. Extract it to the directory created above:
```
composeApp/src/main/assets/model-en-us/
├── am/
├── ivector/
├── conf/
├── graph/
├── words.txt
└── final.mdl
```

### 3. Verify the structure
Check that these files exist:
- `composeApp/src/main/assets/model-en-us/conf/mfcc.conf`
- `composeApp/src/main/assets/model-en-us/graph/G.fst`
- `composeApp/src/main/assets/model-en-us/am/final.mdl`

## Available Models
- **Small English US** (~40MB) - Recommended, fast
- **Large English US** (~80MB) - More accurate
- **Russian** - If you want Russian speech recognition
- **Other languages** - Available on the Vosk models page

## Windows Command to Extract
```powershell
# Download
Invoke-WebRequest -Uri "https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip" -OutFile "model.zip"

# Extract
Expand-Archive -Path "model.zip" -DestinationPath "composeApp\src\main\assets\"

# Rename to standard directory name
Rename-Item "composeApp\src\main\assets\vosk-model-small-en-us-0.15" -NewName "model-en-us"
```

## Linux/Mac Command
```bash
# Download
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip

# Extract
unzip vosk-model-small-en-us-0.15.zip

# Place in correct location
mv vosk-model-small-en-us-0.15 composeApp/src/main/assets/model-en-us
```

## Verification
After placing the model, verify the setup:
```bash
# Check if model directory exists
ls -la composeApp/src/main/assets/model-en-us/

# Check key files
ls composeApp/src/main/assets/model-en-us/am/
ls composeApp/src/main/assets/model-en-us/graph/
ls composeApp/src/main/assets/model-en-us/conf/
```

## Troubleshooting
- If model is not found at runtime, check logs: `adb logcat | grep VoiceManager`
- Ensure model files have read permissions
- On first app run, model is extracted from assets to app's files directory automatically

## That's It!
Once the model is in place, run `./gradlew build` and the app will use the offline Vosk model for speech recognition.
