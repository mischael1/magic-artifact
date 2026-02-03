# ⚠️ ВАЖНО: Сборка APK для Windows

Из-за ограничений окружения, APK не может быть собран автоматически. Вот что нужно сделать:

## Вариант 1: Использование Docker Desktop (РЕКОМЕНДУЕТСЯ)

### Шаг 1: Установка Docker Desktop
1. Скачайте Docker Desktop для Windows:
   https://www.docker.com/products/docker-desktop

2. Установите и перезагрузитесь

3. Запустите Docker Desktop (значок должен быть зелёным в трее)

### Шаг 2: Сборка в командной строке

Откройте **PowerShell** или **Command Prompt** и выполните:

```bash
cd C:\Users\GIGABYTE\opencode

python build_apk_docker.py
```

Или запустите bat файл двойным кликом:
```
build_docker.bat
```

## Вариант 2: Через WSL2 (Более быстрый способ)

### Требует установки:
- Windows 10/11
- WSL2 с Ubuntu

### Команды в WSL2:

```bash
# Скопируйте проект в WSL
cp -r /mnt/c/Users/GIGABYTE/opencode ~/magic_artifact

# Перейдите в папку
cd ~/magic_artifact

# Установите зависимости (один раз)
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk python3-pip git

pip3 install buildozer cython pyjnius

# Запустите сборку
buildozer android debug
```

## Вариант 3: Через Google Colab (Облако)

Используйте файл `COLAB_BUILD.ipynb`:
1. Откройте Google Colab
2. Загрузите файл COLAB_BUILD.ipynb
3. Запустите ячейки по порядку
4. Скачайте готовый APK

## Вариант 4: Через GitHub Actions

Push на GitHub → автоматическая сборка в облаке

## Что ожидать

- **Первая сборка**: 45-60 минут (качание SDK)
- **Последующие**: 10-20 минут
- **Размер APK**: ~120-150 MB
- **Место на диске**: ~6-8 GB

## Проверка сборки

После завершения файл появится здесь:
```
bin/magicartifact-0.1-debug.apk
```

## Установка на планшет

1. Скопируйте файл APK на планшет
2. Или используйте adb:
```bash
adb install -r bin/magicartifact-0.1-debug.apk
```

## Статус проверки

✅ Все исходники готовы
✅ Конфигурация исправлена
✅ Разрешения установлены
✅ Структура проекта корректна

**Просто запусти `build_apk_docker.py` или `build_docker.bat` и жди!**
