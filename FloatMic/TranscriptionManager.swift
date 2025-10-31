import Foundation
import SwiftUI
import Combine

class TranscriptionManager: ObservableObject {
    @Published var isTranscribing = false
    @Published var lastTranscription = ""
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var showStatusBanner = false
    @Published var statusMessage = ""
    
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
                    self.showStatusBanner = false
                    self.isTranscribing = false
                }
            } catch {
                await MainActor.run {
                    self.showStatus("Transcription failed. \(error.localizedDescription)")
                    self.showToast(message: "Transcription failed")
                    self.isTranscribing = false
                }
            }
        }
    }
    
    private func performTranscriptionWithFallback(audioURL: URL) async throws -> String {
        let availableServices = apiManager.getAvailableServices()
        
        for service in availableServices {
            do {
                await MainActor.run { self.showStatus("Using \(service.rawValue)...") }
                let result = try await transcribeWithService(service, audioURL: audioURL)
                return result
            } catch {
                await MainActor.run { self.showStatus("\(service.rawValue) failed, trying next...") }
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
        if #available(macOS 15.0, *) {
            let service = AppleIntelligenceService()
            return try await service.transcribe(audioURL: audioURL)
        } else {
            throw TranscriptionError.serviceNotAvailable("Apple Intelligence requires macOS 15.0 or later")
        }
    }
    
    private func transcribeWithOpenAI(audioURL: URL) async throws -> String {
        let service = OpenAIWhisperService()
        let key = apiManager.getAPIKey(for: .openAI)
        return try await service.transcribe(apiKey: key, audioURL: audioURL)
    }
    
    private func transcribeWithOpenRouter(audioURL: URL) async throws -> String {
        let service = OpenRouterTranscriptionService()
        let key = apiManager.getAPIKey(for: .openRouter)
        return try await service.transcribe(apiKey: key, audioURL: audioURL)
    }
    
    private func transcribeWithGemini(audioURL: URL) async throws -> String {
        let service = GeminiTranscriptionService()
        let key = apiManager.getAPIKey(for: .gemini)
        return try await service.transcribe(apiKey: key, audioURL: audioURL)
    }
    
    private func transcribeWithWhisperLocal(audioURL: URL) async throws -> String {
        // Get the selected model name from settings
        let modelName = UserDefaults.standard.string(forKey: "whisperModelName") ?? "ggml-base"
        
        // Extract base model name (remove .bin extension if present, handle ggml- prefix)
        let baseModelName: String
        if modelName.hasPrefix("ggml-") {
            baseModelName = modelName
        } else if modelName.hasSuffix(".bin") {
            baseModelName = String(modelName.dropLast(4))
        } else {
            baseModelName = modelName
        }
        
        let whisperService = WhisperLocalService(modelName: baseModelName)
        
        guard whisperService.initialize() else {
            throw TranscriptionError.serviceNotAvailable("Local Whisper - Failed to initialize")
        }
        
        guard let result = whisperService.transcribeAudioFile(url: audioURL) else {
            throw TranscriptionError.serviceNotAvailable("Local Whisper - Transcription failed")
        }
        
        // Check if result is a placeholder
        if result.contains("Placeholder transcription") {
            throw TranscriptionError.serviceNotAvailable("Local Whisper - Model not found. Please download a Whisper model.")
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

    func showStatus(_ message: String) {
        statusMessage = message
        showStatusBanner = true
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
