@echo off
setlocal enabledelayedexpansion

set "ADB=C:\Users\GIGABYTE\AppData\Local\Android\Sdk\platform-tools\adb.exe"
set "APK=C:\Users\GIGABYTE\opencode\bin\magicartifact-0.1-debug.apk"
set "PACKAGE=org.magicartifact.magicartifact"

echo.
echo =====================================================================
echo           Magic Artifact - Install and Run
echo =====================================================================
echo.

REM 1. Check emulator
echo [1/5] Checking emulator...
"%ADB%" devices | findstr "emulator" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Emulator not found!
    pause
    exit /b 1
)
echo OK: Emulator connected
echo.

REM 2. Wait for APK
echo [2/5] Waiting for APK file...
setlocal enabledelayedexpansion
set "count=0"
:wait_apk
if exist "%APK%" (
    echo OK: APK found
    goto apk_found
)
if %count% gtr 120 (
    echo ERROR: APK not found after 10 minutes!
    pause
    exit /b 1
)
set /a count=count+1
if %count% equ 1 (
    cls
    echo.
    echo =====================================================================
    echo           Magic Artifact - Install and Run
    echo =====================================================================
    echo.
    echo [WAITING FOR APK FILE]
    echo.
    echo Please build APK in Google Colab:
    echo 1. Open COLAB_BUILD_FINAL.ipynb
    echo 2. Upload opencode.zip
    echo 3. Run cells 1-4 (this takes 60-120 minutes)
    echo 4. Download magicartifact-0.1-debug.apk from Files
    echo 5. Save to: C:\Users\GIGABYTE\opencode\bin\
    echo.
    echo Waiting... (checking every 5 seconds)
    echo.
)
timeout /t 5 /nobreak >nul
goto wait_apk

:apk_found
echo.

REM 3. Uninstall old version
echo [3/5] Removing old version...
"%ADB%" shell pm uninstall %PACKAGE% >nul 2>&1
timeout /t 2 /nobreak >nul
echo OK: Done
echo.

REM 4. Install APK
echo [4/5] Installing APK...
"%ADB%" install -r "%APK%"
if errorlevel 1 (
    echo ERROR: Installation failed!
    pause
    exit /b 1
)
echo.
echo OK: APK installed!
echo.

REM 5. Run app
echo [5/5] Starting application...
"%ADB%" shell am start -n %PACKAGE%/org.kivy.android.PythonActivity >nul 2>&1
echo OK: Application started!
echo.

echo =====================================================================
echo                      MONITORING LOGS
echo =====================================================================
echo.
echo Press Ctrl+C to stop
echo.

timeout /t 2 /nobreak >nul
"%ADB%" logcat -c
"%ADB%" logcat | findstr "python"

pause
