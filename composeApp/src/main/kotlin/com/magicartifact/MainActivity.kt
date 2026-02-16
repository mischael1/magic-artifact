package com.magicartifact

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.WindowManager
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import kotlinx.coroutines.launch

private const val TAG = "MagicArtifact"

class MainActivity : ComponentActivity() {
    
    private lateinit var voiceManager: VoiceManager
    
    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted: Boolean ->
        Log.d(TAG, "Audio permission granted: $isGranted")
        if (isGranted) {
            voiceManager.startListening()
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        Log.e(TAG, ">>> MainActivity onCreate called <<<")
        Log.e(TAG, "App is starting!")
        
        // Инициализируем VoiceManager
        voiceManager = VoiceManager(this)
        
        // Полноэкранный режим
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        
        Log.d(TAG, "Window flags set")
        
        // Проверка и запрос разрешений
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            when {
                ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.RECORD_AUDIO
                ) == PackageManager.PERMISSION_GRANTED -> {
                    Log.d(TAG, "Audio permission already granted")
                }
                else -> {
                    Log.d(TAG, "Requesting audio permission")
                    requestPermissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
                }
            }
        }
        
        Log.d(TAG, "Setting content")
        try {
            setContent {
                Log.d(TAG, "Content composable started")
                MaterialTheme {
                    Log.d(TAG, "Rendering AppScreen")
                    AppScreen(voiceManager)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in setContent", e)
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        voiceManager.cleanup()
    }
}

@Composable
fun AppScreen(voiceManager: VoiceManager) {
    Log.d(TAG, "AppScreen composable created")
    
    // Make system UI bars transparent so content goes behind them
    val systemUiController = rememberSystemUiController()
    LaunchedEffect(Unit) {
        systemUiController.setStatusBarColor(
            color = Color.Transparent,
            darkIcons = false
        )
        systemUiController.setNavigationBarColor(
            color = Color.Transparent,
            darkIcons = false
        )
    }
    
    var recognizedText by remember { mutableStateOf("") }
    var isAwaitingArtifact by remember { mutableStateOf(true) }
    var allRecognizedWords by remember { mutableStateOf(listOf<String>()) }
    
    val spellRecognizer = remember { 
        Log.d(TAG, "Creating SpellRecognizer")
        SpellRecognizer() 
    }
    
    // Animation for color transition
    val infiniteTransition = rememberInfiniteTransition(label = "color_animation")
    val colorAnim by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(8000, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "hue_animation"
    )
    
    fun hsvToRgb(h: Float, s: Float, v: Float): Color {
        val c = v * s
        val hPrime = h / 60f
        val x = c * (1 - Math.abs((hPrime % 2) - 1).toFloat())
        val (r1, g1, b1) = when {
            hPrime < 1 -> Triple(c, x, 0f)
            hPrime < 2 -> Triple(x, c, 0f)
            hPrime < 3 -> Triple(0f, c, x)
            hPrime < 4 -> Triple(0f, x, c)
            hPrime < 5 -> Triple(x, 0f, c)
            else -> Triple(c, 0f, x)
        }
        val m = v - c
        return Color(r1 + m, g1 + m, b1 + m)
    }
    
    val backgroundColor = hsvToRgb(colorAnim, 0.8f, 0.6f)
    
    // Настраиваем callbacks VoiceManager
    LaunchedEffect(Unit) {
        voiceManager.setOnReady {
            Log.d(TAG, "VoiceManager ready")
            voiceManager.startListening()
        }
        
        voiceManager.setOnFinalResult { text ->
            Log.d(TAG, "Final result from Vosk: '$text'")
            
            if (isAwaitingArtifact) {
                // Ищем слово "артефакт"
                val lowerText = text.lowercase().trim()
                Log.d(TAG, "Checking for artifact: '$lowerText'")
                
                recognizedText = "[FINAL] $text"
                
                // Проверяем различные варианты слова артефакт
                val isArtifact = (
                    lowerText.contains("артефакт") ||
                    lowerText.contains("артефект") ||
                    lowerText.contains("артифакт") ||
                    lowerText == "артефакт" ||
                    lowerText == "артефект" ||
                    lowerText == "артифакт"
                )
                
                if (isArtifact) {
                    Log.d(TAG, "Artifact detected! Switching to spell mode")
                    isAwaitingArtifact = false
                    allRecognizedWords = listOf()
                    recognizedText = "[РЕЖИМ СЛУШАНИЯ]"
                } else {
                    Log.d(TAG, "Not artifact, continuing to listen")
                    // Продолжаем слушать
                    voiceManager.startListening()
                }
            } else {
                // В режиме слушания заклинания - проверяем финал
                val lowerText = text.lowercase().trim()
                val isFinale = (
                    lowerText.contains("финал") ||
                    lowerText.contains("финале") ||
                    lowerText == "финал" ||
                    lowerText == "финале"
                )
                
                if (isFinale) {
                    Log.d(TAG, "Finale detected! Switching back to artifact mode")
                    isAwaitingArtifact = true
                    allRecognizedWords = listOf()
                    recognizedText = ""
                } else {
                    // В режиме слушания заклинания - добавляем слова
                    if (text.isNotEmpty()) {
                        Log.d(TAG, "Adding spell word: '$text'")
                        allRecognizedWords = allRecognizedWords + text
                        recognizedText = allRecognizedWords.joinToString(" ")
                    }
                    // Продолжаем слушать
                    voiceManager.startListening()
                }
            }
        }
        
        voiceManager.setOnPartialResult { text ->
            Log.d(TAG, "Partial result: $text")
            if (isAwaitingArtifact) {
                recognizedText = "[PARTIAL] $text"
                
                // Также проверяем артефакт в partial результатах
                val lowerText = text.lowercase().trim()
                val isArtifact = (
                    lowerText.contains("артефакт") ||
                    lowerText.contains("артефект") ||
                    lowerText.contains("артифакт")
                )
                
                if (isArtifact) {
                    Log.d(TAG, "Artifact detected in partial! Switching to spell mode")
                    isAwaitingArtifact = false
                    allRecognizedWords = listOf()
                    recognizedText = "[РЕЖИМ СЛУШАНИЯ]"
                }
            } else {
                // В режиме слушания - проверяем финал
                val lowerText = text.lowercase().trim()
                val isFinale = (
                    lowerText.contains("финал") ||
                    lowerText.contains("финале")
                )
                
                if (isFinale) {
                    Log.d(TAG, "Finale detected in partial! Switching back to artifact mode")
                    isAwaitingArtifact = true
                    allRecognizedWords = listOf()
                    recognizedText = ""
                } else {
                    recognizedText = text
                }
            }
        }
        
        voiceManager.setOnError { error ->
            Log.e(TAG, "Vosk error: $error")
        }
    }
    
    Log.d(TAG, "AppScreen state initialized")
    
    if (isAwaitingArtifact) {
        // Режим ожидания - цветная заливка с переливанием
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(backgroundColor)
        )
    } else {
        // Режим слушания - чёрный экран
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color.Black),
            contentAlignment = Alignment.Center
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center,
                modifier = Modifier.fillMaxSize()
            ) {
                Text(
                    text = "Слушаю...",
                    fontSize = 48.sp,
                    color = Color.White,
                    textAlign = TextAlign.Center
                )
                
                Spacer(modifier = Modifier.height(32.dp))
                
                Text(
                    text = recognizedText,
                    fontSize = 28.sp,
                    color = Color(0xFF64b5f6),
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 16.dp)
                )
            }
        }
    }
}
