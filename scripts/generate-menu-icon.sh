#!/bin/bash

# FloatMic Menu Bar Icon Generator
# This script generates a menu bar icon using SF Symbols

echo "📊 Generating FloatMic Menu Bar Icon"
echo "===================================="

TEMP_DIR="temp_menu_icon"
MENU_ICON_DIR="FloatMic/Assets.xcassets"

# Create temp directory
mkdir -p "$TEMP_DIR"

echo "📱 Generating menu bar icon..."

# Create a Swift script to generate the menu bar icon
cat > "$TEMP_DIR/generate_menu_icon.swift" << 'EOF'
import Cocoa
import SwiftUI

// Create a view for the menu bar icon
struct MenuBarIconView: View {
    var body: some View {
        ZStack {
            // Simple white background with subtle shadow
            Circle()
                .fill(Color.white)
                .frame(width: 18, height: 18)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            
            // Microphone symbol
            Image(systemName: "mic.fill")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.black)
        }
    }
}

// Generate the image
let view = MenuBarIconView()
let hostingView = NSHostingView(rootView: view)
hostingView.frame = NSRect(x: 0, y: 0, width: 18, height: 18)

let image = NSImage(size: NSSize(width: 18, height: 18))
image.lockFocus()
hostingView.draw(NSRect(x: 0, y: 0, width: 18, height: 18))
image.unlockFocus()

// Save as PNG
if let tiffData = image.tiffRepresentation,
   let bitmapRep = NSBitmapImageRep(data: tiffData),
   let pngData = bitmapRep.representation(using: .png, properties: [:]) {
    try pngData.write(to: URL(fileURLWithPath: "temp_menu_icon/menu_icon.png"))
    print("✅ Generated menu bar icon")
} else {
    print("❌ Failed to generate menu bar icon")
}
EOF

# Run the Swift script
swift "$TEMP_DIR/generate_menu_icon.swift"

# Copy to assets
cp "$TEMP_DIR/menu_icon.png" "$MENU_ICON_DIR/"

# Clean up
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Menu bar icon generated successfully!"
echo ""
echo "Icon features:"
echo "- 18x18 pixel size (standard for menu bar)"
echo "- White circular background with subtle shadow"
echo "- Black microphone symbol"
echo "- Clean, minimal design"
echo ""
echo "The icon will be used in the menu bar when the app is running."
