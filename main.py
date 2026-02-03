# Интегрированное приложение Магического Артефакта

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.core.window import Window
from kivy.clock import Clock
from kivy.graphics import Color, Rectangle, Ellipse
from kivy.uix.widget import Widget
import random
import os
import sys
import traceback
import time
import math
from datetime import datetime

# Добавляем путь к src для импорта модулей
sys.path.append(os.path.join(os.path.dirname(__file__), "src"))

# Настройка полноэкранного режима
Window.fullscreen = "auto"
Window.keep_screen_on = True  # Отключаем спящий режим


# ЛОГИРОВАНИЕ НА ANDROID
class LogWriter:
    """Пишет логи в файл на устройстве"""
    
    def __init__(self):
        # Пытаемся использовать общую папку
        try:
            # Для Android
            from android.storage import app_storage_path
            self.log_dir = app_storage_path()
        except:
            # Для других платформ
            self.log_dir = os.path.expanduser("~")
        
        self.log_file = os.path.join(self.log_dir, "magicartifact_debug.log")
        
        # Очищаем старый лог
        try:
            if os.path.exists(self.log_file):
                os.remove(self.log_file)
        except:
            pass
        
        self.write(f"\n{'='*70}")
        self.write(f"🔮 МАГИЧЕСКИЙ АРТЕФАКТ - ЛОГИРОВАНИЕ")
        self.write(f"Время: {datetime.now()}")
        self.write(f"{'='*70}\n")
    
    def write(self, message):
        """Пишет сообщение в лог"""
        try:
            with open(self.log_file, 'a', encoding='utf-8') as f:
                f.write(message + "\n")
                f.flush()
        except:
            pass
        
        # Также выводим в консоль
        print(message)


log_writer = LogWriter()


class MagicArtifactWidget(Widget):
    """Основной виджет магического артефакта"""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.particles = []
        self.animation_step = 0

    def on_size(self, instance, value):
        """Вызывается при изменении размера"""
        self.canvas.clear()
        self.create_background()

    def create_background(self):
        """Создает магический фон"""
        with self.canvas:
            # Темный магический фон
            Color(0.1, 0.05, 0.15, 1)  # Темно-фиолетовый
            Rectangle(pos=self.pos, size=self.size)

            # Магические круги
            Color(0.3, 0.2, 0.5, 0.3)
            center_x = self.center_x
            center_y = self.center_y

            # Внешний круг
            Ellipse(pos=(center_x - 150, center_y - 150), size=(300, 300))

            # Средний круг
            Color(0.5, 0.3, 0.7, 0.4)
            Ellipse(pos=(center_x - 100, center_y - 100), size=(200, 200))

            # Внутренний круг
            Color(0.7, 0.5, 0.9, 0.5)
            Ellipse(pos=(center_x - 50, center_y - 50), size=(100, 100))

    def update_animation(self, dt):
        """Обновляет анимацию"""
        self.animation_step += 1
        if self.animation_step % 60 == 0:  # Каждую секунду
            self.add_magic_particle()

    def add_magic_particle(self):
        """Добавляет магическую частицу"""
        with self.canvas:
            # Случайный цвет для частицы
            colors = [
                (0.8, 0.4, 1.0, 0.6),  # Фиолетовый
                (0.4, 0.8, 1.0, 0.6),  # Голубой
                (1.0, 0.4, 0.8, 0.6),  # Розовый
                (0.4, 1.0, 0.8, 0.6),  # Бирюзовый
            ]
            Color(*random.choice(colors))

            # Случайная позиция в прямоугольной области вокруг центра
            offset_x = random.uniform(-150, 150)
            offset_y = random.uniform(-150, 150)
            x = self.center_x + offset_x
            y = self.center_y + offset_y

            # Маленькая частица
            size = random.uniform(3, 8)
            Ellipse(pos=(x - size / 2, y - size / 2), size=(size, size))


class MagicArtifactApp(App):
    """Основное приложение Магического Артефакта"""

    def build(self):
        """Строит интерфейс приложения"""
        try:
            log_writer.write("\n" + "="*70)
            log_writer.write("🔨 Запуск build()")
            log_writer.write("="*70)
            
            # Создаем основной layout
            log_writer.write("[1/3] Создание layout...")
            main_layout = BoxLayout(orientation="vertical", padding=20, spacing=10)

            # Создаем магический виджет
            log_writer.write("[2/3] Создание magic_widget...")
            self.magic_widget = MagicArtifactWidget()

            # Создаем заголовок
            log_writer.write("[3/3] Создание labels...")
            title_label = Label(
                text="МАГИЧЕСКИЙ АРТЕФАКТ",
                font_size="32sp",
                color=(0.9, 0.7, 1.0, 1.0),
                halign="center",
                valign="middle",
                size_hint_y=None,
                height=60,
            )

            # Создаем статусный текст
            status_label = Label(
                text="Инициализация...\nПожалуйста подождите",
                font_size="18sp",
                color=(0.7, 0.5, 0.9, 1.0),
                halign="center",
                valign="middle",
                size_hint_y=None,
                height=80,
            )

            # Добавляем виджеты в layout
            main_layout.add_widget(title_label)
            main_layout.add_widget(self.magic_widget)
            main_layout.add_widget(status_label)

            # Запускаем анимацию
            Clock.schedule_interval(self.magic_widget.update_animation, 1 / 60)

            # Сохраняем ссылки для будущего использования
            self.status_label = status_label
            self.title_label = title_label

            log_writer.write("✓ UI инициализирован успешно")
            log_writer.write(f"  Лог-файл: {log_writer.log_file}")
            
            # Инициализируем компоненты с задержкой
            Clock.schedule_once(self.initialize_components, 1.5)

            return main_layout
            
        except Exception as e:
            log_writer.write(f"✗ КРИТИЧЕСКАЯ ОШИБКА в build(): {e}")
            log_writer.write(traceback.format_exc())
            raise

    def initialize_components(self, dt):
        """Инициализирует компоненты приложения"""
        log_writer.write("\n" + "="*70)
        log_writer.write("⚙️  Инициализация компонентов")
        log_writer.write("="*70)
        
        try:
            # ЭТАП 1: Импорт модулей
            log_writer.write("\n[1/6] Импорт модулей...")
            try:
                from spell_manager import SpellManager
                log_writer.write("  ✓ SpellManager импортирован")
            except Exception as e:
                log_writer.write(f"  ✗ SpellManager: {e}")
                log_writer.write(traceback.format_exc())
                raise
            
            try:
                from voice_manager import VoiceManager
                log_writer.write("  ✓ VoiceManager импортирован")
            except Exception as e:
                log_writer.write(f"  ✗ VoiceManager: {e}")
                log_writer.write(traceback.format_exc())
                raise
            
            try:
                from media_player import MediaPlayer
                log_writer.write("  ✓ MediaPlayer импортирован")
            except Exception as e:
                log_writer.write(f"  ✗ MediaPlayer: {e}")
                log_writer.write(traceback.format_exc())
                raise

            # ЭТАП 2: Инициализация SpellManager
            log_writer.write("\n[2/6] SpellManager...")
            try:
                self.spell_manager = SpellManager()
                log_writer.write("  ✓ SpellManager инициализирован")
            except Exception as e:
                log_writer.write(f"  ✗ {e}")
                log_writer.write(traceback.format_exc())
                self.update_status(f"Ошибка SpellManager:\n{str(e)[:100]}")
                raise

            # ЭТАП 3: Инициализация VoiceManager
            log_writer.write("\n[3/6] VoiceManager...")
            try:
                self.voice_manager = VoiceManager()
                log_writer.write("  ✓ VoiceManager инициализирован")
            except Exception as e:
                log_writer.write(f"  ✗ {e}")
                log_writer.write(traceback.format_exc())
                self.update_status(f"Ошибка VoiceManager:\n{str(e)[:100]}")
                raise

            # ЭТАП 4: Инициализация MediaPlayer
            log_writer.write("\n[4/6] MediaPlayer...")
            try:
                self.media_player = MediaPlayer()
                self.media_player.set_parent_widget(self.magic_widget)
                log_writer.write("  ✓ MediaPlayer инициализирован")
            except Exception as e:
                log_writer.write(f"  ✗ {e}")
                log_writer.write(traceback.format_exc())
                self.update_status(f"Ошибка MediaPlayer:\n{str(e)[:100]}")
                raise

            # ЭТАП 5: Настройка callbacks
            log_writer.write("\n[5/6] Callbacks...")
            try:
                self.voice_manager.set_wake_word_callback(self.on_wake_word_detected)
                self.voice_manager.set_speech_callback(self.on_speech_recognized)
                log_writer.write("  ✓ Callbacks установлены")
            except Exception as e:
                log_writer.write(f"  ✗ {e}")
                log_writer.write(traceback.format_exc())
                raise

            # ЭТАП 6: Запуск прослушивания
            log_writer.write("\n[6/6] Запуск прослушивания...")
            try:
                wake_word = self.spell_manager.get_wake_word()
                self.update_status(
                    f'Слушаю пробуждение...\nСкажи "{wake_word}" для активации'
                )
                
                self.voice_manager.start_listening()
                log_writer.write("  ✓ Прослушивание запущено")
            except Exception as e:
                log_writer.write(f"  ✗ {e}")
                log_writer.write(traceback.format_exc())
                raise

            log_writer.write("\n" + "="*70)
            log_writer.write("✅ Все компоненты успешно инициализированы!")
            log_writer.write("="*70)

        except Exception as e:
            log_writer.write("\n" + "="*70)
            log_writer.write("❌ ОШИБКА ИНИЦИАЛИЗАЦИИ")
            log_writer.write("="*70)
            log_writer.write(f"\nТип: {type(e).__name__}")
            log_writer.write(f"Сообщение: {e}")
            log_writer.write("\nFull trace:")
            log_writer.write(traceback.format_exc())
            log_writer.write("="*70)
            log_writer.write(f"\nЛог сохранен в: {log_writer.log_file}")
            
            self.update_status(
                f"ОШИБКА:\n{type(e).__name__}\n\nСм. логи на устройстве"
            )

    def on_start(self):
        """Вызывается при запуске приложения"""
        log_writer.write("\n🚀 Приложение запущено")

    def update_status(self, text):
        """Обновляет статусный текст"""
        try:
            if hasattr(self, "status_label"):
                self.status_label.text = text
                log_writer.write(f"[STATUS] {text.replace(chr(10), ' | ')}")
        except Exception as e:
            log_writer.write(f"✗ Ошибка обновления статуса: {e}")

    def on_wake_word_detected(self):
        """Обрабатывает обнаружение wake-word"""
        try:
            log_writer.write("\n[WAKE-WORD] Обнаружен!")
            self.update_status("Пробуждение обнаружено!\nОжидаю заклинание...")

            if hasattr(self, "voice_manager"):
                self.voice_manager.start_speech_recognition(duration=5)

            Clock.schedule_once(lambda dt: self.reset_to_listening(), 10)
        except Exception as e:
            log_writer.write(f"✗ Ошибка wake-word: {e}")
            log_writer.write(traceback.format_exc())

    def on_speech_recognized(self, text):
        """Обрабатывает распознанную речь"""
        try:
            if text is None:
                log_writer.write("[SPEECH] Ничего не распознано")
                self.reset_to_listening()
                return
                
            log_writer.write(f"[SPEECH] Распознано: {text}")

            if not hasattr(self, "spell_manager"):
                self.update_status(f'Распознано: "{text}"\nНет менеджера')
                Clock.schedule_once(lambda dt: self.reset_to_listening(), 3)
                return

            spell_id = self.spell_manager.find_spell(text)

            if spell_id:
                spell_data = self.spell_manager.get_spell_data(spell_id)
                if spell_data:
                    spell_name = spell_data.get("name", spell_id)
                    self.update_status(f"Заклинание!\n{spell_name}")
                    self.play_spell_effect(spell_id)
                    self.spell_manager.update_last_cast(spell_id)
                else:
                    self.update_status(f"Заклинание\n(нет данных)")
            else:
                self.update_status(f'Неизвестное:\n"{text}"')

            reset_timeout = self.spell_manager.get_reset_timeout()
            Clock.schedule_once(lambda dt: self.reset_to_listening(), reset_timeout)
            
        except Exception as e:
            log_writer.write(f"✗ Ошибка speech: {e}")
            log_writer.write(traceback.format_exc())
            self.update_status(f"Ошибка обработки")
            Clock.schedule_once(lambda dt: self.reset_to_listening(), 3)

    def play_spell_effect(self, spell_id):
        """Воспроизводит эффект заклинания"""
        try:
            if not hasattr(self, "media_player"):
                return

            media_paths = self.spell_manager.get_spell_media_paths(spell_id)
            duration = self.spell_manager.get_spell_duration(spell_id)

            self.media_player.play_spell(
                spell_id=spell_id,
                media_paths=media_paths,
                duration=duration,
                completion_callback=lambda: None,
            )

            log_writer.write(f"[EFFECT] Эффект: {spell_id}")

        except Exception as e:
            log_writer.write(f"✗ Ошибка эффекта: {e}")
            log_writer.write(traceback.format_exc())

    def reset_to_listening(self):
        """Возвращает в режим прослушивания"""
        try:
            log_writer.write("[RESET] Режим прослушивания")
            self.update_status('Слушаю пробуждение...\nСкажи "артефакт"')

            if hasattr(self, "voice_manager"):
                self.voice_manager.start_listening()
        except Exception as e:
            log_writer.write(f"✗ Ошибка reset: {e}")
            log_writer.write(traceback.format_exc())

    def on_stop(self):
        """Вызывается при остановке приложения"""
        log_writer.write("\n" + "="*70)
        log_writer.write("🛑 Остановка приложения")
        log_writer.write("="*70)

        try:
            if hasattr(self, "voice_manager"):
                self.voice_manager.cleanup()
                log_writer.write("✓ VoiceManager очищен")
        except Exception as e:
            log_writer.write(f"✗ Ошибка очистки voice: {e}")

        try:
            if hasattr(self, "media_player"):
                self.media_player.cleanup()
                log_writer.write("✓ MediaPlayer очищен")
        except Exception as e:
            log_writer.write(f"✗ Ошибка очистки media: {e}")

        log_writer.write("="*70)


if __name__ == "__main__":
    log_writer.write("\nСоздание приложения...")
    app = MagicArtifactApp()
    app.run()
