package managers

data class SpellData(
    val id: String,
    val name: String,
    val keywords: List<String>,
    val media: List<String> = emptyList(),
    val duration: Float = 3f,
    val enabled: Boolean = true
)

class SpellManager {
    private val spells = mutableListOf<SpellData>()
    private val lastCastTimes = mutableMapOf<String, Long>()
    
    init {
        loadDefaultSpells()
    }
    
    private fun loadDefaultSpells() {
        spells.addAll(listOf(
            SpellData(
                id = "spell_fire",
                name = "Огненный взрыв",
                keywords = listOf("огонь", "взрыв", "горит"),
                media = listOf("fire_effect", "fire_sound"),
                duration = 2.5f
            ),
            SpellData(
                id = "spell_ice",
                name = "Ледяная буря",
                keywords = listOf("лед", "холод", "мороз"),
                media = listOf("ice_effect", "ice_sound"),
                duration = 3f
            ),
            SpellData(
                id = "spell_lightning",
                name = "Молния",
                keywords = listOf("молния", "электричество", "гром"),
                media = listOf("lightning_effect", "lightning_sound"),
                duration = 2f
            )
        ))
    }
    
    fun findSpell(query: String): String? {
        val lowerQuery = query.lowercase()
        return spells.find { spell ->
            spell.enabled && spell.keywords.any { keyword ->
                lowerQuery.contains(keyword) || keyword.contains(lowerQuery)
            }
        }?.id
    }
    
    fun getSpellData(spellId: String): SpellData? {
        return spells.find { it.id == spellId }
    }
    
    fun getWakeWord(): String = "артефакт"
    
    fun getResetTimeout(): Float = 10f
    
    fun getSpellDuration(spellId: String): Float {
        return getSpellData(spellId)?.duration ?: 3f
    }
    
    fun getSpellMediaPaths(spellId: String): List<String> {
        return getSpellData(spellId)?.media ?: emptyList()
    }
    
    fun updateLastCast(spellId: String) {
        lastCastTimes[spellId] = System.currentTimeMillis()
    }
    
    fun addSpell(spell: SpellData) {
        spells.removeAll { it.id == spell.id }
        spells.add(spell)
    }
    
    fun getAllSpells(): List<SpellData> = spells.toList()
}
