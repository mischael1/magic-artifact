Set-Location "c:\Users\GIGABYTE\opencode"

$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

Write-Host "Building project..." -ForegroundColor Cyan
Write-Host ""

& ".\gradlew.bat" "composeApp:build" 2>&1
