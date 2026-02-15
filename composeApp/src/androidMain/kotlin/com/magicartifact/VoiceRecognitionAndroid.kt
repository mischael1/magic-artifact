package com.magicartifact

import android.content.Context
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Build
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File

class VoiceRecognitionAndroid(private val context: Context) {
    
    private var audioRecord: AudioRecord? = null
    private var isRecording = false
    
    suspend fun initializeVosk() = withContext(Dispatchers.IO) {
        try {
            Log.d("VoiceRecognition", "Initializing Vosk for Android")
            // Vosk будет инициализирован при первом запросе речи
        } catch (e: Exception) {
            Log.e("VoiceRecognition", "Error initializing Vosk: ${e.message}")
        }
    }
    
    suspend fun startListening() = withContext(Dispatchers.IO) {
        try {
            if (audioRecord == null) {
                setupAudioRecord()
            }
            audioRecord?.startRecording()
            isRecording = true
            Log.d("VoiceRecognition", "Started listening")
        } catch (e: Exception) {
            Log.e("VoiceRecognition", "Error starting listening: ${e.message}")
        }
    }
    
    suspend fun stopListening() = withContext(Dispatchers.IO) {
        try {
            isRecording = false
            audioRecord?.stop()
            Log.d("VoiceRecognition", "Stopped listening")
        } catch (e: Exception) {
            Log.e("VoiceRecognition", "Error stopping listening: ${e.message}")
        }
    }
    
    fun release() {
        try {
            audioRecord?.release()
            audioRecord = null
        } catch (e: Exception) {
            Log.e("VoiceRecognition", "Error releasing audio: ${e.message}")
        }
    }
    
    private fun setupAudioRecord() {
        val sampleRate = 16000
        val channelConfig = android.media.AudioFormat.CHANNEL_IN_MONO
        val audioFormat = android.media.AudioFormat.ENCODING_PCM_16BIT
        val bufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)
        
        audioRecord = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            AudioRecord.Builder()
                .setAudioSource(MediaRecorder.AudioSource.MIC)
                .setAudioFormat(
                    android.media.AudioFormat.Builder()
                        .setEncoding(audioFormat)
                        .setSampleRate(sampleRate)
                        .setChannelMask(channelConfig)
                        .build()
                )
                .setBufferSizeInBytes(bufferSize * 2)
                .build()
        } else {
            @Suppress("DEPRECATION")
            AudioRecord(
                MediaRecorder.AudioSource.MIC,
                sampleRate,
                channelConfig,
                audioFormat,
                bufferSize * 2
            )
        }
        
        Log.d("VoiceRecognition", "AudioRecord setup with buffer size: $bufferSize")
    }
}
