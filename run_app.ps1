Set-Location "c:\Users\GIGABYTE\opencode"

$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

Write-Host "Running application..." -ForegroundColor Cyan
Write-Host ""

& ".\gradlew.bat" "composeApp:run" 2>&1
