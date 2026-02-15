@echo off
cd /d "c:\Users\GIGABYTE\opencode"
echo Building with Vosk integration...
call gradlew.bat composeApp:build
pause
