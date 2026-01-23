# Простое изображение фона можно создать программно

import math
from PIL import Image, ImageDraw
import os


def create_magic_background(width=1280, height=720):
    """Создает магический фон для артефакта"""
    # Создаем изображение
    image = Image.new("RGB", (width, height), color=(20, 10, 40))  # Темно-фиолетовый
    draw = ImageDraw.Draw(image)

    # Рисуем магические круги
    center_x, center_y = width // 2, height // 2

    # Внешний круг
    draw.ellipse(
        [center_x - 150, center_y - 150, center_x + 150, center_y + 150],
        outline=(80, 50, 130),
        width=3,
    )

    # Средний круг
    draw.ellipse(
        [center_x - 100, center_y - 100, center_x + 100, center_y + 100],
        outline=(120, 80, 180),
        width=2,
    )

    # Внутренний круг
    draw.ellipse(
        [center_x - 50, center_y - 50, center_x + 50, center_y + 50],
        outline=(180, 130, 230),
        width=2,
    )

    # Добавляем магические символы
    for i in range(8):
        angle = i * math.pi / 4
        x = center_x + 200 * math.cos(angle)
        y = center_y + 200 * math.sin(angle)
        draw.ellipse([x - 5, y - 5, x + 5, y + 5], fill=(200, 150, 255))

    return image


def create_spell_effect(spell_type="fire", width=640, height=480):
    """Создает изображение эффекта заклинания"""
    image = Image.new("RGBA", (width, height), color=(0, 0, 0, 0))
    draw = ImageDraw.Draw(image)

    center_x, center_y = width // 2, height // 2

    if spell_type == "fire":
        # Огненный эффект - красные и оранжевые круги
        for i in range(5):
            size = 100 - i * 15
            color = (255, 100 + i * 30, 0, 200 - i * 30)
            draw.ellipse(
                [center_x - size, center_y - size, center_x + size, center_y + size],
                outline=color,
                width=3,
            )

    elif spell_type == "heal":
        # Лечебный эффект - зеленые и синие круги
        for i in range(5):
            size = 80 - i * 12
            color = (0, 200 - i * 30, 255 - i * 20, 180 - i * 20)
            draw.ellipse(
                [center_x - size, center_y - size, center_x + size, center_y + size],
                outline=color,
                width=2,
            )

    elif spell_type == "shield":
        # Защитный эффект - синие круги
        for i in range(4):
            size = 120 - i * 20
            color = (0, 100 + i * 40, 255, 150 - i * 20)
            draw.ellipse(
                [center_x - size, center_y - size, center_x + size, center_y + size],
                outline=color,
                width=4,
            )

    return image


if __name__ == "__main__":
    # Создаем папки если их нет
    os.makedirs("assets/images", exist_ok=True)
    os.makedirs("assets/spells/fireball", exist_ok=True)
    os.makedirs("assets/spells/heal", exist_ok=True)
    os.makedirs("assets/spells/shield", exist_ok=True)

    # Создаем фоновое изображение
    bg = create_magic_background()
    bg.save("assets/images/background.jpg", "JPEG", quality=85)
    print("Фоновое изображение создано: assets/images/background.jpg")

    # Создаем эффекты заклинаний
    fire_effect = create_spell_effect("fire")
    fire_effect.convert("RGB").save(
        "assets/spells/fireball/image.jpg", "JPEG", quality=85
    )
    print("Эффект огненного шара создан: assets/spells/fireball/image.jpg")

    heal_effect = create_spell_effect("heal")
    heal_effect.convert("RGB").save("assets/spells/heal/image.jpg", "JPEG", quality=85)
    print("Эффект лечения создан: assets/spells/heal/image.jpg")

    shield_effect = create_spell_effect("shield")
    shield_effect.convert("RGB").save(
        "assets/spells/shield/image.jpg", "JPEG", quality=85
    )
    print("Эффект щита создан: assets/spells/shield/image.jpg")
