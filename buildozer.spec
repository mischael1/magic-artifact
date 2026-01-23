[app]
title = Магический Артефакт
package.name = magicartifact
package.domain = org.magicartifact
source.dir = .
source.include_exts = py,png,jpg,kv,atlas,json,mp3,mp4,wav,onnx
version = 0.1
requirements = python3,kivy==2.3.1,numpy,pyjnius,android

[buildozer]
log_level = 2

[android]
android.api = 31
android.ndk = 25b
android.minapi = 21
android.sdk = 31
android.accept_sdk_license = True
android.arch = arm64-v8a
android.permissions = RECORD_AUDIO,WAKE_LOCK,WRITE_EXTERNAL_STORAGE,READ_EXTERNAL_STORAGE,INTERNET
android.wakelock = True
android.orientation = landscape
android.fullscreen = True

# Киоск режим
android.activity_class_name = PythonActivity
android.meta_data = android.intent.action.MAIN

# Оптимизация размера APK
android.add_assets = assets/*
android.split_apks = False
android.gradle_dependencies = 

# Настройки для медиа
android.allow_source_libs = True
android.storage_flags = internal

# Gradle версия
android.gradle_version = 7.0.3
android.gradle_plugin_version = 7.0.0