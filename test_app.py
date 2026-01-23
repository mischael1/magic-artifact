# Тестовое приложение Магического Артефакта (без голосовых зависимостей)

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
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
            import math

            x = self.center_x + radius * math.cos(angle)
            y = self.center_y + radius * math.sin(angle)

            # Маленькая частица
            size = random.uniform(3, 8)
            Ellipse(pos=(x - size / 2, y - size / 2), size=(size, size))

    def clear_particles(self):
        """Очищает частицы"""
        self.canvas.clear()
        self.create_background()


class TestMagicArtifactApp(App):
    """Тестовое приложение Магического Артефакта"""

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
        self.status_label = Label(
            text="Тестовый режим\nГотов к работе!",
            font_size="18sp",
            color=(0.7, 0.5, 0.9, 1.0),
            halign="center",
            valign="middle",
            size_hint_y=None,
            height=80,
        )

        # Создаем кнопки для тестирования
        button_layout = BoxLayout(
            orientation="horizontal", size_hint_y=None, height=80, spacing=10
        )

        # Кнопка симуляции wake-word
        wake_button = Button(
            text="Wake-word",
            font_size="16sp",
            background_color=(0.3, 0.2, 0.5, 0.8),
            size_hint_x=0.5,
        )
        wake_button.bind(on_press=self.on_wake_word_test)

        # Кнопка симуляции заклинания
        spell_button = Button(
            text="Заклинание",
            font_size="16sp",
            background_color=(0.5, 0.2, 0.3, 0.8),
            size_hint_x=0.5,
        )
        spell_button.bind(on_press=self.on_spell_test)

        button_layout.add_widget(wake_button)
        button_layout.add_widget(spell_button)

        # Добавляем виджеты в layout
        main_layout.add_widget(title_label)
        main_layout.add_widget(self.magic_widget)
        main_layout.add_widget(self.status_label)
        main_layout.add_widget(button_layout)

        # Запускаем анимацию
        Clock.schedule_interval(self.magic_widget.update_animation, 1 / 60)

        return main_layout

    def on_start(self):
        """Вызывается при запуске приложения"""
        print("Магический Артефакт активирован в тестовом режиме!")
        self.update_status("Тестовый режим\nИспользуйте кнопки для симуляции")

    def update_status(self, text):
        """Обновляет статусный текст"""
        self.status_label.text = text

    def on_wake_word_test(self, instance):
        """Симулирует обнаружение wake-word"""
        self.update_status("Wake-word обнаружен!\nГотов слушать заклинания...")

        # Очищаем частицы и создаем новые
        self.magic_widget.clear_particles()

        # Автосброс через 5 секунд
        Clock.schedule_once(
            lambda dt: self.update_status(
                "Тестовый режим\nИспользуйте кнопки для симуляции"
            ),
            5,
        )

    def on_spell_test(self, instance):
        """Симулирует активацию заклинания"""
        spells = [
            "Огненный шар активирован!",
            "Лечебное заклинание активировано!",
            "Магический щит создан!",
            "Темная стрела выпущена!",
        ]

        spell_text = random.choice(spells)
        self.update_status(spell_text)

        # Создаем взрыв частиц
        for _ in range(10):
            self.magic_widget.add_magic_particle()

        # Автосброс через 3 секунды
        Clock.schedule_once(
            lambda dt: self.update_status(
                "Тестовый режим\nИспользуйте кнопки для симуляции"
            ),
            3,
        )


if __name__ == "__main__":
    # Запускаем тестовое приложение
    app = TestMagicArtifactApp()
    app.run()
