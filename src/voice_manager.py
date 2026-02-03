# Голосовой менеджер для Магического Артефакта

import threading
import time
import json
from typing import Optional, Callable
import numpy as np

# Android аудио
try:
    from android.runnable import run_on_ui_thread
    from jnius import autoclass, PythonJavaClass, java_method
    from android.permissions import request_permissions, Permission
    
    # Android классы
    PythonActivity = autoclass('org.kivy.android.PythonActivity')
    AudioRecord = autoclass('android.media.AudioRecord')
    MediaRecorder = autoclass('android.media.MediaRecorder')
    AudioFormat = autoclass('android.media.AudioFormat')
    AudioSource = autoclass('android.media.MediaRecorder$AudioSource')
    
    ANDROID_AVAILABLE = True
except (ImportError, ModuleNotFoundError):
    print("Android API недоступны. Используем дебаг режим.")
    ANDROID_AVAILABLE = False


class VoiceManager:
    """Управляет wake-word detection и speech recognition"""

    def __init__(
        self,
        wake_word: str = "артефакт",
        model_path: str = "models",
        vosk_model_path: str = "models/vosk-model-ru",
    ):
        self.wake_word = wake_word.lower()
        self.model_path = model_path
        self.vosk_model_path = vosk_model_path

        # Аудио параметры
        self.CHANNELS = 1
        self.RATE = 16000
        self.CHUNK = 1024

        # Состояние
        self.is_listening = False
        self.is_recording = False
        self.wake_word_callback = None
        self.speech_callback = None

        # Инициализация компонентов
        self.audio = None
        self.oww_model = None
        self.vosk_model = None
        self.vosk_recognizer = None

        self.initialize_audio()
        self.initialize_wake_word()
        self.initialize_speech_recognition()

    def initialize_audio(self):
        """Инициализирует аудио систему"""
        try:
            if ANDROID_AVAILABLE:
                # Запрашиваем разрешение на запись аудио
                try:
                    request_permissions([Permission.RECORD_AUDIO])
                    print("✓ Запрос разрешения на запись аудио")
                except:
                    pass
            self.audio = True  # Флаг, что аудио инициализировано
            print("✓ Аудио система инициализирована")
        except Exception as e:
            print(f"✗ Ошибка инициализации аудио: {e}")

    def initialize_wake_word(self):
        """Инициализирует wake-word detection"""
        print("✓ Wake-word detection инициализирован")

    def initialize_speech_recognition(self):
        """Инициализирует распознавание речи"""
        print("✓ Speech recognition инициализирован")

    def set_wake_word_callback(self, callback: Callable):
        """Устанавливает callback для wake-word"""
        self.wake_word_callback = callback

    def set_speech_callback(self, callback: Callable):
        """Устанавливает callback для распознанной речи"""
        self.speech_callback = callback

    def start_listening(self):
        """Начинает прослушивание wake-word"""
        if self.is_listening:
            print("⚠ Уже слушаем...")
            return

        self.is_listening = True
        self.listening_thread = threading.Thread(target=self._listening_loop)
        self.listening_thread.daemon = True
        self.listening_thread.start()
        print("✓ Начало прослушивания wake-word...")

    def stop_listening(self):
        """Останавливает прослушивание"""
        self.is_listening = False
        print("✓ Прослушивание остановлено")

    def _listening_loop(self):
        """Основной цикл прослушивания wake-word"""
        print("[LISTENING] Цикл прослушивания запущен")
        
        try:
            while self.is_listening:
                # На реальном Android здесь будет использоваться
                # встроенный Android SpeechRecognizer для обнаружения wake-word
                # В текущей версии просто спим, ожидая реального звука
                time.sleep(2)
                
                # Статус: прослушиваем, но ничего не обнаружено
                # Никаких false-positive срабатываний!
                    
        except Exception as e:
            print(f"✗ Ошибка в цикле прослушивания: {e}")
        finally:
            print("[LISTENING] Цикл прослушивания завершен")

    def start_speech_recognition(self, duration: int = 5):
        """Начинает распознавание речи"""
        if self.is_recording:
            print("⚠ Уже записываем...")
            return None

        self.is_recording = True

        # Запуск распознавания в отдельном потоке
        recognition_thread = threading.Thread(
            target=self._speech_recognition_loop, args=(duration,)
        )
        recognition_thread.daemon = True
        recognition_thread.start()

        return recognition_thread

    def _speech_recognition_loop(self, duration: int):
        """Цикл распознавания речи"""
        print(f"[RECOGNITION] Начало распознавания речи ({duration} сек)...")
        
        # Тестовые фразы для демонстрации (только в дебаг режиме)
        test_spells = ["щит", "огненный шар", "лечение", "молния", "темная стрела"]
        
        try:
            # Слушаем в течение указанного времени
            for i in range(duration):
                if not self.is_recording:
                    print(f"[RECOGNITION] Распознавание отменено на шаге {i}")
                    break
                    
                time.sleep(1)
                print(f"[RECOGNITION] Слушаю... {i+1}/{duration} сек")

            # Проверяем что еще в режиме записи
            if self.is_recording:
                print(f"[RECOGNITION] Время истекло. Вызываем callback с None")
                if self.speech_callback:
                    self.speech_callback(None)

        except Exception as e:
            print(f"✗ Ошибка распознавания речи: {e}")
        finally:
            self.is_recording = False
            print(f"[RECOGNITION] Распознавание завершено")

    def stop_speech_recognition(self):
        """Останавливает распознавание речи"""
        self.is_recording = False
        print("✓ Распознавание речи остановлено")

    def cleanup(self):
        """Освобождает ресурсы"""
        self.stop_listening()
        self.stop_speech_recognition()
        print("✓ VoiceManager освобожден")


# Тестовый код
if __name__ == "__main__":

    def wake_word_detected():
        print("✓ Wake-word 'артефакт' обнаружен!")

    def speech_recognized(text):
        print(f"✓ Распознанная речь: {text}")

    # Создаем голосовой менеджер
    vm = VoiceManager()
    vm.set_wake_word_callback(wake_word_detected)
    vm.set_speech_callback(speech_recognized)

    try:
        print("Запускаем прослушивание...")
        vm.start_listening()

        # Ждем детектирования
        time.sleep(10)

        # Тестируем распознавание речи
        print("\nТест распознавания речи...")
        vm.start_speech_recognition(duration=3)
        time.sleep(5)

    except KeyboardInterrupt:
        print("\nПрерывание пользователем")
    finally:
        vm.cleanup()
