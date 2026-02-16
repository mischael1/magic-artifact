# Быстрое тестирование Vosk интеграции

## Готовность проекта

✅ Компиляция - успешно  
✅ Интеграция - завершена  
✅ Модель - на месте (assets/model-en-us/)

## Команды для тестирования

### Очистка и пересборка
```bash
gradlew clean compileDebugKotlin
```

### Сборка APK (debug)
```bash
gradlew assembleDebug
```

### Запуск на эмуляторе
```bash
adb install -r app-debug.apk
adb shell am start -n com.magicartifact.debug/com.magicartifact.MainActivity
```

## Проверочный список

### При запуске приложения:

- [ ] Приложение запускается без крашей
- [ ] Видна UI с кнопками "Начать", "Стоп", "Очистить"
- [ ] Список заклинаний отображается (5 шт)
- [ ] Статус показывает "Готов к распознаванию"

### При нажатии "Начать":

- [ ] Статус меняется на "🎤 Слушаю..."
- [ ] Приложение слушает микрофон (проверить по логам)
- [ ] Нет крашей в logcat

### Проверка распознавания:

1. Нажать "Начать"
2. Сказать одно из слов: "огненный", "ледяной", "щит", "исцеление", "молния"
3. Проверить:
   - [ ] Распознаннный текст появляется в UI
   - [ ] Если совпадение найдено - появляется информация о заклинании
   - [ ] Статус обновляется корректно

### Проверка логов

```bash
adb logcat | grep VoiceManager
adb logcat | grep SpellRecognizer
adb logcat | grep MainActivity
```

Ищите:
- ✅ `Model loaded successfully`
- ✅ `Starting speech recognition`
- ✅ `onFinalResult` и распознанный текст
- ✅ `findSpell` и результаты

### При нажатии "Стоп":

- [ ] Микрофон останавливается
- [ ] Статус меняется на "Остановлено"
- [ ] Нет ошибок в логах

### При нажатии "Очистить":

- [ ] Текст очищается
- [ ] Найденное заклинание исчезает
- [ ] Статус возвращается к "Готов к распознаванию"

## Логирование

### Основные логи для проверки

```
D/VoiceManager: LibVosk initialized
D/VoiceManager: Model loaded successfully
D/VoiceManager: Starting speech recognition
D/VoiceManager: onPartialResult: слово в процессе
D/VoiceManager: onFinalResult: полное предложение
D/SpellRecognizer: findSpell called with text: 'огненный шар'
D/SpellRecognizer: New best match: Огненный шар with score 1.0
```

### Проверка ошибок

Если нет логов `Model loaded successfully`:
- Проверить что model-en-us находится в assets
- Проверить permissions RECORD_AUDIO в AndroidManifest.xml
- Проверить что устройство выдало разрешение на микрофон

Если нет распознавания:
- Проверить что микрофон работает
- Проверить логи Vosk в logcat (может быть `onError` или `onTimeout`)
- Попробовать говорить громче и четче

## Файлы для отладки

После запуска приложение создает логи:
- `logcat` - основные логи Android
- `adb logcat > logs.txt` - сохранить логи в файл

## Ссылки на документацию

- `INTEGRATION_SUMMARY.md` - полная сводка изменений
- `VOSK_INTEGRATION_OFFICIAL.md` - подробное описание архитектуры

## Если что-то не работает

1. Проверить логи: `adb logcat | grep "VoiceManager\|SpellRecognizer"`
2. Проверить разрешения: Settings > Apps > MagicArtifact > Permissions > Microphone
3. Проверить что модель распакована: `adb shell ls /data/data/com.magicartifact/files/model/`
4. Пересобрать проект: `gradlew clean assembleDebug`

## Ожидаемые результаты

| Слово | Заклинание | Коэффициент |
|-------|-----------|------------|
| огненный | Огненный шар | 0.5-1.0 |
| шар | Огненный шар | 0.5-1.0 |
| ледяной | Ледяной удар | 0.5-1.0 |
| щит | Магический щит | 0.7-1.0 |
| исцеление | Исцеление | 1.0 |
| молния | Молния | 1.0 |

Порог совпадения: **0.6**
