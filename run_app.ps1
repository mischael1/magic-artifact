# PowerShell скрипт для установки и запуска приложения

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "Magic Artifact - Установка и Запуск" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

$ADB = "C:\Users\GIGABYTE\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$APK_PATH = "C:\Users\GIGABYTE\opencode\bin\magicartifact-0.1-debug.apk"
$PACKAGE = "org.magicartifact.magicartifact"
$ACTIVITY = "$PACKAGE/org.kivy.android.PythonActivity"

# 1. Проверка эмулятора
Write-Host "[1/5] Проверка эмулятора..." -ForegroundColor Yellow
$devices = & $ADB devices | Select-String "emulator"

if (-not $devices) {
    Write-Host "ОШИБКА: Эмулятор не найден!" -ForegroundColor Red
    exit 1
}

Write-Host "OK: Эмулятор подключен" -ForegroundColor Green
Write-Host ""

# 2. Ожидание APK файла
Write-Host "[2/5] Ожидание APK файла..." -ForegroundColor Yellow

$timeout = 0
$max_timeout = 600

while (-not (Test-Path $APK_PATH) -and $timeout -lt $max_timeout) {
    Write-Host "  Ожидание... ($timeout сек)" -ForegroundColor Gray
    Start-Sleep -Seconds 5
    $timeout += 5
}

if (-not (Test-Path $APK_PATH)) {
    Write-Host "ОШИБКА: APK файл не найден за 10 минут!" -ForegroundColor Red
    exit 1
}

$apk_size = (Get-Item $APK_PATH).Length / 1MB
Write-Host "OK: APK найден, размер $([Math]::Round($apk_size, 1)) MB" -ForegroundColor Green
Write-Host ""

# 3. Удаление старой версии
Write-Host "[3/5] Удаление старой версии..." -ForegroundColor Yellow
& $ADB shell pm uninstall $PACKAGE 2>$null
Start-Sleep -Seconds 2
Write-Host "OK: Готово" -ForegroundColor Green
Write-Host ""

# 4. Установка APK
Write-Host "[4/5] Установка APK..." -ForegroundColor Yellow
& $ADB install -r $APK_PATH

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK: APK установлен!" -ForegroundColor Green
} else {
    Write-Host "ОШИБКА: Установка не удалась!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 5. Запуск приложения
Write-Host "[5/5] Запуск приложения..." -ForegroundColor Yellow
& $ADB shell am start -n $ACTIVITY 2>$null
Write-Host "OK: Приложение запущено!" -ForegroundColor Green
Write-Host ""

Write-Host "=====================================================================" -ForegroundColor Green
Write-Host "ГОТОВО! Просмотр логов..." -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Нажми Ctrl+C чтобы остановить просмотр логов" -ForegroundColor Yellow
Write-Host ""

# Очищаем логи
& $ADB logcat -c

# Выводим логи
& $ADB logcat | ForEach-Object {
    $line = $_
    
    # Выводим все логи содержащие python, приложение, ошибки
    if ($line -match "python|magicartifact|ERROR|Exception" -or $line -match "STATUS|initialized|Success") {
        if ($line -match "ERROR|Exception") {
            Write-Host "[ERROR] $line" -ForegroundColor Red
        } elseif ($line -match "Success|initialized") {
            Write-Host "[OK] $line" -ForegroundColor Green
        } else {
            Write-Host "[LOG] $line" -ForegroundColor Cyan
        }
    }
}
