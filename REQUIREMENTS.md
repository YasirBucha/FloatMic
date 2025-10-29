# FloatMic - macOS Requirements Specification

## Project Overview
**Project Name:** FloatMic  
**Platform:** macOS (Native)  
**Technology Stack:** Swift + SwiftUI + AppKit  
**Purpose:** A floating, draggable microphone button for instant speech-to-text transcription

## Core Concept
A native macOS application featuring a small, always-on-top circular microphone button that users can drag anywhere on their screen. The button records speech, transcribes it instantly using various AI models, and automatically copies the transcribed text to the clipboard.

## Functional Requirements

### 1. Floating Mic Interface
- **FR-001:** Display a small circular microphone button on app launch
- **FR-002:** Button must be always-on-top and draggable anywhere on screen
- **FR-003:** Button should have visual feedback (glow red) during recording
- **FR-004:** Support click-to-start and click-to-stop recording functionality
- **FR-005:** Support keyboard shortcut (Enter/Return) to stop recording

### 2. Audio Recording
- **FR-006:** Capture audio input using AVFoundation
- **FR-007:** Start recording on button click
- **FR-008:** Stop recording on second click or Enter/Return key press
- **FR-009:** Handle audio permissions and error states

### 3. Speech Transcription
- **FR-010:** Transcribe recorded audio to text after stopping
- **FR-011:** Support multiple transcription engines:
  - Whisper.cpp (local, offline)
  - OpenAI Whisper API
  - OpenRouter API
  - Google Gemini API
  - DeepSeek API (future support)
- **FR-012:** Automatically copy transcribed text to clipboard
- **FR-013:** Display toast notification "Transcription copied"

### 4. Menu Bar Integration
- **FR-014:** Add menu bar icon for app control
- **FR-015:** Menu bar options:
  - Toggle Floating Mic (show/hide)
  - Choose Model Source (Local Whisper / API)
  - Manage API Keys
  - Preferences
  - Quit

### 5. API Key Management
- **FR-016:** Secure storage of API keys in macOS Keychain
- **FR-017:** Support for multiple API providers
- **FR-018:** Key validation and error handling
- **FR-019:** Model selection and switching logic

## Technical Requirements

### 1. Architecture
- **TR-001:** SwiftUI for user interface
- **TR-002:** AppKit interop for draggable floating window
- **TR-003:** AVFoundation for audio recording
- **TR-004:** Whisper.cpp integration via C-bridge for local transcription
- **TR-005:** Modular, lightweight code structure

### 2. Security
- **TR-006:** All API keys stored securely in macOS Keychain
- **TR-007:** No plaintext storage of sensitive credentials
- **TR-008:** Secure API communication with proper error handling

### 3. Performance
- **TR-009:** Fast local transcription using Whisper.cpp
- **TR-010:** Efficient memory management for audio processing
- **TR-011:** Minimal CPU usage when idle
- **TR-012:** Quick response times for UI interactions

### 4. User Experience
- **TR-013:** Intuitive drag-and-drop functionality
- **TR-014:** Clear visual feedback for all states
- **TR-015:** Toast notifications for user actions
- **TR-016:** Keyboard shortcuts for power users
- **TR-017:** Always-on-top behavior for accessibility

## File Structure Requirements

### Core Application Files
- `AppDelegate.swift` - Application lifecycle and setup
- `ContentView.swift` - Main UI components
- `AudioRecorder.swift` - Audio recording functionality
- `TranscriptionManager.swift` - Transcription orchestration
- `APIManager.swift` - API key management and routing
- `ToastView.swift` - Toast notification UI

### Supporting Files
- `Models/` - Data models for API responses
- `Services/` - Service layer for different transcription engines
- `Utils/` - Utility functions and extensions
- `Resources/` - Assets, sounds, and configuration files

## API Integration Requirements

### 1. Whisper.cpp (Local)
- **API-001:** Integrate C-bridge for Whisper.cpp
- **API-002:** Support for offline transcription
- **API-003:** Model file management and loading

### 2. OpenAI Whisper API
- **API-004:** REST API integration
- **API-005:** Key validation and authentication
- **API-006:** Error handling and rate limiting

### 3. OpenRouter API
- **API-007:** Multi-provider API integration
- **API-008:** Model selection and configuration
- **API-009:** Cost tracking and usage monitoring

### 4. Google Gemini API
- **API-010:** Google Cloud integration
- **API-011:** Authentication and authorization
- **API-012:** Response parsing and error handling

## Non-Functional Requirements

### 1. Compatibility
- **NFR-001:** macOS 12.0+ support
- **NFR-002:** Intel and Apple Silicon compatibility
- **NFR-003:** Dark mode and light mode support

### 2. Reliability
- **NFR-004:** Graceful error handling for all API failures
- **NFR-005:** Offline functionality with local Whisper
- **NFR-006:** Automatic retry mechanisms for transient failures

### 3. Usability
- **NFR-007:** One-click recording start/stop
- **NFR-008:** Immediate visual feedback
- **NFR-009:** Keyboard accessibility
- **NFR-010:** Intuitive menu bar controls

## Success Criteria
1. Users can drag the mic button anywhere on screen
2. One-click recording with immediate visual feedback
3. Successful transcription using at least 2 different engines
4. Automatic clipboard copying with user notification
5. Secure API key management
6. Menu bar integration with all required options
7. Offline functionality with local Whisper.cpp
8. Smooth, responsive UI with minimal resource usage

## Future Enhancements
- **FE-001:** Customizable hotkeys for recording
- **FE-002:** Multiple language support
- **FE-003:** Audio quality settings
- **FE-004:** Transcription history
- **FE-005:** Export functionality
- **FE-006:** Voice activity detection
- **FE-007:** Real-time transcription streaming
