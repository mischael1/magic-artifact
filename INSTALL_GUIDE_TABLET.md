# УПРОЩЕННАЯ ИНСТРУКЦИЯ ДЛЯ ПЛАНШЕТА LENOVO TAB M10 FHD PLUS

## 🚀️ ЕСЛИ У ВАС УЖЕСТ ANDROID STUDIO:
1. **Скачайте Android Studio** с официального сайта: https://developer.android.com/studio
2. **Установите** с стандартными настройками
3. **Запустите Android Studio** и дождитесь завершения установки
4. **Откройте SDK Manager** через Tools → SDK Manager
5. **Установите**: 
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - Android SDK Platform-Tools (поставьте галочки "Android 9.0+" или выше)

## 📱 ЕСЛИ У ВАС НЕТ ANDROID STUDIO:

### Вариант 1: Установить только SDK и Buildozer
1. **Скачайте Command Line Tools** (146 MB):
   - Перейдите на: https://developer.android.com/studio/install
   - Прокрутите вниз до "Get the command line tools only"
   - Скачайте версию для Windows

2. **Распакуйте архив** в папку: `C:\AndroidSDK`
3. **Добавьте в PATH**:
   ```
   C:\AndroidSDK\platform-tools
   C:\AndroidSDK\build-tools
   C:\AndroidSDK\platform-tools\bin
   ```

4. **Установите переменные окружения**:
   ```cmd
   set ANDROID_HOME=C:\AndroidSDK
   set PATH=%PATH%;C:\AndroidSDK\platform-tools;C:\AndroidSDK\build-tools
   ```

5. **Проверьте установку**:
   ```cmd
   adb version
   ```

### Вариант 2: Использовать готовые файлы
1. Я скачаю Command Line Tools и подготовлю их для вас
2. Распакую в удобную папку с инструкциями

## 📋 ПОДКЛЮЧАНИЕ ПЛАНШЕТА:

### Шаг 1: Установка инструментов
```bash
# 1. Установка Python зависимостей (уже сделано)
pip install kivy openwakeword vosk pyaudio numpy Pillow buildozer

# 2. Скачайте Command Line Tools
# (Я помогу скачать, если нужно)
```

### Шаг 2: Сборка APK
```bash
cd "C:\Users\GIGABYTE\opencode"
buildozer -v android debug
```

### Шаг 3: Установка на планшет
```bash
# 1. Подключите планшет к компьютеру
# 2. Разрешите установку из неизвестных источников в настройках Android
# 3. Скачайте APK и установите

adb install bin/MagicArtifactApp-debug.apk
```

### Шаг 4: Тестирование
```bash
# Проверка установки
adb shell pm list packages | findstr magicartifact

# Запуск приложения
adb shell am start -n com.magicartifact/.MainActivity

# Просмотр логов
adb logcat | findstr MagicArtifact
```

## 📱 ВАЖНЫЕ ФАЙЛЫ:

1. **Разрешение**: Установку из неизвестных источников в настройках безопасности Android
2. **Место для APK**: Скопируйте APK в папку "Downloads" планшета
3. **Батарея**: Убедитесь что планшет заряжен перед установкой
4. **Память**: Убедитесь достаточно места (APK ~30-50MB)

## 📞 ДЛЯ ПРОСМОТРА:

Как только установите и протестируете, я помогу вам с любыми проблемами! 
Свяжитесь со мной через этот чат.

## 🎯 ГОТОВО К ТЕСТУ:

После установки:
1. ✅ **Проверить полноэкранный режим**
2. ✅ **Тестировать wake-word ("артефакт")**
3. ✅ **Тестировать русские заклинания**
4. ✅ **Проверить визуальные эффекты**

---

## 🎉 Начинаем установку?

Вы хотите чтобы я помог с:
1. **Скачал Command Line Tools** и подготовил их для вас?
2. **Дождать пока вы установите Android Studio**?
3. **Сразу перейти к сборке APK** используя мой компьютер?

Дайте знать, какой вариант вам подходит! 🚀️