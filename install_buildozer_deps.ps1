#!/usr/bin/env powershell
# Установка зависимостей Buildozer на Windows

Write-Host "=== Установка зависимостей Buildozer ===" -ForegroundColor Cyan

# 1. Проверка и установка Buildozer
Write-Host "`n1. Установка Buildozer..." -ForegroundColor Yellow
pip install buildozer cython

# 2. Проверка Java
Write-Host "`n2. Проверка Java..." -ForegroundColor Yellow
java -version 2>&1
if (-not $?) {
    Write-Host "`n⚠️  Java не установлена!" -ForegroundColor Red
    Write-Host "Установите JDK 11+ вручную: https://www.oracle.com/java/technologies/javase-downloads.html" -ForegroundColor Yellow
}
else {
    Write-Host "`n✓ Java найдена" -ForegroundColor Green
}

# 3. Проверка Android SDK (Buildozer установит его автоматически)
Write-Host "`n3. При первой сборке Buildozer установит Android SDK автоматически" -ForegroundColor Cyan

# 4. Проверка переменных окружения
Write-Host "`n4. Проверка переменных окружения..." -ForegroundColor Yellow

$androidHome = [Environment]::GetEnvironmentVariable("ANDROID_HOME", "User")
$javaHome = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")

if (-not $androidHome) {
    Write-Host "⚠️  ANDROID_HOME не установлена" -ForegroundColor Yellow
}
else {
    Write-Host "✓ ANDROID_HOME = $androidHome" -ForegroundColor Green
}

if (-not $javaHome) {
    Write-Host "⚠️  JAVA_HOME не установлена" -ForegroundColor Yellow
}
else {
    Write-Host "✓ JAVA_HOME = $javaHome" -ForegroundColor Green
}

Write-Host "`n=== Готово! ===" -ForegroundColor Green
Write-Host "Для сборки APK выполните:" -ForegroundColor Cyan
Write-Host ".\build_apk_local.ps1" -ForegroundColor Gray
Write-Host "`nДля полной очистки и пересборки:" -ForegroundColor Cyan
Write-Host ".\build_apk_local.ps1 -Clean" -ForegroundColor Gray
