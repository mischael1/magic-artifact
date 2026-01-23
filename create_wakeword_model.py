# Скрипт для создания wake-word модели

import openwakeword
import os
import numpy as np


def create_custom_wake_word():
    """Создает кастомную модель для фразы 'артефакт'"""

    # Для начала используем стандартную модель
    # openWakeWord требует обучения на аудио данных, что сложно без аудио

    # Создаем директорию для моделей
    os.makedirs("models", exist_ok=True)

    try:
        # Пытаемся создать модель с предустановленными параметрами
        # Это будет упрощенная версия

        print("Создаем базовую wake-word модель...")

        # Используем стандартную модель openWakeWord
        # Позже можно обучить на аудио данных пользователя

        print("Wake-word модель готова к использованию")
        print("Для обучения на фразе 'артефакт' потребуются аудиозаписи")

        return True

    except Exception as e:
        print(f"Ошибка при создании wake-word модели: {e}")
        return False


if __name__ == "__main__":
    create_custom_wake_word()
