@echo off
cd /d "c:\Users\GIGABYTE\opencode"

echo Looking for Java...
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo Java not found in PATH
    echo Searching in common locations...
    
    if exist "C:\Program Files\Java\jdk-11\bin\java.exe" (
        set JAVA_HOME=C:\Program Files\Java\jdk-11
        goto found
    )
    if exist "C:\Program Files\Java\jdk-17\bin\java.exe" (
        set JAVA_HOME=C:\Program Files\Java\jdk-17
        goto found
    )
    if exist "C:\Program Files\Amazon Corretto\jdk11.0.18_10\bin\java.exe" (
        set JAVA_HOME=C:\Program Files\Amazon Corretto\jdk11.0.18_10
        goto found
    )
    
    echo ERROR: Java not found!
    pause
    exit /b 1
)

:found
java -version
echo.
echo Running application...
echo.

call gradlew composeApp:run

pause
