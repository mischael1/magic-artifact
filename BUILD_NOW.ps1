# Lokalnaya sborka APK dlia Magic Artifact
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:Path = "$env:JAVA_HOME\bin;$env:Path"

Write-Host "=== Local APK Build ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Checking Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    Write-Host "OK: Java found" -ForegroundColor Green
    Write-Host $javaVersion[0] -ForegroundColor Gray
}
catch {
    Write-Host "ERROR: Java not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Checking Buildozer..." -ForegroundColor Yellow
$buildozerVersion = buildozer --version
Write-Host "OK: $buildozerVersion" -ForegroundColor Green

Write-Host ""
Write-Host "3. Starting APK build..." -ForegroundColor Cyan
Write-Host "This will take 20-40 minutes on first run" -ForegroundColor Yellow
Write-Host ""

buildozer android debug

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host ""
    
    $apk = Get-ChildItem -Path "bin" -Filter "*.apk" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($apk) {
        Write-Host "APK location:" -ForegroundColor Cyan
        Write-Host "$($apk.FullName)" -ForegroundColor Green
    }
}
else {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}
