@echo off
setlocal
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot
cd /d "%~dp0"
call gradlew.bat composeApp:run > logs.txt 2>&1
echo.
echo Приложение закрыто. Логи в logs.txt
pause
