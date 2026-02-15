expect class VoiceRecognition(
    onRecognized: (spellId: String) -> Unit,
    onStatusChange: (status: String) -> Unit,
    onTextRecognized: (text: String) -> Unit = {}
) {
    fun startListening()
    fun stopListening()
    fun cleanup()
}
