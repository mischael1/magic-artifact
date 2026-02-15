import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application
import androidx.compose.ui.window.WindowState
import androidx.compose.ui.unit.dp
import javax.sound.sampled.*
import kotlin.math.sqrt

fun main(args: Array<String>) {
    // Устанавливаем UTF-8 для консоли
    System.setProperty("file.encoding", "UTF-8")
    System.setProperty("stdout.encoding", "UTF-8")
    System.setProperty("stderr.encoding", "UTF-8")
    
    val workDir = System.getProperty("user.dir")
    println("Working directory: $workDir")
    println("Java version: ${System.getProperty("java.version")}")
    
    // Логируем начало работы
    val startLog = java.io.File(workDir, "app_start.log")
    startLog.writeText("App started at ${java.time.LocalDateTime.now()}\nWorking dir: $workDir\n", Charsets.UTF_8)
    
    if (args.contains("--test-mic")) {
        testMicrophone()
        return
    }
    
    println("Starting Magic Artifact application...")
    try {
        application {
            Window(
                onCloseRequest = ::exitApplication,
                title = "MAGIC ARTIFACT - Voice Spell Recognition",
                state = WindowState(width = 500.dp, height = 1000.dp),
                resizable = true
            ) {
                println("Creating App composable...")
                AppContent()
            }
        }
    } catch (e: Exception) {
        println("FATAL ERROR: ${e.message}")
        e.printStackTrace()
    }
}

fun testMicrophone() {
    println("=== MICROPHONE TEST ===")
    
    val audioFormat = AudioFormat(
        AudioFormat.Encoding.PCM_SIGNED,
        16000f,
        16,
        1,
        2,
        16000f,
        false
    )
    
    val info = DataLine.Info(TargetDataLine::class.java, audioFormat)
    
    if (!AudioSystem.isLineSupported(info)) {
        println("ERROR: Microphone not supported")
        return
    }
    
    val audioLine = AudioSystem.getLine(info) as TargetDataLine
    audioLine.open(audioFormat)
    audioLine.start()
    
    println("Microphone opened. Recording 3 seconds...")
    println("SPEAK NOW:")
    
    val buffer = ByteArray(4096)
    var totalBytes = 0
    var maxRMS = 0.0
    val startTime = System.currentTimeMillis()
    
    while (System.currentTimeMillis() - startTime < 3000) {
        val bytesRead = audioLine.read(buffer, 0, buffer.size)
        if (bytesRead > 0) {
            totalBytes += bytesRead
            val rms = calculateTestRMS(buffer, bytesRead)
            if (rms > maxRMS) maxRMS = rms
            println("Read $bytesRead bytes, RMS: %.0f".format(rms))
        }
        Thread.sleep(10)
    }
    
    audioLine.stop()
    audioLine.close()
    
    println("\nRecording complete!")
    println("Total bytes: $totalBytes")
    println("Max RMS: %.0f".format(maxRMS))
}

private fun calculateTestRMS(buffer: ByteArray, length: Int): Double {
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
