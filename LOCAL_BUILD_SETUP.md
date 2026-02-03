# Локальная сборка APK на Windows

## Требования
- Windows 10/11
- Python 3.9+ (уже установлен)
- Java Development Kit (JDK) 11+
- Android SDK
- NDK (версия 25.1.8937393)

## Шаг 1: Установка Java (если не установлена)

```powershell
# Скачайте JDK 11+ с https://www.oracle.com/java/technologies/javase-downloads.html
# или установите через chocolatey:
choco install openjdk11
```

## Шаг 2: Установка Buildozer

```powershell
pip install buildozer cython
```

## Шаг 3: Подготовка Android SDK

Buildozer может скачать SDK автоматически при первой сборке.
Убедитесь, что переменные окружения установлены правильно:

```powershell
# Установите переменные окружения (опционально):
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Users\GIGABYTE\.buildozer\android\platform\android-sdk", "User")
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk-11", "User")
```

## Шаг 4: Сборка APK

```powershell
# Из корня проекта:
buildozer android debug
```

На первый раз это займет 20-40 минут, так как будут скачены все зависимости.

## Шаг 5: Запуск на эмуляторе или устройстве

```powershell
# После сборки найдите APK в:
# bin/magicartifact-0.1-debug.apk

# Установите на устройство:
adb install bin/magicartifact-0.1-debug.apk

# Или на эмулятор (убедитесь, что запущен)
adb install bin/magicartifact-0.1-debug.apk
```

## Для обновления после изменений кода:

```powershell
# Полная пересборка:
buildozer android debug

# Быстрая переустановка (если только код изменился):
adb install -r bin/magicartifact-0.1-debug.apk
```

## Правда о памяти и дисковом пространстве:

- Android SDK требует ~5-8 ГБ дискового пространства в `.buildozer`
- Первая сборка требует 4+ ГБ ОЗУ
- На Windows может быть медленнее, чем на Linux/Mac

## Если возникают проблемы:

1. Очистите кеш: `buildozer android clean`
2. Убедитесь, что нет антивируса, блокирующего Java или SDK
3. Проверьте, что Python 3.9+ (не Python 2)
4. Смотрите логи: `buildozer android debug -vv`

## Альтернатива: Docker (быстрее на Windows)

```powershell
docker-compose -f docker-compose.yml build --no-cache
docker-compose -f docker-compose.yml up
```

Это изолирует все зависимости в контейнере.
