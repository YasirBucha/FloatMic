import Foundation
import SwiftUI

class TranscriptionManager: ObservableObject {
    @Published var isTranscribing = false
    @Published var lastTranscription = ""
    @Published var showToast = false
    @Published var toastMessage = ""
    
    private let apiManager: APIManager
    private let historyManager: TranscriptionHistoryManager
    
    init(apiManager: APIManager, historyManager: TranscriptionHistoryManager) {
        self.apiManager = apiManager
        self.historyManager = historyManager
    }
    
    func transcribeAudio(url: URL) {
        guard !isTranscribing else { return }
        
        isTranscribing = true
        
        Task {
            do {
                let result = try await performTranscriptionWithFallback(audioURL: url)
                
                await MainActor.run {
                    self.lastTranscription = result
                    self.copyToClipboard(text: result)
                    self.addToHistory(text: result)
                    self.showToast(message: "Transcription copied to clipboard")
                    self.isTranscribing = false
                }
            } catch {
                await MainActor.run {
                    self.showToast(message: "Transcription failed: \(error.localizedDescription)")
                    self.isTranscribing = false
                }
            }
        }
    }
    
    private func performTranscriptionWithFallback(audioURL: URL) async throws -> String {
        let availableServices = apiManager.getAvailableServices()
        
        for service in availableServices {
            do {
                let result = try await transcribeWithService(service, audioURL: audioURL)
                return result
            } catch {
                print("Service \(service) failed: \(error)")
                continue
            }
        }
        
        throw TranscriptionError.noServicesAvailable
    }
    
    private func transcribeWithService(_ service: APIManager.ServiceType, audioURL: URL) async throws -> String {
        switch service {
        case .appleIntelligence:
            return try await transcribeWithAppleIntelligence(audioURL: audioURL)
        case .openAI:
            return try await transcribeWithOpenAI(audioURL: audioURL)
        case .openRouter:
            return try await transcribeWithOpenRouter(audioURL: audioURL)
        case .gemini:
            return try await transcribeWithGemini(audioURL: audioURL)
        case .whisperLocal:
            return try await transcribeWithWhisperLocal(audioURL: audioURL)
        }
    }
    
    private func transcribeWithAppleIntelligence(audioURL: URL) async throws -> String {
        // Placeholder for Apple Intelligence integration
        // This would use Foundation Models framework when available
        throw TranscriptionError.serviceNotAvailable("Apple Intelligence")
    }
    
    private func transcribeWithOpenAI(audioURL: URL) async throws -> String {
        // Placeholder for OpenAI Whisper API
        throw TranscriptionError.serviceNotAvailable("OpenAI Whisper")
    }
    
    private func transcribeWithOpenRouter(audioURL: URL) async throws -> String {
        // Placeholder for OpenRouter API
        throw TranscriptionError.serviceNotAvailable("OpenRouter")
    }
    
    private func transcribeWithGemini(audioURL: URL) async throws -> String {
        // Placeholder for Google Gemini API
        throw TranscriptionError.serviceNotAvailable("Google Gemini")
    }
    
    private func transcribeWithWhisperLocal(audioURL: URL) async throws -> String {
        // Use the actual WhisperLocalService
        let whisperService = WhisperLocalService()
        
        guard whisperService.initialize() else {
            throw TranscriptionError.serviceNotAvailable("Local Whisper - Failed to initialize")
        }
        
        guard let result = whisperService.transcribeAudioFile(url: audioURL) else {
            throw TranscriptionError.serviceNotAvailable("Local Whisper - Transcription failed")
        }
        
        return result
    }
    
    private func copyToClipboard(text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private func addToHistory(text: String) {
        let item = TranscriptionHistoryItem(
            id: UUID(),
            text: text,
            timestamp: Date(),
            duration: 0.0 // We'll calculate this later
        )
        historyManager.addTranscription(item)
    }
    
    func showToast(message: String) {
        toastMessage = message
        showToast = true
        
        // Auto-hide toast after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.showToast = false
        }
    }
}

enum TranscriptionError: LocalizedError {
    case noServicesAvailable
    case serviceNotAvailable(String)
    
    var errorDescription: String? {
        switch self {
        case .noServicesAvailable:
            return "No transcription services are available"
        case .serviceNotAvailable(let service):
            return "\(service) is not available"
        }
    }
}
