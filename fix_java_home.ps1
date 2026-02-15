# Fix JAVA_HOME for Gradle
# Run as Administrator

Write-Host "Setting up JAVA_HOME for Gradle..."
Write-Host ""

# The path to Eclipse Adoptium JDK (without /bin)
$JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

# Verify the path exists
if (-not (Test-Path $JAVA_HOME)) {
    Write-Host "ERROR: Java path does not exist: $JAVA_HOME" -ForegroundColor Red
    exit 1
}

# Check if java.exe exists
$javaExe = "$JAVA_HOME\bin\java.exe"
if (-not (Test-Path $javaExe)) {
    Write-Host "ERROR: java.exe not found at: $javaExe" -ForegroundColor Red
    exit 1
}

Write-Host "Java found at: $javaExe" -ForegroundColor Green
Write-Host ""

# Set JAVA_HOME as System Variable (requires admin)
Write-Host "Setting JAVA_HOME system environment variable..."
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $JAVA_HOME, [System.EnvironmentVariableTarget]::Machine)

Write-Host "JAVA_HOME set to: $JAVA_HOME" -ForegroundColor Green
Write-Host ""
Write-Host "Verifying..."
$checkJavaHome = [System.Environment]::GetEnvironmentVariable("JAVA_HOME", [System.EnvironmentVariableTarget]::Machine)
Write-Host "System JAVA_HOME = $checkJavaHome" -ForegroundColor Green

Write-Host ""
Write-Host "SUCCESS! Please restart your command prompt or IDE for changes to take effect." -ForegroundColor Green
Write-Host ""
Write-Host "Test with: java -version"
