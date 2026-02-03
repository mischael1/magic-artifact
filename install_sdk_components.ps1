#!/usr/bin/env powershell
# Установка компонентов Android SDK
# Запускается от администратора

$ANDROID_HOME = "$env:USERPROFILE\.android-sdk"
$JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:PATH = "$JAVA_HOME\bin;$env:PATH"

Write-Host "=== Installing Android SDK Components ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "ANDROID_HOME: $ANDROID_HOME" -ForegroundColor Gray
Write-Host ""

# Проверка sdkmanager
$sdkManager = "$ANDROID_HOME\cmdline-tools\latest\bin\sdkmanager.bat"
if (-not (Test-Path $sdkManager)) {
    Write-Host "ERROR: sdkmanager not found at $sdkManager" -ForegroundColor Red
    exit 1
}

Write-Host "1. Installing platform-tools..." -ForegroundColor Yellow
& $sdkManager --install "platform-tools" 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: platform-tools" -ForegroundColor Green
}
else {
    Write-Host "WARNING: platform-tools install may need manual intervention" -ForegroundColor Yellow
}

Write-Host "2. Installing Android API 31..." -ForegroundColor Yellow
& $sdkManager --install "platforms;android-31" 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: Android API 31" -ForegroundColor Green
}

Write-Host "3. Installing build-tools 31.0.0..." -ForegroundColor Yellow
& $sdkManager --install "build-tools;31.0.0" 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: build-tools 31.0.0" -ForegroundColor Green
}

Write-Host "4. Installing NDK 25.1.8937393 (this takes time)..." -ForegroundColor Yellow
Write-Host "   Downloading ~3 GB..." -ForegroundColor Gray
& $sdkManager --install "ndk;25.1.8937393" 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: NDK 25.1.8937393" -ForegroundColor Green
}

Write-Host ""
Write-Host "5. Setting environment variables..." -ForegroundColor Yellow

[Environment]::SetEnvironmentVariable("ANDROID_HOME", $ANDROID_HOME, "User")
[Environment]::SetEnvironmentVariable("JAVA_HOME", $JAVA_HOME, "User")

Write-Host "OK: Environment variables set" -ForegroundColor Green

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "SDK ready at: $ANDROID_HOME" -ForegroundColor Green
Write-Host ""
Write-Host "Next step:" -ForegroundColor Cyan
Write-Host "1. Close and reopen PowerShell" -ForegroundColor Gray
Write-Host "2. Run: .\rebuild.ps1" -ForegroundColor Gray
