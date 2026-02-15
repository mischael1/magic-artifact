import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay
import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.sin

@Composable
fun MagicArtifactApp() {
    var statusText by remember { mutableStateOf("Инициализация...\nПожалуйста подождите") }
    var animationStep by remember { mutableStateOf(0) }
    var isActive by remember { mutableStateOf(false) }
    var voiceRecognition by remember { mutableStateOf<VoiceRecognition?>(null) }
    var soundEffects by remember { mutableStateOf<SoundEffects?>(null) }
    var isListening by remember { mutableStateOf(false) }
    var initError by remember { mutableStateOf("") }
    var currentSpellName by remember { mutableStateOf("") }
    var recognizedText by remember { mutableStateOf("") }
    
    fun triggerSpell(spellId: String) {
        val spell = SpellManager.getSpellById(spellId)
        if (spell != null) {
            currentSpellName = spell.name
            isActive = true
        }
    }
    
    fun toggleListening() {
        if (isListening) {
            voiceRecognition?.stopListening()
            isListening = false
            statusText = "Нажми 🎤 для начала"
        } else {
            voiceRecognition?.startListening()
            isListening = true
        }
    }
    
    // Запускаем инициализацию
    LaunchedEffect(Unit) {
        try {
            delay(500)
            statusText = "Инициализация компонентов..."
            
            delay(500)
            
            try {
                soundEffects = SoundEffects()
                println("SoundEffects initialized")
            } catch (e: Exception) {
                println("WARNING: SoundEffects init failed: ${e.message}")
                e.printStackTrace()
            }
            
            try {
                voiceRecognition = VoiceRecognition(
                    onRecognized = { spellId ->
                        println("Spell recognized: $spellId")
                        triggerSpell(spellId)
                        soundEffects?.playSound(spellId)
                    },
                    onStatusChange = { status ->
                        println("Status: $status")
                        statusText = status
                    },
                    onTextRecognized = { text ->
                        println("Text recognized: '$text'")
                        recognizedText = text
                    }
                )
                println("VoiceRecognition initialized")
            } catch (e: Exception) {
                println("ERROR: VoiceRecognition init failed: ${e.message}")
                e.printStackTrace()
                initError = "Ошибка инициализации голоса:\n${e.message}"
                statusText = initError
            }
            
            if (initError.isEmpty()) {
                statusText = "Нажми 🎤\nи скажи: 'АРТЕФАКТ'"
                isActive = false
            }
        } catch (e: Exception) {
            println("ERROR in LaunchedEffect: ${e.message}")
            e.printStackTrace()
            initError = "ОШИБКА:\n${e.message}"
            statusText = initError
        }
    }
    
    // Очистка при выходе
    DisposableEffect(Unit) {
        onDispose {
            println("Cleaning up...")
            voiceRecognition?.cleanup()
            soundEffects?.cleanup()
        }
    }
    
    // Анимация
    LaunchedEffect(Unit) {
        while (true) {
            delay(16)
            animationStep++
        }
    }
    
    // Сброс активного состояния через 3 секунды
    LaunchedEffect(isActive) {
        if (isActive) {
            delay(3000)
            isActive = false
        }
    }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(color = Color(0x1a0f1826))
            .padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Заголовок
        Text(
            text = "МАГИЧЕСКИЙ АРТЕФАКТ",
            style = TextStyle(
                fontSize = 32.sp,
                color = Color(0xffe6b3ff)
            ),
            modifier = Modifier
                .height(60.dp)
                .wrapContentHeight(Alignment.CenterVertically)
        )
        
        // Магический виджет с анимацией
        MagicArtifactWidget(
            animationStep = animationStep,
            isActive = isActive,
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth()
        )
        
        // Название активного заклинания
        if (currentSpellName.isNotEmpty() && isActive) {
            Text(
                text = currentSpellName,
                style = TextStyle(
                    fontSize = 24.sp,
                    color = Color(0xffff6666)
                ),
                modifier = Modifier
                    .height(40.dp)
                    .wrapContentHeight(Alignment.CenterVertically),
                textAlign = TextAlign.Center
            )
        }
        
        // Распознанный текст (для отладки)
        if (recognizedText.isNotEmpty()) {
            Text(
                text = "🔊 \"$recognizedText\"",
                style = TextStyle(
                    fontSize = 16.sp,
                    color = Color(0xff66ffff)
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(40.dp)
                    .wrapContentHeight(Alignment.CenterVertically),
                textAlign = TextAlign.Center
            )
        }
        
        // Статус текст
        Text(
            text = statusText,
            style = TextStyle(
                fontSize = 18.sp,
                color = Color(0xffb38cff)
            ),
            modifier = Modifier
                .height(80.dp)
                .wrapContentHeight(Alignment.CenterVertically),
            textAlign = TextAlign.Center
        )
        
        // Кнопка слушания
        if (voiceRecognition != null && initError.isEmpty()) {
            Button(
                onClick = { toggleListening() },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(60.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (isListening) Color(0xff00ff00) else Color(0xff8833ff)
                )
            ) {
                Text(
                    if (isListening) "🎤 СЛУШАЮ..." else "🎤 СЛУШАТЬ",
                    fontSize = 24.sp,
                    color = if (isListening) Color.Black else Color.White
                )
            }
        } else {
            Text(
                "Инициализация...",
                style = TextStyle(
                    fontSize = 16.sp,
                    color = Color(0xffff6666)
                )
            )
        }
    }
}

@Composable
fun MagicArtifactWidget(
    animationStep: Int,
    isActive: Boolean = false,
    modifier: Modifier = Modifier
) {
    Canvas(modifier = modifier) {
        val centerX = size.width / 2
        val centerY = size.height / 2
        
        // Темный фон
        drawRect(
            color = Color(0x1a0f1826),
            size = size
        )
        
        // Внешний круг
        drawCircle(
            color = Color(0x4d4d3366),
            radius = 150.dp.toPx(),
            center = Offset(centerX, centerY)
        )
        
        // Средний круг
        drawCircle(
            color = Color(0x664d4db3),
            radius = 100.dp.toPx(),
            center = Offset(centerX, centerY)
        )
        
        // Внутренний круг
        drawCircle(
            color = if (isActive) Color(0xffff0000) else Color(0x80b38cff),
            radius = 50.dp.toPx(),
            center = Offset(centerX, centerY)
        )
        
        // Магические частицы (анимированные)
        repeat((animationStep / 60) % (if (isActive) 30 else 10)) { i ->
            val angle = (i * 36f + animationStep * 2f) * PI / 180
            val distance = 100 + (animationStep % 50) * 1.5
            val x = centerX + (distance * cos(angle)).toFloat()
            val y = centerY + (distance * sin(angle)).toFloat()
            
            drawCircle(
                color = when (i % 4) {
                    0 -> Color(0x99cc66ff)
                    1 -> Color(0x9966ccff)
                    2 -> Color(0x99ff66cc)
                    else -> Color(0x9966ffcc)
                },
                radius = 5.dp.toPx(),
                center = Offset(x, y)
            )
        }
    }
}
