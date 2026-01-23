#!/bin/bash
set -e

echo "🔨 Установка зависимостей для сборки APK..."

# Обновляем систему
sudo apt-get update
sudo apt-get upgrade -y

# Устанавливаем Java
sudo apt-get install -y openjdk-11-jdk-headless

# Устанавливаем buildozer и зависимости
pip install --upgrade pip setuptools wheel
pip install buildozer cython

# Создаем директорию для Android SDK
mkdir -p ~/android-sdk
cd ~/android-sdk

echo "📥 Скачивание Android SDK Command-line Tools..."
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip -q commandlinetools-linux-*.zip
rm commandlinetools-linux-*.zip

echo "⚙️ Установка компонентов Android SDK..."
yes | ./cmdline-tools/bin/sdkmanager --install \
  "platforms;android-31" \
  "build-tools;31.0.0" \
  "ndk;25.1.8937393" \
  2>/dev/null || true

export ANDROID_SDK_ROOT=~/android-sdk
export ANDROID_NDK_ROOT=~/android-sdk/ndk/25.1.8937393

# Добавляем в ~/.bashrc для будущих сеансов
echo "export ANDROID_SDK_ROOT=~/android-sdk" >> ~/.bashrc
echo "export ANDROID_NDK_ROOT=~/android-sdk/ndk/25.1.8937393" >> ~/.bashrc

echo "✅ Установка завершена!"
echo ""
echo "📝 Для сборки APK выполните в терминале:"
echo "   cd /workspaces/magic-artifact"
echo "   python3 build_apk.py"
