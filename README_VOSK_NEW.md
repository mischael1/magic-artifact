# Vosk Интеграция - Официальный подход

> ✅ **Готово к использованию.** Проект переинтегрирован с использованием официального Vosk Android SDK от Alpha Cephei.

## Быстрый старт

### Сборка

```bash
# Очистка и пересборка
gradlew clean assembleDebug

# Или просто компиляция
gradlew compileDebugKotlin
```

### Установка

```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.magicartifact.debug/com.magicartifact.MainActivity
```

### Логирование

```bash
adb logcat | grep "VoiceManager\|SpellRecognizer"
```

## Архитектура

```
VoiceManager (implements RecognitionListener)
  ├─ StorageService.unpack() → распаковка модели
  ├─ SpeechService → управление микрофоном
  └─ Callbacks → onFinalResult, onPartialResult, onError
```

## Использование в коде

```kotlin
// Инициализация
val voiceManager = VoiceManager(context)

// Callbacks
voiceManager.setOnFinalResult { text ->
    println("Распознано: $text")
}

voiceManager.setOnPartialResult { text ->
    println("Слушаю: $text")
}

voiceManager.setOnError { error ->
    println("Ошибка: $error")
}

// Запуск
voiceManager.startListening()

// Остановка
voiceManager.stopListening()

// Очистка
voiceManager.cleanup()
```

## Версии

- **Vosk:** 0.3.75 (последняя)
- **JNA:** 5.18.1@aar
- **Kotlin:** 2.0.21
- **Android API:** 24-34

## Файлы

### Основные

| Файл | Описание |
|------|---------|
| `composeApp/src/main/kotlin/com/magicartifact/VoiceManager.kt` | Интеграция Vosk (ПЕРЕПИСАН) |
| `composeApp/build.gradle.kts` | Зависимости (ОБНОВЛЕНО) |
| `composeApp/src/main/assets/model-en-us/` | Модель Vosk |

### Удаленные

| Файл | Причина |
|------|---------|
| `VoiceRecognitionAndroid.kt` | Больше не нужен (SpeechService управляет AudioRecord) |

## Документация

- **[VOSK_MIGRATION_REPORT.md](VOSK_MIGRATION_REPORT.md)** - Полный отчет о миграции
- **[QUICK_TEST.md](QUICK_TEST.md)** - Руководство по тестированию
- **[VOSK_INTEGRATION_OFFICIAL.md](VOSK_INTEGRATION_OFFICIAL.md)** - Подробная архитектура

## Статус

| Компонент | Статус |
|-----------|--------|
| Компиляция | ✅ BUILD SUCCESSFUL |
| Зависимости | ✅ Актуальны |
| API | ✅ Совместим с API 24+ |
| Логирование | ✅ Добавлено |
| Runtime | ⏳ Нужно тестировать |

## Разрешения

Требуемые разрешения (уже в AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

Запрашиваются в runtime (Android 6.0+):

```kotlin
requestPermissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
```

## Модель

- **Расположение в проекте:** `composeApp/src/main/assets/model-en-us/`
- **Размер:** ~60 MB
- **Язык:** English (US)
- **Распаковка:** Автоматически при первом запуске

## Troubleshooting

### "Model not loaded"
- Проверить что `model-en-us/` существует в assets
- Проверить логи: `adb logcat | grep StorageService`

### "Failed to start listening"
- Проверить разрешение RECORD_AUDIO
- Проверить что микрофон не занят другим приложением

### "No recognition"
- Проверить что модель полностью распакована
- Говорить громче и четче
- Проверить логи: `adb logcat | grep VoiceManager`

### "Low battery/memory"
- Приложение использует SpeechService - ресурсы управляются автоматически
- Вызвать `cleanup()` при выходе из приложения

## Результаты распознавания

### Final Result
```json
{
  "result": ["word1", "word2", "word3"]
}
```
Слова объединяются в текст: "word1 word2 word3"

### Partial Result
```json
{
  "partial": "word1 word2"
}
```
Обновляется в реальном времени во время говорения

## Заклинания

Поддерживаемые заклинания:

| Триггеры | Заклинание | Описание |
|----------|-----------|---------|
| огненный, шар, fire | Огненный шар | Огненный снаряд |
| ледяной, лед, ice | Ледяной удар | Замораживающее |
| щит, shield | Магический щит | Защита |
| исцеление, heal | Исцеление | Восстановление |
| молния, lightning | Молния | Электрический удар |

## Ссылки

- [GitHub: vosk-android-demo](https://github.com/alphacephei/vosk-android-demo)
- [Официальная документация](https://alphacephei.com/vosk/android)
- [Maven Central](https://search.maven.org/artifact/com.alphacephei/vosk-android)

## Чек-лист перед выпуском

- [ ] Проект компилируется
- [ ] APK собирается без ошибок
- [ ] Приложение запускается
- [ ] Модель распаковывается
- [ ] Микрофон работает
- [ ] Речь распознается
- [ ] Заклинания находятся
- [ ] Ошибки обрабатываются
- [ ] Ресурсы освобождаются

---

**Статус:** ✅ Готово к тестированию  
**Последнее обновление:** 2026-02-15
