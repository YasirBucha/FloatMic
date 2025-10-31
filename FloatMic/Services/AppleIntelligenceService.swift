import Foundation
import AVFoundation
import Speech

@available(macOS 15.0, *)
class AppleIntelligenceService {
    enum AppleIntelligenceError: LocalizedError {
        case speechRecognitionNotAvailable
        case authorizationDenied
        case audioProcessingFailed
        case recognitionFailed(String)
        
        var errorDescription: String? {
            switch self {
            case .speechRecognitionNotAvailable:
                return "Speech recognition is not available on this system"
            case .authorizationDenied:
                return "Speech recognition authorization denied. Please enable it in System Settings > Privacy & Security > Speech Recognition."
            case .audioProcessingFailed:
                return "Failed to process audio file"
            case .recognitionFailed(let msg):
                return "Recognition failed: \(msg)"
            }
        }
    }
    
    func transcribe(audioURL: URL) async throws -> String {
        // Request authorization if needed
        let authStatus = SFSpeechRecognizer.authorizationStatus()
        if authStatus == .notDetermined {
            await withCheckedContinuation { continuation in
                SFSpeechRecognizer.requestAuthorization { status in
                    continuation.resume()
                }
            }
        }
        
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
            throw AppleIntelligenceError.authorizationDenied
        }
        
        // Check for on-device recognition support
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")),
              recognizer.isAvailable else {
            throw AppleIntelligenceError.speechRecognitionNotAvailable
        }
        
        // Create recognition request
        let request = SFSpeechURLRecognitionRequest(url: audioURL)
        request.shouldReportPartialResults = false
        
        // Prefer on-device processing (Apple Intelligence on macOS 15.0+)
        request.requiresOnDeviceRecognition = true
        
        // Perform recognition
        return try await withCheckedThrowingContinuation { continuation in
            var task: SFSpeechRecognitionTask?
            
            task = recognizer.recognitionTask(with: request) { result, error in
                if let error = error {
                    task?.cancel()
                    continuation.resume(throwing: AppleIntelligenceError.recognitionFailed(error.localizedDescription))
                    return
                }
                
                if let result = result, result.isFinal {
                    task?.cancel()
                    continuation.resume(returning: result.bestTranscription.formattedString)
                }
            }
        }
    }
}

