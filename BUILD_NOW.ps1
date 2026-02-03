#!/usr/bin/env powershell
<#
.SYNOPSIS
Локальная сборка APK для Magic Artifact - быстрый скрипт
#>

# Установка переменных окружения для Java (из Android Studio)
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:Path = "$env:JAVA_HOME\bin;$env:Path"

Write-Host "=== Локальная сборка APK ===" -ForegroundColor Cyan
Write-Host ""

# Проверка Java
Write-Host "1. Проверка Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    Write-Host "✓ Java найдена:" -ForegroundColor Green
    Write-Host $javaVersion[0] -ForegroundColor Gray
}
catch {
    Write-Host "❌ Java не найдена! Используется Java из Android Studio." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Проверка Buildozer..." -ForegroundColor Yellow
$buildozerVersion = buildozer --version
Write-Host "✓ $buildozerVersion" -ForegroundColor Green

Write-Host ""
Write-Host "3. Начало сборки APK..." -ForegroundColor Cyan
Write-Host "⏱  Это займет ~20-40 минут в первый раз" -ForegroundColor Yellow
Write-Host ""

# Основная сборка
buildozer android debug

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓✓✓ СБОРКА УСПЕШНА! ✓✓✓" -ForegroundColor Green
    Write-Host ""
    
    # Поиск APK
    $apk = Get-ChildItem -Path "bin" -Filter "*.apk" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($apk) {
        Write-Host "APK находится в:" -ForegroundColor Cyan
        Write-Host "$($apk.FullName)" -ForegroundColor Green
        Write-Host ""
        Write-Host "Для установки на устройство выполните:" -ForegroundColor Cyan
        Write-Host "adb install -r `"$($apk.FullName)`"" -ForegroundColor Gray
    }
}
else {
    Write-Host "❌ Сборка не удалась!" -ForegroundColor Red
    exit 1
}
