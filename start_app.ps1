# Запуск приложения Magic Artifact

$env:JAVA_HOME = 'C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot'
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host "=== ЗАПУСК MAGIC ARTIFACT ===" -ForegroundColor Cyan
Write-Host "Нажми 🎤 и скажи: 'АРТЕФАКТ'" -ForegroundColor Yellow
Write-Host ""

& .\gradlew.bat composeApp:run
