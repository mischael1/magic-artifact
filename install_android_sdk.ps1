#!/usr/bin/env powershell
<#
.SYNOPSIS
Установка Android SDK и NDK для локальной сборки Buildozer
#>

$ErrorActionPreference = "Continue"
$ProgressPreference = 'SilentlyContinue'

$ANDROID_HOME = "$env:USERPROFILE\.android-sdk"
$SDK_URL = "https://dl.google.com/android/repository/commandlinetools-win-10406996_latest.zip"

Write-Host "=== Android SDK Installation ===" -ForegroundColor Cyan
Write-Host ""

# Проверка админ прав
if (-NOT ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')) {
    Write-Host "This script requires admin privileges" -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator" -ForegroundColor Yellow
    exit 1
}

Write-Host "Installation directory: $ANDROID_HOME" -ForegroundColor Gray
Write-Host ""

# Проверка Java
Write-Host "1. Checking Java..." -ForegroundColor Yellow
$javaHome = "C:\Program Files\Android\Android Studio\jbr"
if (Test-Path $javaHome) {
    Write-Host "OK: Java found in Android Studio" -ForegroundColor Green
}
else {
    Write-Host "ERROR: Java not found in Android Studio" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Creating SDK directory..." -ForegroundColor Yellow
if (-not (Test-Path $ANDROID_HOME)) {
    New-Item -ItemType Directory -Path $ANDROID_HOME -Force | Out-Null
    Write-Host "OK: Directory created" -ForegroundColor Green
}
else {
    Write-Host "OK: Directory already exists" -ForegroundColor Green
}

Write-Host ""
Write-Host "3. Downloading Android SDK (~500 MB)..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Gray

$sdkZip = "$ANDROID_HOME\cmdline-tools.zip"
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    
    # Показываем прогресс скачивания
    $ProgressPreference = 'Continue'
    Invoke-WebRequest -Uri $SDK_URL -OutFile $sdkZip -UseBasicParsing
    $ProgressPreference = 'SilentlyContinue'
    
    Write-Host "OK: SDK downloaded" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to download SDK" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "4. Extracting SDK..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $sdkZip -DestinationPath $ANDROID_HOME -Force
    Write-Host "OK: SDK extracted" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to extract SDK" -ForegroundColor Red
    exit 1
}

# Реорганизация структуры папок
Write-Host ""
Write-Host "5. Organizing SDK structure..." -ForegroundColor Yellow
$cmdlineToolsPath = "$ANDROID_HOME\cmdline-tools"
$latestPath = "$cmdlineToolsPath\latest"

if (Test-Path "$cmdlineToolsPath\cmdline-tools") {
    if (-not (Test-Path $latestPath)) {
        New-Item -ItemType Directory -Path $latestPath -Force | Out-Null
    }
    Move-Item -Path "$cmdlineToolsPath\cmdline-tools\*" -Destination $latestPath -Force
}

Remove-Item $sdkZip -Force
Write-Host "OK: Structure organized" -ForegroundColor Green

Write-Host ""
Write-Host "6. Installing Android SDK components..." -ForegroundColor Yellow
Write-Host "This will take 10-20 minutes..." -ForegroundColor Gray
Write-Host ""

$sdkManagerPath = "$latestPath\bin\sdkmanager.bat"
$platformToolsPath = "$ANDROID_HOME\platform-tools"

# Platform tools
Write-Host "   - Installing platform-tools..." -ForegroundColor Gray
& $sdkManagerPath --install "platform-tools" 2>&1 | Out-Null

# Android API 31
Write-Host "   - Installing Android API 31..." -ForegroundColor Gray
& $sdkManagerPath --install "platforms;android-31" 2>&1 | Out-Null

# Build tools
Write-Host "   - Installing build-tools..." -ForegroundColor Gray
& $sdkManagerPath --install "build-tools;31.0.0" 2>&1 | Out-Null

# NDK
Write-Host "   - Installing NDK 25.1.8937393 (~3 GB, this takes time)..." -ForegroundColor Gray
& $sdkManagerPath --install "ndk;25.1.8937393" 2>&1 | Out-Null

Write-Host "OK: Components installed" -ForegroundColor Green

Write-Host ""
Write-Host "7. Setting up environment variables..." -ForegroundColor Yellow

# Проверяем текущие переменные
$currentAndroidHome = [Environment]::GetEnvironmentVariable("ANDROID_HOME", "User")
$currentJavaHome = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")

if ($currentAndroidHome -ne $ANDROID_HOME) {
    [Environment]::SetEnvironmentVariable("ANDROID_HOME", $ANDROID_HOME, "User")
    Write-Host "OK: ANDROID_HOME set to $ANDROID_HOME" -ForegroundColor Green
}

if ($currentJavaHome -ne $javaHome) {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, "User")
    Write-Host "OK: JAVA_HOME set to $javaHome" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Now you can build APK locally:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Close and reopen PowerShell (to reload env vars)" -ForegroundColor Gray
Write-Host "2. Run: buildozer android debug" -ForegroundColor Gray
Write-Host ""
Write-Host "First build will take 10-20 minutes" -ForegroundColor Yellow
Write-Host "Subsequent builds will be 5-10 minutes (cached)" -ForegroundColor Yellow
Write-Host ""

Read-Host "Press Enter to continue"
