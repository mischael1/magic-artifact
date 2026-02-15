# Android сборка для Magic Artifact

## Целевое устройство
**Lenovo Tab M10 FHD Plus (TB-X606X)**
- ОС: Android 9.0+
- API уровень: 21-35
- Архитектура: ARM64 (arm64-v8a)
- Разрешение: 1920x1200

## Требования для сборки

### На Windows:
```
- Java Development Kit (JDK) 11+
- Android SDK (API 35)
- Android NDK r21+
- Kotlin 2.0.21+
- Gradle 8.3+
```

### На macOS/Linux:
```
- Те же требования + Unix утилиты
```

## Структура проекта

```
composeApp/
├── src/
│   ├── androidMain/
│   │   ├── kotlin/
│   │   │   ├── MainActivity.kt       (Entry point)
│   │   │   ├── VoiceRecognition.kt   (Vosk интеграция)
│   │   │   ├── SoundEffects.kt       (Android Audio)
│   │   │   └── App.kt                (Compose UI)
│   │   ├── res/
│   │   │   ├── values/
│   │   │   │   ├── strings.xml
│   │   │   │   └── themes.xml
│   │   │   └── drawable/
│   │   └── AndroidManifest.xml
│   ├── commonMain/
│   │   └── kotlin/
│   │       ├── App.kt                (expect)
│   │       ├── MagicArtifactApp.kt   (Shared UI)
│   │       └── SpellManager.kt       (Shared logic)
│   ├── desktopMain/
│   │   └── kotlin/
│   │       ├── Main.kt
│   │       ├── App.kt                (actual)
│   │       ├── VoiceRecognition.kt   (Desktop version)
│   │       └── SoundEffects.kt       (Desktop version)
│   └── commonTest/

└── build.gradle.kts (Android + Desktop)
```

## Киоск режим конфигурация

### AndroidManifest.xml:
```xml
<activity
    android:screenOrientation="sensorLandscape"
    android:configChanges="orientation|screenSize">
```

### MainActivity.kt:
```kotlin
window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
window.decorView.systemUiVisibility = (
    View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
    View.SYSTEM_UI_FLAG_FULLSCREEN or
    View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
)
```

## Требуемые разрешения

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" /> <!-- опционально -->
```

## Сборка APK

### Debug сборка:
```bash
./gradlew assembleDebug
# APK: composeApp/build/outputs/apk/debug/composeApp-debug.apk
```

### Release сборка:
```bash
./gradlew assembleRelease
# APK: composeApp/build/outputs/apk/release/composeApp-release.apk
```

### Установка на устройство:
```bash
adb install -r build/outputs/apk/debug/composeApp-debug.apk
```

## Vosk интеграция на Android

### Модель для русского языка:
```
https://alphacephei.com/vosk/models/vosk-model-ru-0.42.zip (~50MB)
```

### Размещение:
1. Скачайте модель
2. Распакуйте в `composeApp/src/androidMain/assets/vosk_model/`
3. При запуске приложение скопирует её в `context.filesDir/vosk_model/`

### Альтернатива:
Если модель не доступна на устройстве, приложение может загружать её с интернета при первом запуске.

## Тестирование на планшете

### Подключение через ADB:
```bash
# Включить режим разработчика на планшете
# Подключить по USB

# Проверить подключение
adb devices

# Запустить логи
adb logcat | grep -i "magicartifact\|vosk\|error"
```

### Проверка работы микрофона:
```bash
adb shell "am start -n com.magicartifact/.MainActivity"
```

## Оптимизация для Lenovo Tab M10

### Параметры для конкретного устройства:
- **API target**: 31 (Android 12) - рекомендуется
- **Архитектура**: arm64-v8a (основная)
- **Минимум**: API 21 (Android 5.0) для совместимости
- **Память**: минимум 2GB RAM

### Оптимизация батареи:
```kotlin
// Сократить CPU активность вне режима слушания
// Использовать WakeLock только при необходимости
// Отключать микрофон при неактивности
```

## Проблемы и решения

### Проблема: Нет звука на устройстве
**Решение**: 
- Проверьте громкость устройства
- Убедитесь, что разрешение RECORD_AUDIO выдано
- Протестируйте системный звук отдельно

### Проблема: Микрофон не работает
**Решение**:
- Проверьте разрешение в Параметры > Приложения > Magic Artifact > Разрешения
- Убедитесь, что нет других приложений, блокирующих микрофон
- Перезагрузите планшет

### Проблема: Vosk модель не загружается
**Решение**:
- Скопируйте модель вручную в assets
- Убедитесь, что путь к модели правильный
- Используйте эвристический режим вместо Vosk (менее точный, но работает)

## Дальнейшие шаги

1. ✅ Настройка Compose Multiplatform
2. ✅ Интеграция Vosk для Android
3. ✅ Настройка киоска режима
4. 🔄 Тестирование на реальном устройстве
5. 🔄 Оптимизация производительности
6. 🔄 Обработка жизненного цикла приложения
