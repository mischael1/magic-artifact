# PowerShell скрипт для сборки APK через Docker

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "        Magic Artifact APK Builder (Docker)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# Проверяем Docker
Write-Host "Проверка Docker..." -ForegroundColor Yellow
docker --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker не установлен или не работает" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Сборка Docker образа (может занять 10-15 минут)..." -ForegroundColor Yellow

# Собираем Docker образ
docker build -t magic-artifact-builder .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Не удалось собрать Docker образ" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Запуск сборки APK (может занять 30-60 минут)..." -ForegroundColor Yellow
Write-Host "Это может быть довольно долго при первой сборке..." -ForegroundColor Gray

# Запускаем сборку APK
docker run -v ${PWD}:/workspace magic-artifact-builder buildozer android debug

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Сборка APK не удалась" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "         Сборка завершена успешно!" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

# Находим APK файл
$APKFiles = Get-ChildItem -Path ".\bin\*.apk" -ErrorAction SilentlyContinue

if ($APKFiles) {
    Write-Host "✅ APK файл создан:" -ForegroundColor Green
    foreach ($apk in $APKFiles) {
        $size = [math]::Round($apk.Length / 1MB, 2)
        Write-Host "   📦 $($apk.Name) ($size MB)" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "Инструкции по установке:" -ForegroundColor Cyan
    Write-Host "1. Подключите планшет по USB"
    Write-Host "2. На планшете включите режим разработчика"
    Write-Host "3. Разрешите отладку по USB"
    Write-Host "4. Выполните команду:"
    Write-Host "   adb install -r bin\magicartifact-0.1-debug.apk" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Или просто откройте файл APK на планшете и установите." -ForegroundColor Gray
} else {
    Write-Host "⚠️ APK файл не найден в папке bin/" -ForegroundColor Yellow
    Write-Host "Проверьте логи сборки" -ForegroundColor Yellow
}
