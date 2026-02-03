$env:JAVA_HOME = 'C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot'
$env:PATH = $env:PATH + ';C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot\bin'

cd c:/users/GIGABYTE/opencode

Write-Host "🔨 Начинаю сборку APK..." -ForegroundColor Cyan
Write-Host "Это может занять 30-60 минут. Не выключайте компьютер."
Write-Host ""

python -m buildozer.toolchain android debug
