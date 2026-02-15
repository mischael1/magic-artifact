@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM Попытаемся найти Java
set JAVA_HOME=
for /d %%A in ("C:\Program Files\Java\jdk*") do (
    set JAVA_HOME=%%A
    goto found_java
)
for /d %%A in ("C:\Program Files\Amazon Corretto\*") do (
    set JAVA_HOME=%%A
    goto found_java
)

:found_java
if "!JAVA_HOME!"=="" (
    echo ERROR: Java не найдена!
    echo Пожалуйста установите JDK 11 или выше
    pause
    exit /b 1
)

echo JAVA_HOME = !JAVA_HOME!

cd /d "c:\Users\GIGABYTE\opencode"
echo.
echo Запускаю приложение Voice Recognition...
echo.

gradlew composeApp:run

pause
