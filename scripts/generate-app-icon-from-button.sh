#!/bin/bash

# FloatMic App Icon Generator - Based on Button Design
# This script generates app icons that match the floating microphone button design

echo "🎨 Generating FloatMic App Icons from Button Design"
echo "==================================================="

ICON_DIR="FloatMicApp/FloatMicApp/Assets.xcassets/AppIcon.appiconset"
TEMP_DIR="temp_button_icons"

# Button color from SettingsManager (default: aaca52)
BUTTON_COLOR_HEX="aaca52"

# Parse hex color to RGB
# aaca52 = RGB(170, 202, 82)
RED=170
GREEN=202
BLUE=82

# Create temp directory
mkdir -p "$TEMP_DIR"

# Function to generate icon matching button design
generate_icon() {
    local size=$1
    local filename=$2
    
    echo "📱 Generating ${size}x${size} icon..."
    
    # Calculate icon size as a percentage of the canvas (button should be ~80% of icon size)
    local button_size=$(awk "BEGIN {printf \"%.0f\", $size * 0.8}")
    local icon_size=$(awk "BEGIN {printf \"%.0f\", $button_size * 0.4}")
    
    # Create a Swift script to generate the icon
    cat > "$TEMP_DIR/generate_icon.swift" << EOF
import Cocoa
import SwiftUI

// Create a view matching the button design
struct ButtonIconView: View {
    var body: some View {
        ZStack {
            // Transparent background (will be square for macOS)
            Color.clear
            
            // Circular button matching the app button design
            ZStack {
                // Circle background with button color
                Circle()
                    .fill(Color(red: $RED/255.0, green: $GREEN/255.0, blue: $BLUE/255.0))
                    .frame(width: $button_size, height: $button_size)
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                
                // White microphone icon
                Image(systemName: "mic.fill")
                    .font(.system(size: $icon_size, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .frame(width: $size, height: $size)
    }
}

// Generate the image
let view = ButtonIconView()
let hostingView = NSHostingView(rootView: view)
hostingView.frame = NSRect(x: 0, y: 0, width: $size, height: $size)

let image = NSImage(size: NSSize(width: $size, height: $size))
image.lockFocus()
hostingView.draw(NSRect(x: 0, y: 0, width: $size, height: $size))
image.unlockFocus()

// Save as PNG
if let tiffData = image.tiffRepresentation,
   let bitmapRep = NSBitmapImageRep(data: tiffData),
   let pngData = bitmapRep.representation(using: .png, properties: [:]) {
    try pngData.write(to: URL(fileURLWithPath: "$TEMP_DIR/$filename"))
    print("✅ Generated $filename")
} else {
    print("❌ Failed to generate $filename")
}
EOF

    # Run the Swift script
    swift "$TEMP_DIR/generate_icon.swift"
}

# Generate all required icon sizes
echo "🔨 Generating icons matching button design..."

# macOS App Icons
generate_icon 16 "icon_16x16.png"
generate_icon 32 "icon_16x16@2x.png"
generate_icon 32 "icon_32x32.png"
generate_icon 64 "icon_32x32@2x.png"
generate_icon 128 "icon_128x128.png"
generate_icon 256 "icon_128x128@2x.png"
generate_icon 256 "icon_256x256.png"
generate_icon 512 "icon_256x256@2x.png"
generate_icon 512 "icon_512x512.png"
generate_icon 1024 "icon_512x512@2x.png"

# Copy icons to the app bundle
echo "📁 Copying icons to app bundle..."
cp "$TEMP_DIR/icon_16x16.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_16x16@2x.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_32x32.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_32x32@2x.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_128x128.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_128x128@2x.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_256x256.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_256x256@2x.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_512x512.png" "$ICON_DIR/"
cp "$TEMP_DIR/icon_512x512@2x.png" "$ICON_DIR/"

# Update Contents.json
echo "📄 Updating Contents.json..."
cat > "$ICON_DIR/Contents.json" << 'EOF'
{
  "images" : [
    {
      "filename" : "icon_16x16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_16x16@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "icon_32x32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_32x32@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "icon_128x128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_128x128@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "icon_256x256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_256x256@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "icon_512x512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "icon_512x512@2x.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Clean up
rm -rf "$TEMP_DIR"

echo ""
echo "✅ App icons generated successfully!"
echo ""
echo "Icons created:"
echo "- 16x16, 32x32, 128x128, 256x256, 512x512 (1x and 2x)"
echo "- Circular button design matching the app button"
echo "- Color: #$BUTTON_COLOR_HEX (from button settings)"
echo "- White mic.fill icon with shadow"
echo ""
echo "Next steps:"
echo "1. Build and run the app to see the new icons"
echo "2. Test the icons in different contexts (Dock, Finder, etc.)"
echo "3. If you want to use a different color, modify BUTTON_COLOR_HEX in this script"
