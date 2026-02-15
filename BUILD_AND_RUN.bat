@echo off
cd /d C:\Users\GIGABYTE\opencode

REM Set JAVA_HOME correctly
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot
echo JAVA_HOME set to: %JAVA_HOME%

REM Verify Java
java -version

REM Build and run
echo.
echo Building and running Magic Artifact with Vosk...
echo ================================================
gradlew.bat desktopRun

pause
