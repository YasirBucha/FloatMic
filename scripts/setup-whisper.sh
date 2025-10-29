#!/bin/bash

# FloatMic Whisper.cpp Setup Script
# This script helps set up Whisper.cpp for local transcription

echo "🎤 FloatMic Whisper.cpp Setup"
echo "=============================="

# Check if we're in the right directory
if [ ! -f "FloatMic.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Please run this script from the FloatMic project root directory"
    exit 1
fi

# Create whisper directory
echo "📁 Creating whisper directory..."
mkdir -p whisper

# Download Whisper.cpp (if not already present)
if [ ! -d "whisper/whisper.cpp" ]; then
    echo "📥 Downloading Whisper.cpp..."
    cd whisper
    git clone https://github.com/ggerganov/whisper.cpp.git
    cd whisper.cpp
    echo "🔨 Building Whisper.cpp..."
    make
    cd ../..
else
    echo "✅ Whisper.cpp already present"
fi

# Create models directory
echo "📁 Creating models directory..."
mkdir -p whisper/models

# Download base model (74MB)
if [ ! -f "whisper/models/ggml-base.bin" ]; then
    echo "📥 Downloading Whisper base model (74MB)..."
    cd whisper/models
    curl -L -o ggml-base.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin
    cd ../..
    echo "✅ Base model downloaded"
else
    echo "✅ Base model already present"
fi

# Create framework directory
echo "📁 Creating framework directory..."
mkdir -p whisper/framework

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Add the whisper.cpp library to your Xcode project"
echo "2. Link the framework in your project settings"
echo "3. Update the model path in WhisperLocalService.swift"
echo ""
echo "Model location: whisper/models/ggml-base.bin"
echo "Library location: whisper/whisper.cpp/"
