#!/usr/bin/env pwsh
# -*- coding: utf-8 -*-

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Проверяем JAVA_HOME
Write-Host "Проверка Java..." -ForegroundColor Cyan

# Ищем JDK
$jdkPaths = @(
    "C:\Program Files\Java\jdk-11",
    "C:\Program Files\Java\jdk-17", 
    "C:\Program Files\Amazon Corretto\jdk11.0.18_10",
    "C:\Program Files\OpenJDK\jdk-11.0.1"
)

$found = $false
foreach ($path in $jdkPaths) {
    if (Test-Path "$path\bin\java.exe") {
        $env:JAVA_HOME = $path
        Write-Host "✓ Java найдена: $path" -ForegroundColor Green
        $found = $true
        break
    }
}

if (-not $found) {
    Write-Host "✗ Java не найдена!" -ForegroundColor Red
    Write-Host "Установите JDK 11 или выше"
    Exit 1
}

# Переходим в каталог проекта
Set-Location "C:\Users\GIGABYTE\opencode"
Write-Host "Каталог: $(Get-Location)" -ForegroundColor Cyan

# Запускаем build и run
Write-Host "`nЗапуск сборки и приложения..." -ForegroundColor Yellow
Write-Host "Это может занять 1-2 минуты..." -ForegroundColor Gray

& ".\gradlew.bat" "composeApp:run"
