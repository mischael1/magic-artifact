Set-Location "c:\Users\GIGABYTE\opencode"
Write-Host "Installing Vosk..."

# Create directories
New-Item -ItemType Directory -Path "composeApp\libs" -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType Directory -Path "composeApp\src\main\assets\model-en-us" -Force -ErrorAction SilentlyContinue | Out-Null

# Download AAR
Write-Host "Downloading AAR..."
$aarUrl = "https://github.com/alphacephei/vosk-android/releases/download/v0.3.50/vosk-android-0.3.50.aar"
$aarPath = "composeApp\libs\vosk-android-0.3.50.aar"

$ProgressPreference = 'SilentlyContinue'
try {
    Invoke-WebRequest -Uri $aarUrl -OutFile $aarPath -TimeoutSec 30
    $size = (Get-Item $aarPath).Length
    Write-Host "OK: AAR ($size bytes)"
} catch {
    Write-Host "FAIL: Could not download AAR"
}

# Download model
Write-Host "Downloading model (40MB)..."
$modelUrl = "https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip"
$modelZip = "vosk-model.zip"

try {
    Invoke-WebRequest -Uri $modelUrl -OutFile $modelZip -TimeoutSec 60
    Write-Host "OK: Model downloaded"
    
    Write-Host "Extracting model..."
    Expand-Archive -Path $modelZip -DestinationPath "composeApp\src\main\assets" -Force
    
    $srcDir = Get-ChildItem "composeApp\src\main\assets" -Directory | Where-Object { $_.Name -like "vosk-model*" } | Select-Object -First 1
    if ($srcDir) {
        Rename-Item -Path $srcDir.FullName -NewName "model-en-us" -Force
        Write-Host "OK: Model extracted"
    }
    
    Remove-Item $modelZip -Force
} catch {
    Write-Host "FAIL: Could not download/extract model"
}

# Verify
Write-Host "Verifying..."
if (Test-Path "composeApp\libs\vosk-android-0.3.50.aar") {
    Write-Host "  AAR: OK"
}
if (Test-Path "composeApp\src\main\assets\model-en-us\conf\mfcc.conf") {
    Write-Host "  Model: OK"
}

Write-Host "Done!"
