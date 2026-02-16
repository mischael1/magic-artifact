# Vosk Интеграция (Официальный подход)

Дата: 2026-02-15

## Обзор

Приложение переинтегрировано на использование **официального подхода** из `vosk-android-demo` вместо предыдущей кастомной реализации.

## Ключевые изменения

### 1. Обновлены зависимости (build.gradle.kts)

**Было:**
```gradle
implementation("com.github.alphacephei:vosk-android:0.3.50")
```

**Стало:**
```gradle
implementation("net.java.dev.jna:jna:5.18.1@aar")
implementation("com.alphacephei:vosk-android:0.3.75@aar")
```

- Добавлен JNA (Java Native Access) - зависимость для работы с нативными библиотеками Vosk
- Обновлена версия Vosk на последнюю официальную версию (0.3.75)

### 2. Полностью переписана интеграция VoiceManager

**Старый подход (удален):**
- Ручное управление AudioRecord
- Ручное управление байтовыми буферами
- Ручная реализация RecognitionListener паттерна

**Новый подход (официальный):**
- `StorageService` для распаковки модели из assets
- `SpeechService` для управления микрофоном и распознаванием
- `RecognitionListener` из официального SDK

### 3. Архитектура VoiceManager

```
VoiceManager (implements RecognitionListener)
├── StorageService.unpack() - распаковка модели
├── Model - загруженная модель
├── SpeechService - управление микрофоном
└── Callbacks (onPartialResult, onFinalResult, onError)
```

### 4. Жизненный цикл распознавания

```
init()
  ↓
StorageService.unpack(context, "model-en-us", "model")
  ↓
Model загружена, isReady = true
  ↓
startListening()
  ↓
SpeechService создается и начинает слушать
  ↓
RecognitionListener callbacks вызываются:
  - onPartialResult(text) - текущее распознавание
  - onFinalResult(text) - финальный результат
  - onError(exception) - ошибки
  ↓
stopListening()
  ↓
SpeechService.stop() и .shutdown()
  ↓
cleanup()
  ↓
Model.close()
```

## Формат результатов Vosk

### onFinalResult
```json
{
  "result": ["word1", "word2", "word3"]
}
```
Слова объединяются в одну строку при извлечении.

### onPartialResult
```json
{
  "partial": "word1 word2"
}
```
Промежуточное распознавание, обновляется в реальном времени.

## Использование в MainActivity

```kotlin
// Инициализация
voiceManager = VoiceManager(this)

// Установка callbacks
voiceManager.setOnFinalResult { text ->
    // Обработка финального результата
}

voiceManager.setOnPartialResult { text ->
    // Обновление UI промежуточным результатом
}

voiceManager.setOnError { error ->
    // Обработка ошибок
}

// Запуск
voiceManager.startListening()

// Остановка
voiceManager.stopListening()

// Очистка
voiceManager.cleanup()
```

## Удаленные файлы

1. `composeApp/src/androidMain/kotlin/com/magicartifact/VoiceRecognitionAndroid.kt` - больше не нужен, так как SpeechService управляет AudioRecord

## Файлы Vosk

### Модель
- Расположение в проекте: `composeApp/src/main/assets/model-en-us/`
- Структура:
  - `am/` - acoustic model
  - `conf/` - конфигурация
  - `graph/` - граф декодирования
  - `ivector/` - i-vector для нормализации
  - `README` - информация о модели

### Распаковка модели
`StorageService.unpack()` автоматически распаковывает модель из assets в `context.filesDir/model/`

## Сравнение с старой реализацией

| Аспект | Старое | Новое |
|--------|--------|-------|
| Model Loading | Ручное | StorageService.unpack() |
| Audio Capture | AudioRecord (ручное) | SpeechService |
| Recognition | Recognizer (ручное) | SpeechService + RecognitionListener |
| Version | 0.3.50 | 0.3.75 |
| Dependencies | JitPack (GitHub) | Official Maven |

## Преимущества новой интеграции

✅ Официальная поддержка Alpha Cephei (разработчики Vosk)  
✅ Лучшая надежность и совместимость  
✅ Автоматическое управление ресурсами  
✅ Стандартный паттерн RecognitionListener  
✅ Встроенная поддержка паузы/возобновления  
✅ Лучшая обработка ошибок и таймаутов  

## Тестирование

1. Проверить что модель распаковывается в `context.filesDir/model/`
2. Проверить что микрофон инициализируется правильно
3. Проверить все три callback события (partial, final, error)
4. Проверить корректное завершение и очистку ресурсов

## Ссылки

- GitHub: https://github.com/alphacephei/vosk-android-demo
- Официальная документация: https://alphacephei.com/vosk/android
- Maven Central: https://search.maven.org/artifact/com.alphacephei/vosk-android
