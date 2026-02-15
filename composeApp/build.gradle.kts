plugins {
    kotlin("multiplatform") version "2.0.21"
    kotlin("plugin.compose") version "2.0.21"
    id("org.jetbrains.compose") version "1.6.11"
}

repositories {
    google()
    mavenCentral()
    maven("https://repo1.maven.org/maven2")
    maven("https://oss.sonatype.org/content/repositories/snapshots")
    maven("https://maven.indexdata.com/snapshot")
}

kotlin {
    jvmToolchain(11)
    
    // Desktop target
    jvm("desktop") {
    }
    
    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation(compose.runtime)
                implementation(compose.foundation)
                implementation(compose.material3)
            }
        }
        
        val desktopMain by getting {
            dependencies {
                implementation(compose.desktop.currentOs)
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.8.1")
                implementation("net.java.dev.jna:jna:5.13.0")
                implementation("com.alphacephei:vosk:0.3.32")
            }
        }
    }
}

compose.desktop {
    application {
        mainClass = "MainKt"
        jvmArgs += listOf(
            "-Dfile.encoding=UTF-8",
            "-Dstdout.encoding=UTF-8",
            "-Dstderr.encoding=UTF-8",
            "-Djava.library.path=."
        )
    }
}
