# Удаление старых/дублирующихся файлов из проекта

Write-Host "Cleaning up old and duplicate files..." -ForegroundColor Yellow

$filesToRemove = @(
    "composeApp/src/commonMain/kotlin/managers/SpellManager.kt",
    "composeApp/src/androidMain/kotlin/managers/VoiceManager.kt",
    "composeApp/src/androidMain/kotlin/managers/MediaPlayer.kt",
    "composeApp/src/commonMain/kotlin/managers"
)

foreach ($file in $filesToRemove) {
    $fullPath = Join-Path (Get-Location) $file
    if (Test-Path $fullPath) {
        Remove-Item -Path $fullPath -Recurse -Force
        Write-Host "Removed: $file" -ForegroundColor Green
    }
}

Write-Host "`nCleanup complete!" -ForegroundColor Cyan
