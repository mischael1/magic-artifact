import java.io.File
import java.util.*

object AppConfig {
    private val properties = Properties()
    
    init {
        loadProperties()
    }
    
    private fun loadProperties() {
        try {
            // Try loading from config.properties in project root
            val configFile = File("config.properties")
            if (configFile.exists()) {
                configFile.inputStream().use { input ->
                    properties.load(input)
                }
            } else {
                // Try loading from classpath
                this::class.java.classLoader.getResourceAsStream("config.properties")?.use { input ->
                    properties.load(input)
                }
            }
        } catch (e: Exception) {
            System.err.println("Warning: Could not load config.properties: ${e.message}")
        }
    }
    
    fun getOpenAIKey(): String = properties.getProperty("openai_api_key", "").trim()
    fun getGoogleCloudKey(): String = properties.getProperty("google_cloud_api_key", "").trim()
    fun getYandexKey(): String = properties.getProperty("yandex_api_key", "").trim()
    
    fun isConfigured(): Boolean {
        return getOpenAIKey().isNotEmpty() || 
               getGoogleCloudKey().isNotEmpty() || 
               getYandexKey().isNotEmpty()
    }
}
