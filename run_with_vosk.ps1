# Build and run Magic Artifact with Vosk
Write-Host "Building Magic Artifact with Vosk integration..."
Write-Host "========================================="

# Set JAVA_HOME to use system Java
$javaPath = (gcm java).Source
$javaDir = Split-Path -Parent (Split-Path -Parent $javaPath)
Write-Host "Using Java from: $javaDir"
$env:JAVA_HOME = $javaDir

# Clean and build
Write-Host "`nBuilding project..."
& ".\gradlew.bat" composeApp:runDesktop

Write-Host "`nDone!"
