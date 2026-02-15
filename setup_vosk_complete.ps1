#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Green
Write-Host "Complete Vosk Setup for Magic Artifact" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# 1. Check Python
Write-Host "`n1. Checking Python..." -ForegroundColor Cyan
$pythonCmd = $null
if (Get-Command python3 -ErrorAction SilentlyContinue) {
    $pythonCmd = "python3"
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonCmd = "python"
} else {
    Write-Host "ERROR: Python not found. Please install Python 3.8+" -ForegroundColor Red
    exit 1
}

Write-Host "Found Python: $pythonCmd" -ForegroundColor Green

# 2. Install Vosk packages
Write-Host "`n2. Installing Vosk packages..." -ForegroundColor Cyan
& $pythonCmd -m pip install vosk
& $pythonCmd -m pip install vosk-server

# 3. Download model
Write-Host "`n3. Downloading Russian language model (200MB)..." -ForegroundColor Cyan
$modelUrl = "https://alphacephei.com/vosk/models/vosk-model-ru-0.42-big.zip"
$modelZip = "vosk-model-ru.zip"
$modelDir = "vosk-model-ru"

if (Test-Path $modelDir) {
    Write-Host "Model already exists at $modelDir" -ForegroundColor Yellow
} else {
    Write-Host "Downloading..." -ForegroundColor Cyan
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $modelUrl -OutFile $modelZip
    
    Write-Host "Extracting..." -ForegroundColor Cyan
    Expand-Archive -Path $modelZip -DestinationPath .
    
    Rename-Item -Path "vosk-model-ru-0.42-big" -NewName $modelDir -ErrorAction SilentlyContinue
    
    Remove-Item $modelZip -ErrorAction SilentlyContinue
    Write-Host "Model installed at $modelDir" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host "`nTo start Vosk server, run:" -ForegroundColor Yellow
Write-Host "$pythonCmd -m vosk.server --model vosk-model-ru" -ForegroundColor Cyan

Write-Host "`nThen in another window, run:" -ForegroundColor Yellow
Write-Host "./gradlew.bat composeApp:run" -ForegroundColor Cyan
