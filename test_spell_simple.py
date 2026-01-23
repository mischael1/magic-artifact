# Test spell recognition system

import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), "src"))

from spell_manager import SpellManager


def test_spell_recognition():
    """Test spell recognition system"""

    # Create spell manager
    spell_manager = SpellManager()

    print("TEST SPELL RECOGNITION SYSTEM")
    print("=" * 50)
    print(f"Wake-word: '{spell_manager.get_wake_word()}'")
    print(f"Auto-reset: {spell_manager.get_reset_timeout()} seconds")
    print()

    # Get all spells
    spells_info = spell_manager.get_all_spells_info()

    print("AVAILABLE SPELLS:")
    print("-" * 30)
    for spell in spells_info:
        print(f"* {spell['name']}")
        print(f"  ID: {spell['id']}")
        print(f"  Activation: {', '.join(spell['trigger_words'])}")
        print()

    print("TEST RECOGNITION:")
    print("-" * 30)

    # Test phrases
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
        "темная магия",
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
                print(f"OK: '{phrase}' -> {spell_data['name']}")
            else:
                print(f"WARNING: '{phrase}' -> {spell_id} (data not found)")
        else:
            print(f"NOT RECOGNIZED: '{phrase}'")

    print()
    print("ACCURACY TEST:")
    print("-" * 30)

    # Test exact matches
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
            print(f"✓ '{phrase}' -> {result_id}")
        else:
            print(f"✗ '{phrase}' -> {result_id} (expected {expected_id})")

    accuracy = (correct / total) * 100 if total > 0 else 0
    print(f"\nAccuracy: {correct}/{total} ({accuracy:.1f}%)")

    print()
    print("SIMILARITY SCORES:")
    print("-" * 30)

    # Test similarity scores
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
    print("USAGE TIPS:")
    print("-" * 30)
    print("1. Speak clearly and distinctly")
    print("2. Use exact phrases from the list")
    print("3. Avoid background noise")
    print("4. Say wake-word 'артефакт' first")
    print("5. Say spell within 5 seconds")

    # Show all trigger words
    print()
    print("ALL TRIGGER WORDS:")
    print("-" * 30)
    for spell in spells_info:
        for trigger in spell["trigger_words"]:
            print(f"  • {trigger}")


if __name__ == "__main__":
    test_spell_recognition()
