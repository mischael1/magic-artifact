[app]
title = Магический Артефакт
package.name = magicartifact
package.domain = org.magicartifact
source.dir = .
source.include_exts = py,png,jpg,json,mp3,mp4,wav
version = 0.1
requirements = python3,kivy,numpy,pyjnius

[buildozer]
log_level = 2

[android]
android.api = 31
android.ndk = 25.1.8937393
android.minapi = 21
android.permissions = RECORD_AUDIO,INTERNET
android.arch = arm64-v8a
android.wakelock = True
android.orientation = portrait
