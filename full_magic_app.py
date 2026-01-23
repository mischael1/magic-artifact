# Полнофункциональное приложение с голосовым управлением

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.core.window import Window
from kivy.clock import Clock
from kivy.graphics import Color, Rectangle, Ellipse
from kivy.uix.widget import Widget
from kivy.uix.image import Image
import random
import os
import sys

# Добавляем путь к src для импорта модулей
sys.path.append(os.path.join(os.path.dirname(__file__), "src"))

# Настройка полноэкранного режима
Window.fullscreen = "auto"
Window.keep_screen_on = True


class MagicArtifactWidget(Widget):
    """Основной виджет магического артефакта"""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.particles = []
        self.animation_step = 0
        self.current_image = None

    def on_size(self, instance, value):
        """Вызывается при изменении размера"""
        self.create_background()

    def create_background(self):
        """Создает магический фон"""
        self.canvas.clear()

        # Загружаем фоновое изображение если существует
        if os.path.exists("assets/images/background.jpg"):
            with self.canvas:
                Color(1, 1, 1, 1)
                Rectangle(
                    source="assets/images/background.jpg", pos=self.pos, size=self.size
                )
        else:
            # Программный фон если изображения нет
            with self.canvas:
                Color(0.1, 0.05, 0.15, 1)
                Rectangle(pos=self.pos, size=self.size)

                # Магические круги
                Color(0.3, 0.2, 0.5, 0.3)
                center_x = self.center_x
                center_y = self.center_y

                Ellipse(pos=(center_x - 150, center_y - 150), size=(300, 300))
                Color(0.5, 0.3, 0.7, 0.4)
                Ellipse(pos=(center_x - 100, center_y - 100), size=(200, 200))
                Color(0.7, 0.5, 0.9, 0.5)
                Ellipse(pos=(center_x - 50, center_y - 50), size=(100, 100))

    def update_animation(self, dt):
        """Обновляет анимацию"""
        self.animation_step += 1
        if self.animation_step % 60 == 0:
            self.add_magic_particle()

    def add_magic_particle(self):
        """Добавляет магическую частицу"""
        with self.canvas:
            colors = [
                (0.8, 0.4, 1.0, 0.6),
                (0.4, 0.8, 1.0, 0.6),
                (1.0, 0.4, 0.8, 0.6),
                (0.4, 1.0, 0.8, 0.6),
            ]
            Color(*random.choice(colors))

            angle = random.uniform(0, 2 * 3.14159)
            radius = random.uniform(80, 120)
            import math

            x = self.center_x + radius * math.cos(angle)
            y = self.center_y + radius * math.sin(angle)

            size = random.uniform(3, 8)
            Ellipse(pos=(x - size / 2, y - size / 2), size=(size, size))

    def clear_particles(self):
        """Очищает частицы"""
        self.canvas.clear()
        self.create_background()

    def show_spell_image(self, spell_type):
        """Показывает изображение заклинания"""
        if self.current_image:
            self.remove_widget(self.current_image)
            self.current_image = None

        image_path = f"assets/spells/{spell_type}/image.jpg"
        if os.path.exists(image_path):
            self.current_image = Image(
                source=image_path, size=self.size, pos=self.pos, allow_stretch=True
            )
            self.add_widget(self.current_image)

    def hide_spell_image(self):
        """Скрывает изображение заклинания"""
        if self.current_image:
            self.remove_widget(self.current_image)
            self.current_image = None


class FullMagicArtifactApp(App):
    """Полнофункциональное приложение с голосовым управлением"""

    def build(self):
        """Строит интерфейс приложения"""
        main_layout = BoxLayout(orientation="vertical", padding=20, spacing=10)

        self.magic_widget = MagicArtifactWidget()

        title_label = Label(
            text="МАГИЧЕСКИЙ АРТЕФАКТ",
            font_size="32sp",
            color=(0.9, 0.7, 1.0, 1.0),
            halign="center",
            valign="middle",
            size_hint_y=None,
            height=60,
        )

        self.status_label = Label(
            text="Инициализация...",
            font_size="18sp",
            color=(0.7, 0.5, 0.9, 1.0),
            halign="center",
            valign="middle",
            size_hint_y=None,
            height=80,
        )

        # Кнопки управления
        button_layout = BoxLayout(
            orientation="horizontal", size_hint_y=None, height=120, spacing=10
        )

        wake_button = Button(
            text="Начать\nпрослушивание",
            font_size="14sp",
            background_color=(0.3, 0.2, 0.5, 0.8),
            size_hint_x=0.33,
        )
        wake_button.bind(on_press=self.start_listening)

        stop_button = Button(
            text="Остановить\nпрослушивание",
            font_size="14sp",
            background_color=(0.5, 0.2, 0.2, 0.8),
            size_hint_x=0.33,
        )
        stop_button.bind(on_press=self.stop_listening)

        test_button = Button(
            text="Тестовое\nзаклинание",
            font_size="14sp",
            background_color=(0.2, 0.5, 0.3, 0.8),
            size_hint_x=0.33,
        )
        test_button.bind(on_press=self.test_spell)

        button_layout.add_widget(wake_button)
        button_layout.add_widget(stop_button)
        button_layout.add_widget(test_button)

        main_layout.add_widget(title_label)
        main_layout.add_widget(self.magic_widget)
        main_layout.add_widget(self.status_label)
        main_layout.add_widget(button_layout)

        Clock.schedule_interval(self.magic_widget.update_animation, 1 / 60)
        Clock.schedule_once(self.initialize_components, 1)

        return main_layout

    def initialize_components(self, dt):
        """Инициализирует компоненты приложения"""
        try:
            # Импортируем модули
            from spell_manager import SpellManager
            from voice_manager import VoiceManager
            from media_player import MediaPlayer

            # Создаем компоненты
            self.spell_manager = SpellManager()
            self.voice_manager = VoiceManager()
            self.media_player = MediaPlayer()
            self.media_player.set_parent_widget(self.magic_widget)

            # Устанавливаем callback'и
            self.voice_manager.set_wake_word_callback(self.on_wake_word_detected)
            self.voice_manager.set_speech_callback(self.on_speech_recognized)

            wake_word = self.spell_manager.get_wake_word()
            self.update_status(
                f'Слушаю пробуждение...\nСкажи "{wake_word}" для активации'
            )

            print("Все компоненты успешно инициализированы")

        except Exception as e:
            print(f"Ошибка инициализации компонентов: {e}")
            self.update_status(
                f"Ошибка инициализации:\n{str(e)}\n\nИспользуйте кнопки для тестирования"
            )

    def on_start(self):
        """Вызывается при запуске приложения"""
        print("Магический Артефакт активирован!")

    def update_status(self, text):
        """Обновляет статусный текст"""
        if hasattr(self, "status_label"):
            self.status_label.text = text

    def start_listening(self, instance):
        """Начинает прослушивание wake-word"""
        self.update_status("Начинаю прослушивание wake-word...")

        if hasattr(self, "voice_manager"):
            try:
                self.voice_manager.start_listening()
                self.update_status('Прослушивание активно...\nСкажите "артефакт"')
            except Exception as e:
                print(f"Ошибка запуска прослушивания: {e}")
                self.update_status("Ошибка прослушивания\nИспользуйте тестовую кнопку")
        else:
            # Тестовый режим
            self.update_status("Тестовый режим активирован!\nWake-word симулирован")
            self.on_wake_word_detected()

    def stop_listening(self, instance):
        """Останавливает прослушивание"""
        self.update_status("Прослушивание остановлено")

        if hasattr(self, "voice_manager"):
            try:
                self.voice_manager.stop_listening()
            except Exception as e:
                print(f"Ошибка остановки прослушивания: {e}")

    def test_spell(self, instance):
        """Тестирует активацию случайного заклинания"""
        spells = ["fireball", "heal", "shield"]
        spell_type = random.choice(spells)

        spell_names = {
            "fireball": "Огненный шар",
            "heal": "Лечебное заклинание",
            "shield": "Магический щит",
        }

        spell_name = spell_names.get(spell_type, f"Заклинание {spell_type}")
        self.on_spell_activated(spell_name, spell_type)

    def on_wake_word_detected(self):
        """Обрабатывает обнаружение wake-word"""
        print("Wake-word 'артефакт' обнаружен!")
        self.update_status("Пробуждение обнаружено!\nОжидаю заклинание...")

        # Очищаем частицы
        self.magic_widget.clear_particles()

        # Начинаем распознавание речи
        if hasattr(self, "voice_manager"):
            try:
                self.voice_manager.start_speech_recognition(duration=5)
            except Exception as e:
                print(f"Ошибка распознавания речи: {e}")

        # Автосброс через 10 секунд если ничего не сказано
        Clock.schedule_once(lambda dt: self.reset_to_listening(), 10)

    def on_speech_recognized(self, text):
        """Обрабатывает распознанную речь"""
        print(f"Распознано: {text}")

        if not hasattr(self, "spell_manager"):
            self.update_status(f'Распознано: "{text}"\nМенеджер заклинаний не готов')
            return

        # Ищем заклинание
        spell_id = self.spell_manager.find_spell(text)

        if spell_id:
            spell_data = self.spell_manager.get_spell_data(spell_id)
            if spell_data:
                spell_name = spell_data.get("name", spell_id)
                self.on_spell_activated(spell_name, spell_id)
                self.spell_manager.update_last_cast(spell_id)
            else:
                self.update_status(
                    f"Заклинание найдено: {spell_id}\nНо данные не загружены"
                )
        else:
            self.update_status(f'Неизвестное заклинание:\n"{text}"')

        # Автосброс через 30 секунд
        reset_timeout = self.spell_manager.get_reset_timeout()
        Clock.schedule_once(lambda dt: self.reset_to_listening(), reset_timeout)

    def on_spell_activated(self, spell_name, spell_type):
        """Обрабатывает активацию заклинания"""
        self.update_status(f"{spell_name}\nактивировано!")

        # Показываем изображение заклинания
        self.magic_widget.show_spell_image(spell_type)

        # Создаем эффект частиц
        for _ in range(15):
            self.magic_widget.add_magic_particle()

        # Воспроизводим эффект
        if hasattr(self, "media_player") and hasattr(self, "spell_manager"):
            try:
                media_paths = self.spell_manager.get_spell_media_paths(spell_type)
                duration = self.spell_manager.get_spell_duration(spell_type)
                self.media_player.play_spell(
                    spell_id=spell_type, media_paths=media_paths, duration=duration
                )
            except Exception as e:
                print(f"Ошибка воспроизведения эффекта: {e}")

        # Скрываем изображение через 4 секунды
        Clock.schedule_once(lambda dt: self.magic_widget.hide_spell_image(), 4)

    def reset_to_listening(self):
        """Возвращает в режим прослушивания"""
        wake_word = (
            self.spell_manager.get_wake_word()
            if hasattr(self, "spell_manager")
            else "артефакт"
        )
        self.update_status(f'Слушаю пробуждение...\nСкажи "{wake_word}" для активации')

    def on_stop(self):
        """Вызывается при остановке приложения"""
        print("Остановка Магического Артефакта")

        # Освобождаем ресурсы
        if hasattr(self, "voice_manager"):
            self.voice_manager.cleanup()

        if hasattr(self, "media_player"):
            self.media_player.cleanup()


if __name__ == "__main__":
    FullMagicArtifactApp().run()
