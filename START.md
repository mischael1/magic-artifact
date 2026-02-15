# 🔮 Magic Artifact - Kotlin Multiplatform Setup

## ✅ Что сделано

Проект **полностью переделан** на **Kotlin Multiplatform** с **Compose UI**.

## Структура проекта

```
composeApp/
├── src/
│   ├── commonMain/kotlin/
│   │   ├── App.kt                    ← Основной UI контейнер
│   │   ├── MagicArtifactApp.kt       ← Магический интерфейс с анимацией
│   │   └── managers/
│   │       └── SpellManager.kt        ← Управление заклинаниями
│   │
│   ├── desktopMain/kotlin/
│   │   └── Main.kt                   ← Desktop entry point (Hot Reload)
│   │
│   └── androidMain/
│       ├── kotlin/
│       │   ├── MainActivity.kt        ← Android entry point
│       │   └── managers/
│       │       ├── VoiceManager.kt    ← Распознавание речи
│       │       └── MediaPlayer.kt     ← Воспроизведение медиа
│       └── res/
│           ├── AndroidManifest.xml
│           └── values/
│
├── build.gradle.kts
└── ...
```

## 📋 Требования

- **Java 11+** → Уже есть ✅
- **Gradle** → Скачается автоматически

## 🚀 Быстрый старт

### Вариант 1: Запуск через PowerShell (Windows)

```powershell
# Чистка предыдущих сборок
rm -r composeApp/build

# Первая сборка (скачает ~500MB зависимостей)
gradle build -x test

# Запуск Desktop с Hot Reload
gradle desktopRun --continuous
```

### Вариант 2: Используя встроенный gradlew

```bash
# Сборка
./gradlew.bat build -x test

# Hot Reload
./gradlew.bat desktopRun --continuous
```

### Вариант 3: Через IDE

1. Открыть проект в **IntelliJ IDEA** или **Android Studio**
2. Дождаться индексации
3. В главном меню: **Run** → **Run 'Main.kt'** (для Desktop)
4. Автоматический Hot Reload включится

## 🔥 Compose Hot Reload

Когда запущен `desktopRun --continuous`:

1. Отредактируй файл `composeApp/src/commonMain/kotlin/MagicArtifactApp.kt`
2. Сохрани (Ctrl+S)
3. Изменения применятся за **1-2 секунды** без перезагрузки приложения

Пример: измени цвет в `Color(0xffe6b3ff)` на `Color(0xffff0000)` - заголовок станет красным.

## 📦 Сборка Android APK

```bash
gradle assembleDebug
```

APK будет в: `composeApp/build/outputs/apk/debug/app-debug.apk`

## 🔧 Инструменты

- **Kotlin 2.0** - современный язык со статической типизацией
- **Compose** - декларативный UI фреймворк
- **Multiplatform** - один код для Desktop и Android
- **Gradle** - система сборки

## ⚠️ Если ошибки

### `JAVA_HOME не установлена`
```bash
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-11.0.28.6-hotspot"
gradle build
```

### `Gradle daemon timeout`
```bash
gradle --stop
gradle build
```

### `Не скачались зависимости`
```bash
gradle clean build -x test --refresh-dependencies
```

## 📚 Что дальше

### 1. Интеграция VoiceManager
- Подключить Google Speech-to-Text API
- Реализовать wake-word detection
- Добавить звуковые эффекты

### 2. Полировка UI
- Анимации переходов
- Расширенная система частиц
- Темы оформления

### 3. Сборка и тестирование
- Локальное тестирование на эмуляторе
- Тестирование на реальном устройстве
- Сборка Release версии

## 🎯 Статус

- ✅ Проект создан
- ✅ UI реализован
- ✅ Desktop target готов к Hot Reload
- ✅ Android target структурирован
- ✅ Managers перенесены из Python
- ⏳ Нужна интеграция VoiceManager
- ⏳ Нужны звуковые эффекты

---

**Готово к разработке!**

Запусти `gradle desktopRun --continuous` и начинай менять UI.
