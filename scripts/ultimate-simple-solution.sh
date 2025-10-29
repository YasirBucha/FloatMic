#!/bin/bash

# ULTIMATE SIMPLE SOLUTION - Just create the files and let Xcode handle the project

echo "🚀 ULTIMATE SIMPLE SOLUTION"
echo "==========================="

# Create the FloatMic directory structure
mkdir -p FloatMic

# Create the essential Swift files
echo "📝 Creating Swift files..."

# FloatMicApp.swift
cat > FloatMic/FloatMicApp.swift << 'EOF'
import SwiftUI

@main
struct FloatMicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOF

# ContentView.swift
cat > FloatMic/ContentView.swift << 'EOF'
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "mic.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)
            
            Text("FloatMic")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Floating Microphone App")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Ready to build!")
                .font(.subheadline)
                .foregroundColor(.green)
                .padding(.top)
        }
        .padding()
        .frame(width: 400, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
EOF

# Create basic Assets.xcassets
mkdir -p FloatMic/Assets.xcassets/AppIcon.appiconset
mkdir -p FloatMic/Assets.xcassets/AccentColor.colorset
mkdir -p "FloatMic/Preview Content/Preview Assets.xcassets"

# Assets.xcassets/Contents.json
cat > FloatMic/Assets.xcassets/Contents.json << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# AppIcon.appiconset/Contents.json
cat > FloatMic/Assets.xcassets/AppIcon.appiconset/Contents.json << 'EOF'
{
  "images" : [
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
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

# AccentColor.colorset/Contents.json
cat > FloatMic/Assets.xcassets/AccentColor.colorset/Contents.json << 'EOF'
{
  "colors" : [
    {
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Preview Assets.xcassets/Contents.json
cat > "FloatMic/Preview Content/Preview Assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "✅ All files created!"

# Now let's create a new Xcode project using the command line
echo "📱 Creating new Xcode project..."

# Use xcodebuild to create a new project
xcodebuild -create-api-only-project -name FloatMic -bundle-identifier com.floatmic.app -output FloatMic.xcodeproj

if [ $? -eq 0 ]; then
    echo "✅ Xcode project created successfully!"
    
    # Copy our files to the project
    echo "📋 Copying files to project..."
    cp -r FloatMic/* FloatMic.xcodeproj/
    
    echo "🎉 SUCCESS! Opening Xcode..."
    open FloatMic.xcodeproj
else
    echo "⚠️  API project creation failed, but files are ready"
    echo "   You can create a new project in Xcode and add these files"
fi

echo ""
echo "🎉 FILES ARE READY!"
echo "==================="
echo "✅ FloatMicApp.swift created"
echo "✅ ContentView.swift created"
echo "✅ Assets.xcassets created"
echo "✅ All file structure ready"
echo ""
echo "Next steps:"
echo "1. Open Xcode"
echo "2. Create new macOS App project"
echo "3. Add these files to the project"
echo "4. Build and run!"
echo ""
echo "Or if the project opened automatically, just press Cmd+R! 🚀"
