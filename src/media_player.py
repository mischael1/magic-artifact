# Медиа плеер для Магического Артефакта

import os
import time
import threading
from typing import Dict, Optional, Callable
from kivy.core.audio import SoundLoader
from kivy.core.video import VideoBase
from kivy.uix.video import Video
from kivy.uix.image import Image
import kivy


class MediaEffect:
    """Класс для медиа эффекта"""

    def __init__(
        self, video_path: str = None, audio_path: str = None, image_path: str = None
    ):
        self.video_path = video_path
        self.audio_path = audio_path
        self.image_path = image_path

        # Загруженные медиа
        self.audio_sound = None
        self.video_widget = None
        self.image_widget = None

        self.load_media()

    def load_media(self):
        """Предзагружает медиафайлы"""
        # Загрузка аудио
        if self.audio_path and os.path.exists(self.audio_path):
            try:
                self.audio_sound = SoundLoader.load(self.audio_path)
                if self.audio_sound:
                    print(f"Аудио загружено: {self.audio_path}")
                else:
                    print(f"Не удалось загрузить аудио: {self.audio_path}")
            except Exception as e:
                print(f"Ошибка загрузки аудио {self.audio_path}: {e}")

        # Загрузка видео
        if self.video_path and os.path.exists(self.video_path):
            print(f"Видео путь: {self.video_path}")
        else:
            self.video_path = None

        # Загрузка изображения
        if self.image_path and os.path.exists(self.image_path):
            print(f"Изображение путь: {self.image_path}")
        else:
            self.image_path = None

    def cleanup(self):
        """Освобождает ресурсы"""
        if self.audio_sound:
            if self.audio_sound.state == "play":
                self.audio_sound.stop()
            self.audio_sound.unload()
            self.audio_sound = None


class MediaPlayer:
    """Управляет воспроизведением медиаэффектов"""

    def __init__(self, assets_path: str = "assets"):
        self.assets_path = assets_path
        self.current_effect = None
        self.is_playing = False
        self.completion_callback = None
        self.reset_timer = None

        # Kivy виджеты для отображения
        self.current_video_widget = None
        self.current_image_widget = None
        self.parent_widget = None

        # Список доступных эффектов
        self.effects_cache = {}

    def set_parent_widget(self, widget):
        """Устанавливает родительский виджет для отображения медиа"""
        self.parent_widget = widget

    def preload_effect(self, spell_id: str, media_paths: Dict[str, str]):
        """Предзагружает медиа эффект"""
        if spell_id not in self.effects_cache:
            self.effects_cache[spell_id] = MediaEffect(
                video_path=media_paths.get("video"),
                audio_path=media_paths.get("audio") or media_paths.get("sound"),
                image_path=media_paths.get("image"),
            )

    def play_spell(
        self,
        spell_id: str,
        media_paths: Dict[str, str],
        duration: int = 3000,
        completion_callback: Callable = None,
    ):
        """Воспроизводит заклинание с медиаэффектами"""
        if self.is_playing:
            self.stop_current()

        self.completion_callback = completion_callback

        # Предзагрузка эффекта если еще не загружен
        self.preload_effect(spell_id, media_paths)

        effect = self.effects_cache.get(spell_id)
        if not effect:
            print(f"Эффект для заклинания {spell_id} не найден")
            self._on_effect_complete()
            return

        self.current_effect = effect
        self.is_playing = True

        print(f"Воспроизведение заклинания: {spell_id}")

        # Воспроизведение видео
        if effect.video_path:
            self._play_video(effect.video_path)

        # Воспроизведение изображения (если нет видео)
        elif effect.image_path:
            self._play_image(effect.image_path)

        # Воспроизведение аудио
        if effect.audio_sound:
            self._play_audio(effect.audio_sound)

        # Установка таймера завершения
        self._set_completion_timer(duration)

    def _play_video(self, video_path: str):
        """Воспроизводит видео"""
        if not self.parent_widget:
            return

        # Создаем виджет видео
        video_widget = Video(
            source=video_path,
            state="play",
            options={"allow_stretch": True, "eos": "stop"},
        )

        # Устанавливаем размер как у родителя
        if self.parent_widget:
            video_widget.size = self.parent_widget.size
            video_widget.pos = self.parent_widget.pos

        # Обработчик завершения видео
        video_widget.bind(eos=self._on_video_finished)

        # Добавляем на экран
        self.parent_widget.add_widget(video_widget)
        self.current_video_widget = video_widget

        print(f"Видео воспроизводится: {video_path}")

    def _play_image(self, image_path: str):
        """Отображает изображение"""
        if not self.parent_widget:
            return

        # Создаем виджет изображения
        image_widget = Image(source=image_path, allow_stretch=True, keep_ratio=False)

        # Устанавливаем размер как у родителя
        if self.parent_widget:
            image_widget.size = self.parent_widget.size
            image_widget.pos = self.parent_widget.pos

        # Добавляем на экран
        self.parent_widget.add_widget(image_widget)
        self.current_image_widget = image_widget

        print(f"Изображение отображено: {image_path}")

    def _play_audio(self, audio_sound):
        """Воспроизводит аудио"""
        if audio_sound:
            try:
                # Устанавливаем громкость
                audio_sound.volume = 0.8

                # Перемотка в начало если нужно
                if audio_sound.state == "play":
                    audio_sound.stop()
                audio_sound.seek(0)

                # Воспроизведение
                audio_sound.play()
                print("Аудио воспроизводится")

            except Exception as e:
                print(f"Ошибка воспроизведения аудио: {e}")

    def _set_completion_timer(self, duration: int):
        """Устанавливает таймер завершения эффекта"""
        if self.reset_timer:
            self.reset_timer.cancel()

        from kivy.clock import Clock

        self.reset_timer = Clock.schedule_once(
            lambda dt: self._on_effect_complete(),
            duration / 1000.0,  # Конвертируем миллисекунды в секунды
        )

    def _on_video_finished(self, instance, value):
        """Обработчик завершения видео"""
        print("Видео завершено")

    def _on_effect_complete(self):
        """Обработчик завершения эффекта"""
        print("Эффект завершен")
        self.stop_current()

        if self.completion_callback:
            self.completion_callback()
            self.completion_callback = None

    def stop_current(self):
        """Останавливает текущее воспроизведение"""
        if not self.is_playing:
            return

        self.is_playing = False

        # Остановка таймера
        if self.reset_timer:
            self.reset_timer.cancel()
            self.reset_timer = None

        # Остановка видео
        if self.current_video_widget:
            if self.current_video_widget.state == "play":
                self.current_video_widget.state = "pause"

            if self.parent_widget:
                self.parent_widget.remove_widget(self.current_video_widget)
            self.current_video_widget = None

        # Удаление изображения
        if self.current_image_widget:
            if self.parent_widget:
                self.parent_widget.remove_widget(self.current_image_widget)
            self.current_image_widget = None

        # Остановка аудио
        if self.current_effect and self.current_effect.audio_sound:
            if self.current_effect.audio_sound.state == "play":
                self.current_effect.audio_sound.stop()

        self.current_effect = None
        print("Воспроизведение остановлено")

    def set_volume(self, volume: float):
        """Устанавливает громкость (0.0 - 1.0)"""
        volume = max(0.0, min(1.0, volume))

        # Установка громкости для текущего аудио
        if self.current_effect and self.current_effect.audio_sound:
            self.current_effect.audio_sound.volume = volume

    def cleanup(self):
        """Освобождает все ресурсы"""
        self.stop_current()

        # Очистка кэша эффектов
        for effect in self.effects_cache.values():
            effect.cleanup()

        self.effects_cache.clear()
        print("MediaPlayer очищен")


# Тестовый код
if __name__ == "__main__":
    from kivy.app import App
    from kivy.uix.widget import Widget
    from kivy.clock import Clock

    class TestMediaPlayerApp(App):
        def build(self):
            widget = Widget(size=(800, 600))

            # Создаем медиа плеер
            self.media_player = MediaPlayer()
            self.media_player.set_parent_widget(widget)

            # Тестовое воспроизведение через 2 секунды
            Clock.schedule_once(self.test_play, 2)

            return widget

        def test_play(self, dt):
            # Создаем тестовые медиафайлы (если существуют)
            test_media = {
                "image": "assets/test_image.jpg",
                "sound": "assets/test_sound.mp3",
            }

            self.media_player.play_spell(
                spell_id="test_spell", media_paths=test_media, duration=3000
            )

        def on_stop(self):
            self.media_player.cleanup()

    # Запуск теста
    TestMediaPlayerApp().run()
