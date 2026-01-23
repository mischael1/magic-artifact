# 🚀 СОБРАТЬ APK ПРЯМО СЕЙЧАС

## Вариант 1: GitHub Actions (ТА САМОЕ БЫСТРОЕ)

### Шаг 1: Push на GitHub

```bash
git init
git add .
git commit -m "build"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/magic-artifact
git push -u origin main
```

### Шаг 2: GitHub соберет APK автоматически

1. Перейдите на **https://github.com/YOUR_USERNAME/magic-artifact/actions**
2. Должен запуститься workflow **Build APK**
3. Ждите 20-30 минут
4. Когда зелено ✅ - скачайте APK из **Artifacts**

### Шаг 3: Установите на планшет

```bash
adb install -r magicartifact-0.1-debug.apk
```

---

## Вариант 2: GitHub Codespaces

### Шаг 1: Откройте Codespaces

На GitHub: `Code` → `Codespaces` → `Create codespace on main`

### Шаг 2: Выполните в терминале

```bash
python3 build_apk.py
```

Ждите 15 минут.

### Шаг 3: Скачайте APK

В файловом браузере Codespaces: `bin/magicartifact-0.1-debug.apk` → Download

---

## ✅ Файл готов? Проверьте:

После успешной сборки должен быть:
- `bin/magicartifact-0.1-debug.apk` (~50-100 MB)

Если файл есть → можно устанавливать на планшет!

```bash
adb install -r magicartifact-0.1-debug.apk
```

**ГОТОВО!** 🎉
