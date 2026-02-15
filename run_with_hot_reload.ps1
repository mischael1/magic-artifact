# Запуск приложения с Compose Hot Reload
Write-Host "Starting Magic Artifact with Compose Hot Reload..." -ForegroundColor Green

$projectRoot = Get-Location
cd $projectRoot

# Убедиться что Gradle в порядке
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
./gradlew clean

# Запуск с поддержкой Hot Reload
Write-Host "Running with Hot Reload..." -ForegroundColor Cyan
./gradlew -t composeApp:runDesktop

Write-Host "Done!" -ForegroundColor Green
