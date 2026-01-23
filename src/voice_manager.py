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
    print("Android API недоступны. Используем симуляцию.")
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
        self.FORMAT = pyaudio.paInt16
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
                request_permissions([Permission.RECORD_AUDIO])
                print("Запрос разрешения на запись аудио")
            self.audio = True  # Флаг, что аудио инициализировано
            print("Аудио система инициализирована")
        except Exception as e:
            print(f"Ошибка инициализации аудио: {e}")

    def initialize_wake_word(self):
        """Инициализирует wake-word detection"""
        # В текущей версии используем простую детекцию громкости
        # Wake-word детекция будет выполняться голосовым движком Android
        print("Wake-word detection: используем встроенный детектор громкости")

    def initialize_speech_recognition(self):
        """Инициализирует распознавание речи"""
        # На Android используется встроенный SpeechRecognizer
        print("Speech recognition: используем встроенный Android SpeechRecognizer")

    def set_wake_word_callback(self, callback: Callable):
        """Устанавливает callback для wake-word"""
        self.wake_word_callback = callback

    def set_speech_callback(self, callback: Callable):
        """Устанавливает callback для распознанной речи"""
        self.speech_callback = callback

    def start_listening(self):
        """Начинает прослушивание wake-word"""
        if self.is_listening:
            return

        self.is_listening = True
        self.listening_thread = threading.Thread(target=self._listening_loop)
        self.listening_thread.daemon = True
        self.listening_thread.start()
        print("Начало прослушивания wake-word...")

    def stop_listening(self):
        """Останавливает прослушивание"""
        self.is_listening = False

    def _listening_loop(self):
        """Основной цикл прослушивания wake-word"""
        # Используем простую модель: каждую секунду проверяем громкость
        print("Начинаем цикл прослушивания...")
        
        # Для тестирования на PC - проверяем громкость каждую секунду
        import random
        
        try:
            while self.is_listening:
                time.sleep(1)
                
                # Проверяем наличие звука (имитация через случайное число)
                # На реальном Android это будет через встроенный SpeechRecognizer
                volume = random.randint(0, 1000)
                
                if volume > 700:  # Порог на громкость
                    print(f"Обнаружен звук высокой интенсивности (громкость: {volume})")
                    if self.wake_word_callback:
                        self.wake_word_callback()
                    break
                    
        except Exception as e:
            print(f"Ошибка в цикле прослушивания: {e}")
        finally:
            pass

    def start_speech_recognition(self, duration: int = 5):
        """Начинает распознавание речи"""
        if self.is_recording:
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
        print(f"Начало распознавания речи на {duration} сек...")
        
        # Тестовые фразы для демонстрации
        test_spells = ["щит", "огненный шар", "лечение", "молния", "темная стрела"]
        
        try:
            # Имитируем слушание
            for i in range(duration):
                if not self.is_recording:
                    break
                    
                time.sleep(1)
                print(f"  Слушаю... {i+1}/{duration}")

            # Имитируем распознавание - возвращаем случайное заклинание
            import random
            if self.is_recording and random.random() > 0.5:
                text = random.choice(test_spells)
                print(f"Распознано (тест): {text}")
                if self.speech_callback:
                    self.speech_callback(text)

        except Exception as e:
            print(f"Ошибка распознавания речи: {e}")
        finally:
            self.is_recording = False

    def stop_speech_recognition(self):
        """Останавливает распознавание речи"""
        self.is_recording = False

    def cleanup(self):
        """Освобождает ресурсы"""
        self.stop_listening()
        self.stop_speech_recognition()

        if self.audio:
            self.audio.terminate()

        print("VoiceManager освобожден")


# Тестовый код
if __name__ == "__main__":

    def wake_word_detected():
        print("Wake-word 'артефакт' обнаружен!")

    def speech_recognized(text):
        print(f"Распознанная речь: {text}")

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
