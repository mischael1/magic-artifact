#!/usr/bin/env pwsh

Write-Host "Building and running Magic Artifact Desktop (window will stay open)..." -ForegroundColor Green

cd "c:\Users\GIGABYTE\opencode"

# Set JAVA_HOME to Temurin Java 11
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

Write-Host "Building project..." -ForegroundColor Cyan
.\gradlew.bat composeApp:build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`nRunning application (press Ctrl+C to stop)..." -ForegroundColor Green
Write-Host "Test instructions:" -ForegroundColor Yellow
Write-Host "1. Click the 🎤 СЛУШАТЬ button"
Write-Host "2. Speak to your microphone"
Write-Host "3. Watch for recognized text to appear in cyan color (🔊 `"text`")"
Write-Host "4. If you hear 'артефакт' key word, the app will ask for a spell"
Write-Host ""

# Run the JAR directly
.\gradlew.bat composeApp:runDistributable
