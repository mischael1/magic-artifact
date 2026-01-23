# Заметки по разработке

## Ключевые технические решения

### 1. Выбор технологического стека

#### Почему Kivy + Python?
- **Преимущества**:
  - У пользователя есть опыт с Python
  - Полностью бесплатный и open-source
  - Кроссплатформенность (Windows, Android, iOS)
  - Активное сообщество и хорошая документация
  - Buildozer для простой Android сборки

- **Недостатки**:
  - Производительность ниже нативного кода
  - Размер APK больше из-за Python runtime
  - Некоторые Android фичи могут быть недоступны

#### Почему openWakeWord?
- **Преимущества**:
  - Полностью бесплатный
  - Поддерживает кастомные wake words
  - Хорошая производительность на ARM
  - Активно развивается
  - Python API

- **Недостатки**:
  - Требует обучения модели
  - Меньше документации чем коммерческие аналоги

#### Почему VOSK?
- **Преимущества**:
  - Бесплатный офлайн speech recognition
  - Отличная поддержка русского языка
  - Компактные модели (~50MB)
  - Streaming API для real-time
  - Python bindings

- **Недостатки**:
  - Точность может быть ниже облачных сервисов
  - Требует качественного микрофона

### 2. Архитектурные паттерны

#### MVC (Model-View-Controller)
```
Model:
- SpellManager (управление заклинаниями)
- VoiceManager (голосовое управление)

View:
- Kivy UI (интерфейс)
- MediaPlayer (воспроизведение медиа)

Controller:
- MagicArtifactApp (основное приложение)
- EventHandlers (обработка событий)
```

#### Observer Pattern
- VoiceManager уведомляет об активации wake-word
- SpellManager уведомляет о распознавании заклинания
- MediaPlayer уведомляет о завершении воспроизведения

### 3. Оптимизация производительности

#### Wake-word detection
```python
# Оптимизированная конфигурация
import openwakeword

oww = openwakeword.Model(
    wakeword_models=["models/wake_word_model.onnx"],
    inference_framework="onnx",
    enable_gpu=False  # для экономии батареи
)
```

#### Speech recognition
```python
# Оптимизация VOSK
import vosk
import json

class OptimizedVosk:
    def __init__(self):
        self.model = vosk.Model("models/vosk-model-ru")
        self.recognizer = vosk.KaldiRecognizer(self.model, 16000)
        
    def process_partial(self, data):
        if self.recognizer.AcceptWaveform(data):
            result = json.loads(self.recognizer.Result())
            return result['text']
        return None
```

#### Медиа оптимизация
```python
# Предзагрузка медиафайлов
class MediaCache:
    def __init__(self):
        self.cache = {}
        
    def preload(self, spell_id, media_paths):
        self.cache[spell_id] = {}
        for media_type, path in media_paths.items():
            if os.path.exists(path):
                self.cache[spell_id][media_type] = self.load_media(path)
```

## Потенциальные проблемы и решения

### 1. Производительность на ARM

#### Проблема
Wake-word detection может быть медленным на MediaTek Helio P22T

#### Решения
- Использовать ONNX runtime для оптимизации
- Уменьшить частоту дискретизации аудио
- Отключить GPU ускорение (может медленнее)
- Оптимизировать размер модели

```python
# Оптимизированные настройки
oww = openwakeword.Model(
    wakeword_models=["models/custom_wake_word.onnx"],
    inference_framework="onnx",
    custom_model_settings={
        "feature_window": 1.0,  # уменьшить окно
        "step_size": 0.5        # увеличить шаг
    }
)
```

### 2. Точность распознавания

#### Проблема
VOSK может ошибочно распознавать заклинания в шумной среде

#### Решения
- Использовать шумоподавление
- Настроить порог уверенности
- Добавить фильтрацию результатов
- Использовать множественные триггерные слова

```python
# Фильтрация результатов
class SpellFilter:
    def __init__(self, confidence_threshold=0.7):
        self.threshold = confidence_threshold
        
    def filter_spell(self, text, spell_list):
        text = text.lower().strip()
        best_match = None
        best_score = 0
        
        for spell_id, spell_data in spell_list.items():
            for trigger in spell_data['trigger_words']:
                score = self.calculate_similarity(text, trigger)
                if score > best_score and score > self.threshold:
                    best_score = score
                    best_match = spell_id
                    
        return best_match
```

### 3. Размер APK

#### Проблема
APK может быть >150MB из-за моделей распознавания

#### Решения
- Использовать split APKs
- Сжать модели распознавания
- Вынести медиа в отдельное скачивание
- Использовать APK expansion files

```python
# buildozer.spec оптимизация
android.add_assets = assets/*
android.add_libs = libs/*
android.split_apks = True
android.apk_expansion = True
```

### 4. Управление памятью

#### Проблема
Приложение может использовать много памяти с медиафайлами

#### Решения
- Ленивая загрузка медиа
- Очистка кэша после использования
- Ограничение размера кэша
- Использование streaming для видео

```python
# Управление памятью
class MemoryManager:
    def __init__(self, max_cache_size=100):
        self.max_size = max_cache_size
        self.cache = {}
        
    def get_media(self, path):
        if path not in self.cache:
            if len(self.cache) >= self.max_size:
                self.cleanup_cache()
            self.cache[path] = self.load_media(path)
        return self.cache[path]
        
    def cleanup_cache(self):
        # Удалить самые старые элементы
        oldest_items = sorted(self.cache.items(), 
                            key=lambda x: x[1].load_time)[:10]
        for key, _ in oldest_items:
            del self.cache[key]
```

## Тестирование

### 1. Unit тесты

#### VoiceManager тесты
```python
import unittest
from unittest.mock import Mock, patch

class TestVoiceManager(unittest.TestCase):
    def setUp(self):
        self.voice_manager = VoiceManager()
        
    @patch('openwakeword.Model')
    def test_wake_word_detection(self, mock_model):
        mock_model.return_value.predict.return_value = [0.9]
        result = self.voice_manager.detect_wake_word(audio_data)
        self.assertTrue(result)
        
    def test_spell_recognition(self):
        with patch('vosk.KaldiRecognizer') as mock_rec:
            mock_rec.return_value.Result.return_value = '{"text": "огненный шар"}'
            result = self.voice_manager.recognize_spell(audio_data)
            self.assertEqual(result, "огненный шар")
```

#### SpellManager тесты
```python
class TestSpellManager(unittest.TestCase):
    def setUp(self):
        self.spell_manager = SpellManager("data/spells.json")
        
    def test_spell_matching(self):
        result = self.spell_manager.find_spell("огненный шар")
        self.assertEqual(result, "огненный_шар")
        
    def test_spell_not_found(self):
        result = self.spell_manager.find_spell("несуществующее заклинание")
        self.assertIsNone(result)
```

### 2. Интеграционные тесты

#### Полный цикл активации
```python
class TestFullCycle(unittest.TestCase):
    def test_wake_word_to_spell(self):
        # Симуляция полного цикла
        voice_manager = VoiceManager()
        spell_manager = SpellManager()
        media_player = MediaPlayer()
        
        # Wake-word детектирован
        voice_manager.on_wake_word_detected()
        
        # Заклинание распознано
        spell_data = spell_manager.find_spell("огненный шар")
        
        # Медиа воспроизведено
        media_player.play_spell(spell_data)
        
        # Проверка состояния
        self.assertTrue(media_player.is_playing())
```

### 3. Тестирование на устройстве

#### Производительность тесты
```python
import time
import psutil

class PerformanceTest:
    def test_wake_word_latency(self):
        start_time = time.time()
        # ... wake word detection ...
        latency = time.time() - start_time
        assert latency < 0.1, f"Wake word latency too high: {latency}"
        
    def test_memory_usage(self):
        process = psutil.Process()
        memory_before = process.memory_info().rss
        
        # ... загрузка и использование приложения ...
        
        memory_after = process.memory_info().rss
        memory_increase = memory_after - memory_before
        assert memory_increase < 200 * 1024 * 1024, "Memory usage too high"
```

## Логирование и отладка

### Структура логирования
```python
import logging

# Настройка логирования
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('magic_artifact.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger('MagicArtifact')

class VoiceManager:
    def __init__(self):
        logger.info("VoiceManager initialized")
        
    def detect_wake_word(self, audio_data):
        logger.debug("Processing wake word detection")
        try:
            result = self.oww.predict(audio_data)
            logger.info(f"Wake word detection result: {result}")
            return result
        except Exception as e:
            logger.error(f"Wake word detection failed: {e}")
            return False
```

### Отладка на Android
```python
# Android логирование
from kivy.logger import Logger

class AndroidDebug:
    @staticmethod
    def log(message, level='info'):
        if platform == 'android':
            from jnius import autoclass
            PythonActivity = autoclass('org.kivy.android.PythonActivity')
            PythonActivity.mActivity.logger.log(level, message)
        else:
            print(f"DEBUG: {message}")
```

## Релиз и дистрибуция

### Подготовка к релизу
1. **Оптимизация кода**: удалить debug логирование
2. **Сжатие медиа**: оптимизировать все медиафайлы
3. **Тестирование**: полное тестирование на устройстве
4. **Документация**: обновить все инструкции

### Сборка релиза
```bash
# Очистка
buildozer android clean

# Релизная сборка
buildozer -v android release

# Подпись APK (если нужно)
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
    -keystore release.keystore bin/MagicArtifactApp-release-unsigned.apk alias_name
```

### Установка на устройство
```bash
# Установка через ADB
adb install bin/MagicArtifactApp-release.apk

# Проверка установки
adb shell pm list packages | grep magicartifact
```

## Мониторинг и аналитика

### Метрики производительности
- Время запуска приложения
- Задержка wake-word detection
- Точность распознавания заклинаний
- Использование памяти и батареи
- Частота активации заклинаний

### Сбор метрик
```python
import time
import psutil

class MetricsCollector:
    def __init__(self):
        self.metrics = {}
        
    def record_startup_time(self):
        self.metrics['startup_time'] = time.time()
        
    def record_wake_word_latency(self, latency):
        self.metrics['wake_word_latency'].append(latency)
        
    def record_memory_usage(self):
        process = psutil.Process()
        self.metrics['memory_usage'].append(process.memory_info().rss)
        
    def get_report(self):
        return {
            'avg_wake_word_latency': sum(self.metrics['wake_word_latency']) / len(self.metrics['wake_word_latency']),
            'max_memory_usage': max(self.metrics['memory_usage']),
            'total_spells_cast': len(self.metrics['spells_cast'])
        }
```

## Будущие улучшения

### Краткосрочные (1-2 месяца)
- Добавить визуальные индикаторы состояния
- Улучшить обработку ошибок
- Оптимизировать размер APK
- Добавить настройки громкости

### Среднесрочные (3-6 месяцев)
- Поддержка нескольких языков
- Система комбо-заклинаний
- Режим обучения wake-word
- Интеграция с внешними эффектами

### Долгосрочные (6+ месяцев)
- Машинное обучение для улучшения распознавания
- Сеть из нескольких артефактов
- Интеграция с LARP системами
- VR/AR поддержка