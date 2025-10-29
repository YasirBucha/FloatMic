#!/bin/bash

# Script to set up Whisper.cpp integration in Xcode project

echo "Setting up Whisper.cpp integration..."

# Get the project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WHISPER_DIR="$PROJECT_DIR/whisper.cpp"
XCODE_PROJECT="$PROJECT_DIR/FloatMicApp.xcodeproj"

echo "Project directory: $PROJECT_DIR"
echo "Whisper directory: $WHISPER_DIR"
echo "Xcode project: $XCODE_PROJECT"

# Check if whisper.cpp is built
if [ ! -f "$WHISPER_DIR/build/libwhisper.dylib" ]; then
    echo "Error: Whisper.cpp not built. Please run 'make' in the whisper.cpp directory first."
    exit 1
fi

# Copy libraries to the app bundle
echo "Copying Whisper libraries..."
mkdir -p "$PROJECT_DIR/FloatMicApp/FloatMicApp/Libraries"

# Copy the dynamic libraries
cp "$WHISPER_DIR/build/libwhisper.dylib" "$PROJECT_DIR/FloatMicApp/FloatMicApp/Libraries/"
cp "$WHISPER_DIR/build/libggml.dylib" "$PROJECT_DIR/FloatMicApp/FloatMicApp/Libraries/"
cp "$WHISPER_DIR/build/libggml-base.dylib" "$PROJECT_DIR/FloatMicApp/FloatMicApp/Libraries/"
cp "$WHISPER_DIR/build/libggml-cpu.dylib" "$PROJECT_DIR/FloatMicApp/FloatMicApp/Libraries/"
cp "$WHISPER_DIR/build/libggml-metal.dylib" "$PROJECT_DIR/FloatMicApp/FloatMicApp/Libraries/"
cp "$WHISPER_DIR/build/libggml-blas.dylib" "$PROJECT_DIR/FloatMicApp/FloatMicApp/Libraries/"

# Copy header files
echo "Copying header files..."
mkdir -p "$PROJECT_DIR/FloatMicApp/FloatMicApp/Headers"
cp "$WHISPER_DIR/include/whisper.h" "$PROJECT_DIR/FloatMicApp/FloatMicApp/Headers/"
cp "$WHISPER_DIR/ggml/include/ggml.h" "$PROJECT_DIR/FloatMicApp/FloatMicApp/Headers/"

echo "Whisper.cpp setup complete!"
echo ""
echo "Next steps:"
echo "1. Open FloatMicApp.xcodeproj in Xcode"
echo "2. Add the following files to your project:"
echo "   - WhisperBridge.h"
echo "   - WhisperBridge.mm"
echo "   - Services/WhisperLocalService.swift"
echo "   - Headers/whisper.h"
echo "   - Headers/ggml.h"
echo "3. Add the Libraries/*.dylib files to your app bundle"
echo "4. Add the Models/*.bin files to your app bundle"
echo "5. Update build settings to include the whisper.cpp include path"
