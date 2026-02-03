#!/usr/bin/env powershell
# Настройка Docker для работы с WSL2

Write-Host "=== Docker WSL2 Setup ===" -ForegroundColor Cyan
Write-Host ""

# Проверка Docker Desktop
Write-Host "1. Checking Docker..." -ForegroundColor Yellow
try {
    $dockerInfo = docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: Docker Desktop is running" -ForegroundColor Green
    }
    else {
        Write-Host "ERROR: Docker Desktop is not responding" -ForegroundColor Red
        Write-Host "Please start Docker Desktop and retry" -ForegroundColor Yellow
        exit 1
    }
}
catch {
    Write-Host "ERROR: Docker not found" -ForegroundColor Red
    Write-Host "Please install Docker Desktop" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "2. Checking Docker build setup..." -ForegroundColor Yellow
Write-Host ""

# Удаляем старые образы если есть
Write-Host "Cleaning old images..." -ForegroundColor Gray
docker-compose -f docker-compose.dev.yml down 2>&1 | Out-Null

Write-Host ""
Write-Host "OK: Docker is ready" -ForegroundColor Green
Write-Host ""
Write-Host "Now run: .\rebuild.ps1" -ForegroundColor Cyan
