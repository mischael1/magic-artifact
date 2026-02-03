[app]
title = Магический Артефакт
package.name = magicartifact
package.domain = org.magicartifact
source.dir = .
source.include_exts = py,png,jpg,json,mp3,mp4,wav
source.exclude_exts = zip
source.exclude_patterns = tests/*,test_*,*~,.git/*,.buildozer/*,bin/*,*.pyc,__pycache__,*.egg-info,MagicArtifactApp/*,models/*
version = 0.1
requirements = python3,kivy,numpy,pyjnius
fullscreen = 1

[buildozer]
log_level = 2

[android]
android.api = 31
android.ndk = 25.1.8937393
android.minapi = 21
android.permissions = RECORD_AUDIO,INTERNET,MODIFY_AUDIO_SETTINGS,WAKE_LOCK
android.features = android.hardware.microphone
android.arch = arm64-v8a
android.wakelock = True
android.orientation = portrait
android.allow_backup = True
android.logcat_filters = *:S python:D
