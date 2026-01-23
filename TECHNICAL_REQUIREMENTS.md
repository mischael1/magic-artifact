# Технические требования

## Устройство

### Планшет Lenovo Tab M10 FHD Plus (TB-X606X)
- **Процессор**: MediaTek Helio P22T (MT6762T)
- **CPU**: 4x 2.3 GHz ARM Cortex-A53 + 4x 1.8 GHz ARM Cortex-A53
- **GPU**: IMG PowerVR GE8320, 650 MHz
- **ОЗУ**: 2GB / 4GB LPDDR4x, 1600 MHz
- **Память**: 32GB / 64GB / 128GB eMMC 5.1
- **microSD**: до 256GB
- **Экран**: 10.3" IPS, 1920 x 1200 пикселей
- **Батарея**: 5100 mAh Li-Polymer
- **ОС**: Android 9.0 Pie (или выше)
- **Порты**: USB-C 2.0, 3.5mm, microSD
- **Микрофон**: встроенный
- **Вес**: 460 г

### Минимальные требования для приложения
- **Android**: 5.0+ (API 21+)
- **ОЗУ**: минимум 2GB
- **Память**: минимум 500MB свободно
- **Микрофон**: обязателен
- **Экран**: минимум 720p

## Программные требования

### Основные зависимости
```
Python >= 3.9
kivy >= 2.3.1
kivy-deps.angle
kivy-deps.glew  
kivy-deps.gstreamer
kivy-deps.sdl2
openwakeword
vosk
pyaudio
buildozer
```

### Модели распознавания
- **VOSK русская модель**: vosk-model-ru-0.42 (~50MB)
- **OpenWakeWord модель**: кастомная для "артефакт" (~10MB)

### Android требования
- **SDK**: Android SDK 21+
- **NDK**: Android NDK r21+
- **Build Tools**: последняя версия
- **Java**: JDK 8 или 11

## Производительность

### Ожидаемые характеристики
- **Запуск приложения**: <5 секунд
- **Wake-word detection**: <100ms задержка
- **Speech recognition**: <1 секунда
- **Медиа воспроизведение**: <500ms задержка
- **Потребление памяти**: <200MB RAM
- **Потребление батареи**: <10% в час

### Оптимизация
- Сжатие медиафайлов
- Оптимизация моделей распознавания
- Кэширование результатов
- Управление жизненным циклом

## Хранилище

### Требования к памяти
```
Приложение: ~20MB
Модели распознавания: ~60MB
Медиафайлы заклинаний: ~100-500MB
Кэш и временные файлы: ~50MB
Всего: ~230-630MB
```

### Рекомендуемая структура
```
/internal storage/
├── Android/data/com.magicartifact/files/
│   ├── models/
│   ├── assets/
│   └── cache/
└── Download/
    └── magic_artifact_media/
```

## Сетевые требования

### Офлайн режим
- **Интернет**: не требуется
- **WiFi**: не требуется  
- **Мобильные данные**: не требуются

### Первоначальная настройка
- **Загрузка моделей**: требуется интернет один раз
- **Обновления**: опционально через WiFi

## Безопасность

### Разрешения Android
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### Приватность
- Все данные обрабатываются локально
- Нет передачи данных на серверы
- Нет сбора персональной информации
- Нет использования облачных сервисов

## Совместимость

### Поддерживаемые устройства
- ✅ Lenovo Tab M10 FHD Plus (TB-X606X)
- ✅ Другие Android планшеты с 2GB+ RAM
- ⚠️ Смартфоны Android (ограниченный функционал)
- ❌ iOS устройства (не поддерживается)

### Тестирование
- Эмулятор Android x86
- Реальное устройство Lenovo Tab M10
- Различные версии Android (5.0-13+)