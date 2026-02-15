#!/bin/bash

# Скрипт для запуска Desktop приложения с Compose Hot Reload

echo "🔮 Magic Artifact - Desktop with Hot Reload"
echo "============================================"
echo ""
echo "Запуск приложения..."
echo "Внимание: Изменения UI будут применены в реальном времени!"
echo ""

cd "$(dirname "$0")" || exit

./gradlew desktopRun --continuous

echo ""
echo "✅ Hot Reload отключен. Приложение остановлено."
