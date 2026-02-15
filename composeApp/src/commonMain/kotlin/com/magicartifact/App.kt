package com.magicartifact

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

@Composable
fun AppContent() {
    var recognizedText by remember { mutableStateOf("") }
    var foundSpell by remember { mutableStateOf<SpellData?>(null) }
    var isListening by remember { mutableStateOf(false) }
    
    val spellRecognizer = remember { SpellRecognizer() }
    
    MaterialTheme {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color(0x1a0f1f))
        ) {
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
                    color = Color(0xffe8b4f0),
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(bottom = 32.dp)
                )
                
                // Статус
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp),
                    colors = CardDefaults.cardColors(containerColor = Color(0x2d1a3f))
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = if (isListening) "🎤 Слушаю..." else "Готов к восприятию",
                            fontSize = 18.sp,
                            color = Color(0xffb385e8),
                            textAlign = TextAlign.Center
                        )
                        
                        Spacer(modifier = Modifier.height(12.dp))
                        
                        if (recognizedText.isNotEmpty()) {
                            Text(
                                text = "Распознано: $recognizedText",
                                fontSize = 16.sp,
                                color = Color(0xff64b5f6),
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
                        colors = CardDefaults.cardColors(containerColor = Color(0x3f2d5f))
                    ) {
                        Column(
                            modifier = Modifier.padding(16.dp),
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            Text(
                                text = "✨ Найдено заклинание!",
                                fontSize = 16.sp,
                                color = Color(0xffffd54f)
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                text = foundSpell!!.name,
                                fontSize = 24.sp,
                                color = Color(0xffff6b9d)
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                text = foundSpell!!.description,
                                fontSize = 14.sp,
                                color = Color(0xffb3e5fc),
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
                    colors = CardDefaults.cardColors(containerColor = Color(0x2d1a3f))
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp)
                    ) {
                        Text(
                            text = "📚 Доступные заклинания:",
                            fontSize = 16.sp,
                            color = Color(0xffe8b4f0)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        spellRecognizer.getAllSpells().forEach { spell ->
                            Text(
                                text = "• ${spell.name}",
                                fontSize = 14.sp,
                                color = Color(0xff64b5f6),
                                modifier = Modifier.padding(vertical = 4.dp)
                            )
                        }
                    }
                }
                
                // Кнопки
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    Button(
                        onClick = {
                            isListening = true
                            recognizedText = "Пример: огненный шар"
                            foundSpell = spellRecognizer.findSpell("огненный шар")
                            isListening = false
                        },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xffff6b9d)
                        )
                    ) {
                        Text("Тест 1")
                    }
                    
                    Button(
                        onClick = {
                            isListening = true
                            recognizedText = "Пример: ледяной удар"
                            foundSpell = spellRecognizer.findSpell("ледяной удар")
                            isListening = false
                        },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xff64b5f6)
                        )
                    ) {
                        Text("Тест 2")
                    }
                    
                    Button(
                        onClick = {
                            recognizedText = ""
                            foundSpell = null
                        },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xff888888)
                        )
                    ) {
                        Text("Очистить")
                    }
                }
            }
        }
    }
}
