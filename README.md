# FloatMic

A native macOS app featuring a floating, draggable microphone button for instant speech-to-text transcription.

## Features

- **Floating Mic Button**: Always-on-top, draggable circular microphone button
- **Multiple Transcription Services** (Intelligent Priority System):
  - **Apple Intelligence** (On-Device) - Highest accuracy, completely private
  - **ChatGPT Whisper API** - High accuracy, cloud-based
  - **Whisper.cpp** (Local) - Good accuracy, completely offline
  - **OpenRouter** - Multi-provider access
  - **Google Gemini API** - Advanced AI transcription
- **Secure API Key Storage**: Keys stored in macOS Keychain
- **Global Hotkey Support**: Cmd+Return to start/stop recording
- **Menu Bar Integration**: Easy access to settings and controls
- **Toast Notifications**: Visual feedback for transcription status

## Requirements

- **macOS 15.0 or later** (for Apple Intelligence)
- **macOS 12.0 or later** (for other services)
- Xcode 15.0 or later
- Microphone permissions

## Setup Instructions

### 1. Open in Xcode

1. Open `FloatMic.xcodeproj` in Xcode
2. Select your development team in project settings
3. Build and run the project

### 2. Configure API Keys (Optional)

The app uses **Apple Intelligence by default** on macOS 15.0+ for the best experience. You can also configure cloud services for additional options:

1. Click the menu bar icon
2. Select "Manage API Keys"
3. Enter your API keys for desired services:
   - **ChatGPT**: Get your API key from [OpenAI Platform](https://platform.openai.com/api-keys)
   - **OpenRouter**: Get your API key from [OpenRouter](https://openrouter.ai/keys)
   - **Gemini**: Get your API key from [Google AI Studio](https://aistudio.google.com/app/apikey)

### 3. Choose Transcription Service

1. Click the menu bar icon
2. Select "Choose Model Source"
3. Pick your preferred service (or let the app choose automatically):
   - **Apple Intelligence (On-Device)**: Highest accuracy, completely private, no setup required
   - **ChatGPT Whisper API**: High-quality cloud transcription
   - **Whisper.cpp (Local)**: Fast, offline, requires model download
   - **OpenRouter**: Multi-provider access with competitive pricing
   - **Google Gemini**: Google's advanced AI transcription

**Intelligent Fallback System**: The app automatically tries services in priority order, so you get the best available option without configuration!

## Usage

### Basic Recording

1. **Start Recording**: Click the floating mic button
2. **Stop Recording**: Click again or press Cmd+Return
3. **View Result**: Transcribed text is automatically copied to clipboard
4. **Toast Notification**: Shows "Transcription copied" confirmation

### Global Hotkey

- **Cmd+Return**: Toggle recording from anywhere in the system
- Configure in Preferences if needed

### Menu Bar Controls

- **Toggle Floating Mic**: Show/hide the floating button
- **Choose Model Source**: Switch between transcription services
- **Manage API Keys**: Configure cloud service credentials
- **Preferences**: General settings and hotkey configuration
- **Quit**: Exit the application

## Whisper.cpp Integration

For local transcription, you'll need to integrate Whisper.cpp:

1. Download Whisper.cpp from [GitHub](https://github.com/ggerganov/whisper.cpp)
2. Build the library for macOS
3. Add the framework to your Xcode project
4. Download a Whisper model (recommended: `base` model, 74MB)

## Audio Settings

The app uses optimized audio settings for transcription:
- **Sample Rate**: 44.1 kHz
- **Bit Depth**: 16-bit
- **Channels**: Mono
- **Format**: WAV

## Security

- All API keys are stored securely in macOS Keychain
- No data is sent to external services without your explicit API key configuration
- Local Whisper.cpp processing keeps your audio completely private

## Troubleshooting

### Microphone Permission Denied
1. Go to System Preferences > Security & Privacy > Privacy
2. Select "Microphone" from the left sidebar
3. Enable FloatMic in the list

### Transcription Not Working
1. Check your internet connection (for cloud services)
2. Verify API keys are correctly configured
3. Ensure microphone permissions are granted
4. Try switching to a different transcription service

### Floating Button Not Visible
1. Check if the button is hidden behind other windows
2. Use the menu bar "Toggle Floating Mic" option
3. Restart the app if needed

## Development

### Project Structure

```
FloatMic/
├── FloatMicApp.swift          # Main app entry point
├── AppDelegate.swift          # App lifecycle and window management
├── ContentView.swift          # Floating mic button UI
├── AudioRecorder.swift        # Audio recording functionality
├── TranscriptionManager.swift # Transcription orchestration
├── APIManager.swift          # API key management
├── ToastView.swift           # Toast notification UI
├── Models/                   # Data models
├── Services/                 # Transcription service implementations
├── Utils/                    # Utility classes
└── Views/                    # Settings and preference windows
```

### Adding New Transcription Services

1. Create a new service class implementing `TranscriptionService` protocol
2. Add the service type to `APIManager.ServiceType` enum
3. Update `TranscriptionManager` to handle the new service
4. Add UI for the new service in settings views

## License

This project is for educational and personal use. Please respect the terms of service for any third-party APIs you use.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review the requirements specification document
3. Open an issue on GitHub with detailed information about your problem
