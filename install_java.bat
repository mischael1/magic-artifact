@echo off
echo Downloading Java 11...
echo.

REM Используем Adoptium OpenJDK 11 (бесплатный, открытый)
REM Это автоматический скачиватель

powershell -NoProfile -Command ^
  "& {" ^
  "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
  "$url = 'https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.20.1+1/OpenJDK11U-jdk_x64_windows_hotspot_11.0.20.1_1.msi';" ^
  "$file = 'C:\Users\GIGABYTE\Downloads\OpenJDK11.msi';" ^
  "Write-Host 'Downloading from: ' $url;" ^
  "Invoke-WebRequest -Uri $url -OutFile $file;" ^
  "Write-Host 'Downloaded to: ' $file;" ^
  "Write-Host 'Please run: msiexec /i ' $file;" ^
  "}"

pause
