# Установка Магического Артефакта на планшет Lenovo Tab

## Что вам понадобится

- Планшет Lenovo Tab M10 FHD Plus (или совместимый Android планшет)
- USB кабель для подключения
- Готовый файл APK (или инструменты для его сборки)

## Способ 1: Прямая установка APK (самый быстрый)

### Если у вас уже есть файл `magicartifact-0.1-debug.apk`:

#### На Windows:

```powershell
# Установите Android Platform Tools
# https://developer.android.com/studio/releases/platform-tools

# Подключите планшет по USB

# В PowerShell перейдите в папку проекта
cd "c:\Users\GIGABYTE\opencode"

# Установите приложение
adb install -r bin/magicartifact-0.1-debug.apk
```

#### На Linux/Mac:

```bash
# Установите Android Platform Tools
# Или через пакетный менеджер:
# Ubuntu: sudo apt-get install android-tools-adb
# macOS: brew install android-platform-tools

cd ~/opencode

adb install -r bin/magicartifact-0.1-debug.apk
```

## Способ 2: Сборка APK на Windows через WSL2

### Шаг 1: Установка WSL2 (первый раз)

```powershell
# В PowerShell (администратор)
wsl --install -d Ubuntu-22.04

# Перезагрузитесь и завершите настройку Ubuntu
```

### Шаг 2: Настройка среды в WSL

```bash
# Откройте WSL2 терминал
wsl

# Обновите систему
sudo apt-get update
sudo apt-get upgrade

# Установите необходимые пакеты
sudo apt-get install -y \
  openjdk-11-jdk \
  build-essential \
  python3-pip \
  python3-dev \
  git

# Установите buildozer
pip3 install buildozer cython

# Установите Android SDK в WSL
mkdir -p ~/android-sdk
cd ~/android-sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-*.zip

# Установите компоненты Android SDK
yes | ./cmdline-tools/bin/sdkmanager --install \
  "platforms;android-31" \
  "build-tools;31.0.0" \
  "ndk;25.1.8937393"
```

### Шаг 3: Сборка APK

```bash
# Переходим в папку проекта
cd /mnt/c/Users/GIGABYTE/opencode

# Экспортируем пути к Android SDK
export ANDROID_SDK_ROOT=~/android-sdk
export ANDROID_NDK_ROOT=~/android-sdk/ndk/25.1.8937393

# Собираем APK
buildozer android debug

# Или используйте Python скрипт
python3 build_apk.py
```

## Способ 3: Облачная сборка через GitHub Actions

Самый простой способ без локальной установки.

### Шаг 1: Создайте GitHub репозиторий

```bash
cd c:\Users\GIGABYTE\opencode

git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/magic-artifact.git
git push -u origin main
```

### Шаг 2: Создайте GitHub Actions Workflow

1. На GitHub откройте **Actions** → **New workflow**
2. Выберите **set up a workflow yourself**
3. Скопируйте содержимое файла `QUICK_BUILD.md` (раздел GitHub Actions)
4. Сохраните как `.github/workflows/build.yml`
5. Нажмите **Run workflow**

После сборки (15-25 мин) скачайте APK из Artifacts.

## Установка APK на планшет

### Через ADB (рекомендуется)

```bash
# Подключите планшет по USB
# Включите режим разработчика:
# Настройки → О планшете → Нажмите 7 раз на "Номер сборки"
# Разрешите отладку по USB

# Проверьте подключение
adb devices

# Установите приложение
adb install -r bin/magicartifact-0.1-debug.apk

# Запустите приложение
adb shell am start -n org.magicartifact/org.magicartifact.MainActivity
```

### Через файловый менеджер (если ADB не доступен)

1. Скопируйте APK файл на планшет через USB
2. Откройте файловый менеджер на планшете
3. Найдите файл `magicartifact-0.1-debug.apk`
4. Нажмите и установите
5. Разрешите установку из неизвестных источников (Настройки → Безопасность)

## Первый запуск

1. Откройте приложение "Магический Артефакт"
2. Приложение запросит разрешение на запись аудио
3. Разрешите доступ к микрофону
4. Приложение переходит в режим ожидания

## Использование

- **Пробуждение**: Произнесите команду (в режиме тестирования - любой звук)
- **Активация заклинания**: Произнесите название заклинания:
  - "щит" - Магический щит
  - "огненный шар" - Огненный шар
  - "лечение" - Лечение
  - "молния" - Молния
  - "темная стрела" - Темная стрела

## Решение проблем

### Приложение не устанавливается
```bash
# Убедитесь, что устройство подключено
adb devices

# Очистите предыдущую версию
adb uninstall org.magicartifact

# Переустановите
adb install -r bin/magicartifact-0.1-debug.apk
```

### Нет звука
- Проверьте громкость планшета
- Убедитесь, что разрешен доступ к аудио в Настройках → Приложения

### Приложение зависает
- Это нормально в режиме тестирования (используется тестовое распознавание речи)
- Перезагрузите приложение

### Нужна помощь?
Смотрите файлы:
- `BUILD_APK.md` - Подробная инструкция по сборке
- `QUICK_BUILD.md` - Быстрые способы получить APK
- `README.md` - Описание проекта
