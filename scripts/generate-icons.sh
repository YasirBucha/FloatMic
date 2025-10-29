#!/bin/bash

# FloatMic Icon Generator
# This script generates app icons using SF Symbols and system tools

echo "🎨 Generating FloatMic App Icons"
echo "================================="

ICON_DIR="FloatMic/Assets.xcassets/AppIcon.appiconset"
TEMP_DIR="temp_icons"

# Create temp directory
mkdir -p "$TEMP_DIR"

# Function to generate icon from SF Symbol
generate_icon() {
    local size=$1
    local filename=$2
    local symbol=$3
    
    echo "📱 Generating ${size}x${size} icon..."
    
    # Create a simple Swift script to generate the icon
    cat > "$TEMP_DIR/generate_icon.swift" << EOF
import Cocoa
import SwiftUI

// Create a view with the SF Symbol
struct IconView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.4, blue: 1.0),  // Blue
                    Color(red: 0.0, green: 0.6, blue: 0.8)   // Light blue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(20)
            
            // SF Symbol
            Image(systemName: "$symbol")
                .font(.system(size: $((size * 3 / 4)), weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
        .frame(width: $size, height: $size)
    }
}

// Generate the image
let view = IconView()
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
echo "🔨 Generating icons..."

# macOS App Icons
generate_icon 16 "icon_16x16.png" "mic.circle.fill"
generate_icon 32 "icon_16x16@2x.png" "mic.circle.fill"
generate_icon 32 "icon_32x32.png" "mic.circle.fill"
generate_icon 64 "icon_32x32@2x.png" "mic.circle.fill"
generate_icon 128 "icon_128x128.png" "mic.circle.fill"
generate_icon 256 "icon_128x128@2x.png" "mic.circle.fill"
generate_icon 256 "icon_256x256.png" "mic.circle.fill"
generate_icon 512 "icon_256x256@2x.png" "mic.circle.fill"
generate_icon 512 "icon_512x512.png" "mic.circle.fill"
generate_icon 1024 "icon_512x512@2x.png" "mic.circle.fill"

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
echo "- Blue gradient background with white microphone symbol"
echo "- Modern, professional appearance"
echo ""
echo "Next steps:"
echo "1. Build and run the app to see the new icons"
echo "2. Test the icons in different contexts (Dock, Finder, etc.)"
echo "3. Adjust colors or symbols if needed"
