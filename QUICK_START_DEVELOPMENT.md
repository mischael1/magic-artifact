# 🚀 Быстрый старт разработки Magic Artifact

## Desktop разработка (быстро)

### Запуск с Hot Reload:
```powershell
./run_with_hot_reload.ps1
```

Изменяйте код - приложение автоматически перекомпилируется и обновляется.

### Или вручную:
```bash
./gradlew composeApp:runDesktop
```

## Android разработка

### Подготовка (один раз):
```bash
# Скачать модель Vosk для русского языка (~50MB)
./download_vosk_model.ps1

# Убедиться, что Android SDK установлен
# Установить эмулятор или подключить реальное устройство
```

### Запуск на эмуляторе:
```bash
./gradlew installDebug
```

### Запуск на реальном устройстве (Lenovo Tab M10):
```bash
# Подключить планшет по USB и включить Debug mode
adb devices  # проверить подключение

# Собрать и установить
./gradlew installDebug

# Просмотреть логи
adb logcat | grep -i "magicartifact"
```

## Файлы для редактирования

### UI логика:
- **composeApp/src/commonMain/kotlin/MagicArtifactApp.kt** - основной экран
- Изменяйте цвета, размеры, анимации

### Распознавание речи:
- **composeApp/src/desktopMain/kotlin/VoiceRecognition.kt** - Desktop версия
- **composeApp/src/androidMain/kotlin/VoiceRecognition.kt** - Android версия
- Меняйте логику распознавания ключевого слова

### База заклинаний:
- **composeApp/src/desktopMain/kotlin/SpellManager.kt** - добавляйте новые заклинания
- Меняйте ключевые фразы и описания

### Звуковые эффекты:
- **composeApp/src/desktopMain/kotlin/SoundEffects.kt** - Desktop звуки
- **composeApp/src/androidMain/kotlin/SoundEffects.kt** - Android звуки
- Меняйте частоты и модуляцию для разных звуков

## Основной сценарий приложения

1. **Инициализация**: приложение загружает компоненты
2. **Ожидание**: слушает ключевое слово "артефакт"
3. **Активация**: когда услышано "артефакт" → ждёт заклинания
4. **Распознавание**: анализирует произнесённую фразу
5. **Эффект**: воспроизводит звук и анимацию для найденного заклинания
6. **Сброс**: через 3 сек возвращается в режим ожидания

## Логирование для отладки

### Desktop:
```bash
./gradlew composeApp:runDesktop 2>&1 | grep -i "error\|status\|recognized"
```

### Android:
```bash
adb logcat MagicArtifact:* *:S
```

## Проверка структуры

### Убедитесь, что есть эти файлы:

**commonMain (общее):**
```
composeApp/src/commonMain/kotlin/
├── App.kt
├── MagicArtifactApp.kt
└── SpellManager.kt
```

**desktopMain (Windows/Mac/Linux):**
```
composeApp/src/desktopMain/kotlin/
├── Main.kt
├── App.kt
├── VoiceRecognition.kt
├── SoundEffects.kt
└── Config.kt
```

**androidMain (Android):**
```
composeApp/src/androidMain/
├── kotlin/
│   ├── MainActivity.kt
│   ├── App.kt
│   ├── VoiceRecognition.kt
│   └── SoundEffects.kt
├── res/
│   └── values/
│       ├── strings.xml
│       └── themes.xml
└── AndroidManifest.xml
```

## Градиент разработки

1. ✅ Работает на Desktop (Java)
2. ✅ Готов для Android (Kotlin/Compose)
3. 🔄 Нужно протестировать на реальном Lenovo Tab M10

## Проблемы при запуске

### "Cannot find Gradle home"
```bash
# Использовать встроенный gradle wrapper
./gradlew clean
./gradlew composeApp:runDesktop
```

### "Kotlin compilation error"
```bash
# Очистить кэш
./gradlew clean
./gradlew build
```

### "Model not found" (Android)
```bash
# Скачать модель Vosk
./download_vosk_model.ps1
```

## Горячие клавиши при разработке

**Desktop приложение:**
- `Ctrl+C` - выход
- Нет специальных горячих клавиш в UI, только кнопка "СЛУШАТЬ"

**IDE (IntelliJ IDEA):**
- `Shift+F10` - запустить приложение
- `Ctrl+Shift+F10` - переустановить и запустить
- `Ctrl+Shift+R` - рефреш проекта

## Следующие шаги после разработки

1. Протестировать на реальном Lenovo Tab M10
2. Отрегулировать чувствительность микрофона
3. Оптимизировать батарею
4. Добавить больше заклинаний при необходимости
5. Собрать release APK для продакшена
