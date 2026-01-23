# Менеджер заклинаний для Магического Артефакта

import json
import os
import time
from typing import Dict, Optional, List, Tuple


class SpellManager:
    """Управляет базой заклинаний и их активацией"""

    def __init__(
        self, spells_file: str = "data/spells.json", assets_path: str = "assets"
    ):
        self.spells_file = spells_file
        self.assets_path = assets_path
        self.spells_data = {}
        self.last_spell_time = {}
        self.load_spells()

    def load_spells(self):
        """Загружает базу заклинаний из JSON файла"""
        try:
            if os.path.exists(self.spells_file):
                with open(self.spells_file, "r", encoding="utf-8") as f:
                    self.spells_data = json.load(f)
                print(f"Загружено {len(self.spells_data.get('spells', {}))} заклинаний")
            else:
                print(f"Файл заклинаний не найден: {self.spells_file}")
                self.create_default_spells()
        except Exception as e:
            print(f"Ошибка загрузки заклинаний: {e}")
            self.create_default_spells()

    def create_default_spells(self):
        """Создает базовую структуру заклинаний"""
        self.spells_data = {
            "meta": {
                "version": "1.0",
                "language": "ru",
                "wake_word": "артефакт",
                "auto_reset_timeout": 30,
            },
            "spells": {
                "огненный_шар": {
                    "name": "Огненный шар",
                    "trigger_words": ["огненный шар", "фаер болл", "fireball"],
                    "description": "Создает мощный огненный снаряд",
                    "media": {"sound": "sounds/fireball.mp3"},
                    "duration": 5000,
                    "effects": ["fire", "explosion"],
                }
            },
            "settings": {"volume": 0.8, "auto_play": True},
        }

    def find_spell(self, text: str) -> Optional[str]:
        """Ищет заклинание по текстовому описанию"""
        if not text or not isinstance(text, str):
            return None

        text = text.lower().strip()
        best_match = None
        best_score = 0

        spells = self.spells_data.get("spells", {})
        if not spells:
            return None

        for spell_id, spell_data in spells.items():
            trigger_words = spell_data.get("trigger_words", [])
            for trigger in trigger_words:
                score = self.calculate_similarity(text, trigger.lower())
                if score > best_score and score > 0.7:  # Порог схожести
                    best_score = score
                    best_match = spell_id

        return best_match

    def calculate_similarity(self, text1: str, text2: str) -> float:
        """Рассчитывает схожесть двух текстов"""
        if text1 == text2:
            return 1.0

        # Простое сравнение по включению слов
        words1 = set(text1.split())
        words2 = set(text2.split())

        if not words1 or not words2:
            return 0.0

        intersection = words1.intersection(words2)
        union = words1.union(words2)

        return len(intersection) / len(union) if union else 0.0

    def get_spell_data(self, spell_id: str) -> Optional[Dict]:
        """Получает данные заклинания по ID"""
        spells = self.spells_data.get("spells", {})
        return spells.get(spell_id)

    def get_spell_media_paths(self, spell_id: str) -> Dict[str, str]:
        """Получает полные пути к медиафайлам заклинания"""
        spell_data = self.get_spell_data(spell_id)
        if not spell_data:
            return {}

        media_paths = {}
        media_files = spell_data.get("media", {})

        for media_type, path in media_files.items():
            full_path = os.path.join(self.assets_path, path)
            if os.path.exists(full_path):
                media_paths[media_type] = full_path

        return media_paths

    def check_cooldown(self, spell_id: str) -> bool:
        """Проверяет, прошло ли время перезарядки заклинания"""
        spell_data = self.get_spell_data(spell_id)
        if not spell_data:
            return True

        cooldown = spell_data.get("cooldown", 0)
        if cooldown <= 0:
            return True

        last_time = self.last_spell_time.get(spell_id, 0)
        current_time = time.time()

        return (current_time - last_time) >= cooldown

    def update_last_cast(self, spell_id: str):
        """Обновляет время последнего использования заклинания"""
        self.last_spell_time[spell_id] = time.time()

    def get_spell_duration(self, spell_id: str) -> int:
        """Получает длительность заклинания в миллисекундах"""
        spell_data = self.get_spell_data(spell_id)
        return spell_data.get("duration", 3000) if spell_data else 3000

    def get_reset_timeout(self) -> int:
        """Получает время автосброса в секундах"""
        return self.spells_data.get("meta", {}).get("auto_reset_timeout", 30)

    def get_wake_word(self) -> str:
        """Получает фразу активации"""
        return self.spells_data.get("meta", {}).get("wake_word", "артефакт")

    def get_all_spells_info(self) -> List[Dict]:
        """Получает информацию о всех заклинаниях"""
        spells_info = []
        spells = self.spells_data.get("spells", {})

        for spell_id, spell_data in spells.items():
            spells_info.append(
                {
                    "id": spell_id,
                    "name": spell_data.get("name", spell_id),
                    "description": spell_data.get("description", ""),
                    "trigger_words": spell_data.get("trigger_words", []),
                }
            )

        return spells_info

    def save_spells(self):
        """Сохраняет базу заклинаний в файл"""
        try:
            with open(self.spells_file, "w", encoding="utf-8") as f:
                json.dump(self.spells_data, f, ensure_ascii=False, indent=2)
            print(f"Заклинания сохранены в {self.spells_file}")
        except Exception as e:
            print(f"Ошибка сохранения заклинаний: {e}")


# Тестовый код
if __name__ == "__main__":
    # Создаем тестовый менеджер заклинаний
    spell_manager = SpellManager()

    # Тестируем поиск заклинаний
    test_phrases = [
        "огненный шар",
        "фаер болл",
        "лечение",
        "хил",
        "несуществующее заклинание",
    ]

    print("Тестирование поиска заклинаний:")
    for phrase in test_phrases:
        spell_id = spell_manager.find_spell(phrase)
        if spell_id:
            spell_data = spell_manager.get_spell_data(spell_id)
            if spell_data:
                print(f"'{phrase}' -> {spell_data['name']}")
        else:
            print(f"'{phrase}' -> Не найдено")

    # Показываем информацию о всех заклинаниях
    print("\nВсе доступные заклинания:")
    for spell_info in spell_manager.get_all_spells_info():
        print(f"- {spell_info['name']}: {spell_info['description']}")
        print(f"  Триггеры: {', '.join(spell_info['trigger_words'])}")
