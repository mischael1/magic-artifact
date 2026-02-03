#!/usr/bin/env powershell
# Быстрая сборка APK - без всяких проверок

$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:ANDROID_HOME = "$env:USERPROFILE\.android-sdk"

Write-Host "Starting APK build..." -ForegroundColor Cyan
Write-Host ""

cd "C:\Users\GIGABYTE\opencode"
buildozer android debug

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "APK: bin/magicartifact-0.1-debug.apk" -ForegroundColor Green
}
else {
    Write-Host "FAILED!" -ForegroundColor Red
}
