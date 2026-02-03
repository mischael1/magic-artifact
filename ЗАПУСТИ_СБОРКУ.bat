@echo off
REM Быстрый запуск локальной сборки APK

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   ЛОКАЛЬНАЯ СБОРКА APK
echo ========================================
echo.

REM Проверка Docker
echo [1/3] Проверка Docker...
docker ps >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ Docker готов!
    echo.
    echo Запускаю Docker сборку...
    echo.
    cd /d "%~dp0"
    docker-compose -f docker-compose.android.yml build --no-cache
    docker-compose -f docker-compose.android.yml up
    goto end
)

REM Если Docker не готов, используем PowerShell
echo ⚠ Docker не доступен, используем PowerShell...
echo.

echo [2/3] Установка зависимостей...
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File ".\install_buildozer_deps.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Ошибка при установке зависимостей!
    pause
    exit /b 1
)

echo.
echo [3/3] Сборка APK...
powershell -ExecutionPolicy Bypass -File ".\build_apk_local.ps1"

:end
echo.
if exist "bin\magicartifact-0.1-debug.apk" (
    echo ✅ Сборка успешна!
    echo APK находится в: %cd%\bin\magicartifact-0.1-debug.apk
) else (
    echo ❌ Что-то пошло не так!
)

pause
