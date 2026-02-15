package com.magicartifact

import android.util.Log

private const val TAG = "SpellRecognizer"

/**
 * Класс для распознавания и сравнения заклинаний
 */
class SpellRecognizer {
    
    init {
        Log.d(TAG, "SpellRecognizer initialized")
        Log.d(TAG, "Available spells: ${spellDatabase.size}")
    }
    
    private val spellDatabase = mapOf(
        "огненный_шар" to SpellData(
            id = "огненный_шар",
            name = "Огненный шар",
            triggers = listOf("огненный шар", "фаер болл", "fireball"),
            description = "Создает мощный огненный снаряд"
        ),
        "ледяной_удар" to SpellData(
            id = "ледяной_удар",
            name = "Ледяной удар",
            triggers = listOf("ледяной удар", "фрост болт", "ice bolt"),
            description = "Замораживающее заклинание"
        ),
        "магический_щит" to SpellData(
            id = "магический_щит",
            name = "Магический щит",
            triggers = listOf("магический щит", "щит", "shield"),
            description = "Защитное заклинание"
        ),
        "исцеление" to SpellData(
            id = "исцеление",
            name = "Исцеление",
            triggers = listOf("исцеление", "хил", "heal"),
            description = "Восстанавливает здоровье"
        ),
        "молния" to SpellData(
            id = "молния",
            name = "Молния",
            triggers = listOf("молния", "электрический удар", "lightning"),
            description = "Мощный электрический удар"
        )
    )
    
    /**
     * Ищет заклинание по распознанному тексту
     */
    fun findSpell(recognizedText: String): SpellData? {
        Log.d(TAG, "findSpell called with text: '$recognizedText'")
        
        if (recognizedText.isBlank()) {
            Log.d(TAG, "Text is blank, returning null")
            return null
        }
        
        val normalizedText = recognizedText.lowercase().trim()
        Log.d(TAG, "Normalized text: '$normalizedText'")
        
        var bestMatch: SpellData? = null
        var bestScore = 0.0
        
        for (spell in spellDatabase.values) {
            for (trigger in spell.triggers) {
                val score = calculateSimilarity(normalizedText, trigger.lowercase())
                Log.d(TAG, "Comparing '$normalizedText' with trigger '${trigger.lowercase()}': score=$score")
                if (score > bestScore && score > 0.6) {
                    bestScore = score
                    bestMatch = spell
                    Log.d(TAG, "New best match: ${spell.name} with score $bestScore")
                }
            }
        }
        
        Log.d(TAG, "findSpell result: ${bestMatch?.name ?: "null"}")
        return bestMatch
    }
    
    /**
     * Рассчитывает схожесть двух текстов (Jaccard similarity)
     */
    private fun calculateSimilarity(text1: String, text2: String): Double {
        if (text1 == text2) return 1.0
        
        val words1 = text1.split(Regex("\\s+")).toSet()
        val words2 = text2.split(Regex("\\s+")).toSet()
        
        if (words1.isEmpty() || words2.isEmpty()) return 0.0
        
        val intersection = words1.intersect(words2).size.toDouble()
        val union = words1.union(words2).size.toDouble()
        
        return if (union > 0) intersection / union else 0.0
    }
    
    /**
     * Получает список всех доступных заклинаний
     */
    fun getAllSpells(): List<SpellData> = spellDatabase.values.toList()
}

/**
 * Данные о заклинании
 */
data class SpellData(
    val id: String,
    val name: String,
    val triggers: List<String>,
    val description: String
)
