# Remove corrupted files
Remove-Item "$env:USERPROFILE\.vosk\*.zip" -Force -ErrorAction SilentlyContinue

$modelDir = "$env:USERPROFILE\.vosk\model-en-us"

if (-not (Test-Path $modelDir)) {
    Write-Host "Downloading Vosk language model (40 MB)..." -ForegroundColor Cyan
    Write-Host "This may take a few minutes..." -ForegroundColor Gray
    
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.vosk" -Force | Out-Null
    
    $url = "https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip"
    $zipPath = "$env:USERPROFILE\.vosk\model.zip"
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $url -OutFile $zipPath -TimeoutSec 300
        
        Write-Host "Extracting..." -ForegroundColor Yellow
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, "$env:USERPROFILE\.vosk")
        
        # Rename extracted folder
        $extracted = Get-ChildItem -Path "$env:USERPROFILE\.vosk" -Directory | Where-Object { $_.Name -match "vosk-model-en-us" } | Select-Object -First 1
        if ($extracted) {
            Rename-Item $extracted.FullName -NewName "model-en-us" -Force
        }
        
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        Write-Host "Model ready!" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Model already exists: $modelDir" -ForegroundColor Green
}

Write-Host ""
Write-Host "Starting application..." -ForegroundColor Cyan
Set-Location "c:\Users\GIGABYTE\opencode"
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

& ".\gradlew.bat" "composeApp:run"
