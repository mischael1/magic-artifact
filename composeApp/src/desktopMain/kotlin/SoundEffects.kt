import javax.sound.sampled.*
import java.io.File
import kotlin.math.sin
import kotlin.math.PI

actual class SoundEffects {
    private var audioClip: Clip? = null
    
    actual fun playSound(spellId: String) {
        try {
            // Stop any currently playing sound
            audioClip?.stop()
            audioClip?.close()
            
            // Generate distinctive sound for each spell
            val (frequency, duration, modulation) = when (spellId.lowercase()) {
                "shield" -> Triple(1000, 400, 0.3)      // Medium-high, steady
                "fire" -> Triple(600, 300, 0.1)         // Lower, quick
                "ice" -> Triple(1400, 350, 0.5)         // High, modulated
                "lightning" -> Triple(800, 200, 0.8)    // Chaotic, very modulated
                "heal" -> Triple(1200, 500, 0.2)        // High, smooth
                "arrow" -> Triple(500, 250, 0.4)        // Low, sharp
                "invisibility" -> Triple(2000, 600, 0.6) // Very high, fade
                "teleport" -> Triple(1100, 400, 0.7)    // Rising pitch effect
                else -> Triple(800, 300, 0.3)
            }
            
            val audioFormat = AudioFormat(
                AudioFormat.Encoding.PCM_SIGNED,
                44100f,
                16,
                1,
                2,
                44100f,
                false
            )
            
            val audioData = generateSpellSound(frequency, duration, 44100, modulation)
            
            audioClip = AudioSystem.getClip()
            audioClip?.open(audioFormat, audioData, 0, audioData.size)
            audioClip?.start()
        } catch (e: Exception) {
            System.err.println("Sound error: ${e.message}")
        }
    }
    
    private fun generateSpellSound(
        baseFrequency: Int,
        durationMillis: Int,
        sampleRate: Int,
        modulation: Double
    ): ByteArray {
        val sampleCount = (sampleRate * durationMillis / 1000.0).toInt()
        val audioData = ByteArray(sampleCount * 2) // 16-bit = 2 bytes
        
        val amplitude = Short.MAX_VALUE / 2.5
        val angularFreq = 2.0 * PI * baseFrequency / sampleRate
        
        for (i in 0 until sampleCount) {
            // Базовый тон
            var sample = sin(angularFreq * i)
            
            // Модуляция частоты (для эффекта)
            val freqMod = 1.0 + modulation * sin(2.0 * PI * i / sampleRate * 5)
            sample += sin(angularFreq * i * freqMod) * modulation
            
            // Огибающая (fade in/out)
            val envelope = when {
                i < sampleCount * 0.1 -> i.toDouble() / (sampleCount * 0.1) // Fade in
                i > sampleCount * 0.85 -> (sampleCount - i).toDouble() / (sampleCount * 0.15) // Fade out
                else -> 1.0
            }
            
            sample *= envelope
            sample /= (1.0 + modulation)
            
            val finalSample = (amplitude * sample).toInt().toShort()
            audioData[i * 2] = (finalSample.toInt() and 0xFF).toByte()
            audioData[i * 2 + 1] = ((finalSample.toInt() shr 8) and 0xFF).toByte()
        }
        
        return audioData
    }
    
    actual fun cleanup() {
        audioClip?.stop()
        audioClip?.close()
    }
}
