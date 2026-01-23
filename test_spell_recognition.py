# Тест системы распознавания заклинаний

import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), "src"))

from spell_manager import SpellManager


def test_spell_recognition():
    """Тестирует распознавание заклинаний"""

    # Создаем менеджер заклинаний
    spell_manager = SpellManager()

    print("TEST SISTEMY RASPOZNAVANIYa ZAKLINANIY")
    print("=" * 50)
print(f"Wake-word: '{spell_manager.get_wake_word()}'")
    print(f"Autosbros: {spell_manager.get_reset_timeout()} sekund")
    print()
    
    # Poluchaem vse zaklinaniya
    spells_info = spell_manager.get_all_spells_info()
    
    print("DOSTUPNYe ZAKLINANIYa:")
    print("-" * 30)
    for spell in spells_info:
        print(f"{spell['name']}")
        print(f"   ID: {spell['id']}")
        print(f"   Aktivatsiya: {', '.join(spell['trigger_words'])}")
        print()

    print("🧪 ТЕСТ РАСПОЗНАВАНИЯ:")
    print("-" * 30)

    # Тестовые фразы
    test_phrases = [
        "огненный шар",
        "фаер болл",
        "fireball",
        "лечение",
        "хил",
        "heal",
        "исцеление",
        "щит",
        "защита",
        "shield",
        "магический щит",
        "темная стрела",
        "дарк болт",
        "dark bolt",
        "молния",
        "электричество",
        "lightning",
        "разряд",
        "несуществующее заклинание",
        "привет мир",
        "абракадабра",
    ]

    for phrase in test_phrases:
        spell_id = spell_manager.find_spell(phrase)
        if spell_id:
            spell_data = spell_manager.get_spell_data(spell_id)
            if spell_data:
                print(f"✅ '{phrase}' -> {spell_data['name']}")
            else:
                print(f"⚠️ '{phrase}' -> {spell_id} (данные не найдены)")
        else:
            print(f"❌ '{phrase}' -> Не распознано")

    print()
    print("🎯 ТОЧНОСТЬ РАСПОЗНАВАНИЯ:")
    print("-" * 30)

    # Тест точных совпадений
    exact_matches = [
        ("огненный шар", "огненный_шар"),
        ("лечение", "лечение"),
        ("щит", "магический_щит"),
        ("молния", "молния"),
    ]

    correct = 0
    total = len(exact_matches)

    for phrase, expected_id in exact_matches:
        result_id = spell_manager.find_spell(phrase)
        if result_id == expected_id:
            correct += 1
            print(f"✅ '{phrase}' -> {result_id}")
        else:
            print(f"❌ '{phrase}' -> {result_id} (ожидал {expected_id})")

    accuracy = (correct / total) * 100 if total > 0 else 0
    print(f"\n📊 Точность: {correct}/{total} ({accuracy:.1f}%)")

    print()
    print("🔍 АНАЛИЗ СХОЖЕСТИ:")
    print("-" * 30)

    # Тест похожих фраз
    similarity_tests = [
        ("огненный шар", "огненный шар"),  # 100%
        ("огненный шар", "фаер болл"),  # 0%
        ("огненный шар", "огненный шары"),  # 50%
        ("лечение", "хил"),  # 0%
        ("лечение", "лечение"),  # 100%
        ("щит", "защита"),  # 0%
        ("щит", "щит"),  # 100%
    ]

    for text1, text2 in similarity_tests:
        similarity = spell_manager.calculate_similarity(text1, text2)
        print(f"'{text1}' vs '{text2}': {similarity:.2f}")

    print()
    print("💡 СОВЕТЫ ПО ИСПОЛЬЗОВАНИЮ:")
    print("-" * 30)
    print("1. Говорите четко и разборчиво")
    print("2. Используйте точные фразы из списка")
    print("3. Избегайте фонового шума")
    print("4. Произносите wake-word 'артефакт' для активации")
    print("5. После wake-word произнесите заклинание в течение 5 секунд")


if __name__ == "__main__":
    test_spell_recognition()
