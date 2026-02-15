# 🚀 Magic Artifact - Final Setup

## Статус

✅ Проект полностью готов к запуску
✅ Все конфиги настроены
✅ Зависимости скачиваются  
⏳ Первая сборка может занять 5-15 минут (это нормально!)

## Быстрый запуск

### Windows - PowerShell

```powershell
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"
cd C:\Users\GIGABYTE\opencode

# Первая сборка (скачает ~600MB, 10-15 минут)
~\.gradle\wrapper\dists\gradle-8.4\bin\gradle composeApp:build -x test

# После успешной сборки - запуск с Hot Reload
~\.gradle\wrapper\dists\gradle-8.4\bin\gradle composeApp:desktopRun
```

### Linux/Mac

```bash
export JAVA_HOME="/path/to/java11"
export PATH="$HOME/.gradle/wrapper/dists/gradle-8.4/bin:$PATH"

cd ~/opencode
gradle composeApp:build -x test
gradle composeApp:desktopRun
```

## Версии используются

- **Kotlin 1.8.22** - стабильная версия  
- **Compose Multiplatform 1.5.12** - полная поддержка Desktop + Android
- **Gradle 8.4** - modern сборщик
- **Java 11** - есть на машине ✅

## Что происходит при первой сборке

1. **Скачивание зависимостей** (~600MB)
   - Kotlin Compiler
   - Compose libraries
   - Android SDK components
   - JetBrains tooling

2. **Компиляция** Desktop + Android targets
   - commonMain - общий код
   - desktopMain - Desktop приложение  
   - androidMain - Android приложение

3. **Сборка** JAR / APK

Это может занять **10-15 минут** в первый раз. Последующие сборки будут намного быстрее.

## Если зависает

Это нормально! Gradle может молчать несколько минут при скачивании. Просто подожди.

Если действительно зависает (больше 30 минут) - убей процесс и попробуй снова с `--verbose`:

```bash
gradle composeApp:build -x test --verbose
```

## После успешной сборки

```bash
# Hot Reload запуск
gradle composeApp:desktopRun --continuous
```

Приложение откроется. Отредактируй файл:
- `composeApp/src/commonMain/kotlin/MagicArtifactApp.kt`

Сохрани - изменения применятся за 1-2 сек!

## Android сборка

Когда Desktop работает, собрать APK:

```bash
gradle composeApp:assembleDebug
```

APK будет в: `composeApp/build/outputs/apk/debug/app-debug.apk`

---

**Все готово! Начинай с первой сборки.**
