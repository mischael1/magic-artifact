$ErrorActionPreference = "Stop"

Write-Host "Building Kotlin Multiplatform Project..." -ForegroundColor Cyan

$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"
java -version

Write-Host "Starting build..." -ForegroundColor Yellow
& ".\gradlew.bat" build -x test 2>&1 | Tee-Object -Variable output
$output
