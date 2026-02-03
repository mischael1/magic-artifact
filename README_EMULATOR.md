# 🚀 Magic Artifact - Android Emulator Setup

## ✅ Что уже сделано

- ✅ Эмулятор Android запущен (Pixel_6, API 35)
- ✅ Скрипт `run_emulator.bat` ожидает APK файла
- ✅ Эмулятор готов к установке приложения

## 📋 Что нужно сделать

### ШАГ 1: Собрать APK в Google Colab

1. Откройте **Google Colab**: https://colab.research.google.com/
2. Загрузите файл `COLAB_BUILD_FINAL.ipynb` (из этой папки)
3. Загрузите ZIP архив проекта (сожмите папку opencode в ZIP)
4. Запустите ячейки по порядку:
   - **Ячейка 1**: Распаковка проекта (~30 сек)
   - **Ячейка 2**: Установка зависимостей (~2 мин)
   - **Ячейка 3**: Android SDK (~15 мин)
   - **Ячейка 4**: СБОРКА APK (**60-120 минут** - это нормально!)
   - **Ячейка 5**: Скачивание APK
5. Скачайте файл `magicartifact-0.1-debug.apk` из Files

### ШАГ 2: Поместить APK в папку

Поместите скачанный APK по пути:
```
C:\Users\GIGABYTE\opencode\bin\magicartifact-0.1-debug.apk
```

Батник автоматически обнаружит файл и установит его!

### ШАГ 3: Просмотр результатов

Батник автоматически:
1. ✅ Установит APK в эмулятор
2. ✅ Запустит приложение
3. ✅ Покажет логи в реальном времени

## 🔧 Ручное управление (если нужно)

Откройте PowerShell и выполните:

```powershell
# Добавить adb в PATH
$env:Path += ";C:\Users\GIGABYTE\AppData\Local\Android\Sdk\platform-tools"

# Посмотреть подключенные устройства
adb devices

# Установить APK
adb install -r "C:\Users\GIGABYTE\opencode\bin\magicartifact-0.1-debug.apk"

# Запустить приложение
adb shell am start -n org.magicartifact.magicartifact/org.kivy.android.PythonActivity

# Смотреть логи (в отдельном PowerShell)
adb logcat | findstr python

# Очистить данные приложения
adb shell pm clear org.magicartifact.magicartifact
```

## 📝 Структура файлов

```
opencode/
├── COLAB_BUILD_FINAL.ipynb      ← Используй этот для сборки APK
├── run_emulator.bat             ← Батник (ждет APK и устанавливает)
├── run_app.ps1                  ← PowerShell скрипт
├── main.py                      ← Главное приложение
├── src/
│   ├── spell_manager.py
│   ├── voice_manager.py
│   └── media_player.py
├── data/
│   └── spells.json
├── assets/
│   ├── images/
│   ├── sounds/
│   └── spells/
└── bin/
    └── magicartifact-0.1-debug.apk  ← Сюда положить APK
```

## 🎯 Процесс работы

1. **Разработка кода** → Тестирование на эмуляторе
2. **Обновление** → Пересборка в Colab
3. **Установка** → APK автоматически устанавливается батником
4. **Отладка** → Логи видны сразу в окне батника

## ❓ Если что-то не работает

### Батник ждет APK, но я забыл собрать

1. Соберите APK в Colab (см. ШАГ 1)
2. Скачайте файл
3. Поместите в папку `bin/`
4. Батник автоматически установит

### Логи не показываются

Откройте второе окно PowerShell:
```powershell
$env:Path += ";C:\Users\GIGABYTE\AppData\Local\Android\Sdk\platform-tools"
adb logcat | findstr python
```

### Эмулятор закрылся

Откройте Android Studio → Device Manager → запустите эмулятор заново

## 📊 Время выполнения

- Ячейка 1 (распаковка): **~30 сек**
- Ячейка 2 (зависимости): **~2 мин**
- Ячейка 3 (SDK): **~15 мин**
- Ячейка 4 (сборка): **60-120 мин** ⏳
- Ячейка 5 (скачивание): **~30 сек**

**ИТОГО: ~2 часа на первую сборку**

Последующие сборки будут быстрее (~40-60 мин) потому что зависимости уже загружены.

## 🎮 Прямая работа с эмулятором

Батник `run_emulator.bat` можно запустить в любое время:
- Двойной клик на файл
- Или из PowerShell: `.\run_emulator.bat`

---

**Status**: ✅ Эмулятор готов, ожидает APK файла
