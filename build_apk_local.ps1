#!/usr/bin/env powershell
# Локальная сборка APK для Windows

param(
    [switch]$Clean = $false,
    [switch]$Release = $false,
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"

Write-Host "=== Локальная сборка APK ===" -ForegroundColor Cyan

# Проверка Python
Write-Host "Проверка Python..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
if (-not $?) {
    Write-Host "❌ Python не установлен!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ $pythonVersion" -ForegroundColor Green

# Проверка Buildozer
Write-Host "Проверка Buildozer..." -ForegroundColor Yellow
try {
    buildozer --version 2>&1 | Out-Null
    Write-Host "✓ Buildozer установлен" -ForegroundColor Green
}
catch {
    Write-Host "Установка Buildozer..." -ForegroundColor Yellow
    pip install buildozer cython
}

# Опциональная очистка
if ($Clean) {
    Write-Host "Очистка старых сборок..." -ForegroundColor Yellow
    buildozer android clean
    Remove-Item -Path "bin" -Recurse -Force -ErrorAction SilentlyContinue
}

# Определение типа сборки
$buildType = if ($Release) { "release" } else { "debug" }
$verboseFlag = if ($Verbose) { "-vv" } else { "" }

# Сборка
Write-Host "Начало сборки $buildType APK..." -ForegroundColor Cyan
Write-Host "Это может занять 20-40 минут на первый раз" -ForegroundColor Yellow

$command = "buildozer android $buildType $verboseFlag"
Write-Host "Выполнение: $command" -ForegroundColor Gray

Invoke-Expression $command

if ($?) {
    Write-Host "`n✓ Сборка успешна!" -ForegroundColor Green
    
    $apkPath = Get-ChildItem -Path "bin" -Filter "*.apk" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($apkPath) {
        Write-Host "`nAPK находится в: $($apkPath.FullName)" -ForegroundColor Green
        Write-Host "`nДля установки на устройство:" -ForegroundColor Cyan
        Write-Host "adb install -r `"$($apkPath.FullName)`"" -ForegroundColor Gray
    }
} else {
    Write-Host "`n❌ Сборка не удалась!" -ForegroundColor Red
    exit 1
}
