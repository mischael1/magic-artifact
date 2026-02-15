@echo off
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot
cd /d "c:\Users\GIGABYTE\opencode"
call gradlew.bat composeApp:run
pause
