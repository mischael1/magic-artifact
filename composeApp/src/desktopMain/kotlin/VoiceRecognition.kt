import kotlinx.coroutines.*
import javax.sound.sampled.*
import kotlin.math.sqrt
import java.io.File
import org.vosk.Recognizer
import org.vosk.Model
import org.vosk.LibVosk
import org.vosk.LogLevel

actual class VoiceRecognition actual constructor(
    private val onRecognized: (String) -> Unit,
    private val onStatusChange: (String) -> Unit,
    private val onTextRecognized: (String) -> Unit
) {
    private var isListening = false
    private var audioLine: TargetDataLine? = null
    private var scope = CoroutineScope(Dispatchers.IO + Job())
    private var captureJob: Job? = null
    private var isAwaitingSpell = false
    private var model: Model? = null
    private var recognizer: Recognizer? = null
    
    private val audioFormat = AudioFormat(
        AudioFormat.Encoding.PCM_SIGNED,
        16000f,
        16,
        1,
        2,
        16000f,
        false
    )
    
    // Ключевое слово для активации
    private val wakeWord = "артефакт"
    
    // База заклинаний - ключевые фразы
    private val spellKeywords = mapOf(
        "щит" to "shield",
        "защита" to "shield",
        "огонь" to "fire",
        "огненный" to "fire",
        "лед" to "ice",
        "льед" to "ice",
        "холод" to "ice",
        "молния" to "lightning",
        "электричество" to "lightning",
        "лечение" to "heal",
        "исцеление" to "heal",
        "стрела" to "arrow",
        "темная" to "arrow",
        "черная" to "arrow",
        "невидимость" to "invisibility",
        "невидим" to "invisibility",
        "телепортация" to "teleport",
        "телепорт" to "teleport"
    )
    
    init {
        initializeVosk()
    }
    
    private fun initializeVosk() {
        try {
            LibVosk.setLogLevel(LogLevel.DEBUG)
            
            // Путь к модели в ресурсах
            val modelPath = getModelPath()
            debugLog("Loading Vosk model from: $modelPath")
            
            if (!File(modelPath).exists()) {
                debugLog("ERROR: Model directory not found at $modelPath")
                return
            }
            
            model = Model(modelPath)
            recognizer = Recognizer(model!!, 16000f)
            debugLog("Vosk initialized successfully")
        } catch (e: Exception) {
            debugLog("ERROR initializing Vosk: ${e.message}")
            e.printStackTrace()
        }
    }
    
    private fun getModelPath(): String {
        // Пытаемся найти модель в ресурсах или текущей папке
        val resourcePath = File("composeApp/src/desktopMain/resources/model/vosk-model-small-ru-0.22")
        if (resourcePath.exists()) {
            return resourcePath.absolutePath
        }
        
        val appPath = File("model/vosk-model-small-ru-0.22")
        if (appPath.exists()) {
            return appPath.absolutePath
        }
        
        // Fallback: текущая рабочая директория
        val workDir = System.getProperty("user.dir")
        return "$workDir/model/vosk-model-small-ru-0.22"
    }
    
    actual fun startListening() {
        if (isListening) return
        
        if (model == null || recognizer == null) {
            onStatusChange("Vosk не инициализирован.\nПроверьте модель.")
            return
        }
        
        isListening = true
        isAwaitingSpell = false
        onStatusChange("Слушаю ключевое слово\n'артефакт'")
        
        captureJob = scope.launch {
            try {
                captureAudio()
            } catch (e: Exception) {
                debugLog("ERROR: ${e.message}")
                onStatusChange("Ошибка: ${e.message}")
                isListening = false
            }
        }
    }
    
    actual fun stopListening() {
        isListening = false
        isAwaitingSpell = false
        audioLine?.stop()
        audioLine?.close()
        audioLine = null
    }
    
    private suspend fun captureAudio() {
        try {
            val info = DataLine.Info(TargetDataLine::class.java, audioFormat)
            
            if (!AudioSystem.isLineSupported(info)) {
                onStatusChange("Микрофон не поддерживается")
                isListening = false
                return
            }
            
            audioLine = AudioSystem.getLine(info) as TargetDataLine
            audioLine?.open(audioFormat)
            audioLine?.start()
            debugLog("Audio capture started")
            
            val buffer = ByteArray(4096)
            var silenceFrames = 0
            var recordingFrames = 0
            var hasSound = false
            val recordedAudio = mutableListOf<ByteArray>()
            
            while (isListening && audioLine != null) {
                val bytesRead = audioLine!!.read(buffer, 0, buffer.size)
                
                if (bytesRead > 0) {
                    val rms = calculateRMS(buffer, bytesRead)
                    
                    // Trigger on RMS > 100
                    if (rms > 100) {
                        hasSound = true
                        silenceFrames = 0
                        recordingFrames++
                        
                        if (isAwaitingSpell) {
                            onStatusChange("Слушаю заклинание...\n(${recordingFrames / 10}s)")
                        } else {
                            onStatusChange("Слушаю...\n(${recordingFrames / 10}s)")
                        }
                        
                        recordedAudio.add(buffer.copyOf(bytesRead))
                    } else {
                        if (hasSound) {
                            silenceFrames++
                        }
                    }
                    
                    // Конец записи (5 frames silence или 8+ frames записи)
                    if (hasSound && silenceFrames > 5 && recordingFrames > 8) {
                        onStatusChange("Анализирую...")
                        delay(200)
                        recognizeVoice(recordedAudio)
                        
                        recordedAudio.clear()
                        hasSound = false
                        silenceFrames = 0
                        recordingFrames = 0
                        
                        delay(1000)
                        if (isListening) {
                            if (isAwaitingSpell) {
                                onStatusChange("Ждаю заклинание\nили скажите 'артефакт' заново")
                            } else {
                                onStatusChange("Слушаю ключевое слово\n'артефакт'")
                            }
                        }
                    }
                    
                    // Таймаут записи
                    if (recordingFrames > 800) {
                        if (hasSound) {
                            onStatusChange("Анализирую...")
                            delay(200)
                            recognizeVoice(recordedAudio)
                        }
                        recordedAudio.clear()
                        hasSound = false
                        silenceFrames = 0
                        recordingFrames = 0
                        
                        delay(1000)
                        if (isListening) {
                            if (isAwaitingSpell) {
                                onStatusChange("Ждаю заклинание\nили скажите 'артефакт' заново")
                            } else {
                                onStatusChange("Слушаю ключевое слово\n'артефакт'")
                            }
                        }
                    }
                }
                
                delay(10)
            }
        } catch (e: Exception) {
            if (isListening) {
                onStatusChange("Ошибка: ${e.message}")
            }
        } finally {
            audioLine?.stop()
            audioLine?.close()
            audioLine = null
        }
    }
    
    private suspend fun recognizeVoice(recordedAudio: List<ByteArray>) {
        try {
            if (recordedAudio.isEmpty()) {
                onStatusChange("Не удалось записать")
                return
            }
            
            val text = voiceToText(recordedAudio).lowercase()
            onTextRecognized(text)
            
            // Логируем распознанный текст
            if (text.isNotEmpty()) {
                logToFile(text)
            }
            
            if (isAwaitingSpell) {
                // Ищем заклинание
                val spellId = findSpell(text)
                if (spellId.isNotEmpty()) {
                    onRecognized(spellId)
                    onStatusChange("ЗАКЛИНАНИЕ СРАБОТАЛО!\n${spellId.uppercase()}")
                    isAwaitingSpell = false
                    delay(3000)
                    isAwaitingSpell = false
                    if (isListening) {
                        onStatusChange("Слушаю ключевое слово\n'артефакт'")
                    }
                } else {
                    onStatusChange("Заклинание не найдено\nПовторите или скажите\n'артефакт'")
                }
            } else {
                // Проверяем ключевое слово
                if (text.contains(wakeWord)) {
                    isAwaitingSpell = true
                    onStatusChange("Артефакт активирован!\nСкажите заклинание:")
                    delay(1000)
                } else {
                    onStatusChange("Слушаю ключевое слово\n'артефакт'")
                }
            }
        } catch (e: Exception) {
            debugLog("ERROR: ${e.message}")
            onStatusChange("Ошибка анализа")
        }
    }
    
    private fun voiceToText(recordedAudio: List<ByteArray>): String {
        try {
            if (recognizer == null) {
                debugLog("Recognizer is null, cannot process")
                return ""
            }
            
            // Объединяем все аудиоданные
            val allBytes = ByteArray(recordedAudio.sumOf { it.size })
            var offset = 0
            for (chunk in recordedAudio) {
                chunk.copyInto(allBytes, offset)
                offset += chunk.size
            }
            
            if (allBytes.isEmpty()) return ""
            
            return recognizeWithVosk(allBytes)
        } catch (e: Exception) {
            debugLog("ERROR in voiceToText: ${e.message}")
            e.printStackTrace()
            return ""
        }
    }
    
    private fun recognizeWithVosk(audioBytes: ByteArray): String {
        return try {
            debugLog("=== START VOSK RECOGNITION ===")
            debugLog("Audio bytes: ${audioBytes.size}")
            
            val rec = recognizer ?: return ""
            var finalText = ""
            
            // Подаём аудиоданные в распознаватель потоком
            var offset = 0
            while (offset < audioBytes.size) {
                val chunkSize = minOf(4096, audioBytes.size - offset)
                val chunk = audioBytes.sliceArray(offset until offset + chunkSize)
                
                if (rec.acceptWaveForm(chunk, chunk.size)) {
                    // Получаем результат
                    val result = rec.result
                    debugLog("Vosk result: $result")
                    finalText = extractText(result)
                } else {
                    // Получаем промежуточный результат
                    val partial = rec.partialResult
                    debugLog("Vosk partial: $partial")
                }
                
                offset += chunkSize
            }
            
            // Получаем финальный результат
            val finalResult = rec.finalResult
            debugLog("Vosk final result: $finalResult")
            finalText = extractText(finalResult)
            
            debugLog("Final recognized text: '$finalText'")
            if (finalText.isNotEmpty()) {
                debugLog("SUCCESS: Text recognized")
            } else {
                debugLog("NO RESULT from Vosk")
            }
            
            finalText
        } catch (e: Exception) {
            debugLog("ERROR in recognizeWithVosk: ${e.message}")
            e.printStackTrace()
            ""
        }
    }
    
    private fun extractText(jsonResult: String): String {
        return try {
            // Простой парсинг JSON: ищем "result" или "text" поле
            val resultMatch = """"result"\s*:\s*\[(.*?)\]""".toRegex().find(jsonResult)
            if (resultMatch != null) {
                // Парсим массив объектов с полями "word"
                val arrayContent = resultMatch.groupValues[1]
                val words = mutableListOf<String>()
                val wordPattern = """"word"\s*:\s*"([^"]*)"""".toRegex()
                wordPattern.findAll(arrayContent).forEach { match ->
                    words.add(match.groupValues[1])
                }
                words.joinToString(" ")
            } else {
                // Fallback: ищем поле "text"
                val textMatch = """"text"\s*:\s*"([^"]*)"""".toRegex().find(jsonResult)
                textMatch?.groupValues?.get(1) ?: ""
            }
        } catch (e: Exception) {
            debugLog("Error extracting text from JSON: ${e.message}")
            ""
        }
    }
    
    private fun findSpell(text: String): String {
        for ((keyword, spell) in spellKeywords) {
            if (text.contains(keyword)) {
                return spell
            }
        }
        return ""
    }
    
    private fun calculateRMS(buffer: ByteArray, length: Int): Double {
        var sum = 0.0
        var count = 0
        var i = 0
        while (i < length && i + 1 < buffer.size) {
            val s1 = buffer[i].toInt() and 0xFF
            val s2 = buffer[i + 1].toInt() and 0xFF
            val sample = ((s2 shl 8) or s1).toShort().toDouble()
            sum += sample * sample
            count++
            i += 2
        }
        return if (count > 0) sqrt(sum / count) else 0.0
    }
    
    private fun logToFile(text: String) {
        try {
            val workDir = System.getProperty("user.dir")
            val logFile = File(workDir, "recognized_text.txt")
            val timestamp = java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss.SSS")
            )
            val line = "[$timestamp] $text\n"
            logFile.appendText(line, Charsets.UTF_8)
            debugLog("Logged to $workDir/recognized_text.txt")
        } catch (e: Exception) {
            debugLog("ERROR writing to log: ${e.message}")
        }
    }
    
    private fun debugLog(msg: String) {
        try {
            val workDir = System.getProperty("user.dir")
            val logFile = File(workDir, "debug.log")
            val timestamp = java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss.SSS")
            )
            logFile.appendText("[$timestamp] $msg\n")
            println("[DEBUG] $msg")
        } catch (e: Exception) {
            println("DEBUG LOG ERROR: ${e.message}")
        }
    }
    
    actual fun cleanup() {
        stopListening()
        captureJob?.cancel()
        scope.cancel()
        try {
            recognizer?.close()
            model?.close()
        } catch (e: Exception) {
            debugLog("Error closing Vosk resources: ${e.message}")
        }
    }
}
