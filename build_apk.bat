@echo off
REM Fast APK build script

setlocal enabledelayedexpansion

set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
set "ANDROID_HOME=%USERPROFILE%\.android-sdk"
set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%PATH%"

echo === APK Build ===
echo.
echo Java: %JAVA_HOME%
echo SDK: %ANDROID_HOME%
echo.

cd /d C:\Users\GIGABYTE\opencode

buildozer android debug

if errorlevel 1 (
    echo.
    echo ERROR: Build failed
    exit /b 1
) else (
    echo.
    echo SUCCESS!
    echo APK: bin\magicartifact-0.1-debug.apk
)

pause
