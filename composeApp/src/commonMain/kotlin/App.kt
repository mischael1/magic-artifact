import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color

@Composable
expect fun App()

@Composable
fun AppContent() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0x1a0f1826))
    ) {
        MagicArtifactApp()
    }
}
