#!/usr/bin/env pwsh

Write-Host "Starting Magic Artifact with debug output..." -ForegroundColor Green
Write-Host "Speak into your microphone now!" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop after 30 seconds" -ForegroundColor Cyan

cd "c:\Users\GIGABYTE\opencode"
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

# Run for 30 seconds max
$job = Start-Job -ScriptBlock {
    cd "c:\Users\GIGABYTE\opencode"
    $env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"
    .\gradlew.bat composeApp:run 2>&1
}

Start-Sleep -Seconds 35
Stop-Job -Job $job
Receive-Job -Job $job
Remove-Job -Job $job
