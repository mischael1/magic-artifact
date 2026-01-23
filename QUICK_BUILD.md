# Быстрая сборка APK на Windows

## Самый быстрый способ

Используйте **GitHub Actions** для облачной сборки (бесплатно, 2 часа в месяц).

### Шаг 1: Закачайте проект на GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/magic-artifact.git
git push -u origin main
```

### Шаг 2: Создайте GitHub Actions Workflow

1. На GitHub откройте вкладку **Actions**
2. Нажмите **New workflow** → **set up a workflow yourself**
3. Скопируйте этот файл `.github/workflows/build.yml`:

```yaml
name: Build APK

on: 
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install system dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y openjdk-11-jdk build-essential libffi-dev
      
      - name: Setup Android SDK
        run: |
          mkdir -p ~/android-sdk
          cd ~/android-sdk
          wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
          unzip -q commandlinetools-linux-*.zip
          yes | ./cmdline-tools/bin/sdkmanager --install "platforms;android-31" "build-tools;31.0.0" "ndk;25.1.8937393"
      
      - name: Install Python dependencies
        run: |
          python -m pip install --upgrade pip
          pip install buildozer cython
      
      - name: Build APK
        run: |
          export ANDROID_SDK_ROOT=~/android-sdk
          export ANDROID_NDK_ROOT=~/android-sdk/ndk/25.1.8937393
          buildozer android debug
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: magic-artifact-apk
          path: bin/*.apk
          retention-days: 30
```

### Шаг 3: Загрузите файл и запустите сборку

1. Сохраните файл
2. Нажмите **Commit changes**
3. Перейдите на вкладку **Actions**
4. Выберите workflow и нажмите **Run workflow**
5. Дождитесь завершения (обычно 15-25 минут)
6. Скачайте APK из **Artifacts**

---

## Локальная сборка на Windows через WSL2

Если вы предпочитаете собирать локально:

### Минимальные требования

- Windows 10/11 Pro (для WSL2)
- 20 GB свободного места
- 8 GB RAM

### Установка WSL2

```powershell
# В PowerShell (админ)
wsl --install -d Ubuntu-22.04

# Перезагрузитесь
# Завершите настройку в Ubuntu
```

### Сборка в WSL2

```bash
# Откройте WSL2 терминал
wsl

# Установите зависимости
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk build-essential python3-pip

# Установите buildozer
pip3 install buildozer cython

# Перейдите в проект
cd /mnt/c/Users/GIGABYTE/opencode

# Установите Android SDK (первый раз долго ~10-15 мин)
# Создайте setup.sh и запустите

# Собирайте
buildozer android debug
```

### Получение APK

После успешной сборки APK находится в:
```
bin/magicartifact-0.1-debug.apk
```

### Установка на планшет

```bash
# Подключите планшет по USB (режим разработчика включен)
adb devices  # Проверка

adb install -r bin/magicartifact-0.1-debug.apk
```

---

## Рекомендуемый способ

**GitHub Actions** (облако) - самый простой:
- ✅ Ничего не нужно устанавливать локально
- ✅ Работает на любом ПК
- ✅ Бесплатно
- ✅ Автоматическая переиндексация

**Минусы**: Нужно место на GitHub, 15-25 минут ожидания

**Локальная WSL2 сборка**:
- ✅ Быстрее (после первой установки)
- ✅ Можно собирать сколько угодно
- ❌ Нужно установить WSL2 и Android SDK (~5 GB)
- ❌ Только на Windows 10/11 Pro
