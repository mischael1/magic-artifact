#!/usr/bin/env powershell
<#
.SYNOPSIS
Быстрая пересборка APK локально с Buildozer
Первый запуск: 10-20 минут (кеш SDK)
Последующие: 5-10 минут (кеш)
#>

param(
    [switch]$Clean = $false
)

Write-Host "=== Local APK Build (Buildozer) ===" -ForegroundColor Cyan
Write-Host ""

# Установка переменных окружения
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:ANDROID_HOME = "$env:USERPROFILE\.android-sdk"
$env:Path = "$env:JAVA_HOME\bin;$env:ANDROID_HOME\cmdline-tools\latest\bin;$env:ANDROID_HOME\platform-tools;$env:Path"

# Проверка Java
Write-Host "1. Checking Java..." -ForegroundColor Yellow
if (Test-Path "$env:JAVA_HOME\bin\java.exe") {
    $javaVersion = & "$env:JAVA_HOME\bin\java.exe" -version 2>&1 | Select-Object -First 1
    Write-Host "OK: $javaVersion" -ForegroundColor Green
}
else {
    Write-Host "ERROR: Java not found at $env:JAVA_HOME" -ForegroundColor Red
    Write-Host "Android Studio should have Java installed" -ForegroundColor Yellow
    exit 1
}

# Проверка Android SDK
Write-Host ""
Write-Host "2. Checking Android SDK..." -ForegroundColor Yellow
if (Test-Path "$env:ANDROID_HOME\platform-tools") {
    Write-Host "OK: Android SDK found at $env:ANDROID_HOME" -ForegroundColor Green
}
else {
    Write-Host "ERROR: Android SDK not found" -ForegroundColor Red
    Write-Host "Run: .\install_android_sdk.ps1" -ForegroundColor Yellow
    exit 1
}

# Проверка Buildozer
Write-Host ""
Write-Host "3. Checking Buildozer..." -ForegroundColor Yellow
$buildozerVersion = buildozer --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: $buildozerVersion" -ForegroundColor Green
}
else {
    Write-Host "ERROR: Buildozer not found" -ForegroundColor Red
    exit 1
}

if ($Clean) {
    Write-Host ""
    Write-Host "4. Cleaning build cache..." -ForegroundColor Yellow
    buildozer android clean 2>&1 | Out-Null
    Remove-Item -Path "bin" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "OK: Cache cleaned" -ForegroundColor Green
}

# Основная сборка
Write-Host ""
Write-Host "4. Building APK..." -ForegroundColor Cyan
Write-Host "First run: 10-20 min, Subsequent: 5-10 min" -ForegroundColor Yellow
Write-Host ""

buildozer android debug

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓✓✓ SUCCESS! ✓✓✓" -ForegroundColor Green
    Write-Host ""
    
    $apk = Get-ChildItem -Path "bin" -Filter "*.apk" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($apk) {
        Write-Host "APK ready at: $($apk.FullName)" -ForegroundColor Green
        Write-Host ""
        Write-Host "To install on device:" -ForegroundColor Cyan
        Write-Host "adb install -r `"$($apk.FullName)`"" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "To rebuild after code changes:" -ForegroundColor Cyan
    Write-Host ".\rebuild.ps1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To clean and rebuild:" -ForegroundColor Cyan
    Write-Host ".\rebuild.ps1 -Clean" -ForegroundColor Gray
}
else {
    Write-Host ""
    Write-Host "❌ BUILD FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "Check: Is buildozer.spec correct?" -ForegroundColor Yellow
    Write-Host "Check: Do you have main.py in project root?" -ForegroundColor Yellow
    exit 1
}
