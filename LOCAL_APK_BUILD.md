# Локальная сборка APK (вместо Colab)

## Быстрый старт (5 минут)

### Для Windows (рекомендуется Docker):

```powershell
# Способ 1: Docker (самый надежный)
docker-compose -f docker-compose.android.yml build --no-cache
docker-compose -f docker-compose.android.yml up

# APK будет в bin/magicartifact-0.1-debug.apk
```

### Для Windows (прямой запуск):

```powershell
# 1. Установка зависимостей (один раз)
.\install_buildozer_deps.ps1

# 2. Сборка
.\build_apk_local.ps1

# 3. Для следующих сборок (быстрее):
.\build_apk_local.ps1 -Release

# 4. Если нужно очистить кеш:
.\build_apk_local.ps1 -Clean
```

## Требования

### Способ 1: Docker (рекомендуется)
- Docker Desktop для Windows
- ~8 ГБ дискового пространства
- Первая сборка 20-40 минут, последующие 5-10 минут

### Способ 2: Native Windows
- Python 3.9+
- Java Development Kit (JDK) 11+
- Buildozer (установится автоматически)
- ~8 ГБ дискового пространства
- ~15 минут на сборку

## Как это работает

1. **build_apk_local.ps1** - главный скрипт сборки
   - Проверяет Python и Buildozer
   - Запускает `buildozer android debug`
   - Показывает путь к готовому APK

2. **install_buildozer_deps.ps1** - первоначальная настройка
   - Устанавливает Buildozer и Cython
   - Проверяет Java
   - Настраивает переменные окружения

3. **Dockerfile.android** - контейнер для сборки
   - Все зависимости в изолированной среде
   - Кроссплатформенность
   - Без влияния на систему

## После сборки

```powershell
# Установка на подключенное Android устройство
adb install -r bin/magicartifact-0.1-debug.apk

# Или на эмулятор (если запущен)
adb install -r bin/magicartifact-0.1-debug.apk

# Запуск приложения
adb shell am start -n org.magicartifact.magicartifact/.MainActivity
```

## Проблемы и решения

### "buildozer: команда не найдена"
```powershell
pip install buildozer cython
```

### "Java не найдена"
Скачайте JDK 11+: https://www.oracle.com/java/technologies/javase-downloads.html

### "Недостаточно памяти"
Используйте Docker (выделит ровно столько, сколько нужно)

### Долгая сборка
- Первый раз нормально (20-40 минут)
- После - 5-10 минут
- Используйте `-Clean` только если нужно

### Антивирус блокирует скачивание SDK
Добавьте исключение для `.buildozer` папки

## Структура файлов после сборки

```
project/
├── bin/
│   └── magicartifact-0.1-debug.apk  ← готовый APK
├── .buildozer/  ← кеш (большой, можно удалить и переделать)
└── build/       ← временные файлы сборки
```

## Скорость сборки (примерно)

| Этап | Время | Комментарий |
|------|-------|-----------|
| Скачивание SDK (первый раз) | 5-10 мин | ~2 ГБ |
| Компиляция Python | 5-10 мин | Зависит от кода |
| Упаковка APK | 3-5 мин | Быстро |
| **ИТОГО (первый раз)** | **25-40 мин** | Есть кеш |
| **ИТОГО (последующие)** | **5-10 мин** | Кеш готов |

## Если используете Git

После успешной сборки:

```powershell
# Закоммитьте изменения
git add .
git commit -m "Update: local APK build setup"
git push
```

## Дополнительные флаги build_apk_local.ps1

```powershell
# Полная пересборка (очистка кеша)
.\build_apk_local.ps1 -Clean

# Release-сборка (для Play Store, требует signing)
.\build_apk_local.ps1 -Release

# С подробными логами
.\build_apk_local.ps1 -Verbose

# Комбинированно
.\build_apk_local.ps1 -Clean -Verbose
```

## Следующие шаги

1. ✓ Соберите APK локально
2. Протестируйте на эмуляторе или устройстве
3. При изменениях кода пересоберите (быстрее, чем Colab)
4. Используйте логи для дебага: `adb logcat`

Наслаждайтесь быстрой локальной разработкой!
