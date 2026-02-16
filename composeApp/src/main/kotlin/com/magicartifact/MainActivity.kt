package com.magicartifact

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
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
    var foundSpell by remember { mutableStateOf<SpellData?>(null) }
    var isListening by remember { mutableStateOf(false) }
    var statusMessage by remember { mutableStateOf("Готов к распознаванию") }
    
    val spellRecognizer = remember { 
        Log.d(TAG, "Creating SpellRecognizer")
        SpellRecognizer() 
    }
    
    // Настраиваем callbacks VoiceManager
    LaunchedEffect(Unit) {
        voiceManager.setOnFinalResult { text ->
            Log.d(TAG, "Final result from Vosk: $text")
            recognizedText = text
            val spell = spellRecognizer.findSpell(text)
            if (spell != null) {
                foundSpell = spell
                statusMessage = "✨ Найдено: ${spell.name}"
            } else {
                statusMessage = "Заклинание не найдено"
            }
        }
        
        voiceManager.setOnPartialResult { text ->
            Log.d(TAG, "Partial result: $text")
            recognizedText = text
            statusMessage = "🎤 Слушаю..."
        }
        
        voiceManager.setOnError { error ->
            Log.e(TAG, "Vosk error: $error")
            statusMessage = "❌ Ошибка: $error"
        }
    }
    
    Log.d(TAG, "AppScreen state initialized")
    
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF1a0f1f))
    ) {
        Log.d(TAG, "Box drawn")
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceEvenly
        ) {
            // Заголовок
            Text(
                text = "🔮 МАГИЧЕСКИЙ АРТЕФАКТ",
                fontSize = 32.sp,
                color = Color(0xFFe8b4f0),
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(bottom = 32.dp)
            )
            
            // Статус
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFF2d1a3f))
            ) {
                Column(
                    modifier = Modifier.padding(16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = statusMessage,
                        fontSize = 18.sp,
                        color = Color(0xFFb385e8),
                        textAlign = TextAlign.Center
                    )
                    
                    Spacer(modifier = Modifier.height(12.dp))
                    
                    if (recognizedText.isNotEmpty()) {
                        Text(
                            text = "Распознано: $recognizedText",
                            fontSize = 16.sp,
                            color = Color(0xFF64b5f6),
                            textAlign = TextAlign.Center
                        )
                    }
                }
            }
            
            // Найденное заклинание
            if (foundSpell != null) {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp),
                    colors = CardDefaults.cardColors(containerColor = Color(0xFF3f2d5f))
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = "✨ Найдено заклинание!",
                            fontSize = 16.sp,
                            color = Color(0xFFffd54f)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = foundSpell!!.name,
                            fontSize = 24.sp,
                            color = Color(0xFFff6b9d)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = foundSpell!!.description,
                            fontSize = 14.sp,
                            color = Color(0xFFb3e5fc),
                            textAlign = TextAlign.Center
                        )
                    }
                }
            }
            
            // Список всех заклинаний
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFF2d1a3f))
            ) {
                Column(
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text(
                        text = "📚 Доступные заклинания:",
                        fontSize = 16.sp,
                        color = Color(0xFFe8b4f0)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    spellRecognizer.getAllSpells().forEach { spell ->
                        Text(
                            text = "• ${spell.name}",
                            fontSize = 14.sp,
                            color = Color(0xFF64b5f6),
                            modifier = Modifier.padding(vertical = 4.dp)
                        )
                    }
                }
            }
            
            // Кнопки управления
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                Button(
                    onClick = {
                        if (!isListening) {
                            isListening = true
                            statusMessage = "🎤 Слушаю..."
                            voiceManager.startListening()
                        }
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFFff6b9d)
                    )
                ) {
                    Text(if (isListening) "Слушаю..." else "Начать")
                }
                
                Button(
                    onClick = {
                        if (isListening) {
                            isListening = false
                            voiceManager.stopListening()
                            statusMessage = "Остановлено"
                        }
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF64b5f6)
                    )
                ) {
                    Text("Стоп")
                }
                
                Button(
                    onClick = {
                        recognizedText = ""
                        foundSpell = null
                        statusMessage = "Готов к распознаванию"
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF888888)
                    )
                ) {
                    Text("Очистить")
                }
            }
        }
    }
}
