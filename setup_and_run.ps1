[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Continue"

Write-Host "Setting up Vosk speech recognition..." -ForegroundColor Cyan
Write-Host ""

# 1. Create libs directory
$libsDir = "composeApp\libs"
if (-not (Test-Path $libsDir)) {
    New-Item -ItemType Directory -Path $libsDir -Force | Out-Null
    Write-Host "Created: $libsDir" -ForegroundColor Green
}

# 2. Download Vosk JAR
Write-Host ""
Write-Host "Step 1: Downloading Vosk JAR file..." -ForegroundColor Yellow
$voskJar = "$libsDir\vosk.jar"

if (Test-Path $voskJar) {
    Write-Host "Vosk JAR already exists: $voskJar" -ForegroundColor Green
} else {
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        # Try direct JAR download from Maven Central
        $urls = @(
            "https://repo1.maven.org/maven2/org/vosk/vosk/0.3.32/vosk-0.3.32.jar",
            "https://central.maven.org/maven2/org/vosk/vosk/0.3.32/vosk-0.3.32.jar",
            "https://oss.sonatype.org/content/repositories/releases/org/vosk/vosk/0.3.32/vosk-0.3.32.jar"
        )
        
        $downloaded = $false
        foreach ($url in $urls) {
            Write-Host "Trying: $url" -ForegroundColor Gray
            try {
                Invoke-WebRequest -Uri $url -OutFile $voskJar -TimeoutSec 30 -ErrorAction Stop
                Write-Host "Downloaded: $voskJar" -ForegroundColor Green
                $downloaded = $true
                break
            } catch {
                Write-Host "Failed with that URL" -ForegroundColor Gray
            }
        }
        
        if (-not $downloaded) {
            Write-Host "Could not download Vosk JAR from Maven" -ForegroundColor Red
            Write-Host "Trying GitHub releases..." -ForegroundColor Yellow
            
            # Try GitHub
            $gitUrl = "https://github.com/alphacephei/vosk-api/releases/download/v0.3.32/vosk-windows-x64.zip"
            $zipPath = "$libsDir\vosk-windows.zip"
            
            Invoke-WebRequest -Uri $gitUrl -OutFile $zipPath -TimeoutSec 60 -ErrorAction Stop
            Write-Host "Downloaded: $zipPath" -ForegroundColor Green
            
            # Extract
            Write-Host "Extracting..." -ForegroundColor Yellow
            Expand-Archive -Path $zipPath -DestinationPath $libsDir -Force
            
            # Find JAR
            $jars = Get-ChildItem -Path $libsDir -Filter "*.jar" -Recurse
            if ($jars) {
                Write-Host "Found JAR files:" -ForegroundColor Green
                $jars | ForEach-Object { Write-Host "  - $($_.FullName)" }
                Copy-Item $jars[0].FullName -Destination $voskJar -Force
                Write-Host "Copied to: $voskJar" -ForegroundColor Green
            }
            
            Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        }
    } catch {
        Write-Host "ERROR: Could not download Vosk JAR: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Manual download required:" -ForegroundColor Yellow
        Write-Host "1. Visit: https://github.com/alphacephei/vosk-api/releases" 
        Write-Host "2. Download vosk-windows-x64.zip"
        Write-Host "3. Extract vosk.jar to: $libsDir"
        Write-Host ""
        Read-Host "Press Enter to continue anyway..."
    }
}

# 3. Download language model
Write-Host ""
Write-Host "Step 2: Setting up language model..." -ForegroundColor Yellow

$modelBaseDir = "$env:USERPROFILE\.vosk"
$modelDir = "$modelBaseDir\model-en-us"

if (Test-Path $modelDir) {
    Write-Host "Model already exists: $modelDir" -ForegroundColor Green
} else {
    try {
        New-Item -ItemType Directory -Path $modelBaseDir -Force | Out-Null
        
        Write-Host "Downloading language model (40 MB)..." -ForegroundColor Yellow
        $modelUrl = "https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip"
        $modelZip = "$modelBaseDir\vosk-model.zip"
        
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $modelUrl -OutFile $modelZip -TimeoutSec 120 -ErrorAction Stop
        Write-Host "Downloaded: $modelZip" -ForegroundColor Green
        
        Write-Host "Extracting model..." -ForegroundColor Yellow
        Expand-Archive -Path $modelZip -DestinationPath $modelBaseDir -Force
        
        # Find extracted directory and rename
        $extracted = Get-ChildItem -Path $modelBaseDir -Directory | Where-Object { $_.Name -match "vosk-model" } | Select-Object -First 1
        if ($extracted) {
            Remove-Item $modelDir -Recurse -Force -ErrorAction SilentlyContinue
            Rename-Item $extracted.FullName -NewName "model-en-us" -Force
            Write-Host "Model ready: $modelDir" -ForegroundColor Green
        }
        
        Remove-Item $modelZip -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "ERROR: Could not download model: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Manual download:" -ForegroundColor Yellow
        Write-Host "1. Visit: https://alphacephei.com/vosk/models"
        Write-Host "2. Download: vosk-model-en-us-0.22.zip"
        Write-Host "3. Extract to: $modelBaseDir"
        Write-Host "4. Rename folder to: model-en-us"
        Write-Host ""
        Read-Host "Press Enter to continue anyway..."
    }
}

# 4. Build and run
Write-Host ""
Write-Host "Step 3: Building and running application..." -ForegroundColor Yellow
Write-Host ""

Set-Location "c:\Users\GIGABYTE\opencode"
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

& ".\gradlew.bat" "composeApp:run"
