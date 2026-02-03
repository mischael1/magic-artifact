@echo off
setlocal enabledelayedexpansion

REM Установка кодировки для русского текста
chcp 65001 >nul 2>&1

echo.
echo ╔════════════════════════════════════════════════════════════════════╗
echo ║      Magic Artifact - Android Emulator Setup                       ║
echo ╚════════════════════════════════════════════════════════════════════╝
echo.

REM Добавляем adb в PATH
set "ADB_PATH=C:\Users\GIGABYTE\AppData\Local\Android\Sdk\platform-tools"
set "PATH=%PATH%;%ADB_PATH%"

echo [1/3] Проверка подключения эмулятора...
adb devices | findstr "emulator" >nul 2>&1

if errorlevel 1 (
    echo ❌ Эмулятор не найден!
    echo.
    echo Пожалуйста:
    echo 1. Откройте Android Studio
    echo 2. Device Manager ^(Tools ^> Device Manager^)
    echo 3. Запустите эмулятор
    echo 4. Затем запустите этот скрипт заново
    echo.
    pause
    exit /b 1
)

echo ✓ Эмулятор найден
echo.

echo [2/3] Установка APK...
adb install -r "C:\Users\GIGABYTE\opencode\bin\magicartifact-0.1-debug.apk"

if errorlevel 1 (
    echo ❌ Ошибка установки!
    pause
    exit /b 1
)

echo.
echo ✓ APK установлен
echo.

echo [3/3] Запуск приложения...
adb shell am start -n org.magicartifact.magicartifact/org.kivy.android.PythonActivity

echo.
echo ╔════════════════════════════════════════════════════════════════════╗
echo ║                    ✅ ГОТОВО!                                     ║
echo ╚════════════════════════════════════════════════════════════════════╝
echo.
echo Приложение должно запуститься в эмуляторе.
echo.
echo Чтобы посмотреть логи, откройте новое окно PowerShell и выполните:
echo   adb logcat | findstr python
echo.
echo Или используйте скрипт:
echo   .\watch_logs.ps1
echo.
pause
