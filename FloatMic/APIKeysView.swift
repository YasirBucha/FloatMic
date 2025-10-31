import SwiftUI

struct APIKeysView: View {
    @EnvironmentObject var apiManager: APIManager
    @State private var apiKeys: [APIManager.ServiceType: String] = [:]
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Manage API Keys")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Enter your API keys for different transcription services:")
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                // Only show services that require API keys
                ForEach(APIManager.ServiceType.allCases.filter { service in
                    // Exclude services that don't need API keys
                    service != .appleIntelligence && service != .whisperLocal
                }, id: \.self) { service in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(service.rawValue)
                            .fontWeight(.medium)
                        
                        HStack {
                            SecureField("Enter API key", text: Binding(
                                get: { apiKeys[service] ?? "" },
                                set: { apiKeys[service] = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button("Save") {
                                saveAPIKey(for: service)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Add informational note about services that don't need keys
                VStack(alignment: .leading, spacing: 8) {
                    Text("Note:")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text("• Apple Intelligence: No API key required - uses built-in AI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("• Local Whisper: No API key required - runs offline on your device")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            loadAPIKeys()
        }
        .alert("API Key", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadAPIKeys() {
        // Only load keys for services that require them
        for service in APIManager.ServiceType.allCases.filter({ $0 != .appleIntelligence && $0 != .whisperLocal }) {
            if let key = apiManager.getAPIKey(for: service) {
                apiKeys[service] = key
            }
        }
    }
    
    private func saveAPIKey(for service: APIManager.ServiceType) {
        if let key = apiKeys[service], !key.isEmpty {
            apiManager.setAPIKey(for: service, key: key)
            alertMessage = "API key saved for \(service.rawValue)"
            showingAlert = true
        } else {
            alertMessage = "Please enter a valid API key"
            showingAlert = true
        }
    }
}
