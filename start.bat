@echo off
setlocal
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot
cd /d "%~dp0"

echo.
echo Starting Magic Artifact...
echo Recognized text will be saved to: recognized_text.txt
echo.

call gradlew.bat composeApp:run
pause
