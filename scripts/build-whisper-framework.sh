#!/bin/bash

# FloatMic Whisper Framework Builder
# This script creates a proper framework for Xcode integration

echo "🔨 Building Whisper Framework for FloatMic"
echo "=========================================="

FRAMEWORK_DIR="whisper/framework"
WHISPER_DIR="whisper/whisper.cpp"
BUILD_DIR="$WHISPER_DIR/build"

# Create framework directory structure
echo "📁 Creating framework structure..."
mkdir -p "$FRAMEWORK_DIR/Whisper.framework/Headers"
mkdir -p "$FRAMEWORK_DIR/Whisper.framework/Resources"

# Copy headers
echo "📋 Copying headers..."
cp "$WHISPER_DIR/include/whisper.h" "$FRAMEWORK_DIR/Whisper.framework/Headers/"
cp "$WHISPER_DIR/ggml/include/ggml.h" "$FRAMEWORK_DIR/Whisper.framework/Headers/"
cp "$BUILD_DIR/bin/ggml-common.h" "$FRAMEWORK_DIR/Whisper.framework/Headers/"

# Create umbrella header
echo "📝 Creating umbrella header..."
cat > "$FRAMEWORK_DIR/Whisper.framework/Headers/Whisper.h" << 'EOF'
#ifndef WHISPER_H
#define WHISPER_H

#import "whisper.h"
#import "ggml.h"

#endif /* WHISPER_H */
EOF

# Copy libraries
echo "📚 Copying libraries..."
cp "$BUILD_DIR/ggml/src/libggml.dylib" "$FRAMEWORK_DIR/Whisper.framework/"
cp "$BUILD_DIR/ggml/src/libggml-base.dylib" "$FRAMEWORK_DIR/Whisper.framework/"
cp "$BUILD_DIR/ggml/src/libggml-cpu.dylib" "$FRAMEWORK_DIR/Whisper.framework/"
cp "$BUILD_DIR/ggml/src/ggml-metal/libggml-metal.dylib" "$FRAMEWORK_DIR/Whisper.framework/"
cp "$BUILD_DIR/ggml/src/ggml-blas/libggml-blas.dylib" "$FRAMEWORK_DIR/Whisper.framework/"
cp "$BUILD_DIR/src/libwhisper.dylib" "$FRAMEWORK_DIR/Whisper.framework/"

# Create Info.plist
echo "📄 Creating Info.plist..."
cat > "$FRAMEWORK_DIR/Whisper.framework/Resources/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>Whisper</string>
    <key>CFBundleIdentifier</key>
    <string>com.floatmic.whisper</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Whisper</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>MinimumOSVersion</key>
    <string>12.0</string>
</dict>
</plist>
EOF

# Create module map
echo "📦 Creating module map..."
mkdir -p "$FRAMEWORK_DIR/Whisper.framework/Modules"
cat > "$FRAMEWORK_DIR/Whisper.framework/Modules/module.modulemap" << 'EOF'
framework module Whisper {
    umbrella header "Whisper.h"
    
    export *
    module * { export * }
    
    link "whisper"
    link "ggml"
    link "ggml-base"
    link "ggml-cpu"
    link "ggml-metal"
    link "ggml-blas"
}
EOF

# Copy model to app bundle location
echo "📁 Setting up model location..."
MODEL_DEST="FloatMic/Models"
mkdir -p "$MODEL_DEST"
cp "whisper/models/ggml-base.bin" "$MODEL_DEST/"

echo ""
echo "✅ Framework created successfully!"
echo ""
echo "Framework location: $FRAMEWORK_DIR/Whisper.framework"
echo "Model location: $MODEL_DEST/ggml-base.bin"
echo ""
echo "Next steps:"
echo "1. Add Whisper.framework to your Xcode project"
echo "2. Link the framework in Build Phases"
echo "3. Add the Models folder to your app bundle"
echo "4. Update WhisperLocalService.swift with the correct model path"
