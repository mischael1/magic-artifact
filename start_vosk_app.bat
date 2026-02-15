@echo off
cd /d C:\Users\GIGABYTE\opencode

REM Set JAVA_HOME
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot

echo.
echo ============================================
echo  MAGIC ARTIFACT - Vosk Speech Recognition
echo ============================================
echo.
echo JAVA_HOME: %JAVA_HOME%
java -version
echo.
echo Starting application...
echo.

REM Run with gradle
gradlew.bat run

pause
