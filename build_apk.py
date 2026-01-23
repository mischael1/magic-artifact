#!/usr/bin/env python3
"""
Скрипт для сборки APK приложения Магический Артефакт

Использование:
    python build_apk.py [clean] [release]
    
Примеры:
    python build_apk.py              # Собрать debug APK
    python build_apk.py clean        # Очистить и собрать
    python build_apk.py release      # Собрать release APK
"""

import os
import sys
import subprocess
import platform
import shutil
from pathlib import Path

class APKBuilder:
    def __init__(self):
        self.project_dir = Path(__file__).parent
        self.platform = platform.system()
        self.is_wsl = self._check_wsl()
        
    def _check_wsl(self):
        """Проверяет, работаем ли в WSL"""
        return "microsoft" in platform.release().lower()
    
    def log(self, msg, level="INFO"):
        """Логирование"""
        symbols = {
            "INFO": "ℹ️",
            "SUCCESS": "✅",
            "ERROR": "❌",
            "WARN": "⚠️",
            "BUILD": "🔨",
            "CLEAN": "🧹"
        }
        symbol = symbols.get(level, "•")
        print(f"{symbol} {msg}")
    
    def check_requirements(self):
        """Проверяет наличие требуемых инструментов"""
        self.log("Проверка требований...", "INFO")
        
        required = {
            "buildozer": "Buildozer",
            "java": "Java JDK",
        }
        
        missing = []
        for cmd, name in required.items():
            if not shutil.which(cmd):
                missing.append(name)
                self.log(f"{name} не найден", "WARN")
            else:
                self.log(f"{name} найден", "SUCCESS")
        
        if missing:
            self.log("", "ERROR")
            self.log(f"Не установлены: {', '.join(missing)}", "ERROR")
            
            if self.platform == "Windows":
                self.log("", "INFO")
                self.log("Для Windows используйте WSL2:", "INFO")
                self.log("  wsl --install -d Ubuntu-22.04", "INFO")
                self.log("  (затем в WSL установите buildozer)", "INFO")
            elif self.platform == "Darwin":
                self.log("", "INFO") 
                self.log("Для macOS используйте Homebrew:", "INFO")
                self.log("  brew install android-platform-tools", "INFO")
            else:
                self.log("", "INFO")
                self.log("Для Linux установите:", "INFO")
                self.log("  sudo apt-get install buildozer openjdk-11-jdk", "INFO")
            
            return False
        
        self.log("Все требования выполнены", "SUCCESS")
        return True
    
    def clean(self):
        """Очищает предыдущую сборку"""
        self.log("Очистка предыдущей сборки...", "CLEAN")
        
        try:
            result = subprocess.run(
                ["buildozer", "android", "clean"],
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=300
            )
            
            if result.returncode == 0:
                self.log("Очистка завершена", "SUCCESS")
                return True
            else:
                self.log(f"Ошибка при очистке: {result.stderr}", "ERROR")
                return False
                
        except subprocess.TimeoutExpired:
            self.log("Очистка заняла слишком много времени", "ERROR")
            return False
        except Exception as e:
            self.log(f"Ошибка: {e}", "ERROR")
            return False
    
    def build_debug(self):
        """Собирает debug APK"""
        self.log("Начало сборки debug APK...", "BUILD")
        self.log("(это может занять 15-30 минут на первой сборке)", "INFO")
        
        try:
            result = subprocess.run(
                ["buildozer", "android", "debug"],
                cwd=self.project_dir,
                timeout=3600  # 1 час таймаут
            )
            
            if result.returncode == 0:
                self.log("APK успешно собран!", "SUCCESS")
                return self._find_apk("debug")
            else:
                self.log("Ошибка при сборке APK", "ERROR")
                return None
                
        except subprocess.TimeoutExpired:
            self.log("Сборка заняла слишком много времени (>1 часа)", "ERROR")
            return None
        except Exception as e:
            self.log(f"Ошибка при сборке: {e}", "ERROR")
            return None
    
    def build_release(self):
        """Собирает release APK"""
        self.log("Начало сборки release APK...", "BUILD")
        self.log("Убедитесь, что у вас есть сертификат подписи", "WARN")
        
        try:
            result = subprocess.run(
                ["buildozer", "android", "release"],
                cwd=self.project_dir,
                timeout=3600
            )
            
            if result.returncode == 0:
                self.log("Release APK успешно собран!", "SUCCESS")
                return self._find_apk("release")
            else:
                self.log("Ошибка при сборке release APK", "ERROR")
                return None
                
        except subprocess.TimeoutExpired:
            self.log("Сборка заняла слишком много времени", "ERROR")
            return None
        except Exception as e:
            self.log(f"Ошибка: {e}", "ERROR")
            return None
    
    def _find_apk(self, build_type):
        """Находит собранный APK файл"""
        bin_dir = self.project_dir / "bin"
        
        if not bin_dir.exists():
            self.log("Директория bin не найдена", "ERROR")
            return None
        
        # Ищем APK файлы
        apks = list(bin_dir.glob("*.apk"))
        
        if not apks:
            self.log("APK файлы не найдены в bin/", "ERROR")
            return None
        
        # Берем последний по времени (самый свежий)
        latest_apk = max(apks, key=lambda f: f.stat().st_mtime)
        size_mb = latest_apk.stat().st_size / (1024 * 1024)
        
        self.log(f"Путь: {latest_apk}", "SUCCESS")
        self.log(f"Размер: {size_mb:.1f} MB", "INFO")
        
        return latest_apk
    
    def print_install_instructions(self, apk_path):
        """Выводит инструкции по установке"""
        print("\n" + "="*60)
        print("📱 ИНСТРУКЦИИ ПО УСТАНОВКЕ")
        print("="*60)
        
        print("\n1. Подключите планшет по USB кабелю")
        print("2. Включите режим разработчика на планшете:")
        print("   Настройки → О телефоне → Номер сборки (7 раз)")
        print("3. Разрешите отладку по USB")
        print("4. Выполните команду:")
        print(f"\n   adb install -r {apk_path}\n")
        
        print("Альтернативно (если нет adb):")
        print(f"1. Скопируйте файл: {apk_path}")
        print("2. Перенесите на планшет через USB")
        print("3. Откройте файл на планшете и установите")
        
        print("\n" + "="*60 + "\n")
    
    def main(self):
        """Главная функция"""
        print("\n" + "="*60)
        print("Сборка APK - Магический Артефакт")
        print("="*60 + "\n")
        
        # Парсим аргументы
        do_clean = "clean" in sys.argv
        is_release = "release" in sys.argv
        
        # Проверяем требования
        if not self.check_requirements():
            sys.exit(1)
        
        print()
        
        # Очищаем если нужно
        if do_clean:
            if not self.clean():
                sys.exit(1)
            print()
        
        # Собираем
        if is_release:
            apk_path = self.build_release()
        else:
            apk_path = self.build_debug()
        
        if apk_path:
            self.print_install_instructions(apk_path)
            sys.exit(0)
        else:
            self.log("Сборка не удалась", "ERROR")
            sys.exit(1)

if __name__ == "__main__":
    builder = APKBuilder()
    builder.main()
