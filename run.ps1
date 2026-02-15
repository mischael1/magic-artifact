Set-Location "c:\Users\GIGABYTE\opencode"

# Set correct JAVA_HOME
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

Write-Host "JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Cyan
java -version
Write-Host ""

# Check if Vosk model exists
$modelPath = "$env:USERPROFILE\.vosk\model-en-us"
if (-not (Test-Path $modelPath)) {
    Write-Host "Vosk model not found!" -ForegroundColor Yellow
    Write-Host "Downloading model..." -ForegroundColor Cyan
    & ".\download_vosk_model.ps1"
}

Write-Host ""
Write-Host "Building and running application..." -ForegroundColor Cyan
Write-Host "This may take 1-2 minutes on first run..." -ForegroundColor Gray
Write-Host ""

& ".\gradlew.bat" "composeApp:run"
