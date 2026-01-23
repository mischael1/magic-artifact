# Сборка APK в GitHub Codespaces

## ⚡ Быстрый способ получить APK без установки на компьютер

### Шаг 1: Загрузите проект на GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/magic-artifact
git push -u origin main
```

### Шаг 2: Откройте Codespaces

1. Перейдите на **https://github.com/YOUR_USERNAME/magic-artifact**
2. Нажмите зеленую кнопку **< > Code**
3. Перейдите на вкладку **Codespaces**
4. Нажмите **Create codespace on main**
5. Дождитесь загрузки (2-3 минуты)

### Шаг 3: Соберите APK

В терминале Codespaces выполните:

```bash
cd /workspaces/magic-artifact
python3 build_apk.py
```

**Ждите 10-15 минут** пока собирается APK.

### Шаг 4: Скачайте APK

После завершения:

1. В файловом браузере Codespaces найдите `bin/magicartifact-0.1-debug.apk`
2. Щелкните правой кнопкой → **Download**
3. Сохраните на компьютер

### Шаг 5: Установите на планшет

```bash
adb install -r magicartifact-0.1-debug.apk
```

---

## 📊 Преимущества GitHub Codespaces

✅ Бесплатно (60 часов в месяц)  
✅ Ничего не нужно устанавливать  
✅ Linux окружение уже подготовлено  
✅ Android SDK устанавливается автоматически  
✅ Быстро (10-15 минут на сборку)

---

## ⏱️ Ожидаемое время

- Создание Codespaces: 2-3 минуты
- Установка зависимостей: 5-8 минут (автоматически)
- Сборка APK: 10-15 минут
- **Итого: 20-25 минут**

---

## 🆘 Если Codespaces не создается

Используйте GitHub Actions вместо этого (см. QUICK_BUILD.md)
