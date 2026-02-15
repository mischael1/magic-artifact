# Kotlin Multiplatform Setup

## Требования

1. **Java 11+** (JDK)
   ```bash
   java -version
   ```
   Если не установлен, скачай с [adoptium.net](https://adoptium.net/)

2. **Gradle** (будет скачан автоматически через gradlew)

3. **Android SDK** (для сборки Android)
   - Скачай Android Studio
   - Или используй CLI tools

4. **IDE** (рекомендуется)
   - IntelliJ IDEA
   - Android Studio
   - VS Code + Kotlin Extension

## Начало работы

### 1. Проверка окружения
```bash
java -version
echo %JAVA_HOME%  # Windows
```

### 2. Первая сборка
```bash
gradlew build
```

### 3. Запуск Desktop с Hot Reload
```bash
gradlew desktopRun --continuous
```

Терминал будет отслеживать изменения. При сохранении файлов в `composeApp/src/commonMain/kotlin/MagicArtifactApp.kt` UI обновится за 1-2 секунды.

### 4. Сборка Android
```bash
gradlew assembleDebug
```

APK будет в `composeApp/build/outputs/apk/debug/`

## Структура

```
composeApp/
├── src/
│   ├── commonMain/
│   │   └── kotlin/
│   │       ├── MagicArtifactApp.kt
│   │       └── managers/
│   ├── desktopMain/
│   │   └── kotlin/
│   │       └── Main.kt
│   └── androidMain/
│       ├── kotlin/
│       │   ├── MainActivity.kt
│       │   └── managers/
│       └── res/
├── build.gradle.kts
└── ...
```

## Возможные ошибки

### `JAVA_HOME не установлена`
```bash
# Windows (PowerShell)
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.XX"
gradlew build

# Linux/Mac
export JAVA_HOME=/path/to/jdk
./gradlew build
```

### `Gradle daemon timeout`
```bash
gradlew --stop
gradlew build
```

### `Android SDK не найден`
Установи Android Studio и запусти его один раз, или:
```bash
gradlew installAndroidSDK
```

## Полезные команды

```bash
# Чистка
gradlew clean

# Полная сборка
gradlew build

# Только Desktop
gradlew desktopRun

# Только Android Debug
gradlew assembleDebug

# Только Android Release
gradlew assembleRelease

# Hot Reload режим (автоматическая перезагрузка)
gradlew desktopRun --continuous

# Список всех задач
gradlew tasks
```

## Следующие шаги

1. Открыть `composeApp/src/commonMain/kotlin/MagicArtifactApp.kt`
2. Запустить `gradlew desktopRun --continuous`
3. Изменять UI и видеть результаты в реальном времени
4. Интегрировать VoiceManager и MediaPlayer
5. Собрать Android APK

---
**Готово к использованию!**
