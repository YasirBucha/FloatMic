#!/bin/bash

echo "Fixing Whisper library linking issues..."

# Remove the Libraries directory from the app bundle to prevent linking issues
rm -rf FloatMicApp/FloatMicApp/Libraries/

# Remove the Headers directory as well
rm -rf FloatMicApp/FloatMicApp/Headers/

echo "Cleaned up Whisper library files."
echo "The app should now run without the Whisper library linking issues."
echo ""
echo "To complete Whisper integration later:"
echo "1. Add the libraries back to Xcode project properly"
echo "2. Set up proper include paths"
echo "3. Configure the bridging header correctly"
