#!/bin/bash

# Скрипт для сборки APK Магического Артефакта
# Запускать из WSL2

set -e

echo "================================"
echo "Сборка APK - Магический Артефакт"
echo "================================"
echo ""

# Проверка наличия buildozer
if ! command -v buildozer &> /dev/null; then
    echo "❌ buildozer не установлен"
    echo "Установите: pip install buildozer cython"
    exit 1
fi

# Проверка наличия Java
if ! command -v java &> /dev/null; then
    echo "❌ Java не установлена"
    echo "Установите: sudo apt-get install openjdk-11-jdk"
    exit 1
fi

echo "✓ buildozer найден"
echo "✓ Java найдена"
echo ""

# Переходим в директорию проекта
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "Директория проекта: $SCRIPT_DIR"
echo ""

# Настройка переменных окружения для Android SDK
export ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-~/android-sdk}
export ANDROID_NDK_ROOT=${ANDROID_NDK_ROOT:-~/android-sdk/ndk/25.1.8937393}
export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools

echo "Android SDK: $ANDROID_SDK_ROOT"
echo "Android NDK: $ANDROID_NDK_ROOT"
echo ""

# Опция для очистки
if [ "$1" == "clean" ]; then
    echo "🧹 Очистка предыдущей сборки..."
    buildozer android clean
    echo ""
fi

# Сборка debug APK
echo "🔨 Начало сборки APK..."
echo "(это может занять 10-30 минут)"
echo ""

if buildozer android debug 2>&1 | tee build.log; then
    echo ""
    echo "✅ APK успешно собран!"
    echo ""
    
    # Поиск собранного APK
    APK_PATH=$(find bin -name "*.apk" -type f -printf '%T@ %p\n' | sort -rn | head -1 | cut -d' ' -f2-)
    
    if [ -f "$APK_PATH" ]; then
        echo "📱 Путь к APK: $APK_PATH"
        echo "Размер: $(du -h "$APK_PATH" | cut -f1)"
        echo ""
        echo "Для установки на устройство через ADB:"
        echo "  adb install -r $APK_PATH"
    fi
else
    echo ""
    echo "❌ Ошибка при сборке"
    echo "Детали см. в build.log"
    exit 1
fi
