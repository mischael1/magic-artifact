# Download Vosk Android AAR
$url = "https://github.com/alphacephei/vosk-android/releases/download/v0.3.50/vosk-android-0.3.50.aar"
$output = "composeApp\libs\vosk-android-0.3.50.aar"

Write-Host "Downloading Vosk Android AAR from: $url"
Write-Host "Saving to: $output"

# Create libs directory if it doesn't exist
$libsDir = Split-Path $output
if (-not (Test-Path $libsDir)) {
    New-Item -ItemType Directory -Path $libsDir -Force | Out-Null
    Write-Host "Created directory: $libsDir"
}

try {
    # Download using .NET method
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $output)
    
    # Verify download
    if (Test-Path $output) {
        $fileSize = (Get-Item $output).Length
        Write-Host "✓ Download successful! File size: $fileSize bytes"
        Write-Host "✓ Vosk AAR is ready for build"
    } else {
        Write-Host "✗ Download failed - file not found"
        exit 1
    }
} catch {
    Write-Host "✗ Error during download: $_"
    exit 1
}
