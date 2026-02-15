#!/bin/bash
# Запуск приложения с Compose Hot Reload

echo "Starting Magic Artifact with Compose Hot Reload..."
cd "$(dirname "$0")"

echo "Cleaning previous builds..."
./gradlew clean

echo "Running with Hot Reload..."
./gradlew -t composeApp:runDesktop

echo "Done!"
