# Инструкции по настройке и установке

## Обзор
Это пошаговое руководство для настройки окружения разработки "Магический Артефакт" на Windows.

## Системные требования
- **ОС**: Windows 10/11 (64-bit)
- **ОЗУ**: минимум 8GB
- **Память**: минимум 10GB свободно
- **Интернет**: требуется для первоначальной загрузки

## Шаг 1: Установка Python

### 1.1 Скачивание Python
1. Перейти на [python.org](https://www.python.org/downloads/)
2. Скачать Python 3.9 или 3.10 (рекомендуется 3.9.13)
3. Запустить установщик

### 1.2 Настройка установки
Важно! При установке отметить:
- ✅ **Add Python to PATH**
- ✅ **Install for all users** (опционально)

### 1.3 Проверка установки
Открыть командную строку (cmd) и выполнить:
```bash
python --version
pip --version
```
Должны показать версии Python и pip.

## Шаг 2: Установка Kivy и зависимостей

### 2.1 Обновление pip
```bash
python -m pip install --upgrade pip
```

### 2.2 Установка Kivy
```bash
pip install kivy
```

### 2.3 Установка зависимостей Kivy
```bash
pip install kivy-deps.angle
pip install kivy-deps.glew
pip install kivy-deps.gstreamer
pip install kivy-deps.sdl2
```

### 2.4 Проверка Kivy
Создать тестовый файл `test_kivy.py`:
```python
from kivy.app import App
from kivy.uix.label import Label

class TestApp(App):
    def build(self):
        return Label(text='Kivy работает!')

if __name__ == '__main__':
    TestApp().run()
```

Запустить и проверить, появляется ли окно с надписью.

## Шаг 3: Установка голосовых библиотек

### 3.1 Установка openWakeWord
```bash
pip install openwakeword
```

### 3.2 Установка VOSK
```bash
pip install vosk
```

### 3.3 Установка PyAudio (для работы с микрофоном)
```bash
pip install pyaudio
```

**Примечание**: Если PyAudio не устанавливается, попробовать:
```bash
pip install pipwin
pipwin install pyaudio
```

### 3.4 Проверка микрофона
Создать тестовый файл `test_microphone.py`:
```python
import pyaudio
import sys

p = pyaudio.PyAudio()

print("Доступные аудиоустройства:")
for i in range(p.get_device_count()):
    info = p.get_device_info_by_index(i)
    if info['maxInputChannels'] > 0:
        print(f"{i}: {info['name']}")

p.terminate()
```

## Шаг 4: Установка Buildozer для Android

### 4.1 Установка Buildozer
```bash
pip install buildozer
```

### 4.2 Установка Android Studio
1. Скачать [Android Studio](https://developer.android.com/studio)
2. Установить с настройками по умолчанию
3. Запустить Android Studio

### 4.3 Настройка Android SDK
В Android Studio:
1. Открыть SDK Manager (Tools → SDK Manager)
2. Установить:
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - Android 10 (API 29) или выше
3. Запомнить путь к SDK

### 4.4 Установка NDK
В SDK Manager:
1. Перейти на вкладку "SDK Tools"
2. Отметить "NDK (Side by side)"
3. Установить

### 4.5 Настройка переменных окружения
Добавить в системные переменные PATH:
```
[PATH_TO_ANDROID_SDK]\platform-tools
[PATH_TO_ANDROID_SDK]\tools
[PATH_TO_ANDROID_SDK]\tools\bin
```

### 4.6 Проверка установки
```bash
adb version
```
Должна показать версию ADB.

## Шаг 5: Создание структуры проекта

### 5.1 Создание папок проекта
```bash
mkdir MagicArtifactApp
cd MagicArtifactApp
mkdir assets
mkdir assets\sounds
mkdir assets\spells
mkdir models
mkdir src
mkdir data
```

### 5.2 Создание основных файлов
Создать файлы:
- `main.py`
- `buildozer.spec`
- `requirements.txt`

### 5.3 Содержимое requirements.txt
```
kivy>=2.3.1
kivy-deps.angle
kivy-deps.glew
kivy-deps.gstreamer
kivy-deps.sdl2
openwakeword
vosk
pyaudio
buildozer
```

## Шаг 6: Скачивание моделей распознавания

### 6.1 Скачивание VOSK модели
1. Перейти на [VOSK Models](https://alphacephei.com/vosk/models)
2. Скачать русскую модель: `vosk-model-small-ru-0.22`
3. Распаковать в папку `models/`
4. Переименовать папку в `vosk-model-ru`

### 6.2 Настройка openWakeWord
Модель будет создана позже при обучении wake-word.

## Шаг 7: Настройка Buildozer

### 7.1 Создание buildozer.spec
Запустить в папке проекта:
```bash
buildozer init
```

### 7.2 Настройка buildozer.spec
Отредактировать файл `buildozer.spec`:
```ini
[app]
title = Магический Артефакт
package.name = magicartifact
package.domain = org.magicartifact
source.dir = .
source.include_exts = py,png,jpg,kv,atlas,json,mp3,mp4
version = 0.1
requirements = python3,kivy,kivy-deps.angle,kivy-deps.glew,kivy-deps.gstreamer,kivy-deps.sdl2,openwakeword,vosk,pyaudio

[buildozer]
log_level = 2

[android]
android.api = 29
android.ndk = 21
android.minapi = 21
android.sdk = 29
android.accept_sdk_license = True
```

## Шаг 8: Тестирование базового приложения

### 8.1 Создание тестового приложения
Создать `main.py`:
```python
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.core.window import Window

# Настройка полноэкранного режима
Window.fullscreen = 'auto'

class MagicArtifactApp(App):
    def build(self):
        layout = BoxLayout(orientation='vertical')
        label = Label(
            text='Магический Артефакт\nГотов к работе!',
            font_size='24sp',
            color=(1, 1, 1, 1)
        )
        layout.add_widget(label)
        return layout

if __name__ == '__main__':
    MagicArtifactApp().run()
```

### 8.2 Тестирование на компьютере
```bash
python main.py
```

### 8.3 Тестирование на Android
```bash
buildozer android debug deploy run
```

## Шаг 9: Поиск и устранение проблем

### Частые проблемы

#### Проблема: PyAudio не устанавливается
**Решение**:
```bash
pip install pipwin
pipwin install pyaudio
```

#### Проблема: Kivy не запускается
**Решение**: Установить Microsoft Visual C++ Redistributable

#### Проблема: Buildozer не находит Android SDK
**Решение**: Проверить переменные окружения ANDROID_HOME

#### Проблема: Ошибка при сборке APK
**Решение**: Обновить buildozer и зависимости

### Полезные команды
```bash
# Проверка установки Kivy
python -c "import kivy; print(kivy.__version__)"

# Проверка VOSK
python -c "import vosk; print('VOSK установлен')"

# Проверка openWakeWord
python -c "import openwakeword; print('openWakeWord установлен')"

# Очистка кэша Buildozer
buildozer android clean

# Пересборка APK
buildozer -v android debug
```

## Следующие шаги

После завершения настройки:
1. Прочитать PROJECT_PLAN.md
2. Начать с Этапа 2: Базовое Kivy приложение
3. Следовать инструкциям в DEVELOPMENT_NOTES.md

## Поддержка

Если возникли проблемы:
1. Проверить системные требования
2. Прочитать FAQ в документации
3. Проверить версии зависимостей
4. Обратиться к логам ошибок