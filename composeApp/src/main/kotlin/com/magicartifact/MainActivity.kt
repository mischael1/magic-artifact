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
        
        // Полноэкранный режим (киоск режим)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        @Suppress("DEPRECATION")
        window.setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        )
        
        // Скрыть системный бар (statusBar и navigationBar)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.setDecorFitsSystemWindows(false)
            window.insetsController?.hide(
                android.view.WindowInsets.Type.systemBars() or 
                android.view.WindowInsets.Type.navigationBars()
            )
            window.insetsController?.systemBarsBehavior = 
                android.view.WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        } else {
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility = (
                android.view.View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY or
                android.view.View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
                android.view.View.SYSTEM_UI_FLAG_FULLSCREEN
            )
        }
        
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
                val lowerText = text.lowercase()
                Log.d(TAG, "Checking for artifact: '$lowerText'")
                if (lowerText.contains("артефакт") || lowerText.contains("артефект") || lowerText.contains("артефакт")) {
                    Log.d(TAG, "Artifact detected! Switching to spell mode")
                    isAwaitingArtifact = false
                    allRecognizedWords = listOf()
                    recognizedText = ""
                } else {
                    Log.d(TAG, "Not artifact, continuing to listen")
                }
                // Продолжаем слушать
                voiceManager.startListening()
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
        
        voiceManager.setOnPartialResult { text ->
            Log.d(TAG, "Partial result: $text")
            recognizedText = text
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
