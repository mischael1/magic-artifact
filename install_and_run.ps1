# PowerShell скрипт для установки APK и запуска приложения с просмотром логов

Write-Host "`n" -NoNewline
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     Magic Artifact - Установка и Запуск на Эмуляторе        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Пути
$ADB = "C:\Users\GIGABYTE\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$APK_PATH = "C:\Users\GIGABYTE\opencode\bin\magicartifact-0.1-debug.apk"
$PACKAGE = "org.magicartifact.magicartifact"
$ACTIVITY = "$PACKAGE/org.kivy.android.PythonActivity"

# Проверка эмулятора
Write-Host "[1/5] Проверка эмулятора..." -ForegroundColor Yellow
$devices = & $ADB devices | Select-String "emulator"

if (-not $devices) {
    Write-Host "❌ Эмулятор не найден!" -ForegroundColor Red
    Write-Host "    Запустите эмулятор через Android Studio" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Эмулятор подключен: $($devices[0])" -ForegroundColor Green
Write-Host ""

# Ожидание APK файла
Write-Host "[2/5] Ожидание APK файла..." -ForegroundColor Yellow

$timeout = 0
$max_timeout = 600  # 10 минут

while (-not (Test-Path $APK_PATH) -and $timeout -lt $max_timeout) {
    Write-Host "  ⏳ Нет APK файла... ($timeout сек)" -ForegroundColor Gray
    Start-Sleep -Seconds 5
    $timeout += 5
}

if (-not (Test-Path $APK_PATH)) {
    Write-Host "❌ APK файл не появился за 10 минут!" -ForegroundColor Red
    Write-Host "   Пожалуйста, соберите APK в Colab и загрузите его" -ForegroundColor Red
    exit 1
}

$apk_size = (Get-Item $APK_PATH).Length / 1MB
Write-Host "✓ APK найден! Размер: $([Math]::Round($apk_size, 1)) MB" -ForegroundColor Green
Write-Host ""

# Удаление старого приложения
Write-Host "[3/5] Очистка старой версии..." -ForegroundColor Yellow
& $ADB shell pm uninstall $PACKAGE 2>$null
Start-Sleep -Seconds 2
Write-Host "✓ Старая версия удалена (или не была установлена)" -ForegroundColor Green
Write-Host ""

# Установка APK
Write-Host "[4/5] Установка APK..." -ForegroundColor Yellow
Write-Host "  Команда: adb install -r '$APK_PATH'" -ForegroundColor Gray
$install_output = & $ADB install -r $APK_PATH

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ APK успешно установлен!" -ForegroundColor Green
} else {
    Write-Host "❌ Ошибка установки!" -ForegroundColor Red
    Write-Host $install_output -ForegroundColor Red
    exit 1
}
Write-Host ""

# Запуск приложения
Write-Host "[5/5] Запуск приложения..." -ForegroundColor Yellow
& $ADB shell am start -n $ACTIVITY 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Приложение запущено!" -ForegroundColor Green
} else {
    Write-Host "⚠ Ошибка при запуске (приложение может быть запущено)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                  ✅ ГОТОВО!                                  ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Просмотр логов
Write-Host "Подключение к логам приложения..." -ForegroundColor Yellow
Write-Host "(Нажмите Ctrl+C чтобы остановить)" -ForegroundColor Yellow
Write-Host ""

# Очищаем логи
& $ADB logcat -c

# Выводим логи с подсветкой
& $ADB logcat | ForEach-Object {
    $line = $_
    
    # Выводим строки с python, приложением или ошибками
    if ($line -match "python|magicartifact|ERROR|Exception|Traceback|I python" -or 
        $line -match "STATUS|WAKE|SPEECH|RESET|EFFECT|initialized|Success") {
        
        # Подсвечиваем разные типы сообщений
        if ($line -match "ERROR|Exception|Traceback") {
            Write-Host "🔴 $line" -ForegroundColor Red
        } elseif ($line -match "WARNING|Error") {
            Write-Host "🟡 $line" -ForegroundColor Yellow
        } elseif ($line -match "✓|✅|Success|initialized|запущен|инициализирован") {
            Write-Host "🟢 $line" -ForegroundColor Green
        } elseif ($line -match "\[") {
            Write-Host "🔵 $line" -ForegroundColor Cyan
        } else {
            Write-Host "⚪ $line" -ForegroundColor White
        }
    }
}
