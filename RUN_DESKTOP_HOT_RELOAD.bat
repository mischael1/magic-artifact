@echo off
REM Windows batch для запуска Desktop с Compose Hot Reload

echo 🔮 Magic Artifact - Desktop with Hot Reload
echo ============================================
echo.
echo Запуск приложения...
echo Внимание: Изменения UI будут применены в реальном времени!
echo.

cd /d "%~dp0"

gradlew.bat desktopRun --continuous

echo.
echo ✅ Hot Reload отключен. Приложение остановлено.
pause
