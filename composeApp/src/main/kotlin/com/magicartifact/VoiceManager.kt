package com.magicartifact

import android.content.Context
import android.util.Log
import org.vosk.LibVosk
import org.vosk.LogLevel
import org.vosk.Model
import org.vosk.Recognizer
import org.vosk.android.RecognitionListener
import org.vosk.android.SpeechService
import org.vosk.android.StorageService
import java.io.IOException

private const val TAG = "VoiceManager"

/**
 * Manages offline speech recognition using Vosk
 * 
 * Follows the official vosk-android-demo pattern with:
 * - StorageService for model unpacking from assets
 * - SpeechService for microphone input
 * - RecognitionListener callbacks for results
 * - Proper resource cleanup
 */
class VoiceManager(private val context: Context) : RecognitionListener {
    
    private var model: Model? = null
    private var speechService: SpeechService? = null
    private var isReady = false
    
    // Callbacks
    private var onPartialResult: ((String) -> Unit)? = null
    private var onFinalResult: ((String) -> Unit)? = null
    private var onError: ((String) -> Unit)? = null
    private var onReady: (() -> Unit)? = null
    
    init {
        try {
            LibVosk.setLogLevel(LogLevel.INFO)
            Log.d(TAG, "LibVosk initialized")
            
            // Initialize Vosk library
            initializeVosk()
            
        } catch (e: Exception) {
            Log.e(TAG, "VoiceManager initialization error", e)
            onError?.invoke("Initialization error: ${e.message}")
        }
    }
    
    /**
     * Initializes Vosk and unpacks model from assets
     */
    private fun initializeVosk() {
        StorageService.unpack(
            context,
            "model-ru-0.22",
            "model",
            { model ->
                this.model = model
                isReady = true
                Log.d(TAG, "Model loaded successfully")
                onReady?.invoke()
            },
            { exception ->
                Log.e(TAG, "Failed to unpack model", exception)
                onError?.invoke("Failed to unpack model: ${exception.message}")
            }
        )
    }
    
    /**
     * Sets callback for partial results
     */
    fun setOnPartialResult(callback: (String) -> Unit) {
        onPartialResult = callback
    }
    
    /**
     * Sets callback for final results
     */
    fun setOnFinalResult(callback: (String) -> Unit) {
        onFinalResult = callback
    }
    
    /**
     * Sets callback for errors
     */
    fun setOnError(callback: (String) -> Unit) {
        onError = callback
    }
    
    /**
     * Sets callback for when model is ready
     */
    fun setOnReady(callback: () -> Unit) {
        onReady = callback
    }
    
    /**
     * Starts listening for speech
     */
    fun startListening() {
        if (!isReady) {
            Log.e(TAG, "Model not ready yet")
            onError?.invoke("Model is still loading, please wait...")
            return
        }
        
        if (speechService != null) {
            Log.w(TAG, "Already listening")
            return
        }
        
        val model = this.model
        if (model == null) {
            Log.e(TAG, "Model is null")
            onError?.invoke("Model not loaded")
            return
        }
        
        try {
            Log.d(TAG, "Starting speech recognition, model ready: $isReady")
            
            // Create recognizer with default grammar
            val recognizer = Recognizer(model, 16000.0f)
            Log.d(TAG, "Recognizer created")
            
            // Create speech service
            speechService = SpeechService(recognizer, 16000.0f)
            Log.d(TAG, "SpeechService created, starting listening...")
            speechService?.startListening(this)
            Log.d(TAG, "Listening started")
            
        } catch (e: IOException) {
            Log.e(TAG, "Error starting listening", e)
            onError?.invoke("Failed to start listening: ${e.message}")
            speechService = null
        }
    }
    
    /**
     * Stops listening for speech
     */
    fun stopListening() {
        if (speechService != null) {
            speechService?.stop()
            speechService?.shutdown()
            speechService = null
            Log.d(TAG, "Stopped listening")
        }
    }
    
    /**
     * Cleans up resources
     */
    fun cleanup() {
        stopListening()
        model?.close()
        model = null
        Log.d(TAG, "VoiceManager cleaned up")
    }
    
    /**
     * Returns whether currently listening
     */
    fun isListening(): Boolean = speechService != null
    
    // ===== RecognitionListener Implementation =====
    
    /**
     * Called when recognizer returns final result
     */
    override fun onResult(hypothesis: String) {
        Log.d(TAG, "onResult: $hypothesis")
    }
    
    /**
     * Called when recognizer returns final result
     * Format can be: {"result": ["word1", "word2", ...]} or {"text": "words"}
     */
    override fun onFinalResult(hypothesis: String) {
        Log.d(TAG, "onFinalResult: $hypothesis")
        
        try {
            val json = org.json.JSONObject(hypothesis)
            var text = ""
            
            // Try result array first
            val resultArray = json.optJSONArray("result")
            if (resultArray != null && resultArray.length() > 0) {
                val words = mutableListOf<String>()
                for (i in 0 until resultArray.length()) {
                    words.add(resultArray.getString(i))
                }
                text = words.joinToString(" ")
            }
            
            // Fallback to text field
            if (text.isEmpty()) {
                text = json.optString("text", "")
            }
            
            if (text.isNotEmpty()) {
                onFinalResult?.invoke(text)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing final result JSON", e)
        }
    }
    
    /**
     * Called when recognizer returns partial result
     * Format: {"partial": "words so far"}
     */
    override fun onPartialResult(hypothesis: String) {
        Log.d(TAG, "onPartialResult: $hypothesis")
        
        try {
            val json = org.json.JSONObject(hypothesis)
            val partial = json.optString("partial", "")
            
            if (partial.isNotEmpty()) {
                onPartialResult?.invoke(partial)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing partial result JSON", e)
        }
    }
    
    /**
     * Called when an error occurs
     */
    override fun onError(exception: Exception) {
        Log.e(TAG, "Vosk error", exception)
        onError?.invoke(exception.message ?: "Unknown error")
        speechService = null
    }
    
    /**
     * Called on timeout
     */
    override fun onTimeout() {
        Log.d(TAG, "onTimeout")
        speechService?.stop()
        speechService?.shutdown()
        speechService = null
    }
}
