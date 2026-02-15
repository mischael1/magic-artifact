# Установка JAVA_HOME
$javaPath = "C:\Program Files\Android\Android Studio\jre"
if (Test-Path $javaPath) {
    $env:JAVA_HOME = $javaPath
} else {
    # Попытаемся найти JDK в других местах
    $jdkPaths = @(
        "C:\Program Files\Java\jdk-11",
        "C:\Program Files\Java\jdk-17",
        "C:\Program Files\Amazon Corretto\jdk11.0.18_10",
        "C:\Program Files (x86)\Java"
    )
    
    foreach ($path in $jdkPaths) {
        if (Test-Path $path) {
            $env:JAVA_HOME = $path
            break
        }
    }
}

Write-Host "JAVA_HOME = $($env:JAVA_HOME)"

# Переход в каталог проекта
Set-Location "c:\Users\GIGABYTE\opencode"

# Компиляция и запуск
Write-Host "Запуск сборки и тестирования..."
& ".\gradlew" "composeApp:run" 2>&1
