Write-Host "Installing Java 11..." -ForegroundColor Cyan
Write-Host ""

$javaPath = "C:\Program Files\OpenJDK\jdk-11.0.1"

# Check if already installed
if (Test-Path "$javaPath\bin\java.exe") {
    Write-Host "Java already installed at $javaPath" -ForegroundColor Green
    & "$javaPath\bin\java.exe" -version
    exit 0
}

# Download link for Adoptium OpenJDK 11
$url = "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.20.1%2B1/OpenJDK11U-jdk_x64_windows_hotspot_11.0.20.1_1.msi"
$installerPath = "$env:TEMP\OpenJDK11.msi"

Write-Host "Downloading Java 11 MSI..." -ForegroundColor Yellow
Write-Host "URL: $url" -ForegroundColor Gray

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $url -OutFile $installerPath -ErrorAction Stop
    
    Write-Host "Downloaded to: $installerPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "Starting installer..." -ForegroundColor Cyan
    
    # Run MSI installer
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$installerPath`" /qn" -Wait
    
    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Verifying installation..." -ForegroundColor Cyan
    & java -version
} catch {
    Write-Host "Error downloading Java: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Alternative: Download manually from:" -ForegroundColor Yellow
    Write-Host "https://adoptium.net/temurin/releases/" -ForegroundColor Blue
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
