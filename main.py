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

# Добавляем путь к src для импорта модулей
sys.path.append(os.path.join(os.path.dirname(__file__), "src"))

# Настройка полноэкранного режима
Window.fullscreen = "auto"
Window.keep_screen_on = True  # Отключаем спящий режим


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

            # Случайная позиция на круге
            angle = random.uniform(0, 2 * 3.14159)
            radius = random.uniform(80, 120)
            x = self.center_x + radius * (angle**0.5)
            y = self.center_y + radius * (3.14159 - angle) ** 0.5

            # Маленькая частица
            size = random.uniform(3, 8)
            Ellipse(pos=(x - size / 2, y - size / 2), size=(size, size))


class MagicArtifactApp(App):
    """Основное приложение Магического Артефакта"""

    def build(self):
        """Строит интерфейс приложения"""
        # Создаем основной layout
        main_layout = BoxLayout(orientation="vertical", padding=20, spacing=10)

        # Создаем магический виджет
        self.magic_widget = MagicArtifactWidget()

        # Создаем заголовок
        title_label = Label(
            text="МАГИЧЕСКИЙ АРТЕФАКТ",
            font_size="32sp",
            color=(0.9, 0.7, 1.0, 1.0),  # Светло-фиолетовый
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

        # Инициализируем компоненты
        Clock.schedule_once(self.initialize_components, 1)

        return main_layout

    def initialize_components(self, dt):
        """Инициализирует компоненты приложения"""
        try:
            # Импортируем и инициализируем модули
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

            # Обновляем статус
            wake_word = self.spell_manager.get_wake_word()
            self.update_status(
                f'Слушаю пробуждение...\nСкажи "{wake_word}" для активации'
            )

            # Начинаем прослушивание
            self.voice_manager.start_listening()

            print("Все компоненты успешно инициализированы")

        except Exception as e:
            print(f"Ошибка инициализации компонентов: {e}")
            self.update_status(
                f"Ошибка инициализации:\n{str(e)}\n\nРаботаем в тестовом режиме"
            )

    def on_start(self):
        """Вызывается при запуске приложения"""
        print("Магический Артефакт активирован!")

    def update_status(self, text):
        """Обновляет статусный текст"""
        if hasattr(self, "status_label"):
            self.status_label.text = text

    def on_wake_word_detected(self):
        """Обрабатывает обнаружение wake-word"""
        print("Wake-word обнаружен!")
        self.update_status("Пробуждение обнаружено!\nОжидаю заклинание...")

        # Запускаем распознавание речи
        if hasattr(self, "voice_manager"):
            self.voice_manager.start_speech_recognition(duration=5)

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
                self.update_status(f"Заклинание активировано!\n{spell_name}")

                # Воспроизводим эффект
                self.play_spell_effect(spell_id)

                # Обновляем время использования
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

    def play_spell_effect(self, spell_id):
        """Воспроизводит эффект заклинания"""
        if not hasattr(self, "media_player"):
            return

        try:
            # Получаем медиа пути
            media_paths = self.spell_manager.get_spell_media_paths(spell_id)
            duration = self.spell_manager.get_spell_duration(spell_id)

            # Воспроизводим эффект
            self.media_player.play_spell(
                spell_id=spell_id,
                media_paths=media_paths,
                duration=duration,
                completion_callback=lambda: None,
            )

            print(f"Воспроизведение эффекта для {spell_id}")

        except Exception as e:
            print(f"Ошибка воспроизведения эффекта: {e}")

    def reset_to_listening(self):
        """Возвращает в режим прослушивания"""
        self.update_status('Слушаю пробуждение...\nСкажи "артефакт" для активации')

        # Возобновляем прослушивание wake-word
        if hasattr(self, "voice_manager"):
            self.voice_manager.start_listening()

    def on_stop(self):
        """Вызывается при остановке приложения"""
        print("Остановка Магического Артефакта")

        # Освобождаем ресурсы
        if hasattr(self, "voice_manager"):
            self.voice_manager.cleanup()

        if hasattr(self, "media_player"):
            self.media_player.cleanup()


if __name__ == "__main__":
    # Запускаем приложение
    app = MagicArtifactApp()
    app.run()
