package com.magicartifact

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
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
import androidx.compose.ui.viewinterop.AndroidView
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.StyledPlayerView
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

private const val TAG = "MagicArtifact"

class MainActivity : ComponentActivity() {
    
    private lateinit var voiceManager: VoiceManager
    private var exoPlayer: ExoPlayer? = null
    
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
        
        // Инициализируем ExoPlayer для видео
        exoPlayer = ExoPlayer.Builder(this).build().apply {
            val mediaItem = MediaItem.fromUri("asset:///book.mp4")
            setMediaItem(mediaItem)
            repeatMode = ExoPlayer.REPEAT_MODE_ALL
            prepare()
            playWhenReady = true  // Начинаем проигрывать сразу
        }
        
        // Полноэкранный режим
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.setDecorFitsSystemWindows(false)
        }
        
        // Полностью скрыть системный UI с immersive режимом
        @Suppress("DEPRECATION")
        window.decorView.systemUiVisibility = (
            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY or
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
            View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
            View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_FULLSCREEN
        )
        
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
                    AppScreen(voiceManager, exoPlayer)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in setContent", e)
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        voiceManager.cleanup()
        exoPlayer?.release()
    }
}

@Composable
fun AppScreen(voiceManager: VoiceManager, exoPlayer: ExoPlayer?) {
    Log.d(TAG, "AppScreen composable created")
    
    // Make system UI bars transparent so content goes behind them
    val systemUiController = rememberSystemUiController()
    SideEffect {
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
    var skipResultsWithArtifact by remember { mutableStateOf(false) }
    var lastRecognitionTime by remember { mutableStateOf(System.currentTimeMillis()) }
    
    // Таймер автоматического возврата в режим ожидания
    LaunchedEffect(isAwaitingArtifact) {
        while (!isAwaitingArtifact) {
            delay(1000)  // Проверяем каждую секунду
            val timeSinceLastRecognition = System.currentTimeMillis() - lastRecognitionTime
            if (timeSinceLastRecognition >= 10000) {
                Log.d(TAG, "No recognition for 10 seconds, returning to greeting screen")
                isAwaitingArtifact = true
                allRecognizedWords = listOf()
                recognizedText = ""
                break
            }
        }
    }
    
    // Список слов для режима слушания
    val spellWords = remember { 
        listOf("каждый", "охотник", "желает", "знать", "где", "сидит", "фазан")
    }
    var recognizedSpellWords by remember { mutableStateOf(setOf<String>()) }
    var allSpellWordsRecognized by remember { mutableStateOf(false) }
    
    val spellRecognizer = remember { 
        Log.d(TAG, "Creating SpellRecognizer")
        SpellRecognizer() 
    }
    
    // Animation for color transition - slow version (greeting screen)
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
    
    // Animation for color transition - fast version (when all spell words recognized)
    val fastInfiniteTransition = rememberInfiniteTransition(label = "fast_color_animation")
    val fastColorAnim by fastInfiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(1600, easing = LinearEasing),  // 5x faster (8000/5 = 1600)
            repeatMode = RepeatMode.Restart
        ),
        label = "fast_hue_animation"
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
        Log.d(TAG, "Setting up VoiceManager callbacks")
        
        voiceManager.setOnReady {
            Log.d(TAG, "VoiceManager ready - starting listening")
            voiceManager.startListening()
        }
        
        voiceManager.setOnFinalResult { text ->
            Log.d(TAG, "Final result from Vosk: '$text'")
            
            if (isAwaitingArtifact) {
                // Ищем слово "артефакт"
                val lowerText = text.lowercase().trim()
                Log.d(TAG, "Checking for artifact: '$lowerText'")
                
                // Не отображаем текст на gradient экране
                
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
                    recognizedText = ""  // Очищаем перед переходом на черный экран
                    skipResultsWithArtifact = true
                } else {
                    Log.d(TAG, "Not artifact, continuing to listen")
                    // Продолжаем слушать
                    voiceManager.startListening()
                }
            } else {
               // В режиме слушания заклинания - проверяем финал и слова
               val lowerText = text.lowercase().trim()
               lastRecognitionTime = System.currentTimeMillis()  // Обновляем время последнего распознавания
               
               // Проверяем содержит ли артефакт
                val containsArtifact = (
                    lowerText.contains("артефакт") ||
                    lowerText.contains("артефект") ||
                    lowerText.contains("артифакт")
                )
                
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
                    skipResultsWithArtifact = false
                    // НЕ сбрасываем recognizedSpellWords и allSpellWordsRecognized - сохраняем прогресс!
                } else if (containsArtifact && skipResultsWithArtifact) {
                    // Пропускаем результаты с артефактом после переключения
                    Log.d(TAG, "Skipping result with artifact: '$text'")
                    voiceManager.startListening()
                } else {
                    // В режиме слушания - проверяем слова из списка
                    var wordFound = false
                    
                    // Проверяем каждое слово из списка
                    for (word in spellWords) {
                        if (lowerText.contains(word) && !recognizedSpellWords.contains(word)) {
                            recognizedSpellWords = recognizedSpellWords + word
                            wordFound = true
                            
                            // Проверяем все ли слова распознаны
                            if (recognizedSpellWords.size == spellWords.size) {
                                allSpellWordsRecognized = true
                            }
                            break
                        }
                    }
                    
                    // Если слово было из списка, добавляем его
                    if (wordFound || text.isEmpty()) {
                        // Слово найдено в списке - оно уже добавлено в recognizedSpellWords
                        recognizedText = recognizedSpellWords.joinToString(" ")
                    } else {
                        // Это слово не из нашего списка - добавляем как обычно
                        if (text.isNotEmpty()) {
                            allRecognizedWords = allRecognizedWords + text
                            recognizedText = allRecognizedWords.joinToString(" ")
                        }
                    }
                    
                    // После первого результата без артефакта - перестаем пропускать
                    skipResultsWithArtifact = false
                    // Продолжаем слушать
                    voiceManager.startListening()
                }
            }
        }
        
        voiceManager.setOnPartialResult { text ->
            Log.d(TAG, "Partial result: $text")
            if (isAwaitingArtifact) {
                // Don't show text while waiting for artifact word
                
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
                    recognizedText = ""
                    skipResultsWithArtifact = true
                }
            } else {
                // В режиме слушания - проверяем финал и слова
                val lowerText = text.lowercase().trim()
                
                val isFinale = (
                    lowerText.contains("финал") ||
                    lowerText.contains("финале")
                )
                
                val containsArtifact = (
                    lowerText.contains("артефакт") ||
                    lowerText.contains("артефект") ||
                    lowerText.contains("артифакт")
                )
                
                if (isFinale) {
                    isAwaitingArtifact = true
                    allRecognizedWords = listOf()
                    recognizedText = ""
                    skipResultsWithArtifact = false
                    // НЕ сбрасываем recognizedSpellWords и allSpellWordsRecognized - сохраняем прогресс!
                } else if (containsArtifact && skipResultsWithArtifact) {
                    // Не показываем partial результаты с артефактом после переключения
                    recognizedText = ""
                } else {
                    // Проверяем слова из списка в partial результатах тоже
                    for (word in spellWords) {
                        if (lowerText.contains(word) && !recognizedSpellWords.contains(word)) {
                            recognizedSpellWords = recognizedSpellWords + word
                            
                            if (recognizedSpellWords.size == spellWords.size) {
                                allSpellWordsRecognized = true
                            }
                            break
                        }
                    }
                    
                    recognizedText = text
                    // После получения результата без артефакта - перестаем пропускать
                    skipResultsWithArtifact = false
                }
            }
        }
        
        voiceManager.setOnError { error ->
            Log.e(TAG, "Vosk error: $error")
        }
    }
    
    Log.d(TAG, "AppScreen state initialized")
    
    if (isAwaitingArtifact) {
        // Режим ожидания - проигрывание видео
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color.Black)
        ) {
            if (exoPlayer != null) {
                AndroidView(
                    factory = { context ->
                        StyledPlayerView(context).apply {
                            player = exoPlayer
                            useController = false
                            layoutParams = ViewGroup.LayoutParams(
                                ViewGroup.LayoutParams.MATCH_PARENT,
                                ViewGroup.LayoutParams.MATCH_PARENT
                            )
                        }
                    },
                    modifier = Modifier.fillMaxSize()
                )
            } else {
                // Fallback если видео не загрузилось
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(backgroundColor)
                )
            }
        }
    } else {
        // Режим слушания - фон меняется от черного к зеленому
        val listeningScreenColor = if (allSpellWordsRecognized) {
            // Все слова распознаны - переливающиеся цвета
            Log.d(TAG, "All words recognized! Using fast color animation")
            hsvToRgb(fastColorAnim, 0.8f, 0.6f)
        } else {
            // Еще не все слова - от черного к зеленому в зависимости от процента
            val progress = recognizedSpellWords.size.toFloat() / spellWords.size.toFloat()
            Log.d(TAG, "Listening screen color progress: $progress (${recognizedSpellWords.size}/${spellWords.size})")
            // Зеленый цвет
            Color(
                red = 0f,
                green = progress,
                blue = 0f
            )
        }
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(listeningScreenColor),
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
