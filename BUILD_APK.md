# Инструкция по сборке APK для Магического Артефакта

## Требования для Windows

1. **WSL2** (Windows Subsystem for Linux 2)
2. **Python 3.9+** на WSL2
3. **Java JDK 11+**
4. **Android SDK**
5. **Android NDK**

## Шаг 1: Подготовка на Windows

### Установка WSL2 с Ubuntu

```powershell
# В PowerShell (администратор)
wsl --install -d Ubuntu-22.04
```

Перезагрузитесь и завершите настройку Ubuntu.

### Установка Java в WSL2

```bash
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk
java -version
```

## Шаг 2: Настройка Android SDK и NDK

```bash
# Установка зависимостей
sudo apt-get install -y build-essential git openjdk-11-jdk python3-pip

# Создание директории для Android SDK
mkdir -p ~/android-sdk
cd ~/android-sdk

# Скачивание Android SDK Command-line Tools
# Переходим на https://developer.android.com/studio и скачиваем командные инструменты

# Примерное расположение:
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-*.zip

# Установка SDK и NDK
./cmdline-tools/bin/sdkmanager --install "platforms;android-31" "build-tools;31.0.0" "ndk;25.1.8937393"
```

## Шаг 3: Установка Buildozer в WSL2

```bash
# Активируем Python окружение
python3 -m venv ~/venv
source ~/venv/bin/activate

# Устанавливаем зависимости
pip install buildozer cython

# Переходим в директорию проекта
cd /mnt/c/Users/GIGABYTE/opencode
```

## Шаг 4: Сборка APK

```bash
# Очистка (если нужно пересобрать)
buildozer android clean

# Сборка debug APK
buildozer android debug

# Сборка release APK (нужны ключи)
# buildozer android release
```

## Шаг 5: Установка на планшет

```bash
# Телефон/планшет должен быть подключен через USB с включенным режимом разработчика

# Проверка устройства
adb devices

# Установка APK
adb install -r bin/magicartifact-0.1-debug.apk
```

## Альтернатива: Использование GitHub Actions

Если вы хотите собрать APK без локальной настройки, используйте GitHub Actions.

Создайте файл `.github/workflows/build.yml`:

```yaml
name: Build APK

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install buildozer cython
          
      - name: Build APK
        run: |
          buildozer android debug
          
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: magic-artifact-apk
          path: bin/*.apk
```

## Решение проблем

### Ошибка "gradle not found"
```bash
buildozer android clean
buildozer android debug
```

### Недостаточно памяти
```bash
export GRADLE_OPTS="-Xmx512m"
buildozer android debug
```

### Ошибки с зависимостями
```bash
pip install --upgrade setuptools wheel
```
