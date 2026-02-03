@echo off
REM Build APK using Buildozer
setlocal enabledelayedexpansion

REM Set Java from Android Studio
set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo === Building APK ===
echo.

echo 1. Checking Java...
java -version 2>&1 | findstr /R "version" >nul
if errorlevel 1 (
    echo ERROR: Java not found
    exit /b 1
) else (
    echo OK: Java found
)

echo.
echo 2. Checking Buildozer...
buildozer --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Buildozer not found
    exit /b 1
) else (
    echo OK: Buildozer found
)

echo.
echo 3. Starting APK build...
echo This will take 20-40 minutes on first run
echo.

cd /d C:\Users\GIGABYTE\opencode
buildozer android debug

if errorlevel 1 (
    echo.
    echo ERROR: Build failed
    exit /b 1
) else (
    echo.
    echo SUCCESS: Build complete
    echo APK in: bin\magicartifact-0.1-debug.apk
)

pause
