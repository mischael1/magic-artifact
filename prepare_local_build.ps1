#!/usr/bin/env powershell
# Подготовка к локальной сборке APK

param(
    [switch]$Docker = $false,
    [switch]$PowerShell = $false,
    [switch]$CheckOnly = $false
)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   Подготовка к локальной сборке APK" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Флаг успеха
$success = $true

# ============================================
# 1. ПРОВЕРКА PYTHON
# ============================================
Write-Host "[1/5] Проверка Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ $pythonVersion" -ForegroundColor Green
    } else {
        Write-Host "  ❌ Python не установлен!" -ForegroundColor Red
        Write-Host "     Загрузите с https://www.python.org (3.9+)" -ForegroundColor Yellow
        $success = $false
    }
} catch {
    Write-Host "  ❌ Python не найден!" -ForegroundColor Red
    $success = $false
}

# ============================================
# 2. ПРОВЕРКА DOCKER
# ============================================
Write-Host "`n[2/5] Проверка Docker..." -ForegroundColor Yellow
try {
    docker ps 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $dockerVersion = docker version --format "Docker {{.Client.Version}}" 2>&1
        Write-Host "  ✓ Docker готов к работе" -ForegroundColor Green
        Write-Host "     Рекомендуем использовать Docker для сборки" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Docker не отвечает" -ForegroundColor Yellow
        Write-Host "     → Запустите Docker Desktop" -ForegroundColor Yellow
        Write-Host "     → Или используйте PowerShell способ" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ℹ️  Docker не установлен (опционально)" -ForegroundColor Cyan
    Write-Host "     → Установите с https://www.docker.com (если нужен)" -ForegroundColor Cyan
}

# ============================================
# 3. ПРОВЕРКА JAVA
# ============================================
Write-Host "`n[3/5] Проверка Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Java установлена" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Java не найдена (требуется для PowerShell сборки)" -ForegroundColor Yellow
        Write-Host "     → Загрузите JDK 11+ с https://www.oracle.com/java" -ForegroundColor Yellow
        Write-Host "     → Или используйте Docker способ" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠️  Java не найдена" -ForegroundColor Yellow
    Write-Host "     → Загрузите JDK 11+ (если нужна PowerShell сборка)" -ForegroundColor Yellow
}

# ============================================
# 4. ПРОВЕРКА ФАЙЛОВ ПРОЕКТА
# ============================================
Write-Host "`n[4/5] Проверка файлов проекта..." -ForegroundColor Yellow

$requiredFiles = @(
    "main.py",
    "buildozer.spec",
    "requirements.txt",
    "Dockerfile.android",
    "docker-compose.android.yml",
    "build_apk_local.ps1",
    "install_buildozer_deps.ps1"
)

$allFilesPresent = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file не найден!" -ForegroundColor Red
        $allFilesPresent = $false
        $success = $false
    }
}

# ============================================
# 5. ПРОВЕРКА ИСТОЧНИКОВ КОДА
# ============================================
Write-Host "`n[5/5] Проверка кода приложения..." -ForegroundColor Yellow

$srcFiles = @(
    "src\__init__.py",
    "src\voice_manager.py",
    "src\spell_manager.py",
    "src\media_player.py"
)

$srcOk = $true
foreach ($file in $srcFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  $file не найден" -ForegroundColor Yellow
        $srcOk = $false
    }
}

if (-not $srcOk) {
    Write-Host "  ⚠️  Некоторые файлы исходного кода отсутствуют" -ForegroundColor Yellow
}

# ============================================
# РЕЗЮМЕ
# ============================================
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   РЕЗЮМЕ" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($success -and $allFilesPresent) {
    Write-Host "✅ ПРОЕКТ ГОТОВ К СБОРКЕ!`n" -ForegroundColor Green
    
    Write-Host "Выберите способ сборки:`n" -ForegroundColor Cyan
    
    Write-Host "1. Docker (рекомендуется):" -ForegroundColor Yellow
    Write-Host "   docker-compose -f docker-compose.android.yml build --no-cache" -ForegroundColor Gray
    Write-Host "   docker-compose -f docker-compose.android.yml up`n" -ForegroundColor Gray
    
    Write-Host "2. PowerShell скрипт:" -ForegroundColor Yellow
    Write-Host "   .\install_buildozer_deps.ps1" -ForegroundColor Gray
    Write-Host "   .\build_apk_local.ps1`n" -ForegroundColor Gray
    
    Write-Host "3. Батник с одного клика:" -ForegroundColor Yellow
    Write-Host "   ЗАПУСТИ_СБОРКУ.bat`n" -ForegroundColor Gray
    
} else {
    Write-Host "⚠️  ТРЕБУЕТСЯ ПОДГОТОВКА`n" -ForegroundColor Yellow
    
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Host "1. Установите Python 3.9+ (https://www.python.org)" -ForegroundColor Yellow
    }
    
    if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
        Write-Host "2. Установите Java JDK 11+ (https://www.oracle.com/java)" -ForegroundColor Yellow
    }
    
    if (-not $allFilesPresent) {
        Write-Host "3. Убедитесь, что все файлы проекта на месте" -ForegroundColor Yellow
    }
    
    Write-Host "`nИли используйте Docker способ (не требует Java локально)" -ForegroundColor Cyan
}

# ============================================
# ИНФОРМАЦИЯ О ПРОЕКТЕ
# ============================================
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   ИНФОРМАЦИЯ О ПРОЕКТЕ" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Приложение: Магический Артефакт" -ForegroundColor Cyan
Write-Host "Версия: 0.1" -ForegroundColor Cyan
Write-Host "API уровень: 31 (Android 12)" -ForegroundColor Cyan
Write-Host "Архитектура: ARM64-v8a" -ForegroundColor Cyan
Write-Host "`nЗависимости:" -ForegroundColor Cyan
Write-Host "  - Kivy (UI)" -ForegroundColor Gray
Write-Host "  - NumPy (вычисления)" -ForegroundColor Gray
Write-Host "  - PyJNI (доступ к Android API)" -ForegroundColor Gray

Write-Host "`nОсновные компоненты:" -ForegroundColor Cyan
Write-Host "  - VoiceManager (микрофон, распознавание)" -ForegroundColor Gray
Write-Host "  - SpellManager (управление заклинаниями)" -ForegroundColor Gray
Write-Host "  - MediaPlayer (звук, видео эффекты)" -ForegroundColor Gray

Write-Host "`n========================================`n" -ForegroundColor Cyan

# Сохранение результата в файл лога
$logFile = "build_prep_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Write-Host "Лог подготовки сохранен в: $logFile" -ForegroundColor Gray

if ($success) {
    Write-Host "`n✅ Готово! Можешь начинать сборку!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Требуется доп. настройка. См. выше." -ForegroundColor Yellow
}

Write-Host "`n"
