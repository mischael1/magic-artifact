# PowerShell скрипт для просмотра логов приложения в реальном времени

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Просмотр логов Magic Artifact" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

$ADB = "C:/Users/GIGABYTE/AppData/Local/Android/Sdk/platform-tools/adb.exe"

# Проверяем подключение эмулятора
Write-Host "Проверка эмулятора..." -ForegroundColor Yellow
$devices = & $ADB devices | Select-String "emulator"

if (-not $devices) {
    Write-Host "❌ Эмулятор не найден!" -ForegroundColor Red
    Write-Host "Пожалуйста, запустите эмулятор через Android Studio" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Эмулятор найден" -ForegroundColor Green
Write-Host ""
Write-Host "Подключение к логам (нажми Ctrl+C чтобы остановить)..." -ForegroundColor Yellow
Write-Host ""

# Очищаем логи
& $ADB logcat -c

# Выводим логи, фильтруя по python и приложению
& $ADB logcat | ForEach-Object {
    $line = $_
    
    # Выводим все строки с python, magicartifact или ERROR
    if ($line -match "python|magicartifact|ERROR|Exception|Traceback" -or $line -match "STATUS|WAKE|SPEECH|RESET|EFFECT") {
        # Подсвечиваем разные уровни
        if ($line -match "ERROR|Exception") {
            Write-Host $line -ForegroundColor Red
        } elseif ($line -match "Traceback") {
            Write-Host $line -ForegroundColor Yellow
        } elseif ($line -match "STATUS|initialized|Success") {
            Write-Host $line -ForegroundColor Green
        } else {
            Write-Host $line -ForegroundColor Cyan
        }
    }
}
