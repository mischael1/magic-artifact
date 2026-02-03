@echo off
REM Скрипт для сборки APK на Windows с использованием WSL2
REM Требует WSL2 с установленными buildozer, Java и Android SDK

setlocal enabledelayedexpansion

echo ============================================================
echo        Magic Artifact APK Builder for Windows
echo ============================================================
echo.

REM Проверяем WSL
wsl --list --quiet >nul 2>&1
if errorlevel 1 (
    echo ERROR: WSL2 не установлен
    echo.
    echo Пожалуйста установите WSL2:
    echo   wsl --install -d Ubuntu-22.04
    pause
    exit /b 1
)

REM Определяем путь проекта
for /d %%i in ("%cd%") do set PROJECT_NAME=%%~nxi
set WSL_PATH=\\wsl$\Ubuntu-22.04\root\magic_artifact

echo Готовимся к сборке...
echo Проект: %PROJECT_NAME%
echo.

REM Копируем проект в WSL
echo Копирование файлов в WSL...
wsl mkdir -p /root/magic_artifact
wsl bash -c "cp -r /mnt/c/Users/GIGABYTE/opencode/* /root/magic_artifact/ 2>/dev/null || true"

REM Запускаем сборку в WSL
echo Запуск сборки в WSL...
echo.

wsl bash -c "cd /root/magic_artifact && buildozer android debug"

if errorlevel 1 (
    echo.
    echo ERROR: Сборка не удалась
    pause
    exit /b 1
)

REM Копируем результат обратно
echo.
echo Копирование результатов...
wsl bash -c "cp -r /root/magic_artifact/bin/* /mnt/c/Users/GIGABYTE/opencode/bin/ 2>/dev/null || true"

echo.
echo ============================================================
echo        Сборка завершена успешно!
echo ============================================================
echo.
echo APK файл находится в папке: bin/
echo.
echo Инструкции по установке:
echo 1. Подключите планшет по USB кабелю
echo 2. Включите режим разработчика на планшете
echo 3. Разрешите отладку по USB
echo 4. Выполните команду:
echo    adb install -r bin\magicartifact-0.1-debug.apk
echo.

pause
