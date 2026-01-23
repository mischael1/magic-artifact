# Улучшенное тестовое приложение с медиа

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

        # Загружаем изображение заклинания
        image_path = f"assets/spells/{spell_type}/image.jpg"
        if os.path.exists(image_path):
            self.current_image = Image(
                source=image_path,
                size=self.size,
                pos=self.pos,
                allow_stretch=True,
                keep_ratio=False,
            )
            self.add_widget(self.current_image)

    def hide_spell_image(self):
        """Скрывает изображение заклинания"""
        if self.current_image:
            self.remove_widget(self.current_image)
            self.current_image = None


class EnhancedMagicArtifactApp(App):
    """Улучшенное тестовое приложение Магического Артефакта"""

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
            text="Тестовый режим с медиа\nГотов к работе!",
            font_size="18sp",
            color=(0.7, 0.5, 0.9, 1.0),
            halign="center",
            valign="middle",
            size_hint_y=None,
            height=80,
        )

        # Улучшенные кнопки
        button_layout = BoxLayout(
            orientation="horizontal", size_hint_y=None, height=100, spacing=10
        )

        wake_button = Button(
            text="Wake-word\nАктивация",
            font_size="14sp",
            background_color=(0.3, 0.2, 0.5, 0.8),
            size_hint_x=0.25,
        )
        wake_button.bind(on_press=self.on_wake_word_test)

        fire_button = Button(
            text="Огненный\nшар",
            font_size="14sp",
            background_color=(0.8, 0.2, 0.1, 0.8),
            size_hint_x=0.25,
        )
        fire_button.bind(on_press=lambda x: self.on_spell_test("fireball"))

        heal_button = Button(
            text="Лечение",
            font_size="14sp",
            background_color=(0.1, 0.8, 0.2, 0.8),
            size_hint_x=0.25,
        )
        heal_button.bind(on_press=lambda x: self.on_spell_test("heal"))

        shield_button = Button(
            text="Щит",
            font_size="14sp",
            background_color=(0.1, 0.3, 0.8, 0.8),
            size_hint_x=0.25,
        )
        shield_button.bind(on_press=lambda x: self.on_spell_test("shield"))

        button_layout.add_widget(wake_button)
        button_layout.add_widget(fire_button)
        button_layout.add_widget(heal_button)
        button_layout.add_widget(shield_button)

        main_layout.add_widget(title_label)
        main_layout.add_widget(self.magic_widget)
        main_layout.add_widget(self.status_label)
        main_layout.add_widget(button_layout)

        Clock.schedule_interval(self.magic_widget.update_animation, 1 / 60)

        return main_layout

    def on_start(self):
        print("Улучшенный Магический Артефакт активирован!")
        self.update_status("Тестовый режим с медиа\nНажмите кнопки для проверки")

    def update_status(self, text):
        self.status_label.text = text

    def on_wake_word_test(self, instance):
        print("Wake-word обнаружен!")
        self.update_status("Пробуждение обнаружено!\nГотов слушать заклинания...")
        self.magic_widget.clear_particles()

        Clock.schedule_once(
            lambda dt: self.update_status(
                "Тестовый режим с медиа\nНажмите кнопки для проверки"
            ),
            5,
        )

    def on_spell_test(self, spell_type):
        spell_names = {
            "fireball": "Огненный шар активирован!",
            "heal": "Лечебное заклинание активировано!",
            "shield": "Магический щит создан!",
        }

        spell_name = spell_names.get(
            spell_type, f"Заклинание {spell_type} активировано!"
        )
        print(spell_name)

        self.update_status(spell_name)

        # Показываем изображение заклинания
        self.magic_widget.show_spell_image(spell_type)

        # Создаем эффект частиц
        for _ in range(15):
            self.magic_widget.add_magic_particle()

        # Скрываем изображение через 3 секунды
        Clock.schedule_once(lambda dt: self.magic_widget.hide_spell_image(), 3)

        # Возвращаем к нормальному состоянию через 4 секунды
        Clock.schedule_once(
            lambda dt: self.update_status(
                "Тестовый режим с медиа\nНажмите кнопки для проверки"
            ),
            4,
        )


if __name__ == "__main__":
    EnhancedMagicArtifactApp().run()
