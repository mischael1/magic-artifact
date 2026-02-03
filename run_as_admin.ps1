#!/usr/bin/env powershell
# Запуск rebuild.ps1 от администратора

if (-NOT ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')) {
    Write-Host "Запрос прав администратора..." -ForegroundColor Yellow
    
    $scriptPath = $MyInvocation.MyCommand.Path
    $workingDir = Split-Path -Parent $scriptPath
    
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$workingDir\rebuild.ps1`"" -Verb RunAs
    exit
}

Write-Host "Running as admin: YES" -ForegroundColor Green
Write-Host ""

# Запускаем rebuild.ps1
& "$PSScriptRoot\rebuild.ps1"
