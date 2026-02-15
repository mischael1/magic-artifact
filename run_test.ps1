#!/usr/bin/env pwsh

Write-Host "Building and running Magic Artifact Desktop..." -ForegroundColor Green

cd "c:\Users\GIGABYTE\opencode"

# Set JAVA_HOME to Temurin Java 11
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

Write-Host "JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Cyan

# Check Java
Write-Host "Checking Java..." -ForegroundColor Cyan
java -version

# Build
Write-Host "`nBuilding project..." -ForegroundColor Cyan
.\gradlew.bat composeApp:build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

# Run
Write-Host "`nRunning application..." -ForegroundColor Cyan
.\gradlew.bat composeApp:run
