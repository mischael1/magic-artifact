# Magic Artifact - Kotlin Multiplatform

## ⚡ Быстро запустить

**Windows:** Двойной клик на `INSTALL_AND_RUN.bat`

**Linux/Mac:**
```bash
chmod +x INSTALL_AND_RUN.bat
./INSTALL_AND_RUN.bat
```

Или вручную:
```bash
export JAVA_HOME=/path/to/java11
gradle :composeApp:desktopRun --continuous
```

## 🔥 Hot Reload в действии

1. Приложение открыто на экране
2. Отредактируй `composeApp/src/commonMain/kotlin/MagicArtifactApp.kt`
3. Сохрани файл
4. **Изменения появятся за 1-2 секунды**

Нет перезагрузки, нет пересборки - только UI update!

## 📦 Структура

```
composeApp/
├── src/commonMain/   ← Общий код (UI + бизнес-логика)
├── src/desktopMain/  ← Desktop (для Hot Reload)
└── src/androidMain/  ← Android (APK)
```

## 🎯 Основной UI файл

**`composeApp/src/commonMain/kotlin/MagicArtifactApp.kt`**

Меняй здесь:
- Цвета (`Color(0x...`)
- Текст
- Размеры
- Анимации

Все изменения применятся в реальном времени!

## 📱 Собрать Android APK

```bash
gradle assembleDebug
```

Результат: `composeApp/build/outputs/apk/debug/app-debug.apk`

## 🆘 Если не запустилось

```bash
# Очистить и пересобрать
gradle clean :composeApp:build -x test

# С подробным логом
gradle :composeApp:desktopRun --continuous --info
```

---

**Готово к разработке!** 🚀
