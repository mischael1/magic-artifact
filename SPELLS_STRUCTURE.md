# Структура заклинаний

## Обзор
Система заклинаний основана на JSON конфигурации с поддержкой множественных триггерных слов и медиаэффектов.

## Формат spells.json

### Основная структура
```json
{
  "meta": {
    "version": "1.0",
    "language": "ru",
    "wake_word": "артефакт",
    "auto_reset_timeout": 30
  },
  "spells": {
    "огненный_шар": {
      "name": "Огненный шар",
      "trigger_words": ["огненный шар", "фаер болл", "fireball"],
      "description": "Создает мощный огненный снаряд",
      "media": {
        "video": "spells/fireball/video.mp4",
        "image": "spells/fireball/image.jpg",
        "sound": "spells/fireball/sound.mp3"
      },
      "duration": 5000,
      "cooldown": 0,
      "effects": ["fire", "explosion"]
    },
    "лечение": {
      "name": "Лечебное заклинание",
      "trigger_words": ["лечение", "хил", "heal", "исцеление"],
      "description": "Восстанавливает здоровье",
      "media": {
        "video": "spells/heal/video.mp4",
        "image": "spells/heal/image.jpg",
        "sound": "spells/heal/sound.mp3"
      },
      "duration": 3000,
      "cooldown": 0,
      "effects": ["heal", "light"]
    }
  },
  "settings": {
    "volume": 0.8,
    "auto_play": true,
    "fallback_image": "assets/default_spell.jpg"
  }
}
```

## Поля описания

### Meta секция
- `version`: версия конфигурации
- `language`: язык кода (ISO 639-1)
- `wake_word`: фраза активации
- `auto_reset_timeout`: время автосброса в секундах

### Spell секция
- `name`: отображаемое имя заклинания
- `trigger_words`: массив фраз для активации
- `description`: описание заклинания
- `media`: пути к медиафайлам
- `duration`: длительность эффекта в миллисекундах
- `cooldown": время перезарядки (будущее)
- `effects`: массив тегов эффектов

### Media секция
- `video`: путь к видеофайлу (опционально)
- `image`: путь к изображению (опционально)
- `sound`: путь к аудиофайлу (опционально)

**Примечание**: Хотя бы один медиафайл обязателен

## Примеры заклинаний

### 1. Огненные заклинания
```json
"огненный_шар": {
  "name": "Огненный шар",
  "trigger_words": ["огненный шар", "фаер болл", "fireball"],
  "media": {
    "video": "spells/fireball/video.mp4",
    "sound": "spells/fireball/explosion.mp3"
  },
  "duration": 5000,
  "effects": ["fire", "explosion"]
},
"пламя": {
  "name": "Пламя",
  "trigger_words": ["пламя", "огонь", "flame"],
  "media": {
    "video": "spells/flame/video.mp4",
    "sound": "spells/flame/fire_sound.mp3"
  },
  "duration": 3000,
  "effects": ["fire"]
}
```

### 2. Лечебные заклинания
```json
"лечение": {
  "name": "Лечение",
  "trigger_words": ["лечение", "хил", "heal"],
  "media": {
    "video": "spells/heal/video.mp4",
    "sound": "spells/heal/heal_sound.mp3"
  },
  "duration": 4000,
  "effects": ["heal", "light"]
},
"возрождение": {
  "name": "Возрождение",
  "trigger_words": ["возрождение", "ресурект", "resurrect"],
  "media": {
    "video": "spells/resurrect/video.mp4",
    "sound": "spells/resurrect/divine_sound.mp3"
  },
  "duration": 8000,
  "effects": ["heal", "divine", "light"]
}
```

### 3. Защитные заклинания
```json
"магический_щит": {
  "name": "Магический щит",
  "trigger_words": ["щит", "защита", "shield"],
  "media": {
    "video": "spells/shield/video.mp4",
    "sound": "spells/shield/shield_sound.mp3"
  },
  "duration": 6000,
  "effects": ["shield", "magic"]
}
```

### 4. Темные заклинания
```json
"темная_стрела": {
  "name": "Темная стрела",
  "trigger_words": ["темная стрела", "дарк болт", "dark bolt"],
  "media": {
    "video": "spells/dark_arrow/video.mp4",
    "sound": "spells/dark_arrow/dark_sound.mp3"
  },
  "duration": 4000,
  "effects": ["dark", "damage"]
}
```

## Структура медиафайлов

### Рекомендуемая структура папок
```
assets/
├── spells/
│   ├── fireball/
│   │   ├── video.mp4
│   │   ├── image.jpg
│   │   └── sound.mp3
│   ├── heal/
│   │   ├── video.mp4
│   │   ├── image.jpg
│   │   └── sound.mp3
│   └── ...
├── sounds/
│   ├── wake_detected.mp3
│   ├── spell_success.mp3
│   ├── spell_fail.mp3
│   └── ambient.mp3
└── images/
    ├── background.jpg
    ├── loading.gif
    └── default_spell.jpg
```

### Форматы медиафайлов

#### Видео
- **Формат**: MP4 (H.264)
- **Разрешение**: 1280x720 или 1920x1080
- **Частота кадров**: 24-30 FPS
- **Битрейт**: 2-5 Mbps
- **Длительность**: 3-10 секунд

#### Аудио
- **Формат**: MP3 или WAV
- **Частота дискретизации**: 44.1 kHz
- **Битрейт**: 128-320 kbps
- **Каналы**: стерео или моно
- **Длительность**: 2-8 секунд

#### Изображения
- **Формат**: JPG или PNG
- **Разрешение**: 1280x720 или выше
- **Качество**: 80-95%
- **Размер файла**: <500KB

## Система匹配

### Алгоритм распознавания
1. **Нормализация**: приведение к нижнему регистру
2. **Токенизация**: разбиение на слова
3. **Сравнение**: поиск совпадений в trigger_words
4. **Рейтинг**: выбор лучшего совпадения
5. **Активация**: воспроизведение медиа

### Пример匹配
```
Ввод: "артефакт огненный шар"
1. Wake-word: "артефакт" ✅
2. Команда: "огненный шар"
3. Поиск в trigger_words:
   - "огненный шар" ✅ (точное совпадение)
   - "фаер болл" ❌
   - "fireball" ❌
4. Результат: заклинание "огненный_шар" активировано
```

### Обработка ошибок
- **Нет совпадений**: воспроизвести звук ошибки
- **Несколько совпадений**: выбрать с наивысшим рейтингом
- **Слишком короткая команда**: проигнорировать
- **Слишком длинная команда**: обрезать до 5 слов

## Расширение системы

### Добавление новых заклинаний
1. Создать папку в `assets/spells/`
2. Добавить медиафайлы
3. Обновить `spells.json`
4. Перезапустить приложение

### Мультиязычная поддержка
```json
"spells": {
  "fireball": {
    "name": {
      "ru": "Огненный шар",
      "en": "Fireball"
    },
    "trigger_words": {
      "ru": ["огненный шар", "фаер болл"],
      "en": ["fireball", "fire ball"]
    }
  }
}
```

### Будущие функции
- **Кулдаун**: время перезарядки заклинаний
- **Комбо**: последовательности заклинаний
- **Условия**: требования для активации
- **Модификаторы**: усиление или ослабление эффектов

## Валидация

### Проверка JSON
```python
import json

def validate_spells(spells_data):
    required_fields = ["meta", "spells"]
    for field in required_fields:
        if field not in spells_data:
            return False, f"Missing field: {field}"
    return True, "Valid"
```

### Проверка медиафайлов
```python
import os

def check_media_files(spells_data, base_path):
    missing_files = []
    for spell_id, spell_data in spells_data["spells"].items():
        for media_type, media_path in spell_data["media"].items():
            full_path = os.path.join(base_path, media_path)
            if not os.path.exists(full_path):
                missing_files.append(full_path)
    return missing_files
```

## Производительность

### Оптимизация
- Предзагрузка медиафайлов
- Кэширование результатов
- Сжатие медиа
- Ленивая загрузка

### Мониторинг
- Время распознавания
- Время загрузки медиа
- Использование памяти
- Частота активации