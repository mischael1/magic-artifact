[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Set-Location "c:\Users\GIGABYTE\opencode"
& ".\gradlew" "composeApp:build" --info 2>&1 | Select-Object -Last 300
