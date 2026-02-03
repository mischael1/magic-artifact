# Быстрая сборка APK для Windows

## Требования
- **Windows 10/11**
- **WSL2** с Ubuntu
- **Java JDK** в WSL
- **Android SDK** в WSL  
- **Buildozer** в WSL

## Быстрая установка требований в WSL2

### 1. Если WSL2 еще не установлена:
```powershell
# В PowerShell от администратора:
wsl --install -d Ubuntu-22.04
```

### 2. В WSL2 (Ubuntu):
```bash
# Обновляем пакеты
sudo apt-get update && sudo apt-get upgrade -y

# Установка Java JDK
sudo apt-get install -y openjdk-11-jdk

# Установка Buildozer и зависимостей
pip install buildozer cython

# Установка Android SDK (опционально, если не установлен)
# Можно использовать готовый Docker контейнер
```

## Способ 1: Через batch файл (самый простой)

```bash
# Просто запустите:
build_windows.bat
```

Скрипт сделает всё автоматически.

## Способ 2: Вручную через WSL2

```bash
# 1. Откройте WSL2 терминал
wsl

# 2. Перейдите в папку проекта
cd /mnt/c/Users/GIGABYTE/opencode

# 3. Запустите сборку (первый раз займет 30-60 минут)
buildozer android debug

# 4. Ждите... приложение соберется в папку bin/
```

## Способ 3: Через Docker (без WSL2)

```powershell
# 1. Установите Docker Desktop для Windows

# 2. В командной строке/PowerShell:
docker build -t magic-artifact .
docker run -it -v C:\Users\GIGABYTE\opencode:/project magic-artifact ^
    bash -c "cd /project && buildozer android debug"

# Результат появится в папке bin/
```

## После сборки

1. Подключите планшет по USB
2. На планшете включите режим разработчика и отладку по USB
3. Выполните:
```bash
adb install -r bin/magicartifact-0.1-debug.apk
```

Или просто скопируйте файл APK на планшет и откройте его.

## Файлы, которые будут созданы

- `bin/magicartifact-0.1-debug.apk` - готовый APK для установки
- `bin/magicartifact-0.1-debug.aar` - библиотека (если требуется)

## Размер файла

Ожидаемый размер APK: ~100-150 MB

## Первая сборка

⏱️ Первая сборка может занять:
- На нормальном ПК с интернетом: 30-60 минут
- На медленном интернете: 60+ минут

Последующие сборки будут быстрее (5-15 минут).

## Проблемы?

### Ошибка: "buildozer not found"
- Убедитесь, что вы в WSL2 терминале
- Переустановите buildozer: `pip install --upgrade buildozer`

### Ошибка: "Android SDK not found"
- Buildozer может скачать SDK автоматически
- Или установите Android SDK через Android Studio

### Ошибка: "java not found"
```bash
sudo apt-get install openjdk-11-jdk-headless
```

### Slow build / Stuck on download
- Проверьте интернет соединение
- Используйте VPN если нужно
- Попробуйте `buildozer android debug 2>&1 | tee build.log` для логирования

## Версии

- **Python**: 3.10+
- **Kivy**: 2.1+
- **Android**: 5.0+ (API 21+)
- **Kotlin**: автоматически

## Примечания

- Debug версия размером больше, но можно отлаживать
- Release версия меньше, но требует подписи
- Приложение полностью на русском языке
- Работает в режиме киоска с полноэкранным режимом

Готовые APK файлы найдутся в папке `bin/`
