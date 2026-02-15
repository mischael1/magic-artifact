#!/usr/bin/env pwsh

Write-Host "Installing Vosk Speech Recognition Server..." -ForegroundColor Green

# Check if Python is installed
$python = (Get-Command python -ErrorAction SilentlyContinue) -or (Get-Command python3 -ErrorAction SilentlyContinue)
if (-not $python) {
    Write-Host "Python not found. Please install Python 3.8+" -ForegroundColor Red
    exit 1
}

# Install Vosk Python
Write-Host "Installing vosk-api..." -ForegroundColor Cyan
pip install vosk

Write-Host "Installing vosk-server..." -ForegroundColor Cyan
pip install vosk-server

# Download Russian language model
Write-Host "Downloading Russian language model..." -ForegroundColor Cyan

$modelUrl = "https://alphacephei.com/vosk/models/vosk-model-ru-0.42-big.zip"
$modelZip = "vosk-model-ru.zip"
$modelDir = "vosk-model-ru"

if (Test-Path $modelDir) {
    Write-Host "Model already exists" -ForegroundColor Yellow
} else {
    Write-Host "Downloading from $modelUrl..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $modelUrl -OutFile $modelZip -UseBasicParsing
    
    Write-Host "Extracting..." -ForegroundColor Cyan
    Expand-Archive -Path $modelZip -DestinationPath .
    
    Rename-Item -Path "vosk-model-ru-0.42-big" -NewName $modelDir -ErrorAction SilentlyContinue
    
    Remove-Item $modelZip
}

Write-Host "Done! Vosk installed successfully" -ForegroundColor Green
Write-Host "To start Vosk server, run: python -m vosk.server --model $modelDir" -ForegroundColor Yellow
