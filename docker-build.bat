@echo off
REM Скрипт для сборки APK через Docker на Windows

echo ========================================
echo Сборка APK для Магического Артефакта
echo ========================================
echo.

REM Проверка наличия Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo ОШИБКА: Docker не установлен!
    echo.
    echo Скачайте Docker Desktop:
    echo https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

echo ✓ Docker найден
echo.

REM Сборка Docker образа
echo Сборка Docker образа (первый раз долго ~5-10 минут)...
docker build -t magic-artifact-builder .
if errorlevel 1 (
    echo ОШИБКА при создании образа!
    pause
    exit /b 1
)

echo ✓ Docker образ готов
echo.

REM Сборка APK
echo Сборка APK (10-20 минут)...
docker run -v "%cd%":/workspace magic-artifact-builder buildozer android debug

if errorlevel 1 (
    echo ОШИБКА при сборке APK!
    pause
    exit /b 1
)

echo.
echo ========================================
echo ✓ APK успешно собран!
echo ========================================
echo.

REM Поиск APK файла
for /f "delims=" %%F in ('dir /b /o-d bin\*.apk 2^>nul') do (
    set APK_FILE=%%F
    goto found
)

:found
if not "%APK_FILE%"=="" (
    echo Файл: bin\%APK_FILE%
    echo.
    echo Установка на планшет:
    echo   adb install -r bin\%APK_FILE%
    echo.
) else (
    echo Внимание: APK файл не найден!
)

pause
