# 🚀 План локальной сборки APK

## Статус проекта
- ✅ Приложение готово (main.py, src/)
- ✅ Конфиг buildozer.spec настроен
- ✅ Требования: kivy, numpy, pyjnius
- ✅ Поддержка микрофона и полноэкранный режим

## Способ 1: Docker (рекомендуется - 20-40 мин)

### Требования:
- Docker Desktop установлен и запущен
- ~8 ГБ дискового пространства

### Шаги:
```powershell
# 1. Перейти в папку проекта
cd C:\Users\GIGABYTE\opencode

# 2. Запустить Docker сборку
docker-compose -f docker-compose.android.yml build --no-cache
docker-compose -f docker-compose.android.yml up

# 3. Ждать 20-40 минут
# APK будет в: bin\magicartifact-0.1-debug.apk
```

## Способ 2: PowerShell скрипт (если Docker недоступен)

### Требования:
- Python 3.9+
- Java JDK 11+ (https://www.oracle.com/java/technologies/javase-downloads.html)
- Свободное место: ~8 ГБ
- Интернет

### Шаги:
```powershell
# 1. Первая сборка - установка зависимостей
cd C:\Users\GIGABYTE\opencode
.\install_buildozer_deps.ps1

# 2. Запуск сборки
.\build_apk_local.ps1

# 3. Ждать 15-25 минут
# APK будет в: bin\magicartifact-0.1-debug.apk

# Для последующих сборок (быстрее):
.\build_apk_local.ps1
```

## Способ 3: Ручная командная строка
```bash
# Первый раз
pip install buildozer cython
buildozer android debug

# Последующие разы
buildozer android debug
```

## После успешной сборки

### Проверка файла:
```powershell
ls -la bin\magicartifact-0.1-debug.apk
```

### Установка на устройство (если подключено):
```powershell
# Если есть ADB и Android устройство подключено
adb install -r bin\magicartifact-0.1-debug.apk

# Запуск приложения
adb shell am start -n org.magicartifact.magicartifact/.MainActivity
```

## Индикаторы прогресса сборки

```
[========>____________] Скачивание SDK (25%)
[=================>____] Компиляция (75%)
[=======================] Упаковка APK (100%)
```

## Если что-то не работает

| Ошибка | Решение |
|--------|----------|
| Docker не запускается | Включи виртуализацию в BIOS |
| "buildozer: команда не найдена" | `pip install buildozer cython` |
| "Java не найдена" | Установи JDK 11+, добавь в PATH |
| Недостаточно памяти | Используй Docker вместо прямой сборки |
| Антивирус блокирует | Добавь `.buildozer` в исключения |

## Структура файлов после сборки

```
opencode/
├── bin/
│   └── magicartifact-0.1-debug.apk  ✅ ГОТОВЫЙ APK
├── .buildozer/  (кеш, можно удалить)
├── build/       (временные файлы)
└── src/         (исходный код)
```

## Время сборки (примерно)

| Способ | Первый раз | Последующие |
|--------|-----------|------------|
| Docker | 20-40 мин | 10-15 мин |
| PowerShell | 15-25 мин | 5-10 мин |
| Прямая команда | 15-25 мин | 5-10 мин |

## Что дальше?

1. ✅ Запусти сборку одним из способов выше
2. Дождись создания APK в папке `bin/`
3. Установи на планшет (USB или скопируй файл)
4. Протестируй приложение
5. При изменениях кода - пересобери (быстрее, чем Colab)
