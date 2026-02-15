# Установка Vosk JAR файлов для распознавания речи

## Что нужно сделать

1. **Скачать Vosk JAR файлы с GitHub:**
   - Перейти: https://github.com/alphacephei/vosk-api/releases
   - Скачать **vosk-windows-x64.zip** (или вашу версию ОС)

2. **Распаковать архив**
   - Распакуй где-нибудь
   - Найди файл **vosk.jar** (примерно 30 МБ)
   - Найди файлы с JNI библиотеками (**vosk.dll**, **libvosk.so** и т.д.)

3. **Скопировать JAR в проект:**
   ```
   c:\Users\GIGABYTE\opencode\composeApp\libs\vosk.jar
   ```

4. **Скачать языковую модель:**
   - Перейти: https://alphacephei.com/vosk/models
   - Скачать модель для твоего языка (например: **vosk-model-en-us-0.22.zip**)
   - Распаковать в:
   ```
   %USERPROFILE%\.vosk\model-en-us
   ```
   (по умолчанию: C:\Users\GIGABYTE\AppData\Roaming\.vosk\model-en-us)

5. **Запустить приложение:**
   ```powershell
   cd c:\Users\GIGABYTE\opencode
   .\run_app.ps1
   ```

## Что произойдет

Когда JAR файлы будут на месте:
- Приложение инициализирует Vosk
- Нажимаешь кнопку LISTEN
- Говоришь слово (Огонь/Fire, Лед/Ice, Молния/Lightning)
- Vosk транскрибирует речь в текст
- Приложение распознает слово и тригирует спелл

## Если не работает

1. **Проверь что JAR файлы в папке:**
   ```
   c:\Users\GIGABYTE\opencode\composeApp\libs\
   ```

2. **Проверь что модель на месте:**
   ```
   c:\Users\GIGABYTE\AppData\Roaming\.vosk\model-en-us\
   ```

3. **Посмотри консоль на ошибки:**
   - "Vosk initialized successfully" - значит всё работает
   - "Vosk model not found" - скачай модель
   - "ClassNotFoundException" - JAR файлы не найдены

## Альтернатива

Если проблемы с Vosk - скажи, можем использовать другой подход (например, Python скрипт для распознавания).
