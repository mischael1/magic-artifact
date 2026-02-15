@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM ===================================================================
REM Magic Artifact - Kotlin Multiplatform Build & Run
REM ===================================================================

title Magic Artifact - Building...

REM Set Java Home
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot

REM Verify Java
if not exist "%JAVA_HOME%\bin\java.exe" (
    color 4F
    echo.
    echo ERROR: Java not found at %JAVA_HOME%
    echo.
    echo Download from: https://adoptium.net/
    echo.
    pause
    exit /b 1
)

echo.
echo ======================================
echo  Magic Artifact - Kotlin Setup
echo ======================================
echo.
echo Java: %JAVA_HOME%
java -version 2>&1 | findstr /R "version"
echo.

cd /d "%~dp0"

REM Clean previous build
echo [1/3] Cleaning...
if exist composeApp\build rmdir /s /q composeApp\build > nul 2>&1

REM Download dependencies and build
echo [2/3] Building project (first time - this will download ~500MB)...
call gradle :composeApp:build -x test --info 2>&1 | findstr /E "BUILD|error|ERROR"

if %ERRORLEVEL% neq 0 (
    color 4F
    echo.
    echo BUILD FAILED!
    echo.
    pause
    exit /b 1
)

REM Success
color 2F
echo.
echo ======================================
echo  SUCCESS! Build complete!
echo ======================================
echo.
echo Starting application with Hot Reload...
echo Edit files in: composeApp/src/commonMain/kotlin/
echo Changes apply instantly when you save!
echo.
echo Press Ctrl+C to stop.
echo.
color 0F

REM Run with hot reload
call gradle :composeApp:desktopRun --continuous

pause
