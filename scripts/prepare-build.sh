#!/bin/bash

# FloatMic Build Preparation Script
# This script ensures everything is ready for building in Xcode

echo "🚀 Preparing FloatMic for Build"
echo "==============================="

# Check if all required files exist
echo "📁 Checking required files..."

REQUIRED_FILES=(
    "FloatMic/Whisper.framework"
    "FloatMic/ggml-base.bin"
    "FloatMic/menu_icon.png"
    "FloatMic/Assets.xcassets/AppIcon.appiconset"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -e "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ Missing: $file"
        exit 1
    fi
done

# Check if Whisper framework has the required libraries
echo ""
echo "🔍 Checking Whisper framework..."
if [ -d "FloatMic/Whisper.framework" ]; then
    echo "✅ Whisper.framework directory exists"
    
    REQUIRED_LIBS=(
        "libwhisper.dylib"
        "libggml.dylib"
        "libggml-base.dylib"
        "libggml-cpu.dylib"
    )
    
    for lib in "${REQUIRED_LIBS[@]}"; do
        if [ -e "FloatMic/Whisper.framework/$lib" ]; then
            echo "✅ $lib"
        else
            echo "❌ Missing library: $lib"
        fi
    done
else
    echo "❌ Whisper.framework not found"
    exit 1
fi

# Check if model file exists and has correct size
echo ""
echo "🎯 Checking model file..."
if [ -e "FloatMic/ggml-base.bin" ]; then
    SIZE=$(stat -f%z "FloatMic/ggml-base.bin")
    SIZE_MB=$((SIZE / 1024 / 1024))
    echo "✅ ggml-base.bin found (${SIZE_MB}MB)"
    
    if [ $SIZE_MB -lt 100 ]; then
        echo "⚠️  Warning: Model file seems smaller than expected"
    fi
else
    echo "❌ Model file not found"
    exit 1
fi

# Check if app icons exist
echo ""
echo "🎨 Checking app icons..."
ICON_COUNT=$(find FloatMic/Assets.xcassets/AppIcon.appiconset -name "*.png" | wc -l)
echo "✅ Found $ICON_COUNT app icons"

if [ $ICON_COUNT -lt 10 ]; then
    echo "⚠️  Warning: Expected 10 icons, found $ICON_COUNT"
fi

# Check if menu icon exists
if [ -e "FloatMic/menu_icon.png" ]; then
    echo "✅ Menu bar icon found"
else
    echo "❌ Menu bar icon missing"
fi

echo ""
echo "🎉 Build preparation complete!"
echo ""
echo "Next steps:"
echo "1. Open FloatMic.xcodeproj in Xcode"
echo "2. Select your development team in project settings"
echo "3. Press Cmd+B to build"
echo "4. Press Cmd+R to run"
echo ""
echo "The app should:"
echo "- Show a floating blue microphone button"
echo "- Display a menu bar icon"
echo "- Request microphone permissions on first run"
echo "- Work with Apple Intelligence (macOS 15.0+) or fallback services"
