FROM ubuntu:22.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk-headless \
    python3 \
    python3-pip \
    wget \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Установка buildozer и cython
RUN pip3 install --upgrade pip setuptools wheel && \
    pip3 install buildozer cython

# Создание директории для Android SDK
RUN mkdir -p /home/android-sdk
WORKDIR /home/android-sdk

# Скачивание и установка Android SDK
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip -q commandlinetools-linux-*.zip && \
    rm commandlinetools-linux-*.zip && \
    yes | ./cmdline-tools/bin/sdkmanager --install \
    "platforms;android-31" \
    "build-tools;31.0.0" \
    "ndk;25.1.8937393" 2>/dev/null || true

# Установка переменных окружения
ENV ANDROID_SDK_ROOT=/home/android-sdk
ENV ANDROID_NDK_ROOT=/home/android-sdk/ndk/25.1.8937393
ENV PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools

# Рабочая директория проекта
WORKDIR /workspace

# Команда по умолчанию - сборка APK
CMD ["buildozer", "android", "debug"]
