# Download Vosk Russian model
$url = "https://alphacephei.com/vosk/models/vosk-model-small-ru-0.22.zip"
$output = "composeApp\src\desktopMain\resources\model\model.zip"
$extractPath = "composeApp\src\desktopMain\resources\model"

Write-Host "Downloading Vosk Russian model (50MB)..."
$client = New-Object System.Net.WebClient
$client.DownloadFile($url, $output)

Write-Host "Extracting..."
Expand-Archive -Path $output -DestinationPath $extractPath -Force

Write-Host "Cleaning up..."
Remove-Item $output

Write-Host "Model structure:"
Get-ChildItem $extractPath -Recurse | Select-Object -First 20 FullName | ForEach-Object {$_.FullName}
Write-Host "Done!"
