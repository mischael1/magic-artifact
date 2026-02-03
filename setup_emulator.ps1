# PowerShell скрипт для автоматической настройки эмулятора Android и установки APK

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Android Emulator Setup & APK Installation" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# Пути
$SDK_PATH = "C:/Users/GIGABYTE/AppData/Local/Android/Sdk"
$ADB = "$SDK_PATH/platform-tools/adb.exe"
$EMULATOR = "$SDK_PATH/emulator/emulator.exe"
$AVDMANAGER = "$SDK_PATH/cmdline-tools/latest/bin/avdmanager.bat"
$APK_PATH = "C:/Users/GIGABYTE/opencode/bin/magicartifact-0.1-debug.apk"
$AVD_NAME = "MagicArtifactTablet"

Write-Host "[1/5] Проверка SDK и tools..." -ForegroundColor Yellow
if (-not (Test-Path $ADB)) {
    Write-Host "❌ adb не найден!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ ADB найден" -ForegroundColor Green

if (-not (Test-Path $APK_PATH)) {
    Write-Host "❌ APK не найден!" -ForegroundColor Red
    Write-Host "    Путь: $APK_PATH" -ForegroundColor Red
    exit 1
}
Write-Host "✓ APK найден" -ForegroundColor Green
Write-Host ""

# Проверяем существующие эмуляторы
Write-Host "[2/5] Проверка существующих эмуляторов..." -ForegroundColor Yellow
$existing_avds = & $ADB devices | Select-String "emulator"

if ($existing_avds) {
    Write-Host "✓ Эмуляторы найдены:" -ForegroundColor Green
    $existing_avds | ForEach-Object { Write-Host "  - $_" }
    
    # Убиваем существующие эмуляторы
    Write-Host "Остановка существующих эмуляторов..." -ForegroundColor Yellow
    & $ADB emu kill 2>$null
    Start-Sleep -Seconds 2
} else {
    Write-Host "ℹ Активных эмуляторов не найдено" -ForegroundColor Cyan
}
Write-Host ""

# Запускаем эмулятор (используем Pixel Tablet который должен быть)
Write-Host "[3/5] Запуск эмулятора..." -ForegroundColor Yellow

# Пытаемся найти эмулятор по имени
$emulator_found = $false

# Проверяем стандартные имена
$common_avds = @("Pixel_Tablet_API_31", "Pixel_Tablet", "pixel_tablet_api_31", "Tablet_API_31")

foreach ($avd in $common_avds) {
    Write-Host "  Проверяю: $avd..." -ForegroundColor Gray
    # Попытаемся запустить этот AVD
    Start-Process -FilePath $EMULATOR -ArgumentList "-avd $avd" -WindowStyle Minimized -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    
    # Проверяем подключился ли эмулятор
    $devices = & $ADB devices | Select-String "emulator"
    if ($devices) {
        Write-Host "✓ Эмулятор $avd запущен!" -ForegroundColor Green
        $emulator_found = $true
        break
    }
}

if (-not $emulator_found) {
    Write-Host "⚠ Не удалось запустить эмулятор автоматически" -ForegroundColor Yellow
    Write-Host "✓ Пожалуйста, откройте Android Studio и запустите эмулятор вручную" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Ожидание подключения эмулятора (максимум 60 сек)..." -ForegroundColor Yellow
    
    $timeout = 0
    while ($timeout -lt 60) {
        $devices = & $ADB devices | Select-String "emulator"
        if ($devices) {
            Write-Host "✓ Эмулятор подключен!" -ForegroundColor Green
            $emulator_found = $true
            break
        }
        Start-Sleep -Seconds 2
        $timeout += 2
        Write-Host "  (ожидание... $timeout сек)" -ForegroundColor Gray
    }
}

if (-not $emulator_found) {
    Write-Host "❌ Эмулятор не подключен. Пожалуйста, запустите эмулятор вручную в Android Studio" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Ждем полной загрузки эмулятора
Write-Host "[4/5] Ожидание полной загрузки эмулятора..." -ForegroundColor Yellow
$boot_complete = $false
$timeout = 0
while ($timeout -lt 120 -and -not $boot_complete) {
    try {
        $boot_check = & $ADB shell getprop sys.boot_from_charger_mode 2>$null
        if ($LASTEXITCODE -eq 0) {
            $boot_complete = $true
        }
    } catch {}
    
    if (-not $boot_complete) {
        Start-Sleep -Seconds 3
        $timeout += 3
        Write-Host "  (загрузка... $timeout сек)" -ForegroundColor Gray
    }
}

Write-Host "✓ Эмулятор загружен" -ForegroundColor Green
Write-Host ""

# Устанавливаем APK
Write-Host "[5/5] Установка APK..." -ForegroundColor Yellow
Write-Host "Команда: adb install -r '$APK_PATH'" -ForegroundColor Gray
& $ADB install -r $APK_PATH

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ APK успешно установлен!" -ForegroundColor Green
    Write-Host ""
    Write-Host "=================================================" -ForegroundColor Green
    Write-Host "✅ ГОТОВО! Приложение установлено в эмулятор" -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Следующие команды для работы:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Запустить приложение:" -ForegroundColor Yellow
    Write-Host "   adb shell am start -n org.magicartifact.magicartifact/org.kivy.android.PythonActivity" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Смотреть логи (в отдельном окне PowerShell):" -ForegroundColor Yellow
    Write-Host "   adb logcat | findstr python" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Переустановить APK после изменений:" -ForegroundColor Yellow
    Write-Host "   adb install -r 'C:/Users/GIGABYTE/opencode/bin/magicartifact-0.1-debug.apk'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Очистить данные приложения:" -ForegroundColor Yellow
    Write-Host "   adb shell pm clear org.magicartifact.magicartifact" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "❌ Ошибка установки APK" -ForegroundColor Red
    exit 1
}
