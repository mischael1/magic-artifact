$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"

Write-Host "Starting Desktop with Hot Reload..." -ForegroundColor Green
Write-Host "Edit composeApp/src/commonMain/kotlin/MagicArtifactApp.kt and save to see changes!" -ForegroundColor Yellow
Write-Host ""

& ".\gradlew.bat" desktopRun --continuous
