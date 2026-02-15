@echo off
setlocal
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot
cd /d "%~dp0"
call gradlew.bat composeApp:run
pause
