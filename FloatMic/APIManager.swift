import Foundation
import SwiftUI

class APIManager: ObservableObject {
    @Published var selectedService: ServiceType = .appleIntelligence
    @Published var apiKeys: [ServiceType: String] = [:]
    
    enum ServiceType: String, CaseIterable {
        case appleIntelligence = "Apple Intelligence"
        case openAI = "OpenAI Whisper"
        case openRouter = "OpenRouter"
        case gemini = "Google Gemini"
        case whisperLocal = "Local Whisper"
        
        var priority: Int {
            switch self {
            case .appleIntelligence: return 1
            case .openAI: return 2
            case .openRouter: return 3
            case .gemini: return 4
            case .whisperLocal: return 5
            }
        }
        
        var description: String {
            switch self {
            case .appleIntelligence:
                return "Apple's built-in AI (Recommended - No API key required)"
            case .openAI:
                return "OpenAI Whisper API (High accuracy, requires API key)"
            case .openRouter:
                return "OpenRouter API (Multiple models, requires API key)"
            case .gemini:
                return "Google Gemini API (Fast, requires API key)"
            case .whisperLocal:
                return "Local Whisper.cpp (Offline, no API key required)"
            }
        }
    }
    
    init() {
        loadAPIKeys()
        loadSelectedService()
    }
    
    func setAPIKey(for service: ServiceType, key: String) {
        apiKeys[service] = key
        saveAPIKeys()
    }
    
    func getAPIKey(for service: ServiceType) -> String? {
        return apiKeys[service]
    }
    
    func setSelectedService(_ service: ServiceType) {
        selectedService = service
        UserDefaults.standard.set(service.rawValue, forKey: "selectedService")
    }
    
    func isAppleIntelligenceAvailable() -> Bool {
        // Check if Apple Intelligence is available on this system
        if #available(macOS 15.0, *) {
            return true
        }
        return false
    }
    
    func getAvailableServices() -> [ServiceType] {
        var services: [ServiceType] = []
        
        // Add Apple Intelligence if available
        if isAppleIntelligenceAvailable() {
            services.append(.appleIntelligence)
        }
        
        // Add other services if they have API keys
        for service in ServiceType.allCases {
            if service != .appleIntelligence && service != .whisperLocal {
                if let _ = apiKeys[service] {
                    services.append(service)
                }
            }
        }
        
        // Always add local Whisper as fallback
        services.append(.whisperLocal)
        
        // Sort by priority
        return services.sorted { $0.priority < $1.priority }
    }
    
    private func loadAPIKeys() {
        for service in ServiceType.allCases {
            if let key = KeychainHelper.getAPIKey(for: service.rawValue) {
                apiKeys[service] = key
            }
        }
    }
    
    private func saveAPIKeys() {
        for (service, key) in apiKeys {
            KeychainHelper.saveAPIKey(key, for: service.rawValue)
        }
    }
    
    private func loadSelectedService() {
        if let serviceString = UserDefaults.standard.string(forKey: "selectedService"),
           let service = ServiceType(rawValue: serviceString) {
            selectedService = service
        }
    }
}
