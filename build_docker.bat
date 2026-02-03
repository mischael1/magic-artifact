@echo off
REM Сборка APK через Docker

setlocal

echo.
echo ========================================================
echo         Magic Artifact APK Builder (Docker)
echo ========================================================
echo.

REM Проверяем Docker
echo Проверка Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker не установлен или не работает
    echo.
    echo Пожалуйста установите Docker Desktop для Windows
    echo https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Docker найден!
echo.

REM Переходим в папку проекта
cd /d "%~dp0"

REM Собираем Docker образ
echo Сборка Docker образа (может занять 10-15 минут)...
echo.
docker build -t magic-artifact-builder .

if errorlevel 1 (
    echo ERROR: Не удалось собрать Docker образ
    pause
    exit /b 1
)

echo.
echo Запуск сборки APK (может занять 30-60 минут)...
echo Это может быть довольно долго при первой сборке...
echo.

REM Запускаем сборку APK
docker run -v %cd%:/workspace magic-artifact-builder buildozer android debug

if errorlevel 1 (
    echo ERROR: Сборка APK не удалась
    pause
    exit /b 1
)

echo.
echo ========================================================
echo          Сборка завершена успешно!
echo ========================================================
echo.

REM Ищем APK файл
if exist "bin\magicartifact-0.1-debug.apk" (
    echo.
    echo APK файл создан: bin\magicartifact-0.1-debug.apk
    echo.
    echo Инструкции по установке:
    echo 1. Подключите планшет по USB
    echo 2. На планшете включите режим разработчика
    echo 3. Разрешите отладку по USB
    echo 4. Выполните команду:
    echo    adb install -r bin\magicartifact-0.1-debug.apk
    echo.
    echo Или просто откройте файл APK на планшете и установите.
    echo.
) else (
    echo.
    echo APK файл не найден в папке bin/
    echo Проверьте логи сборки выше
    echo.
)

pause
