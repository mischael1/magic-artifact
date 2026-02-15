@echo off
setlocal enabledelayedexpansion

set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot

cd /d "C:\Users\GIGABYTE\opencode"

echo.
echo Starting Magic Artifact with Compose Hot Reload...
echo.
echo Edit files in composeApp/src/commonMain/kotlin/ and save to see changes!
echo.

call gradlew.bat desktopRun --continuous

pause
