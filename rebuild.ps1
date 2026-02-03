#!/usr/bin/env powershell
<#
.SYNOPSIS
Быстрая пересборка APK в Docker контейнере
Первый запуск: 30-40 минут (скачивание SDK)
Последующие: 5-10 минут (кеш)
#>

param(
    [switch]$Build = $false,
    [switch]$Clean = $false
)

Write-Host "=== Docker APK Build (Fast Iterative) ===" -ForegroundColor Cyan
Write-Host ""

if ($Clean) {
    Write-Host "Cleaning Docker resources..." -ForegroundColor Yellow
    docker-compose -f docker-compose.dev.yml down -v
    Write-Host "OK: Docker cleaned" -ForegroundColor Green
    Write-Host ""
}

# Первый запуск - собираем образ
Write-Host "1. Building Docker image..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml build

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker build failed" -ForegroundColor Red
    exit 1
}

Write-Host "OK: Image built" -ForegroundColor Green
Write-Host ""

# Запускаем контейнер (остается живым)
Write-Host "2. Starting container..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to start container" -ForegroundColor Red
    exit 1
}

Write-Host "OK: Container running" -ForegroundColor Green
Write-Host ""

# Запускаем сборку внутри контейнера
Write-Host "3. Building APK..." -ForegroundColor Cyan
Write-Host "This will take 30-40 min on first run, 5-10 min on subsequent builds" -ForegroundColor Yellow
Write-Host ""

docker-compose -f docker-compose.dev.yml exec -T buildozer bash -c "cd /app && buildozer android debug"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK is ready at: bin/magicartifact-0.1-debug.apk" -ForegroundColor Green
    Write-Host ""
    Write-Host "To rebuild after code changes:" -ForegroundColor Cyan
    Write-Host ".\rebuild.ps1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To clean Docker and start fresh:" -ForegroundColor Cyan
    Write-Host ".\rebuild.ps1 -Clean" -ForegroundColor Gray
}
else {
    Write-Host "BUILD FAILED!" -ForegroundColor Red
    Write-Host ""
    Write-Host "To see logs:" -ForegroundColor Yellow
    Write-Host "docker-compose -f docker-compose.dev.yml logs buildozer" -ForegroundColor Gray
    exit 1
}
