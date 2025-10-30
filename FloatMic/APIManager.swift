import Foundation
import SwiftUI

class APIManager: ObservableObject {
    @Published var selectedService: ServiceType = .appleIntelligence
    @Published var apiKeys: [ServiceType: String] = [:]
    @Published var forceLocalWhisperOnly: Bool = false
    
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
        forceLocalWhisperOnly = UserDefaults.standard.bool(forKey: "forceLocalWhisperOnly")
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
    
    func setForceLocalWhisperOnly(_ value: Bool) {
        forceLocalWhisperOnly = value
        UserDefaults.standard.set(value, forKey: "forceLocalWhisperOnly")
    }
    
    func isAppleIntelligenceAvailable() -> Bool {
        // Check if Apple Intelligence is available on this system
        if #available(macOS 15.0, *) {
            return true
        }
        return false
    }
    
    func getAvailableServices() -> [ServiceType] {
        if forceLocalWhisperOnly { return [.whisperLocal] }
        var services: [ServiceType] = []
        
        // Base priority list
        if isAppleIntelligenceAvailable() { services.append(.appleIntelligence) }
        if apiKeys[.openAI] != nil { services.append(.openAI) }
        if apiKeys[.openRouter] != nil { services.append(.openRouter) }
        if apiKeys[.gemini] != nil { services.append(.gemini) }
        services.append(.whisperLocal)
        
        // If user explicitly selected a service, try it first
        if let idx = services.firstIndex(of: selectedService) {
            let preferred = services.remove(at: idx)
            services.insert(preferred, at: 0)
        }
        
        return services
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
