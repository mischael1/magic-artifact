#!/bin/bash

echo "========================================"
echo "Сборка APK для Магического Артефакта"
echo "========================================"
echo ""

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "ОШИБКА: Docker не установлен!"
    echo ""
    echo "Установите Docker Desktop:"
    echo "https://www.docker.com/products/docker-desktop"
    echo ""
    exit 1
fi

echo "✓ Docker найден"
echo ""

# Сборка Docker образа
echo "Сборка Docker образа (первый раз долго ~5-10 минут)..."
docker build -t magic-artifact-builder .
if [ $? -ne 0 ]; then
    echo "ОШИБКА при создании образа!"
    exit 1
fi

echo "✓ Docker образ готов"
echo ""

# Сборка APK
echo "Сборка APK (10-20 минут)..."
docker run -v "$(pwd)":/workspace magic-artifact-builder buildozer android debug

if [ $? -ne 0 ]; then
    echo "ОШИБКА при сборке APK!"
    exit 1
fi

echo ""
echo "========================================"
echo "✓ APK успешно собран!"
echo "========================================"
echo ""

# Поиск APK файла
APK_FILE=$(ls -t bin/*.apk 2>/dev/null | head -1)

if [ -n "$APK_FILE" ]; then
    echo "Файл: $APK_FILE"
    echo ""
    echo "Установка на планшет:"
    echo "  adb install -r $APK_FILE"
    echo ""
else
    echo "Внимание: APK файл не найден!"
fi
