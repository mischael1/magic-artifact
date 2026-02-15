@echo off
setlocal enabledelayedexpansion

REM Set JAVA_HOME
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"
set "PATH=!JAVA_HOME!\bin;!PATH!"

REM Verify Java
echo Verifying Java installation...
java -version

REM Build
echo Building Magic Artifact...
call gradlew.bat composeApp:build

echo Build complete!
pause
