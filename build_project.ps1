# PowerShell скрипт для сборки Kotlin Multiplatform проекта
$ErrorActionPreference = "Stop"

Write-Host "🔮 Magic Artifact - Kotlin Multiplatform Build" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Проверяем Java
Write-Host "[1/5] Проверка Java..." -ForegroundColor Yellow
$javaPath = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"
if (-not (Test-Path "$javaPath\bin\java.exe")) {
    Write-Host "❌ Java не найдена!" -ForegroundColor Red
    Write-Host "Установи Java с https://adoptium.net/" -ForegroundColor Red
    exit 1
}
$env:JAVA_HOME = $javaPath
Write-Host "✅ Java: $javaPath" -ForegroundColor Green
java -version 2>&1 | Select-Object -First 1
Write-Host ""

# Очистка старой сборки
Write-Host "[2/5] Очистка старой сборки..." -ForegroundColor Yellow
& ".\gradlew.bat" clean --quiet
Write-Host "✅ Готово" -ForegroundColor Green
Write-Host ""

# Скачиваем зависимости
Write-Host "[3/5] Скачивание зависимостей..." -ForegroundColor Yellow
& ".\gradlew.bat" dependencies --quiet
Write-Host "✅ Готово" -ForegroundColor Green
Write-Host ""

# Собираем Desktop
Write-Host "[4/5] Сборка Desktop target..." -ForegroundColor Yellow
& ".\gradlew.bat" :composeApp:desktopJar
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Ошибка сборки Desktop!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Desktop собран" -ForegroundColor Green
Write-Host ""

# Готово
Write-Host "[5/5] Сборка завершена!" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Запуск с Hot Reload:" -ForegroundColor Cyan
Write-Host "   .\gradlew.bat desktopRun --continuous" -ForegroundColor Gray
Write-Host ""
Write-Host "Или сборка Android:" -ForegroundColor Cyan
Write-Host "   .\gradlew.bat assembleDebug" -ForegroundColor Gray
Write-Host ""
