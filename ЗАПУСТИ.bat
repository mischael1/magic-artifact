@echo off
chcp 65001 > nul
setlocal
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot
cd /d "%~dp0"

echo.
echo ===============================================
echo        МАГИЧЕСКИЙ АРТЕФАКТ
echo ===============================================
echo.
echo Микрофон слушает...
echo Нажми кнопку 🎤 и скажи: "АРТЕФАКТ"
echo.
echo Распознанные слова пишутся в:
echo   recognized_text.txt
echo.
echo ===============================================
echo.

call gradlew.bat composeApp:run

echo.
echo Приложение закрыто
pause
