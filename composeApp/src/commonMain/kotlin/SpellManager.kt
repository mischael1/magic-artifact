data class Spell(
    val id: String,
    val name: String,
    val keywords: List<String>,
    val description: String
)

object SpellManager {
    private val spells = listOf(
        Spell(
            id = "shield",
            name = "Магический Щит",
            keywords = listOf("щит", "защита", "shield", "protection"),
            description = "Создаёт магический щит для защиты"
        ),
        Spell(
            id = "fire",
            name = "Огненный Шар",
            keywords = listOf("огонь", "огненный", "пожар", "fire", "flame"),
            description = "Запускает огненный шар в противника"
        ),
        Spell(
            id = "ice",
            name = "Ледяная Стрела",
            keywords = listOf("лед", "льед", "холод", "мороз", "ice", "freeze"),
            description = "Запускает острую ледяную стрелу"
        ),
        Spell(
            id = "lightning",
            name = "Молния",
            keywords = listOf("молния", "электричество", "гром", "lightning", "thunder"),
            description = "Вызывает удар молнии"
        ),
        Spell(
            id = "heal",
            name = "Исцеление",
            keywords = listOf("лечение", "исцеление", "здоровье", "heal", "cure"),
            description = "Восстанавливает здоровье товарища"
        ),
        Spell(
            id = "arrow",
            name = "Тёмная Стрела",
            keywords = listOf("стрела", "темная", "черная", "arrow", "dark"),
            description = "Запускает тёмную энергетическую стрелу"
        ),
        Spell(
            id = "invisibility",
            name = "Невидимость",
            keywords = listOf("невидимость", "скрыться", "invisibility", "hide"),
            description = "Делает персонажа невидимым"
        ),
        Spell(
            id = "teleport",
            name = "Телепортация",
            keywords = listOf("телепорт", "портал", "телепортация", "teleport"),
            description = "Телепортирует персонажа на дальние расстояния"
        )
    )
    
    fun findSpell(text: String): Spell? {
        val lowerText = text.lowercase()
        
        // Поиск по ключевым словам
        for (spell in spells) {
            for (keyword in spell.keywords) {
                if (lowerText.contains(keyword)) {
                    return spell
                }
            }
        }
        
        return null
    }
    
    fun getAllSpells(): List<Spell> = spells
    
    fun getSpellById(id: String): Spell? = spells.find { it.id == id }
}
