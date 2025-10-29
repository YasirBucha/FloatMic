#!/bin/bash

echo "Adding Whisper files to Xcode project..."

# Add the files to Xcode project
xcodebuild -project FloatMicApp.xcodeproj -target FloatMicApp -add-to-target FloatMicApp \
  -add-file FloatMicApp/WhisperBridge.h \
  -add-file FloatMicApp/WhisperBridge.mm \
  -add-file FloatMicApp/Services/WhisperLocalService.swift \
  -add-file FloatMicApp/Headers/whisper.h \
  -add-file FloatMicApp/Headers/ggml.h

echo "Files added to Xcode project!"
echo ""
echo "Manual steps needed:"
echo "1. Open FloatMicApp.xcodeproj in Xcode"
echo "2. Add the Libraries/*.dylib files to your app bundle"
echo "3. Add the Models/*.bin files to your app bundle"
echo "4. Update build settings:"
echo "   - Add whisper.cpp include path: \$(SRCROOT)/whisper.cpp/include"
echo "   - Add ggml include path: \$(SRCROOT)/whisper.cpp/ggml/include"
echo "   - Add library search paths: \$(SRCROOT)/FloatMicApp/Libraries"
echo "   - Link with libraries: libwhisper.dylib, libggml.dylib, etc."
