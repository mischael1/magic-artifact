Write-Host "Downloading Vosk JAR files for Java..." -ForegroundColor Cyan
Write-Host ""

$libDir = "composeApp\libs"
if (-not (Test-Path $libDir)) {
    New-Item -ItemType Directory -Path $libDir -Force | Out-Null
}

# Vosk Java JAR file
$voskUrl = "https://repo1.maven.org/maven2/org/vosk/vosk/0.3.32/vosk-0.3.32.jar"
$voskJar = "$libDir\vosk.jar"

Write-Host "Downloading Vosk JAR..." -ForegroundColor Yellow
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $voskUrl -OutFile $voskJar -ErrorAction Stop
    Write-Host "Downloaded: $voskJar" -ForegroundColor Green
} catch {
    Write-Host "Failed to download from Maven" -ForegroundColor Red
    Write-Host "Trying alternative source..." -ForegroundColor Yellow
    
    # Alternative: from GitHub releases
    $altUrl = "https://github.com/alphacephei/vosk-api/releases/download/v0.3.32/vosk-windows-x64.zip"
    $zipFile = "$libDir\vosk.zip"
    
    try {
        Write-Host "Downloading from GitHub..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $altUrl -OutFile $zipFile -ErrorAction Stop
        Write-Host "Downloaded: $zipFile" -ForegroundColor Green
        
        Write-Host "Extracting..." -ForegroundColor Yellow
        Expand-Archive -Path $zipFile -DestinationPath $libDir -Force
        
        # Look for JAR files
        $jars = Get-ChildItem -Path $libDir -Filter "*.jar" -Recurse
        Write-Host "Found JAR files:" -ForegroundColor Green
        $jars | ForEach-Object { Write-Host "  - $($_.Name)" }
        
        Remove-Item $zipFile -Force
    } catch {
        Write-Host "ERROR: Failed to download Vosk" -ForegroundColor Red
        Write-Host ""
        Write-Host "Manual download steps:" -ForegroundColor Yellow
        Write-Host "1. Visit: https://github.com/alphacephei/vosk-api/releases"
        Write-Host "2. Download: vosk-windows-x64.zip (or your OS version)"
        Write-Host "3. Extract and find .jar files"
        Write-Host "4. Copy .jar files to: $(Resolve-Path $libDir)"
    }
}

Write-Host ""
Write-Host "Vosk JAR setup complete!" -ForegroundColor Green
Write-Host "Verify files in: $(Resolve-Path $libDir)"
Write-Host ""
Write-Host "Next: Download language model for Vosk"
Write-Host "Run: .\download_vosk_model.ps1"
