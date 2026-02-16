[Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Microsoft\jdk-17.0.8', 'Process')
Set-Location "c:\Users\GIGABYTE\opencode"

Write-Host "Building Vosk integration..."
Write-Host "Java version:" 
java -version

Write-Host "`nStarting Gradle build..."
& ".\gradlew" clean build -x test --info 2>&1 | Select-Object -Last 100
